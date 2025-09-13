import 'package:dio/dio.dart';

class NetworkException implements Exception {
  const NetworkException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.underlyingException,
    this.uri,
  });

  factory NetworkException.noInternetConnection() {
    return const NetworkException(
      message: 'No internet connection',
      errorCode: 'NO_INTERNET',
    );
  }

  factory NetworkException.requestTimeout() {
    return const NetworkException(
      message: 'Request timeout',
      errorCode: 'TIMEOUT',
    );
  }

  factory NetworkException.serverError(int statusCode) {
    return NetworkException(
      message: 'Server error occurred',
      statusCode: statusCode,
      errorCode: 'SERVER_ERROR',
    );
  }

  factory NetworkException.unauthorizedRequest() {
    return const NetworkException(
      message: 'Unauthorized request',
      statusCode: 401,
      errorCode: 'UNAUTHORIZED',
    );
  }

  factory NetworkException.forbidden() {
    return const NetworkException(
      message: 'Access forbidden',
      statusCode: 403,
      errorCode: 'FORBIDDEN',
    );
  }

  factory NetworkException.notFound() {
    return const NetworkException(
      message: 'Resource not found',
      statusCode: 404,
      errorCode: 'NOT_FOUND',
    );
  }

  factory NetworkException.requestCancelled() {
    return const NetworkException(
      message: 'Request was cancelled',
      errorCode: 'REQUEST_CANCELLED',
    );
  }

  factory NetworkException.unexpectedError() {
    return const NetworkException(
      message: 'Unexpected error occurred',
      errorCode: 'UNEXPECTED_ERROR',
    );
  }

  factory NetworkException.unableToProcessException() {
    return const NetworkException(
      message: 'Unable to process exception error occurred',
      errorCode: 'UNABLE_TO_PROCESS_EXCEPTION',
    );
  }

  // New factory constructors
  factory NetworkException.badRequest({String? message}) {
    return NetworkException(
      message: message ?? 'Bad request',
      statusCode: 400,
      errorCode: 'BAD_REQUEST',
    );
  }

  factory NetworkException.conflict({String? message}) {
    return NetworkException(
      message: message ?? 'Conflict occurred',
      statusCode: 409,
      errorCode: 'CONFLICT',
    );
  }

  factory NetworkException.tooManyRequests() {
    return const NetworkException(
      message: 'Too many requests',
      statusCode: 429,
      errorCode: 'TOO_MANY_REQUESTS',
    );
  }

  factory NetworkException.gatewayTimeout() {
    return const NetworkException(
      message: 'Gateway timeout',
      statusCode: 504,
      errorCode: 'GATEWAY_TIMEOUT',
    );
  }

  factory NetworkException.serviceUnavailable() {
    return const NetworkException(
      message: 'Service unavailable',
      statusCode: 503,
      errorCode: 'SERVICE_UNAVAILABLE',
    );
  }

  factory NetworkException.fromDioException(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.requestTimeout();
      case DioExceptionType.badCertificate:
        return NetworkException.unauthorizedRequest();
      case DioExceptionType.badResponse:
        return NetworkException._fromResponse(dioError.response);
      case DioExceptionType.cancel:
        return NetworkException.requestCancelled();
      case DioExceptionType.connectionError:
        return NetworkException.noInternetConnection();
      case DioExceptionType.unknown:
        return NetworkException.unexpectedError();
    }
  }

  factory NetworkException._fromResponse(Response? response) {
    final statusCode = response?.statusCode;
    final message = response?.statusMessage ?? 'Network error occurred';

    switch (statusCode) {
      case 400:
        return NetworkException.badRequest(message: message);
      case 401:
        return NetworkException.unauthorizedRequest();
      case 403:
        return NetworkException.forbidden();
      case 404:
        return NetworkException.notFound();
      case 409:
        return NetworkException.conflict(message: message);
      case 429:
        return NetworkException.tooManyRequests();
      case 500:
        return NetworkException.serverError(500);
      case 503:
        return NetworkException.serviceUnavailable();
      case 504:
        return NetworkException.gatewayTimeout();
      default:
        return NetworkException(
          message: message,
          statusCode: statusCode,
          errorCode: 'HTTP_$statusCode',
        );
    }
  }

  final String message;
  final int? statusCode;
  final String? errorCode;
  final Exception? underlyingException;
  final Uri? uri;

  bool get isNoInternet => errorCode == 'NO_INTERNET';
  bool get isTimeout => errorCode == 'TIMEOUT';
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;

  @override
  String toString() {
    final buffer = StringBuffer('NetworkException: $message');

    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }

    if (errorCode != null) {
      buffer.write(' [Code: $errorCode]');
    }

    if (uri != null) {
      buffer.write(' - URI: $uri');
    }

    if (underlyingException != null) {
      buffer.write(' - Caused by: $underlyingException');
    }

    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'errorCode': errorCode,
      'uri': uri?.toString(),
      'underlyingException': underlyingException?.toString(),
    };
  }

  NetworkException copyWith({
    String? message,
    int? statusCode,
    String? errorCode,
    Exception? underlyingException,
    Uri? uri,
  }) {
    return NetworkException(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      errorCode: errorCode ?? this.errorCode,
      underlyingException: underlyingException ?? this.underlyingException,
      uri: uri ?? this.uri,
    );
  }
}
