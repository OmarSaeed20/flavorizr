import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flavorizr/config/flavors.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../logger/advanced_app_logger.dart';
import '../logger/logger_integration_helpers.dart';
import 'api_response.dart';
import 'exception/network_exceptions.dart';

class AdvancedDioClient {
  AdvancedDioClient({
    required Flavor environment,
    Future<String?> Function()? tokenGetter,
    Future<void> Function(String?)? tokenSaver,
    Future<void> Function()? tokenClearer,
    Future<String?> Function()? refreshTokenGetter,
    Future<void> Function(String?)? refreshTokenSaver,
    bool enableLogging = true,
    bool enableCache = false,
    bool enableRetry = true,
    List<Interceptor>? customInterceptors,
  }) : _environment = environment,
       _tokenGetter = tokenGetter,
       _tokenSaver = tokenSaver,
       _tokenClearer = tokenClearer,
       _refreshTokenGetter = refreshTokenGetter,
       _refreshTokenSaver = refreshTokenSaver,
       _enableLogging = enableLogging,
       _enableCache = enableCache,
       _enableRetry = enableRetry {
    _initDio();
    if (customInterceptors != null) {
      _customInterceptors.addAll(customInterceptors);
    }
  }
  final Dio _dio = Dio();

  /*
  final _logger = 
   CompositeParseErrorLogger([
    DefaultParseErrorLogger(
      logger: Logger(
        printer: PrettyPrinter(
          dateTimeFormat: (time) => time.toIso8601String(),
        ),
      ),
      enableRemoteLogging: true,
    ),
    // Add additional loggers as needed
  ]); */
  final Connectivity _connectivity = Connectivity();
  final Flavor _environment;

  // Interceptors
  final List<Interceptor> _customInterceptors = [];

  // Token management
  final Future<String?> Function()? _tokenGetter;
  final Future<void> Function(String?)? _tokenSaver;
  final Future<void> Function()? _tokenClearer;
  final Future<String?> Function()? _refreshTokenGetter;
  final Future<void> Function(String?)? _refreshTokenSaver;

  // Configuration
  final Map<String, dynamic> _defaultHeaders = {};
  final Duration _defaultTimeout = const Duration(seconds: 30);
  final bool _enableLogging;
  final bool _enableCache;
  final bool _enableRetry;

  void _initDio() {
    // Base configuration
    final baseOptions = BaseOptions(
      baseUrl: _environment.baseUrl,
      connectTimeout: _defaultTimeout,
      receiveTimeout: _defaultTimeout,
      sendTimeout: _defaultTimeout,
      headers: _defaultHeaders,
    );

    _dio.options = baseOptions;

    // Add interceptors
    _addInterceptors();
  }

  void _addInterceptors() {
    // Logging interceptor
    if (_enableLogging) {
      _dio.interceptors.add(
        const LoggerInterceptor(),
        /* LogInterceptor(
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          logPrint: _logger.logError,
        ), */
      );
      /* _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.extra['stopwatch'] = Stopwatch()..start();
            handler.next(options);
          },
        ),
      ); */
    }

    // Auth interceptor
    _dio.interceptors.add(
      AuthInterceptor(
        tokenGetter: _tokenGetter,
        tokenSaver: _tokenSaver,
        tokenClearer: _tokenClearer,
        refreshTokenGetter: _refreshTokenGetter,
        refreshTokenSaver: _refreshTokenSaver,
        dio: _dio,
      ),
    );

    // Retry interceptor
    if (_enableRetry) {
      _dio.interceptors.add(
        RetryInterceptor(dio: _dio, connectivity: _connectivity),
      );
    }

    // Cache interceptor (simplified version)
    if (_enableCache) {
      _dio.interceptors.add(CacheInterceptor());
    }

    // Add custom interceptors
    for (final interceptor in _customInterceptors) {
      _dio.interceptors.add(interceptor);
    }
  }

