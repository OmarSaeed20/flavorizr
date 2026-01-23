import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Application-wide logging utility
/// Provides consistent logging with different levels and formatting
class AppLogger {
  static const String _tag = 'Flavorizr';
  static bool _isEnabled = kDebugMode;

  /// Enable or disable logging
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Log a debug message
  static void d(String message, [String? tag]) {
    _log('DEBUG', message, tag);
  }

  /// Log an info message
  static void i(String message, [String? tag]) {
    _log('INFO', message, tag);
  }

  /// Log a warning message
  static void w(String message, [String? tag]) {
    _log('WARN', message, tag);
  }

  /// Log an error message
  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', message, null, error, stackTrace);
  }

  /// Log a verbose message
  static void v(String message, [String? tag]) {
    _log('VERBOSE', message, tag);
  }

  /// Log network requests
  static void network(String message, [Map<String, dynamic>? data]) {
    if (!_isEnabled) return;
    final dataStr = data != null ? '\n$data' : '';
    _log('NETWORK', '$message$dataStr');
  }

  /// Log API responses
  static void api(String endpoint, int statusCode, [dynamic response]) {
    if (!_isEnabled) return;
    final responseStr = response != null ? '\n$response' : '';
    _log('API', '[$statusCode] $endpoint$responseStr');
  }

  /// Internal logging method
  static void _log(
    String level,
    String message, [
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final logTag = tag ?? _tag;
    final formattedMessage = '[$timestamp] [$level] [$logTag] $message';

    if (kDebugMode) {
      developer.log(
        formattedMessage,
        name: logTag,
        error: error,
        stackTrace: stackTrace,
        level: _getLevelValue(level),
      );

      // Also print to console for easy viewing
      // ignore: avoid_print
      debugPrint(formattedMessage);
      if (error != null) {
        // ignore: avoid_print
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }

  static int _getLevelValue(String level) {
    switch (level) {
      case 'VERBOSE':
        return 500;
      case 'DEBUG':
        return 800;
      case 'INFO':
        return 900;
      case 'WARN':
        return 1000;
      case 'ERROR':
        return 1200;
      default:
        return 800;
    }
  }
}
