// lib/core/network/interceptor/network_interceptor.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';

/// Network interceptor for handling request/response lifecycle events.
///
/// This interceptor provides:
/// - Request logging
/// - Response logging
/// - Error handling and conversion to NetworkException
/// - Performance monitoring
class NetworkInterceptor extends Interceptor {
  /// Whether to log request/response details
  final bool enableLogging;

  /// Minimum duration for logging slow requests
  final Duration slowRequestThreshold;

  NetworkInterceptor({
    this.enableLogging = true,
    this.slowRequestThreshold = const Duration(seconds: 3),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enableLogging) {
      AppLogger.instance.logInfo(
        'Network Request: ${options.method} ${options.uri}',
        category: LogCategory.network,
        data: {
          'headers': options.headers,
          'queryParameters': options.queryParameters,
          'data': options.data,
        },
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enableLogging) {
      AppLogger.instance.logInfo(
        'Network Response: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
        category: LogCategory.network,
        data: {
          'statusCode': response.statusCode,
          'headers': response.headers,
          'data': response.data,
        },
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log the error
    AppLogger.instance.logError(
      'Network Error: ${err.message}',
      category: LogCategory.network,
      stackTrace: err.stackTrace.toString(),
      data: {
        'type': err.type.toString(),
        'uri': err.requestOptions.uri.toString(),
        'method': err.requestOptions.method,
        'statusCode': err.response?.statusCode,
        'response': err.response?.data,
      },
    );

    // Convert DioException to our NetworkException
    final networkException = NetworkExceptionFactory.mapExceptionToFailure(
      err,
      err.stackTrace,
    );

    // Pass our NetworkException instead of DioException
    handler.reject(
      DioException(
        error: networkException,
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        message: err.message,
      ),
    );
  }
}
