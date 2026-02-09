import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/logger/app_logger.dart';

/// Interceptor that logs all HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    this.includeHeaders = true,
    this.includeBody = true,
    this.maxBodyLength = 1000,
  });
  final bool includeHeaders;
  final bool includeBody;
  final int maxBodyLength;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final timestamp = DateTime.now().toIso8601String();
    final method = options.method.toUpperCase();
    final url = options.uri.toString();

    AppLogger.network('➡️ [$timestamp] $method $url');

    if (includeHeaders && options.headers.isNotEmpty) {
      final sanitizedHeaders = _sanitizeHeaders(options.headers);
      AppLogger.d('Headers: ${_formatJson(sanitizedHeaders)}', 'HTTP');
    }

    if (includeBody && options.data != null) {
      final body = _formatBody(options.data);
      AppLogger.d('Body: $body', 'HTTP');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final timestamp = DateTime.now().toIso8601String();
    final method = response.requestOptions.method.toUpperCase();
    final url = response.requestOptions.uri.toString();
    final statusCode = response.statusCode;
    final statusEmoji = _getStatusEmoji(statusCode);

    AppLogger.network('$statusEmoji [$timestamp] $method $url → $statusCode');

    if (includeBody && response.data != null) {
      final body = _formatBody(response.data);
      AppLogger.d('Response: $body', 'HTTP');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final timestamp = DateTime.now().toIso8601String();
    final method = err.requestOptions.method.toUpperCase();
    final url = err.requestOptions.uri.toString();
    final statusCode = err.response?.statusCode ?? 'N/A';

    AppLogger.e(
      '❌ [$timestamp] $method $url → $statusCode\n'
      'Type: ${err.type}\n'
      'Message: ${err.message}',
      err.error,
      err.stackTrace,
    );

    if (err.response?.data != null) {
      final body = _formatBody(err.response?.data);
      AppLogger.d('Error Response: $body', 'HTTP');
    }

    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sensitiveKeys = ['authorization', 'cookie', 'x-api-key'];
    return headers.map((key, value) {
      if (sensitiveKeys.contains(key.toLowerCase())) {
        return MapEntry(key, '***REDACTED***');
      }
      return MapEntry(key, value);
    });
  }

  String _formatBody(dynamic body) {
    try {
      if (body == null) return 'null';
      if (body is String) {
        if (body.length > maxBodyLength) {
          return '${body.substring(0, maxBodyLength)}... (truncated)';
        }
        return body;
      }
      if (body is Map || body is List) {
        final jsonStr = const JsonEncoder.withIndent('  ').convert(body);
        if (jsonStr.length > maxBodyLength) {
          return '${jsonStr.substring(0, maxBodyLength)}... (truncated)';
        }
        return jsonStr;
      }
      return body.toString();
    } catch (e) {
      return 'Unable to format body: $e';
    }
  }

  String _formatJson(Map<String, dynamic> json) {
    try {
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  String _getStatusEmoji(int? statusCode) {
    if (statusCode == null) return '❓';
    if (statusCode >= 200 && statusCode < 300) return '✅';
    if (statusCode >= 300 && statusCode < 400) return '↪️';
    if (statusCode >= 400 && statusCode < 500) return '⚠️';
    if (statusCode >= 500) return '🔥';
    return '❓';
  }
}
