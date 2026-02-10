import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/error/error_handler.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Base class for all network exceptions in the application.
///
/// This sealed class ensures that all network exceptions are handled exhaustively
/// and provides a consistent interface for error handling throughout the application.
///
/// Network exceptions are mapped to domain failures using the [toFailure] extension
/// method, which allows for clean separation between network layer and domain layer.
sealed class NetworkException implements Exception {
  /// Creates a new network exception.
  ///
  /// [message] - A human-readable error message.
  /// [statusCode] - HTTP status code if applicable.
  /// [data] - Additional data related to the error.
  const NetworkException({required this.message, this.statusCode, this.data});

  /// A human-readable error message describing the issue.
  final String message;

  /// HTTP status code if applicable, null for network-level errors.
  final int? statusCode;

  /// Additional data related to the error, such as response body or metadata.
  final dynamic data;

  @override
  String toString() => 'NetworkException: $message (statusCode: $statusCode)';
}

// ============================================================================
// CONCRETE EXCEPTION CLASSES
// ============================================================================

/// No internet connection available.
///
/// Thrown when the device has no network connectivity.
class NoInternetException extends NetworkException {
  /// Creates a no internet exception.
  const NoInternetException()
    : super(
        message: 'No internet connection. Please check your network.',
        statusCode: null,
      );
}

/// Request timeout occurred.
///
/// Thrown when a network request exceeds the allowed time limit.
class TimeoutException extends NetworkException {
  /// Creates a timeout exception.
  const TimeoutException()
    : super(message: 'Request timed out. Please try again.', statusCode: 408);
}

/// Server-side error (5xx status codes).
///
/// Thrown when the server encounters an error processing the request.
class ServerException extends NetworkException {
  /// Creates a server exception.
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.statusCode = 500,
    super.data,
  });
}

/// Bad request error (400 status code).
///
/// Thrown when the request is malformed or contains invalid data.
class BadRequestException extends NetworkException {
  /// Creates a bad request exception.
  const BadRequestException({
    super.message = 'Bad request. Please check your input.',
    super.data,
  }) : super(statusCode: 400);
}

/// Unauthorized access (401 status code).
///
/// Thrown when authentication is required but missing or invalid.
class UnauthorizedException extends NetworkException {
  /// Creates an unauthorized exception.
  const UnauthorizedException({
    super.message = 'Unauthorized. Please login again.',
    super.data,
  }) : super(statusCode: 401);
}

/// Access forbidden (403 status code).
///
/// Thrown when the user is authenticated but lacks required permissions.
class ForbiddenException extends NetworkException {
  /// Creates a forbidden exception.
  const ForbiddenException({super.message = 'Access forbidden.', super.data})
    : super(statusCode: 403);
}

/// Resource not found (404 status code).
///
/// Thrown when the requested resource does not exist.
class NotFoundException extends NetworkException {
  /// Creates a not found exception.
  const NotFoundException({super.message = 'Resource not found.', super.data})
    : super(statusCode: 404);
}

/// Conflict with current state (409 status code).
///
/// Thrown when the request conflicts with the current state of the resource.
class ConflictException extends NetworkException {
  /// Creates a conflict exception.
  const ConflictException({
    super.message = 'Conflict with current state.',
    super.data,
  }) : super(statusCode: 409);
}

/// Validation error (422 status code).
///
/// Thrown when request data fails validation.
class ValidationException extends NetworkException {
  /// Creates a validation exception.
  const ValidationException({
    super.message = 'Validation failed.',
    super.data,
    this.errors,
  }) : super(statusCode: 422);

  /// Field-specific validation errors.
  final Map<String, List<String>>? errors;
}

/// Rate limit exceeded (429 status code).
///
/// Thrown when too many requests are made in a given timeframe.
class RateLimitException extends NetworkException {
  /// Creates a rate limit exception.
  const RateLimitException({
    super.message = 'Too many requests. Please wait and try again.',
    this.retryAfter,
    super.data,
  }) : super(statusCode: 429);

  /// Time to wait before retrying the request.
  final Duration? retryAfter;
}

/// Request was cancelled.
///
/// Thrown when a request is explicitly cancelled by the user or system.
class RequestCancelledException extends NetworkException {
  /// Creates a request cancelled exception.
  const RequestCancelledException()
    : super(message: 'Request was cancelled.', statusCode: null);
}

/// Unknown or unexpected error.
///
/// Thrown when an error occurs that doesn't fit into other categories.
class UnknownNetworkException extends NetworkException {
  /// Creates an unknown network exception.
  const UnknownNetworkException({
    super.message = 'An unknown error occurred.',
    super.statusCode,
    super.data,
    this.exception,
  });

  /// The underlying exception that caused this error.
  final Object? exception;
}

// ============================================================================
// FACTORY FOR EXCEPTION MAPPING
// ============================================================================

