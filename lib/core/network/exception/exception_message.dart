import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';

/// Helper class to extract user-friendly messages from exceptions
class ExceptionMessage {
  /// Get a user-friendly message from a NetworkException
  static String fromNetworkException(NetworkException e) {
    return switch (e) {
      NoInternetException() => 'No internet connection. Please check your network and try again.',
      TimeoutException() => 'The request took too long. Please try again.',
      ServerException() => 'Something went wrong on our end. Please try again later.',
      BadRequestException() => e.message,
      UnauthorizedException() => 'Your session has expired. Please sign in again.',
      ForbiddenException() => "You don't have permission to access this resource.",
      NotFoundException() => 'The requested resource was not found.',
      ConflictException() => e.message,
      ValidationException() => 'Please check your input and try again.',
      RateLimitException() => 'Too many requests. Please wait a moment and try again.',
      RequestCancelledException() => 'Request was cancelled.',
      UnknownNetworkException() => 'An unexpected error occurred. Please try again.',
    };
  }

  /// Get a user-friendly message from a Failure
  static String fromFailure(Failure failure) {
    return failure.message;
  }

  /// Get a short error code for logging/analytics
  static String errorCode(NetworkException e) {
    return switch (e) {
      NoInternetException() => 'NO_INTERNET',
      TimeoutException() => 'TIMEOUT',
      ServerException() => 'SERVER_ERROR_${e.statusCode}',
      BadRequestException() => 'BAD_REQUEST',
      UnauthorizedException() => 'UNAUTHORIZED',
      ForbiddenException() => 'FORBIDDEN',
      NotFoundException() => 'NOT_FOUND',
      ConflictException() => 'CONFLICT',
      ValidationException() => 'VALIDATION_ERROR',
      RateLimitException() => 'RATE_LIMITED',
      RequestCancelledException() => 'CANCELLED',
      UnknownNetworkException() => 'UNKNOWN_${e.statusCode ?? "ERROR"}',
    };
  }

  /// Check if the exception is recoverable (user can retry)
  static bool isRecoverable(NetworkException e) {
    return switch (e) {
      NoInternetException() => true,
      TimeoutException() => true,
      ServerException() => true,
      RateLimitException() => true,
      BadRequestException() => false,
      UnauthorizedException() => false,
      ForbiddenException() => false,
      NotFoundException() => false,
      ConflictException() => false,
      ValidationException() => false,
      RequestCancelledException() => false,
      UnknownNetworkException() => true,
    };
  }

  /// Get suggested action based on exception
  static String suggestedAction(NetworkException e) {
    return switch (e) {
      NoInternetException() => 'Check your internet connection and try again.',
      TimeoutException() => 'The server is taking too long. Try again later.',
      ServerException() => 'Our servers are having issues. Please try again later.',
      BadRequestException() => 'Please review your input.',
      UnauthorizedException() => 'Please sign in to continue.',
      ForbiddenException() => 'Contact support if you believe this is an error.',
      NotFoundException() => "The item you're looking for may have been removed.",
      ConflictException() => 'Refresh and try again.',
      ValidationException() => 'Please correct the highlighted fields.',
      RateLimitException() => 'Wait a few minutes before trying again.',
      RequestCancelledException() => 'You can try the action again.',
      UnknownNetworkException() => 'Try again or contact support if the issue persists.',
    };
  }
}
