import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/base/datasource/base_local_data_source.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Base class for repositories
/// Provides common functionality for data operations combining remote and local sources
abstract class BaseRepository {
  /// Network info for connectivity checks
  NetworkInfo get networkInfo;

  /// Check if device is connected to the internet
  Future<bool> get isConnected => networkInfo.isConnected;

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      networkInfo.onConnectivityChanged;

  /// Execute a remote request with connectivity check
  /// Returns ApiResult with the response data or an error
  /// If [cachedData] is provided and the request fails, returns cached data instead of error
  Future<ApiResult<T>> executeRemoteRequest<T>({
    required Future<ApiResult<T>> Function() request,
    bool requireConnection = true,
    T? cachedData,
  }) async {
    if (requireConnection) {
      final connected = await isConnected;
      if (!connected) {
        if (cachedData != null) {
          'No internet connection, returning cached data'.logInfo(
            'executeRemoteRequest',
          );
          return ApiResult.success(cachedData);
        }
        return const ApiResult.exception(NoInternetException());
      }
    }

    try {
      return await request();
    } catch (e, stackTrace) {
      e.logError('Remote request failed', stackTrace: stackTrace.toString());
      if (cachedData != null) {
        'Remote request failed, returning cached data'.logInfo(
          'executeRemoteRequest',
        );
        return ApiResult.success(cachedData);
      }
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace),
      );
    }
  }

  /// Execute a local request
  /// Returns ApiResult with the data or an error
  Future<ApiResult<T>> executeLocalRequest<T>({
    required Future<ApiResult<T>> Function() request,
  }) async {
    try {
      return await request();
    } catch (e, stackTrace) {
      e.logError('Local request failed', stackTrace: stackTrace.toString());
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace),
      );
    }
  }

  /// Fetch data with caching strategy
  /// First tries to get from local cache, then fetches from remote if needed
  Future<ApiResult<T>> fetchWithCache<T>({
    required String cacheKey,
    required Future<ApiResult<T>> Function() remoteFetcher,
    required Future<ApiResult<T>> Function() localFetcher,
    required Future<void> Function(T data) cacheSaver,
    CacheStrategy strategy = CacheStrategy.cacheFirst,
    Duration? maxCacheAge,
  }) async {
    switch (strategy) {
      case CacheStrategy.cacheFirst:
        return _fetchCacheFirst(
          cacheKey: cacheKey,
          remoteFetcher: remoteFetcher,
          localFetcher: localFetcher,
          cacheSaver: cacheSaver,
          maxCacheAge: maxCacheAge,
        );

      case CacheStrategy.networkFirst:
        return _fetchNetworkFirst(
          cacheKey: cacheKey,
          remoteFetcher: remoteFetcher,
          localFetcher: localFetcher,
          cacheSaver: cacheSaver,
        );

      case CacheStrategy.cacheOnly:
        return localFetcher();

      case CacheStrategy.networkOnly:
        return remoteFetcher();

      case CacheStrategy.staleWhileRevalidate:
        return _fetchStaleWhileRevalidate(
          cacheKey: cacheKey,
          remoteFetcher: remoteFetcher,
          localFetcher: localFetcher,
          cacheSaver: cacheSaver,
          maxCacheAge: maxCacheAge,
        );
    }
  }

  /// Cache-first strategy: Try cache first, fall back to network
  Future<ApiResult<T>> _fetchCacheFirst<T>({
    required String cacheKey,
    required Future<ApiResult<T>> Function() remoteFetcher,
    required Future<ApiResult<T>> Function() localFetcher,
    required Future<void> Function(T data) cacheSaver,
    Duration? maxCacheAge,
  }) async {
    // Try to get from cache
    final cachedResult = await localFetcher();
    if (cachedResult.isSuccess && cachedResult.data != null) {
      // Check if cache is still valid
      if (maxCacheAge == null || await _isCacheValid(cacheKey, maxCacheAge)) {
        return cachedResult;
      }
    }

    // Fetch from network
    final remoteResult = await remoteFetcher();
    if (remoteResult.isSuccess && remoteResult.data != null) {
      // Update cache
      try {
        await cacheSaver(remoteResult.data as T);
        await _updateCacheTimestamp(cacheKey);
      } catch (e) {
        // Don't fail if caching fails
        e.logWarning('Failed to cache data for key: $cacheKey');
      }
    }

    return remoteResult;
  }

  /// Network-first strategy: Try network first, fall back to cache
  Future<ApiResult<T>> _fetchNetworkFirst<T>({
    required String cacheKey,
    required Future<ApiResult<T>> Function() remoteFetcher,
    required Future<ApiResult<T>> Function() localFetcher,
    required Future<void> Function(T data) cacheSaver,
  }) async {
    // Check connectivity
    final connected = await isConnected;
    if (connected) {
      // Try network first
      final remoteResult = await remoteFetcher();
      if (remoteResult.isSuccess && remoteResult.data != null) {
        // Update cache
        try {
          await cacheSaver(remoteResult.data as T);
          await _updateCacheTimestamp(cacheKey);
        } catch (e) {
          e.logWarning('Failed to cache data for key: $cacheKey');
        }
        return remoteResult;
      }
    }

    // Fall back to cache
    return localFetcher();
  }

  /// Stale-while-revalidate: Return cache immediately, update in background
  Future<ApiResult<T>> _fetchStaleWhileRevalidate<T>({
    required String cacheKey,
    required Future<ApiResult<T>> Function() remoteFetcher,
    required Future<ApiResult<T>> Function() localFetcher,
    required Future<void> Function(T data) cacheSaver,
    Duration? maxCacheAge,
  }) async {
    // Try to get from cache
    final cachedResult = await localFetcher();
    final hasValidCache =
        cachedResult.isSuccess &&
        cachedResult.data != null &&
        (maxCacheAge == null || await _isCacheValid(cacheKey, maxCacheAge));

    if (hasValidCache) {
      // Return cache immediately
      // Update in background if connected
      unawaited(
        isConnected.then((connected) {
          if (connected) {
            remoteFetcher().then((remoteResult) {
              if (remoteResult.isSuccess && remoteResult.data != null) {
                cacheSaver(remoteResult.data as T).then((_) {
                  _updateCacheTimestamp(cacheKey);
                });
              }
            });
          }
        }),
      );
      return cachedResult;
    }

    // No valid cache, fetch from network
    final remoteResult = await remoteFetcher();
    if (remoteResult.isSuccess && remoteResult.data != null) {
      try {
        await cacheSaver(remoteResult.data as T);
        await _updateCacheTimestamp(cacheKey);
      } catch (e) {
        e.logWarning('Failed to cache data for key: $cacheKey');
      }
    }

    return remoteResult;
  }

  /// Retry a request with exponential backoff
  Future<ApiResult<T>> retryRequest<T>({
    required Future<ApiResult<T>> Function() request,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffFactor = 2.0,
    bool Function(NetworkException)? shouldRetry,
  }) async {
    ApiResult<T>? lastResult;
    int attempt = 0;

    while (attempt < maxAttempts) {
      attempt++;

      final result = await request();
      lastResult = result;

      if (result.isSuccess) {
        return result;
      }

      // Check if we should retry
      final error = result.error;
      if (error == null) {
        return result;
      }

      final shouldRetryError =
          shouldRetry?.call(error) ?? _defaultShouldRetry(error);
      if (!shouldRetryError || attempt >= maxAttempts) {
        return result;
      }

      // Calculate delay with exponential backoff
      final delay = initialDelay * (backoffFactor ~/ (attempt - 1));
      'Retry attempt $attempt failed, waiting ${delay.inSeconds}s before retry'
          .logInfo('retry');
      await Future.delayed(delay);
    }

    return lastResult ?? const ApiResult.exception(UnknownNetworkException());
  }

  /// Default retry logic - retry on recoverable errors
  bool _defaultShouldRetry(NetworkException error) {
    return switch (error) {
      NoInternetException() => true,
      TimeoutException() => true,
      ServerException() => true,
      RateLimitException() => true,
      UnknownNetworkException() => true,
      BadRequestException() => false,
      UnauthorizedException() => false,
      ForbiddenException() => false,
      NotFoundException() => false,
      ConflictException() => false,
      ValidationException() => false,
      RequestCancelledException() => false,
    };
  }

  /// Execute multiple requests concurrently
  /// Returns ApiResult with a list of successful results or the first error
  Future<ApiResult<List<T>>> fetchAll<T>({
    required List<Future<ApiResult<T>>> requests,
    bool failOnError = true,
  }) async {
    try {
      final results = await Future.wait(requests);

      if (failOnError) {
        // Check for any errors
        for (final result in results) {
          if (result.isError) {
            return result.error != null
                ? ApiResult.exception(result.error!)
                : const ApiResult.exception(UnknownNetworkException());
          }
        }
      }

      // Extract successful data
      final dataList = <T>[];
      for (final result in results) {
        if (result.isSuccess && result.data != null) {
          dataList.add(result.data as T);
        }
      }

      return ApiResult.success(dataList);
    } catch (e, stackTrace) {
      e.logError('Fetch all failed', stackTrace: stackTrace.toString());
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace),
      );
    }
  }

  /// Execute requests sequentially, stopping on first error if failOnError is true
  Future<ApiResult<List<T>>> fetchSequential<T>({
    required List<Future<ApiResult<T>> Function()> requestFactories,
    bool failOnError = true,
  }) async {
    final results = <T>[];

    for (final factory in requestFactories) {
      final result = await factory();

      if (result.isError) {
        if (failOnError) {
          return result.error != null
              ? ApiResult.exception(result.error!)
              : const ApiResult.exception(UnknownNetworkException());
        }
        continue;
      }

      if (result.data != null) {
        results.add(result.data as T);
      }
    }

    return ApiResult.success(results);
  }

  /// Clear cache for a specific key
  Future<ApiResult<void>> clearCache({
    required String key,
    required Future<void> Function() clearer,
  }) async {
    try {
      await clearer();
      await _removeCacheTimestamp(key);
      return const ApiResult.success(null);
    } catch (e, stackTrace) {
      e.logError(
        'Failed to clear cache for key: $key',
        stackTrace: stackTrace.toString(),
      );
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace),
      );
    }
  }

  /// Clear all cache
  Future<ApiResult<void>> clearAllCache({
    required Future<void> Function() clearer,
  }) async {
    try {
      await clearer();
      await _clearAllCacheTimestamps();
      return const ApiResult.success(null);
    } catch (e, stackTrace) {
      e.logError(
        'Failed to clear all cache',
        stackTrace: stackTrace.toString(),
      );
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e, stackTrace),
      );
    }
  }

  /// Check if cache is still valid based on timestamp
  Future<bool> _isCacheValid(String key, Duration maxAge) async {
    try {
      final timestamp = await _getCacheTimestamp(key);
      if (timestamp == null) return false;

      final age = DateTime.now().difference(timestamp);
      return age < maxAge;
    } catch (e) {
      return false;
    }
  }

  /// Get cache timestamp for a key
  Future<DateTime?> _getCacheTimestamp(String key) async {
    // This should be implemented by the concrete repository
    // using their preferred storage mechanism
    return null;
  }

  /// Update cache timestamp for a key
  Future<void> _updateCacheTimestamp(String key) async {
    // This should be implemented by the concrete repository
    // using their preferred storage mechanism
  }

  /// Remove cache timestamp for a key
  Future<void> _removeCacheTimestamp(String key) async {
    // This should be implemented by the concrete repository
    // using their preferred storage mechanism
  }

  /// Clear all cache timestamps
  Future<void> _clearAllCacheTimestamps() async {
    // This should be implemented by the concrete repository
    // using their preferred storage mechanism
  }
}

