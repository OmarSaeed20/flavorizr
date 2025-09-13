// lib/core/network/interceptors/retry_interceptor.dart
import 'dart:math';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 1000),
    this.retryableStatusCodes = const [502, 503, 504, 408, 429],
  });
  final int maxRetries;
  final Duration baseDelay;
  final List<int> retryableStatusCodes;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = (extra['retry_count'] as int?) ?? 0;

    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final delay = _calculateDelay(retryCount);
    await Future.delayed(delay);

    err.requestOptions.extra['retry_count'] = retryCount + 1;

    try {
      final response = await Dio().request(
        err.requestOptions.path,
        options: Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          extra: err.requestOptions.extra,
        ),
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    if (err.response != null) {
      return retryableStatusCodes.contains(err.response!.statusCode);
    }

    return false;
  }

  Duration _calculateDelay(int retryCount) {
    // Exponential backoff with jitter
    final exponentialDelay = baseDelay * pow(2, retryCount);
    final jitter =
        Random().nextDouble() * 0.1 * exponentialDelay.inMilliseconds;
    return Duration(
      milliseconds: exponentialDelay.inMilliseconds + jitter.round(),
    );
  }
}
