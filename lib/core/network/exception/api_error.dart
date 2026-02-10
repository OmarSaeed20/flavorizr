// lib/core/network/exception/api_error.dart
/// API Error types for use cases and business logic.
///
/// This provides a simplified interface for creating API errors
/// that are compatible with NetworkException.
library;

import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';

/// API Error factory for creating domain-specific network exceptions.
///
/// This class provides factory constructors for creating different types
/// of API errors that are compatible with NetworkException. It serves as
/// a convenience layer for business logic to create appropriate network
/// exceptions without needing to import specific exception classes.
abstract class ApiError {
  /// Private constructor to prevent instantiation.
  const ApiError._();

  /// Creates a validation error for form/input validation failures.
  ///
  /// Used when request data fails server-side validation.
  ///
  /// [message] - Human-readable error message.
  /// [errors] - Field-specific validation errors.
  /// [data] - Additional error data.
  static ValidationException validation({
    required String message,
    Map<String, List<String>>? errors,
    dynamic data,
  }) {
    return ValidationException(message: message, errors: errors, data: data);
  }

  /// Creates a bad request error for malformed requests.
  ///
  /// Used when the client sends invalid data or malformed requests.
  ///
  /// [message] - Human-readable error message.
  /// [data] - Additional error data.
  static BadRequestException badRequest({
    String message = 'Bad request. Please check your input.',
    dynamic data,
  }) {
    return BadRequestException(message: message, data: data);
  }

  /// Creates an unauthorized error for authentication failures.
  ///
  /// Used when authentication is required but missing or invalid.
  ///
  /// [message] - Human-readable error message.
  /// [data] - Additional error data.
  static UnauthorizedException unauthorized({
    String message = 'Unauthorized. Please login again.',
    dynamic data,
  }) {
    return UnauthorizedException(message: message, data: data);
  }

  /// Creates a forbidden error for authorization failures.
  ///
  /// Used when the user is authenticated but lacks required permissions.
  ///
  /// [message] - Human-readable error message.
  /// [data] - Additional error data.
  static ForbiddenException forbidden({
    String message = 'Access forbidden.',
    dynamic data,
  }) {
    return ForbiddenException(message: message, data: data);
  }

  /// Creates a not found error for missing resources.
  ///
  /// Used when the requested resource does not exist.
  ///
  /// [message] - Human-readable error message.
  /// [data] - Additional error data.
  static NotFoundException notFound({
    String message = 'Resource not found.',
    dynamic data,
  }) {
    return NotFoundException(message: message, data: data);
  }

  /// Creates a conflict error for resource state conflicts.
  ///
  /// Used when the request conflicts with the current state of the resource.
  ///
  /// [message] - Human-readable error message.
  /// [data] - Additional error data.
  static ConflictException conflict({
    String message = 'Conflict with current state.',
    dynamic data,
  }) {
    return ConflictException(message: message, data: data);
  }

  /// Creates a server error for internal server issues.
  ///
  /// Used when the server encounters an error processing the request.
  ///
  /// [message] - Human-readable error message.
  /// [statusCode] - HTTP status code.
  /// [data] - Additional error data.
  static ServerException server({
    String message = 'Server error. Please try again later.',
    int? statusCode,
    dynamic data,
  }) {
    return ServerException(
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  /// Creates a network error for connectivity issues.
  ///
  /// Used when the device has no network connectivity.
  ///
  /// [message] - Human-readable error message.
  static NoInternetException network({
    String message = 'No internet connection. Please check your network.',
  }) {
    return const NoInternetException();
  }

  /// Creates a timeout error for request timeouts.
  ///
  /// Used when a network request exceeds the allowed time limit.
  ///
  /// [message] - Human-readable error message.
  static TimeoutException timeout({
    String message = 'Request timed out. Please try again.',
  }) {
    return const TimeoutException();
  }

  /// Creates a rate limit error for too many requests.
  ///
  /// Used when too many requests are made in a given timeframe.
  ///
  /// [message] - Human-readable error message.
  /// [retryAfter] - Time to wait before retrying.
  /// [data] - Additional error data.
  static RateLimitException rateLimit({
    String message = 'Too many requests. Please wait and try again.',
    Duration? retryAfter,
    dynamic data,
  }) {
    return RateLimitException(
      message: message,
      retryAfter: retryAfter,
      data: data,
    );
  }

  /// Creates an unknown error for unexpected issues.
  ///
  /// Used when an error occurs that doesn't fit into other categories.
  ///
  /// [message] - Human-readable error message.
  /// [statusCode] - HTTP status code if applicable.
  /// [data] - Additional error data.
  /// [exception] - The underlying exception that caused this error.
  static UnknownNetworkException unknown({
    String message = 'An unknown error occurred.',
    int? statusCode,
    dynamic data,
    Object? exception,
  }) {
    return UnknownNetworkException(
      message: message,
      statusCode: statusCode,
      data: data,
      exception: exception,
    );
  }
}