/// Cache strategy for data fetching
enum CacheStrategy {
  /// Try cache first, fall back to network
  cacheFirst,

  /// Try network first, fall back to cache
  networkFirst,

  /// Only use cache, don't fetch from network
  cacheOnly,

  /// Only use network, don't use cache
  networkOnly,

  /// Return cache immediately, update in background
  staleWhileRevalidate,
}

/// Mixin for repositories that work with remote data sources
mixin RemoteRepositoryMixin on BaseRepository {
  /// Get the remote data source
  BaseRemoteDataSource get remoteDataSource;

  /// Execute a remote request through the data source
  Future<ApiResult<T>> remoteGet<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    bool requireConnection = true,
  }) {
    return executeRemoteRequest(
      request: () =>
          remoteDataSource.get<T>(path: path, queryParameters: queryParameters),
      requireConnection: requireConnection,
    );
  }

  Future<ApiResult<T>> remotePost<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requireConnection = true,
  }) {
    return executeRemoteRequest(
      request: () => remoteDataSource.post<T>(
        path: path,
        data: data,
        queryParameters: queryParameters,
      ),
      requireConnection: requireConnection,
    );
  }

  Future<ApiResult<T>> remotePut<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requireConnection = true,
  }) {
    return executeRemoteRequest(
      request: () => remoteDataSource.put<T>(
        path: path,
        data: data,
        queryParameters: queryParameters,
      ),
      requireConnection: requireConnection,
    );
  }

  Future<ApiResult<T>> remotePatch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requireConnection = true,
  }) {
    return executeRemoteRequest(
      request: () => remoteDataSource.patch<T>(
        path: path,
        data: data,
        queryParameters: queryParameters,
      ),
      requireConnection: requireConnection,
    );
  }

  Future<ApiResult<T>> remoteDelete<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    bool requireConnection = true,
  }) {
    return executeRemoteRequest(
      request: () => remoteDataSource.delete<T>(
        path: path,
        queryParameters: queryParameters,
      ),
      requireConnection: requireConnection,
    );
  }
}