/// Factory for creating appropriate exceptions from various error sources.
///
/// This factory provides methods to convert different types of exceptions
/// (DioException, SocketException, etc.) into our domain-specific
/// NetworkException types.
class NetworkExceptionFactory {
  /// Converts exceptions to domain failures.
  ///
  /// This method maps various exception types to appropriate [NetworkException] types.
  /// It handles both network-layer exceptions (like DioException) and lower-level
  /// exceptions (like SocketException).
  ///
  /// [exception] - The exception to convert.
  /// [stackTrace] - Optional stack trace for debugging.
  static NetworkException mapExceptionToFailure(
    Object exception, [
    StackTrace? stackTrace,
  ]) {
    // DioException handling
    if (exception is DioException) {
      return _mapDioException(exception, stackTrace);
    }

    // Socket exceptions (network issues)
    if (exception is SocketException) {
      return const NoInternetException();
    }

    // HTTP exceptions
    if (exception is HttpException) {
      return ServerException(message: exception.message, data: exception);
    }

    // Timeout exceptions
    if (exception is TimeoutException) {
      return const TimeoutException();
    }

    // Format/Parse exceptions
    if (exception is FormatException) {
      return UnknownNetworkException(
        message: 'Failed to parse data: ${exception.message}',
        exception: exception,
      );
    }

    // Type cast errors
    if (exception is TypeError) {
      return UnknownNetworkException(
        message: 'Data type mismatch',
        exception: exception,
      );
    }

    // File system exceptions
    if (exception is FileSystemException) {
      return UnknownNetworkException(
        message: 'File system error: ${exception.message}',
        exception: exception,
      );
    }

    // Fallback to unexpected failure
    return UnknownNetworkException(
      message: exception.toString(),
      exception: exception,
    );
  }

  /// Maps DioException to appropriate NetworkException type.
  ///
  /// This method handles the specific types of DioExceptions and converts them
  /// to our domain-specific exceptions.
  ///
  /// [exception] - The DioException to map.
  /// [stackTrace] - Optional stack trace for debugging.
  static NetworkException _mapDioException(
    DioException exception, [
    StackTrace? stackTrace,
  ]) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NoInternetException();

      case DioExceptionType.cancel:
        return const RequestCancelledException();

      case DioExceptionType.badCertificate:
        return const UnknownNetworkException(
          message: 'Certificate verification failed.',
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
          return const NoInternetException();
        }
        return UnknownNetworkException(
          message: exception.message ?? 'An unexpected error occurred',
          exception: exception,
        );
    }
  }

  /// Maps HTTP status codes to appropriate NetworkException types.
  ///
  /// This method extracts error information from HTTP responses and creates
  /// the appropriate NetworkException based on the status code.
  ///
  /// [statusCode] - The HTTP status code.
  /// [responseData] - The response data/body.
  /// [exception] - The original exception.
  /// [stackTrace] - Optional stack trace for debugging.
  static NetworkException _mapHttpStatusCode(
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
          return ValidationException(
            message: errorMessage ?? 'Invalid request',
            data: responseData,
            errors: fieldErrors,
          );
        }
        return BadRequestException(
          message: errorMessage ?? 'Invalid request',
          data: responseData,
        );

      case 401:
        return UnauthorizedException(
          message: errorMessage ?? 'Please sign in to continue',
          data: responseData,
        );

      case 403:
        return ForbiddenException(
          message: errorMessage ?? 'Access denied',
          data: responseData,
        );

      case 404:
        return NotFoundException(
          message: errorMessage ?? 'Resource not found',
          data: responseData,
        );

      case 409:
        return ConflictException(
          message: errorMessage ?? 'Conflict occurred',
          data: responseData,
        );

      case 422:
        return ValidationException(
          message: errorMessage ?? 'Validation failed',
          data: responseData,
          errors: fieldErrors,
        );

      case 429:
        return RateLimitException(
          message: errorMessage ?? 'Too many requests',
          data: responseData,
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: errorMessage ?? 'Server error',
          statusCode: statusCode,
          data: responseData,
        );

      default:
        return UnknownNetworkException(
          message: errorMessage ?? 'Server error',
          statusCode: statusCode,
          data: responseData,
        );
    }
  }

  /// Wraps an async operation with error handling.
  ///
  /// This method provides a convenient way to execute async operations while
  /// automatically handling network exceptions and converting them to failures.
  ///
  /// Returns `null` if an error occurs and handles it appropriately.
  ///
  /// [operation] - The async operation to execute.
  /// [context] - Optional context for error reporting.
  /// [onError] - Optional callback for handling errors.
  static Future<T?> guard<T>(
    Future<T> Function() operation, {
    String? context,
    void Function(NetworkException failure)? onError,
  }) async {
    try {
      return await operation();
    } catch (e, stack) {
      final failure = mapExceptionToFailure(e, stack);

      // Report if needed
      if (ErrorHandler.crashReportingEnabled && !kDebugMode) {
        await ErrorHandler.reportError(e, stackTrace: stack, reason: context);
      }

      // Call error callback if provided
      onError?.call(failure);

      return null;
    }
  }
}

// ============================================================================
// EXTENSIONS FOR CONVERTING TO FAILURES
// ============================================================================

/// Extension to convert NetworkException to Failure.
///
/// This extension provides a clean way to convert our network exceptions
/// to domain failures that can be used throughout the application.
extension NetworkExceptionToFailure on NetworkException {
  /// Converts NetworkException to Failure.
  ///
  /// This method maps each NetworkException type to its corresponding
  /// domain Failure type, maintaining consistency between layers.
  Failure toFailure() {
    return switch (this) {
      NoInternetException() => Failure.network(message: message),
      TimeoutException() => Failure.timeout(message: message),
      ServerException() => Failure.server(
        message: message,
        statusCode: statusCode,
      ),
      BadRequestException() => Failure.badRequest(message: message),
      UnauthorizedException() => Failure.unauthorized(message: message),
      ForbiddenException() => Failure.unauthorized(message: message),
      NotFoundException() => Failure.notFound(message: message),
      ConflictException() => Failure.conflict(message: message),
      ValidationException() => Failure.validation(message: message),
      RateLimitException(:final retryAfter) => Failure.rateLimit(
        message: message,
        retryAfter: retryAfter?.inSeconds.toInt(),
      ),
      RequestCancelledException() => Failure.unknown(message: message),
      UnknownNetworkException() => Failure.unknown(message: message),
    };
  }
}
