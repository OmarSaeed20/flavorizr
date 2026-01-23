// lib/core/error/error_handler.dart
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
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
  ErrorHandler._();

  static bool _isInitialized = false;
  static bool _crashReportingEnabled = true;

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
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true, reason: 'Zone Error');
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
          await FirebaseCrashlytics.instance.setCustomKey(entry.key, entry.value.toString());
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

  /// Converts exceptions to domain failures.
  ///
  /// This method maps various exception types to appropriate [Failure] types.
  static Failure mapExceptionToFailure(Object exception, [StackTrace? stackTrace]) {
    // DioException handling
    if (exception is DioException) {
      return _mapDioException(exception, stackTrace);
    }

    // Socket exceptions (network issues)
    if (exception is SocketException) {
      return NetworkFailure(
        message: 'No internet connection',
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    // HTTP exceptions
    if (exception is HttpException) {
      return ServerFailure(
        message: exception.message,
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    // Timeout exceptions
    if (exception is TimeoutException) {
      return TimeoutFailure(
        message: 'Request timed out',
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    // Format/Parse exceptions
    if (exception is FormatException) {
      return ParseFailure(
        message: 'Failed to parse data: ${exception.message}',
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    // Type cast errors
    if (exception is TypeError) {
      return ParseFailure(
        message: 'Data type mismatch',
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    // File system exceptions
    if (exception is FileSystemException) {
      return CacheFailure(
        message: 'File system error: ${exception.message}',
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    // Fallback to unexpected failure
    return UnexpectedFailure(
      message: exception.toString(),
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// Maps DioException to appropriate Failure type.
  static Failure _mapDioException(DioException exception, [StackTrace? stackTrace]) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: 'Connection timed out',
          exception: exception,
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection',
          exception: exception,
          stackTrace: stackTrace,
        );

      case DioExceptionType.cancel:
        return CancelledFailure(exception: exception, stackTrace: stackTrace);

      case DioExceptionType.badCertificate:
        return ServerFailure(
          message: 'Certificate verification failed',
          code: 'SSL_ERROR',
          exception: exception,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        return _mapHttpStatusCode(
          exception.response?.statusCode,
          exception.response?.data,
          exception,
          stackTrace,
        );

      case DioExceptionType.unknown:
        if (exception.error is SocketException) {
          return NetworkFailure(exception: exception, stackTrace: stackTrace);
        }
        return UnexpectedFailure(
          message: exception.message ?? 'An unexpected error occurred',
          exception: exception,
          stackTrace: stackTrace,
        );
    }
  }

  /// Maps HTTP status codes to appropriate Failure types.
  static Failure _mapHttpStatusCode(
    int? statusCode,
    dynamic responseData,
    Object exception,
    StackTrace? stackTrace,
  ) {
    // Extract error message from response if available
    String? errorMessage;
    Map<String, List<String>>? fieldErrors;

    if (responseData is Map<String, dynamic>) {
      errorMessage =
          responseData['message'] as String? ??
          responseData['error'] as String? ??
          responseData['detail'] as String?;

      // Extract validation errors if present
      final errors = responseData['errors'];
      if (errors is Map<String, dynamic>) {
        fieldErrors = errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.map((e) => e.toString()).toList());
          }
          return MapEntry(key, [value.toString()]);
        });
      }
    }

    switch (statusCode) {
      case 400:
        if (fieldErrors != null && fieldErrors.isNotEmpty) {
          return ValidationFailure(
            message: errorMessage ?? 'Invalid request',
            fieldErrors: fieldErrors,
            exception: exception,
            stackTrace: stackTrace,
          );
        }
        return BadRequestFailure(
          message: errorMessage ?? 'Invalid request',
          exception: exception,
          stackTrace: stackTrace,
        );

      case 401:
        return UnauthenticatedFailure(
          message: errorMessage ?? 'Please sign in to continue',
          exception: exception,
          stackTrace: stackTrace,
        );

      case 403:
        return UnauthorizedFailure(
          message: errorMessage ?? 'Access denied',
          exception: exception,
          stackTrace: stackTrace,
        );

      case 404:
        return NotFoundFailure(
          message: errorMessage ?? 'Resource not found',
          exception: exception,
          stackTrace: stackTrace,
        );

      case 409:
        return ConflictFailure(
          message: errorMessage ?? 'Conflict occurred',
          exception: exception,
          stackTrace: stackTrace,
        );

      case 422:
        return ValidationFailure(
          message: errorMessage ?? 'Validation failed',
          fieldErrors: fieldErrors,
          exception: exception,
          stackTrace: stackTrace,
        );

      case 429:
        return RateLimitFailure(
          message: errorMessage ?? 'Too many requests',
          exception: exception,
          stackTrace: stackTrace,
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: errorMessage ?? 'Server error',
          statusCode: statusCode,
          exception: exception,
          stackTrace: stackTrace,
        );

      default:
        return ServerFailure(
          message: errorMessage ?? 'Server error',
          statusCode: statusCode,
          exception: exception,
          stackTrace: stackTrace,
        );
    }
  }

  /// Wraps an async operation with error handling.
  ///
  /// Returns `null` if an error occurs and handles it appropriately.
  static Future<T?> guard<T>(
    Future<T> Function() operation, {
    String? context,
    void Function(Failure failure)? onError,
  }) async {
    try {
      return await operation();
    } catch (e, stack) {
      final failure = mapExceptionToFailure(e, stack);

      // Report if needed
      if (failure.shouldReport) {
        await reportError(e, stackTrace: stack, reason: context);
      }

      // Call error callback if provided
      onError?.call(failure);

      return null;
    }
  }
}
