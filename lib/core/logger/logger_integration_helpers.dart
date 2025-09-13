// lib/core/logger/logger_interceptors.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'advanced_app_logger.dart';

// HTTP Logger Interceptor for Dio
class LoggerInterceptor extends Interceptor {
  const LoggerInterceptor();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['stopwatch'] = Stopwatch()..start();
    AppLogger.instance.logNetworkRequest(
      options.method,
      options.uri.toString(),
      headers: options.headers.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      body: options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final stopwatch = response.requestOptions.extra['stopwatch'] as Stopwatch?;
    final duration = stopwatch?.elapsedMilliseconds;

    AppLogger.instance.logNetworkResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
      headers: response.headers.map.map(
        (key, value) => MapEntry(key, value.join(', ')),
      ),
      body: response.data,
      duration: duration,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.instance.logError(
      'Network Error: ${err.message}',
      category: LogCategory.network,
      data: {
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'statusCode': err.response?.statusCode,
        'error': err.message,
        'type': err.type.name,
      },
      stackTrace: err.stackTrace.toString(),
    );
    super.onError(err, handler);
  }
}

// Navigation Logger
class LoggerNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      AppLogger.instance.logUserAction(
        'Navigate to ${route.settings.name}',
        context: {
          'from': previousRoute?.settings.name,
          'to': route.settings.name,
          'arguments': route.settings.arguments?.toString(),
        },
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      AppLogger.instance.logUserAction(
        'Navigate back from ${route.settings.name}',
        context: {
          'from': route.settings.name,
          'to': previousRoute?.settings.name,
        },
      );
    }
  }
}

// Performance Logger Mixin
mixin PerformanceLoggerMixin<T extends StatefulWidget> on State<T> {
  late Stopwatch _buildStopwatch;

  @override
  void initState() {
    super.initState();
    _buildStopwatch = Stopwatch();
    AppLogger.instance.logDebug(
      'Widget $T initialized',
      category: LogCategory.ui,
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildStopwatch
      ..reset()
      ..start();

    final widget = buildWidget(context);

    _buildStopwatch.stop();

    if (_buildStopwatch.elapsedMilliseconds > 16) {
      // More than 1 frame
      AppLogger.instance.logPerformance(
        '$T build',
        _buildStopwatch.elapsed,
        metrics: {'widgetType': T.toString()},
      );
    }

    return widget;
  }

  Widget buildWidget(BuildContext context);

  @override
  void dispose() {
    AppLogger.instance.logDebug('Widget $T disposed', category: LogCategory.ui);
    super.dispose();
  }
}

// Error Handler
class AppErrorHandler {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) async {
      await AppLogger.instance.logCritical(
        'Flutter Error: ${details.exception}',
        data: {
          'library': details.library ?? 'Unknown',
          'context': details.context?.toString(),
          'informationCollector': details.informationCollector?.toString(),
        },
        stackTrace: details.stack.toString(),
      );

      // Still report to Flutter's default error handler in debug mode
      if (kDebugMode) FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      error.logMethod(
        'Platform Error: $error',
        () async {},
        level: LogLevel.critical,
        // parameters: stack,
        category: LogCategory.crash,
      );
      return true;
    };
  }
}

// lib/core/logger/logger_decorators.dart

// Method decorator for automatic logging
class LoggedMethod {
  const LoggedMethod({
    this.level = LogLevel.debug,
    this.category = LogCategory.business,
    this.logParameters = true,
    this.logResult = true,
    this.logDuration = true,
  });
  final LogLevel level;
  final LogCategory category;
  final bool logParameters;
  final bool logResult;
  final bool logDuration;
}

// Extension for easy method logging
extension LoggedMethodExtension on Object {
  Future<T> logMethod<T>(
    String methodName,
    Future<T> Function() method, {
    LogLevel level = LogLevel.debug,
    LogCategory category = LogCategory.business,
    Map<String, dynamic>? parameters,
    bool logResult = true,
    bool logDuration = true,
  }) async {
    final stopwatch = Stopwatch()..start();

    await AppLogger.instance.logV(
      level,
      'Method $methodName started',
      category,
      parameters != null ? {'parameters': parameters} : null,
    );

    try {
      final result = await method();
      stopwatch.stop();

      final data = <String, dynamic>{};
      if (logDuration) data['duration'] = stopwatch.elapsedMilliseconds;
      if (logResult) data['result'] = result?.toString();

      await AppLogger.instance.logV(
        level,
        'Method $methodName completed',
        category,
        data.isNotEmpty ? data : null,
      );

      return result;
    } catch (error, stackTrace) {
      stopwatch.stop();

      await AppLogger.instance.logError(
        'Method $methodName failed: $error',
        category: category,
        data: {
          'parameters': parameters,
          'duration': stopwatch.elapsedMilliseconds,
          'error': error.toString(),
        },
        stackTrace: stackTrace.toString(),
      );

      rethrow;
    }
  }
}
