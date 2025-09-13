// lib/core/network/interceptors/performance_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PerformanceInterceptor extends Interceptor {
  final Map<String, DateTime> _requestStartTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestStartTimes[options.uri.toString()] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logPerformance(response.requestOptions, success: true);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logPerformance(err.requestOptions, success: false);
    handler.next(err);
  }

  void _logPerformance(RequestOptions options, {required bool success}) {
    final url = options.uri.toString();
    final startTime = _requestStartTimes[url];

    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);

      // Log performance metrics
      if (kDebugMode) {
        print('🚀 API Performance:');
        print('   URL: ${options.method} $url');
        print('   Duration: ${duration.inMilliseconds}ms');
        print('   Success: $success');
      }

      // You can integrate with analytics services here
      _trackApiPerformance(
        method: options.method,
        endpoint: options.path,
        duration: duration,
        success: success,
      );

      _requestStartTimes.remove(url);
    }
  }

  void _trackApiPerformance({
    required String method,
    required String endpoint,
    required Duration duration,
    required bool success,
  }) {
    // Integrate with your analytics service
    // Example: Firebase Analytics, Crashlytics, or custom analytics
    // AnalyticsService.track('api_performance', {
    //   'method': method,
    //   'endpoint': endpoint,
    //   'duration_ms': duration.inMilliseconds,
    //   'success': success,
    // });
  }
}
