// lib/core/error/error_handler.dart
import 'dart:async';

import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Global error handler for the application.
///
/// Provides centralized error handling for:
/// - Flutter framework errors
/// - Platform dispatcher errors
/// - Uncaught zone errors
/// - API/Network errors
///
/// Also integrates with crash reporting services.
class ErrorHandler {
  const ErrorHandler._();

  static bool _isInitialized = false;
  static bool _crashReportingEnabled = true;

  static bool get crashReportingEnabled => _crashReportingEnabled;

  /// Initializes the global error handler.
  ///
  /// Call this once at app startup.
  static void initialize({bool enableCrashReporting = true}) {
    if (_isInitialized) return;

    _crashReportingEnabled = enableCrashReporting;
    _isInitialized = true;

    // Handle Flutter framework errors
    FlutterError.onError = _handleFlutterError;

    // Handle errors outside of Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };
  }

  /// Handles Flutter framework errors.
  static void _handleFlutterError(FlutterErrorDetails details) {
    // Log the error
    AppLogger.instance.logError(
      'Flutter Error: ${details.exceptionAsString()}',
      category: LogCategory.crash,
      stackTrace: details.stack?.toString(),
      data: {
        'library': details.library,
        'context': details.context?.toString(),
        'silent': details.silent,
      },
    );

    // Report to crash analytics in release mode
    if (_crashReportingEnabled && kReleaseMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }

    // In debug mode, also print to console
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  /// Handles errors from the platform dispatcher.
  static void _handlePlatformError(Object error, StackTrace stack) {
    // Log the error
    AppLogger.instance.logError(
      'Platform Error: $error',
      category: LogCategory.crash,
      stackTrace: stack.toString(),
    );

    // Report to crash analytics in release mode
    if (_crashReportingEnabled && kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
        reason: 'Platform Dispatcher Error',
      );
    }
  }

  /// Handles errors from a runZonedGuarded zone.
  static void handleZoneError(Object error, StackTrace stack) {
    // Log the error
    AppLogger.instance.logError(
      'Zone Error: $error',
      category: LogCategory.crash,
      stackTrace: stack.toString(),
    );

    // Report to crash analytics in release mode
    if (_crashReportingEnabled && kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
        reason: 'Zone Error',
      );
    }
  }

  /// Reports a non-fatal error to crash analytics.
  static Future<void> reportError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
    bool fatal = false,
  }) async {
    // Log the error
    AppLogger.instance.logError(
      reason ?? 'Error: $error',
      category: LogCategory.crash,
      stackTrace: stackTrace?.toString(),
      data: information,
    );

    // Report to crash analytics
    if (_crashReportingEnabled && !kDebugMode) {
      // Add custom information
      if (information != null) {
        for (final entry in information.entries) {
          await FirebaseCrashlytics.instance.setCustomKey(
            entry.key,
            entry.value.toString(),
          );
        }
      }

      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace ?? StackTrace.current,
        fatal: fatal,
        reason: reason,
      );
    }
  }

  /// Sets the user identifier for crash reports.
  static Future<void> setUserIdentifier(String? userId) async {
    if (_crashReportingEnabled) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
    }
  }

  /// Adds a custom log message to crash reports.
  static Future<void> log(String message) async {
    AppLogger.instance.logInfo(message);
    if (_crashReportingEnabled) {
      await FirebaseCrashlytics.instance.log(message);
    }
  }

  /// Enables or disables crash reporting.
  static Future<void> setCrashReportingEnabled(bool enabled) async {
    _crashReportingEnabled = enabled;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
  }
}
