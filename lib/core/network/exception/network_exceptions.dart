import 'dart:io';

import 'package:dio/dio.dart';

/// Base class for all network exceptions
sealed class NetworkException implements Exception {
  const NetworkException({required this.message, this.statusCode, this.data});
  final String message;
  final int? statusCode;
  final dynamic data;

  @override
  String toString() => 'NetworkException: $message (statusCode: $statusCode)';
}

/// No internet connection
class NoInternetException extends NetworkException {
  const NoInternetException()
    : super(message: 'No internet connection. Please check your network.', statusCode: null);
}

/// Request timeout
class TimeoutException extends NetworkException {
  const TimeoutException()
    : super(message: 'Request timed out. Please try again.', statusCode: 408);
}

/// Server error (5xx)
class ServerException extends NetworkException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.statusCode = 500,
    super.data,
  });
}

/// Bad request (400)
class BadRequestException extends NetworkException {
  const BadRequestException({super.message = 'Bad request. Please check your input.', super.data})
    : super(statusCode: 400);
}

/// Unauthorized (401)
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({super.message = 'Unauthorized. Please login again.', super.data})
    : super(statusCode: 401);
}

/// Forbidden (403)
class ForbiddenException extends NetworkException {
  const ForbiddenException({super.message = 'Access forbidden.', super.data})
    : super(statusCode: 403);
}

/// Not found (404)
class NotFoundException extends NetworkException {
  const NotFoundException({super.message = 'Resource not found.', super.data})
    : super(statusCode: 404);
}

/// Conflict (409)
class ConflictException extends NetworkException {
  const ConflictException({super.message = 'Conflict with current state.', super.data})
    : super(statusCode: 409);
}

/// Unprocessable entity (422)
class ValidationException extends NetworkException {
  const ValidationException({super.message = 'Validation failed.', super.data, this.errors})
    : super(statusCode: 422);
  final Map<String, List<String>>? errors;
}

/// Rate limit exceeded (429)
class RateLimitException extends NetworkException {
  const RateLimitException({
    super.message = 'Too many requests. Please wait and try again.',
    this.retryAfter,
    super.data,
  }) : super(statusCode: 429);
  final Duration? retryAfter;
}

/// Request cancelled
class RequestCancelledException extends NetworkException {
  const RequestCancelledException() : super(message: 'Request was cancelled.', statusCode: null);
}

/// Unknown/generic error
class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({
    super.message = 'An unknown error occurred.',
    super.statusCode,
    super.data,
    this.originalError,
  });
  final Object? originalError;
}

/// Factory for creating appropriate exception from DioException
class NetworkExceptionFactory {
  static NetworkException fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.badCertificate:
        return const UnknownNetworkException(message: 'Invalid SSL certificate.');

      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          return const NoInternetException();
        }
        return const UnknownNetworkException(
          message: 'Connection error. Please check your network.',
        );

      case DioExceptionType.cancel:
        return const RequestCancelledException();

      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response);

      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const NoInternetException();
        }
        return UnknownNetworkException(
          message: e.message ?? 'An unknown error occurred.',
          originalError: e.error,
        );
    }
  }

  static NetworkException _handleStatusCode(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final message = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(message: message, data: data);
      case 401:
        return UnauthorizedException(message: message, data: data);
      case 403:
        return ForbiddenException(message: message, data: data);
      case 404:
        return NotFoundException(message: message, data: data);
      case 409:
        return ConflictException(message: message, data: data);
      case 422:
        return ValidationException(
          message: message,
          data: data,
          errors: _extractValidationErrors(data),
        );
      case 429:
        return RateLimitException(
          message: message,
          data: data,
          retryAfter: _extractRetryAfter(response),
        );
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerException(message: message, statusCode: statusCode, data: data);
      default:
        return UnknownNetworkException(message: message, statusCode: statusCode, data: data);
    }
  }

  static String _extractMessage(dynamic data) {
    if (data == null) return 'An error occurred';
    if (data is String) return data;
    if (data is Map) {
      return data['message'] ?? data['error'] ?? data['error_description'] ?? 'An error occurred';
    }
    return 'An error occurred';
  }

  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is! Map) return null;

    return errors.map((key, value) {
      if (value is List) {
        return MapEntry(key.toString(), value.map((e) => e.toString()).toList());
      }
      return MapEntry(key.toString(), [value.toString()]);
    });
  }

  static Duration? _extractRetryAfter(Response? response) {
    final retryAfter = response?.headers.value('retry-after');
    if (retryAfter == null) return null;

    final seconds = int.tryParse(retryAfter);
    return seconds != null ? Duration(seconds: seconds) : null;
  }
}
