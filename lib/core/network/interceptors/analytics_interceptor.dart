// lib/core/network/interceptors/analytics_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';

class AnalyticsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _trackApiCall(
      method: options.method,
      endpoint: options.path,
      event: 'api_request_started',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _trackApiCall(
      method: response.requestOptions.method,
      endpoint: response.requestOptions.path,
      event: 'api_request_success',
      statusCode: response.statusCode,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _trackApiCall(
      method: err.requestOptions.method,
      endpoint: err.requestOptions.path,
      event: 'api_request_error',
      statusCode: err.response?.statusCode,
      errorType: err.type.toString(),
    );
    handler.next(err);
  }

  void _trackApiCall({
    required String method,
    required String endpoint,
    required String event,
    int? statusCode,
    String? errorType,
  }) {
    final properties = {
      'method': method,
      'endpoint': endpoint,
      'event': event,
      if (statusCode != null) 'status_code': statusCode,
      if (errorType != null) 'error_type': errorType,
    };

    // Integrate with your analytics service
    // Example: Firebase Analytics, Mixpanel, etc.
    // AnalyticsService.track(event, properties);

    AppLogger.instance.logInfo(
      '📊 Analytics: $event - $method $endpoint',
      category: LogCategory.performance,
      data: properties,
    );
  }
}
