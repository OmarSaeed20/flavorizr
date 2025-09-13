import 'dart:async';

import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/network/exception/exception_message.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flutter/foundation.dart' show compute, kDebugMode;
import 'package:get_it/get_it.dart';
import 'package:worker_manager/worker_manager.dart' show workerManager;

class ApiResultSuccess<T> extends ApiResult<T> {
  const ApiResultSuccess(this.data);
  @override
  final T data;

  @override
  String toString() => 'ApiResultSuccess: $data';
}

class ApiResultError<T> extends ApiResult<T> {
  const ApiResultError(this.error);
  @override
  final NetworkException error;

  @override
  String toString() => 'ApiResultError: $error => ${error.message}';
}

sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = ApiResultSuccess;
  const factory ApiResult.error(NetworkException error) = ApiResultError;

  bool get isSuccess => this is ApiResultSuccess<T>;

  bool get isError => this is ApiResultError<T>;

  T? get data =>
      (this is ApiResultSuccess<T>) ? (this as ApiResultSuccess<T>).data : null;

  NetworkException? get error =>
      (this is ApiResultError<T>) ? (this as ApiResultError<T>).error : null;

  ApiResult<T> when({
    required void Function(T success) success,
    required void Function(NetworkException error) error,
  }) {
    switch (this) {
      case ApiResultSuccess<T>():
        success((this as ApiResultSuccess<T>).data);
      case ApiResultError<T>():
        error((this as ApiResultError<T>).error);
    }
    return this;
  }

  S map<S>({
    required S Function(ApiResultSuccess<T> data) success,
    required S Function(ApiResultError<T> error) error,
  }) {
    return switch (this) {
      ApiResultSuccess<T>() => success(this as ApiResultSuccess<T>),
      ApiResultError<T>() => error(this as ApiResultError<T>),
    };
  }

  Future<S> mapAsync<S>({
    required Future<S> Function(ApiResultSuccess<T> data) success,
    required Future<S> Function(ApiResultError<T> error) error,
  }) async {
    return switch (this) {
      ApiResultSuccess<T>() => success(this as ApiResultSuccess<T>),
      ApiResultError<T>() => error(this as ApiResultError<T>),
    };
  }

  FutureOr<ApiResult<S>> mapDataAsync<S>({
    required Mapper<T, ApiResult<S>> mapper,
  }) async {
    return switch (this) {
      ApiResultSuccess<T>() => await mapper((this as ApiResultSuccess<T>).data),
      ApiResultError<T>() => ApiResult.error((this as ApiResultError<T>).error),
    };
  }

  FutureOr<S?> mapDataAsyncOrNull<S>({
    required Mapper<T, S> mapper,
    Mapper<NetworkException, S>? errorMapper,
  }) async {
    return switch (this) {
      ApiResultSuccess<T>() => await mapper((this as ApiResultSuccess<T>).data),
      ApiResultError<T>() => errorMapper?.call(
        (this as ApiResultError<T>).error,
      ),
    };
  }

  Future<ApiResult<S>> mapDataAsyncInIsolate<S>({
    required Mapper<T, ApiResult<S>> mapper,
    String? exceptionMessage,
    bool useWorkManager = true,
  }) async {
    try {
      return await mapAsyncInIsolate(
        success: mapper,
        error: (error) async => ApiResult.error(error),
        useWorkManager: useWorkManager,
      );
    } catch (e, _) {
      return ApiResult.error(
        NetworkException.unableToProcessException().copyWith(
          message:
              exceptionMessage ??
              _exceptionMessages?.unableToProcess ??
              'unableToProcess',
        ),
      );
    }
  }

  Future<S> mapAsyncInIsolate<S>({
    required Mapper<T, S> success,
    required Mapper<NetworkException, S> error,
    bool useWorkManager = true,
  }) async {
    return MapUtils.mapAsyncInIsolate(
      data: this,
      mapper: (ApiResult<T> res) async {
        return switch (res) {
          ApiResultSuccess<T>() => await success(res.data),
          ApiResultError<T>() => await error(res.error),
        };
      },
      useWorkManager: useWorkManager,
    );
  }

  ExceptionMessage? get _exceptionMessages =>
      GetIt.instance.isRegistered<ExceptionMessage>()
      ? GetIt.instance.get<ExceptionMessage>()
      : null;
}

typedef Mapper<T, S> = FutureOr<S> Function(T data);

class MapUtils {
  const MapUtils._();

  static Future<S> mapAsync<T, S>({
    required T data,
    required Mapper<T, S> mapper,
    bool printError = kDebugMode,
  }) async {
    try {
      return mapper(data);
    } catch (e, s) {
      if (printError) {
        e.logError('MapAsync Error', stackTrace: s.toString());
      }
      // Handle any errors in the main thread
      rethrow;
    }
  }

  static Future<S> mapAsyncInIsolate<T, S>({
    required T data,
    required Mapper<T, S> mapper,
    bool useWorkManager = true,
    bool printError = kDebugMode,
  }) async {
    try {
      final res = useWorkManager
          ? await workerManager.execute(() => _mapAsync<T, S>([data, mapper]))
          : await compute(_mapAsync<T, S>, [data, mapper]);
      return res;
    } catch (e, s) {
      if (printError) {
        e.logError('MapAsyncInIsolate Error', stackTrace: s.toString());
      }
      rethrow;
    }
  }

  static Future<S> _mapAsync<T, S>(List arguments) async {
    try {
      final data = arguments[0] as T;
      final mapper = arguments[1] as Mapper<T, S>;
      return await mapper(data);
    } catch (e) {
      rethrow;
    }
  }
}

extension MapAsync<T> on T {
  Future<S> mapAsync<S>({
    required Mapper<T, S> mapper,
    bool printError = kDebugMode,
  }) => MapUtils.mapAsync(data: this, mapper: mapper, printError: printError);

  Future<S> mapAsyncInIsolate<S>({
    required Mapper<T, S> mapper,
    bool useWorkManager = true,
    bool printError = kDebugMode,
  }) => MapUtils.mapAsyncInIsolate(
    data: this,
    mapper: mapper,
    useWorkManager: useWorkManager,
    printError: printError,
  );
}