  // Generic request method
  Future<ApiResponse<T>> request<T>({
    required String method,
    required String path,
    required T Function(dynamic) dataParser,
    dynamic data,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.first == ConnectivityResult.none) {
        throw const NetworkException(
          message: 'No internet connection',
          statusCode: 0,
          errorCode: 'NO_CONNECTION',
        );
      }

      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _setOptions(method, options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse<T>(
        data: dataParser(response.data),
        message: 'Success',
        success: true,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      e.logError(
        'Dio error: ${e.message} | endpoint: $path | targetType: $T',
        data: e.response?.data as Map<String, dynamic>?,
        stackTrace: e.stackTrace as String? ?? '',
      );
      final networkException = NetworkException(
        message:
            (e.response?.data?['message'] as String?) ??
            e.message ??
            'Unknown error',
        statusCode: e.response?.statusCode ?? 0,
        errorCode: e.response?.data?['code'] as String?,
      );

      return ApiResponse<T>(
        message: networkException.message,
        success: false,
        statusCode: networkException.statusCode,
      );
    } catch (e, stackTrace) {
      e.logError(e.toString(), stackTrace: stackTrace.toString());
      // await AppLogger.instance.logError(
      //   e,
      //   stackTrace: stackTrace,
      //   data: ,
      //   options: null,
      //   targetType: T,
      //   endpoint: path,
      // );

      return ApiResponse<T>(
        message: 'An unexpected error occurred',
        success: false,
        statusCode: 0,
      );
    }
  }

  // GET request
  Future<ApiResponse<T>> get<T>({
    required String path,
    required T Function(dynamic) dataParser,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      dataParser: dataParser,
    );
  }

  // POST request
  Future<ApiResponse<T>> post<T>({
    required String path,
    required T Function(dynamic) dataParser,
    dynamic data,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      method: 'POST',
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      dataParser: dataParser,
    );
  }

  // PUT request
  Future<ApiResponse<T>> put<T>({
    required String path,
    required T Function(dynamic) dataParser,
    dynamic data,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      method: 'PUT',
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      dataParser: dataParser,
    );
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>({
    required String path,
    required T Function(dynamic) dataParser,
    dynamic data,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
  }) {
    return request(
      method: 'DELETE',
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      dataParser: dataParser,
    );
  }

  // PATCH request
  Future<ApiResponse<T>> patch<T>({
    required String path,
    required T Function(dynamic) dataParser,
    dynamic data,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return request(
      method: 'PATCH',
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      dataParser: dataParser,
    );
  }

  // File upload
  Future<ApiResponse<T>> upload<T>({
    required String path,
    required FormData formData,
    required T Function(dynamic) dataParser,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return post(
      path: path,
      data: formData,
      queryParameters: queryParameters,
      options: options ?? Options(contentType: 'multipart/form-data'),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      dataParser: dataParser,
    );
  }

  // File download
  Future<Response> download({
    required String urlPath,
    required String savePath,
    Map<String, dynamic> queryParameters = const {},
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.download(
      urlPath,
      savePath,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Options _setOptions(String method, Options? options) {
    return (options ?? Options()).copyWith(
      method: method,
      headers: {
        ..._defaultHeaders,
        if (options?.headers != null) ...options!.headers!,
      },
    );
  }

  // Clear all cached responses
  void clearCache() {
    // Implementation depends on your caching strategy
  }

  // Cancel all ongoing requests
  void cancelAllRequests({CancelToken? except}) {
    // Implementation depends on how you manage cancel tokens
  }
}

// Authentication Interceptor
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenGetter,
    required this.tokenSaver,
    required this.tokenClearer,
    required this.refreshTokenGetter,
    required this.refreshTokenSaver,
    required this.dio,
  });
  final Future<String?> Function()? tokenGetter;
  final Future<void> Function(String?)? tokenSaver;
  final Future<void> Function()? tokenClearer;
  final Future<String?> Function()? refreshTokenGetter;
  final Future<void> Function(String?)? refreshTokenSaver;
  final Dio dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenGetter?.call();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';

      // Check if token is about to expire
      if (JwtDecoder.isExpired(token)) {
        // Token expired, try to refresh
        try {
          final newToken = await _refreshToken();
          if (newToken != null) {
            options.headers['Authorization'] = 'Bearer $newToken';
          }
        } catch (e) {
          // Refresh failed, continue with expired token
          // or handle according to your auth flow
        }
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Update the request with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          // Repeat the request
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, clear tokens and redirect to login
        await tokenClearer?.call();
        // You might want to navigate to login screen here
      }
    }

    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await refreshTokenGetter?.call();

      if (refreshToken == null) return null;

      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newToken = response.data['token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      await tokenSaver?.call(newToken);
      if (newRefreshToken != null) {
        await refreshTokenSaver?.call(newRefreshToken);
      }

      return newToken;
    } catch (e) {
      return null;
    }
  }
}

// Retry Interceptor
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    required this.connectivity,
    // required this.logger,
  });
  final Dio dio;
  final Connectivity connectivity;
  // final Logger logger;
  final int maxRetries = 3;
  final Duration retryInterval = const Duration(seconds: 1);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);

    if (!shouldRetry) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;
    final retryCount = (requestOptions.extra['retry_count'] as int?) ?? 0;

    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Check connectivity before retrying
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.first == ConnectivityResult.none) {
      return handler.next(err);
    }

    // Wait before retrying
    await Future.delayed(retryInterval);

    // Update retry count
    requestOptions.extra['retry_count'] = retryCount + 1;

    // Retry the request
    try {
      final response = await dio.fetch(requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.response?.statusCode == 429 ||
        err.response?.statusCode == 503;
  }
}

// Cache Interceptor (simplified version)
class CacheInterceptor extends Interceptor {
  final Map<String, dynamic> _cache = {};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.method == 'GET') {
      final key = _getCacheKey(options);

      if (_cache.containsKey(key)) {
        final cachedResponse = _cache[key];
        handler.resolve(
          Response(
            requestOptions: options,
            data: cachedResponse,
            statusCode: 200,
          ),
        );
        return;
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.requestOptions.method == 'GET') {
      final key = _getCacheKey(response.requestOptions);
      _cache[key] = response.data;
    }

    handler.next(response);
  }

  String _getCacheKey(RequestOptions options) {
    return '${options.method}:${options.path}:${options.queryParameters}';
  }
}

// Usage example
void exampleUsage() {
  /* final dioClient = AdvancedDioClient(
    environment: Flavor.dev,
    tokenGetter: () async => 'your-auth-token',
    tokenSaver: (token) async {
      // Save token to secure storage
    },
    tokenClearer: () async {
      // Clear token from storage
    },
    refreshTokenGetter: () async => 'your-refresh-token',
    refreshTokenSaver: (refreshToken) async {
      // Save refresh token to secure storage
    },
    enableCache: true,
  ); */

  // Make a GET request
  /* final response = dioClient.get<User>(
    path: '/users/1',
    dataParser: (data) => User.fromJson(data as Map<String, dynamic>),
  ); */

  // Make a POST request
  /* final postResponse = dioClient.post<User>(
    path: '/users',
    data: {'name': 'John', 'email': 'john@example.com'},
    dataParser: (data) => User.fromJson(data as Map<String, dynamic>),
  ); */
}

// Example model
class User {
  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
  final String name;
  final String email;
}