/// Mixin for repositories that work with local data sources
mixin LocalRepositoryMixin on BaseRepository {
  /// Get the local data source
  BaseLocalDataSource get localDataSource;

  /// Execute a local get request
  Future<ApiResult<T>> localGet<T>({
    required String key,
    required Future<T?> Function() fetcher,
  }) {
    return executeLocalRequest(
      request: () =>
          localDataSource.getLocalData<T>(key: key, fetcher: fetcher),
    );
  }

  /// Execute a local save request
  Future<ApiResult<void>> localSave<T>({
    required String key,
    required T data,
    required Future<void> Function(T data) saver,
  }) {
    return executeLocalRequest(
      request: () =>
          localDataSource.saveLocalData<T>(key: key, data: data, saver: saver),
    );
  }

  /// Execute a local delete request
  Future<ApiResult<void>> localDelete({
    required String key,
    required Future<void> Function() deleter,
  }) {
    return executeLocalRequest(
      request: () =>
          localDataSource.deleteLocalData(key: key, deleter: deleter),
    );
  }

  /// Execute a local clear all request
  Future<ApiResult<void>> localClearAll({
    required Future<void> Function() clearer,
  }) {
    return executeLocalRequest(
      request: () => localDataSource.clearAllLocalData(clearer: clearer),
    );
  }

  /// Check if local data exists
  Future<ApiResult<bool>> localHasData({
    required String key,
    required Future<bool> Function() checker,
  }) {
    return executeLocalRequest(
      request: () => localDataSource.hasLocalData(key: key, checker: checker),
    );
  }
}
