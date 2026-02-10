import 'dart:async';

import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:flutter/foundation.dart' show compute, kDebugMode;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:worker_manager/worker_manager.dart' show workerManager;

part 'dio_reslut.freezed.dart';

@freezed
sealed class ApiResult<T> with _$ApiResult<T> {
  const ApiResult._();

  const factory ApiResult.success(T data, [NetworkException? info]) = ApiResultSuccess<T>;
  const factory ApiResult.exception(NetworkException exception) = ApiResultError<T>;

  bool get isSuccess => maybeWhen(success: (_, _) => true, orElse: () => false);

  bool get isError => maybeWhen(exception: (_) => true, orElse: () => false);

  T? get data => maybeWhen(success: (data, _) => data, orElse: () => null);

  bool get isValid => isSuccess && data != null;

  NetworkException? get error => maybeWhen(exception: (error) => error, orElse: () => null);

  /// Creates a failure result from an exception.
  static ApiResult<T> failure<T>(NetworkException error) => ApiResult.exception(error);

  ApiResult<T> whenVoid({
    required void Function(T success) success,
    required void Function(NetworkException error) error,
  }) {
    return when(
      success: (data, _) {
        success(data);
        return this;
      },
      exception: (err) {
        error(err);
        return this;
      },
    );
  }

  S map<S>({
    required S Function(ApiResultSuccess<T> data) success,
    required S Function(ApiResultError<T> error) exception,
  }) {
    return when(
      success: (data, _) => success(ApiResultSuccess(data)),
      exception: (err) => exception(ApiResultError(err)),
    );
  }

  Future<S> mapAsync<S>({
    required Future<S> Function(ApiResultSuccess<T> data) success,
    required Future<S> Function(ApiResultError<T> error) error,
  }) async {
    return when(
      success: (data, _) async => success(ApiResultSuccess(data)),
      exception: (err) async => error(ApiResultError(err)),
    );
  }

  FutureOr<ApiResult<S>> mapDataAsync<S>({required Mapper<T, ApiResult<S>> mapper}) {
    return when(success: (data, _) => mapper(data), exception: ApiResult.exception);
  }

  FutureOr<S?> mapDataAsyncOrNull<S>({
    required Mapper<T, S> mapper,
    Mapper<NetworkException, S>? errorMapper,
  }) {
    return when(success: (data, _) => mapper(data), exception: (err) => errorMapper?.call(err));
  }

  Future<ApiResult<S>> mapDataAsyncInIsolate<S>({
    required Mapper<T, ApiResult<S>> mapper,
    String? exceptionMessage,
    bool useWorkManager = true,
  }) async {
    try {
      return await mapAsyncInIsolate(
        success: mapper,
        error: (error) async => ApiResult.exception(error),
        useWorkManager: useWorkManager,
      );
    } catch (e, _) {
      return ApiResult.exception(
        UnknownNetworkException(message: exceptionMessage ?? 'Unable to process data'),
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
      mapper: (ApiResult<T> res) {
        return res.when(success: (data, _) => success(data), exception: (err) => error(err));
      },
      useWorkManager: useWorkManager,
    );
  }
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
  Future<S> mapAsync<S>({required Mapper<T, S> mapper, bool printError = kDebugMode}) =>
      MapUtils.mapAsync(data: this, mapper: mapper, printError: printError);

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
