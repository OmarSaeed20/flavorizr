// test/core/network/exception/network_exceptions_test.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/error/failures.dart' as failures;
import 'package:fast_golden_taxi/core/network/exception/api_error.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkException', () {
    test('NoInternetException should be instantiated correctly', () {
      const exception = NoInternetException();
      expect(
        exception.message,
        'No internet connection. Please check your network.',
      );
      expect(exception.statusCode, isNull);
    });

    test('TimeoutException should be instantiated correctly', () {
      const exception = TimeoutException();
      expect(exception.message, 'Request timed out. Please try again.');
      expect(exception.statusCode, 408);
    });

    test('ServerException should be instantiated correctly', () {
      const exception = ServerException(
        message: 'Custom server error',
        statusCode: 503,
        data: {'error': 'Service unavailable'},
      );
      expect(exception.message, 'Custom server error');
      expect(exception.statusCode, 503);
      expect(exception.data, {'error': 'Service unavailable'});
    });

    test('BadRequestException should be instantiated correctly', () {
      const exception = BadRequestException(
        message: 'Invalid request data',
        data: {'field': 'Invalid value'},
      );
      expect(exception.message, 'Invalid request data');
      expect(exception.statusCode, 400);
      expect(exception.data, {'field': 'Invalid value'});
    });

    test('UnauthorizedException should be instantiated correctly', () {
      const exception = UnauthorizedException();
      expect(exception.message, 'Unauthorized. Please login again.');
      expect(exception.statusCode, 401);
    });

    test('ForbiddenException should be instantiated correctly', () {
      const exception = ForbiddenException();
      expect(exception.message, 'Access forbidden.');
      expect(exception.statusCode, 403);
    });

    test('NotFoundException should be instantiated correctly', () {
      const exception = NotFoundException();
      expect(exception.message, 'Resource not found.');
      expect(exception.statusCode, 404);
    });

    test('ConflictException should be instantiated correctly', () {
      const exception = ConflictException();
      expect(exception.message, 'Conflict with current state.');
      expect(exception.statusCode, 409);
    });

    test('ValidationException should be instantiated correctly', () {
      const exception = ValidationException(
        message: 'Validation failed',
        errors: {
          'email': ['Invalid email format'],
        },
      );
      expect(exception.message, 'Validation failed');
      expect(exception.statusCode, 422);
      expect(exception.errors, {
        'email': ['Invalid email format'],
      });
    });

    test('RateLimitException should be instantiated correctly', () {
      const exception = RateLimitException(
        message: 'Rate limit exceeded',
        retryAfter: Duration(seconds: 30),
      );
      expect(exception.message, 'Rate limit exceeded');
      expect(exception.statusCode, 429);
      expect(exception.retryAfter, const Duration(seconds: 30));
    });

    test('RequestCancelledException should be instantiated correctly', () {
      const exception = RequestCancelledException();
      expect(exception.message, 'Request was cancelled.');
      expect(exception.statusCode, isNull);
    });

    test('UnknownNetworkException should be instantiated correctly', () {
      const exception = UnknownNetworkException(
        message: 'Unknown error',
        statusCode: 500,
        exception: 'Original exception',
      );
      expect(exception.message, 'Unknown error');
      expect(exception.statusCode, 500);
      expect(exception.exception, 'Original exception');
    });
  });

  group('NetworkExceptionFactory', () {
    test('should map DioException connection timeout to TimeoutException', () {
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = NetworkExceptionFactory.mapExceptionToFailure(
        dioException,
      );
      expect(exception, isA<TimeoutException>());
    });

    test('should map DioException connection error to NoInternetException', () {
      final dioException = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = NetworkExceptionFactory.mapExceptionToFailure(
        dioException,
      );
      expect(exception, isA<NoInternetException>());
    });

    test('should map SocketException to NoInternetException', () {
      const socketException = SocketException('No internet');
      final exception = NetworkExceptionFactory.mapExceptionToFailure(
        socketException,
      );
      expect(exception, isA<NoInternetException>());
    });

    test('should map DioException bad response 400 to BadRequestException', () {
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {'message': 'Bad request'},
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = NetworkExceptionFactory.mapExceptionToFailure(
        dioException,
      );
      expect(exception, isA<BadRequestException>());
    });

    test('should map DioException bad response 422 to ValidationException', () {
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 422,
          data: {
            'message': 'Validation failed',
            'errors': {
              'email': ['Invalid format'],
            },
          },
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = NetworkExceptionFactory.mapExceptionToFailure(
        dioException,
      );
      expect(exception, isA<ValidationException>());
      expect((exception as ValidationException).errors, {
        'email': ['Invalid format'],
      });
    });

    test('should map DioException bad response 500 to ServerException', () {
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 500,
          data: {'message': 'Internal server error'},
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );
      final exception = NetworkExceptionFactory.mapExceptionToFailure(
        dioException,
      );
      expect(exception, isA<ServerException>());
    });

    test('should map unknown exception to UnknownNetworkException', () {
      final exception = NetworkExceptionFactory.mapExceptionToFailure(
        Exception('Unknown'),
      );
      expect(exception, isA<UnknownNetworkException>());
    });
  });

  group('NetworkExceptionToFailure Extension', () {
    test('NoInternetException should convert to NetworkFailure', () {
      const exception = NoInternetException();
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });

    test('TimeoutException should convert to TimeoutFailure', () {
      const exception = TimeoutException();
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });

    test('ServerException should convert to ServerFailure', () {
      const exception = ServerException(statusCode: 503);
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });

    test('BadRequestException should convert to BadRequestFailure', () {
      const exception = BadRequestException();
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });

    test('UnauthorizedException should convert to UnauthorizedFailure', () {
      const exception = UnauthorizedException();
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });

    test('ValidationException should convert to ValidationFailure', () {
      const exception = ValidationException();
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });

    test('RateLimitException should convert to RateLimitFailure', () {
      const exception = RateLimitException(retryAfter: Duration(seconds: 30));
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });

    test('UnknownNetworkException should convert to UnknownFailure', () {
      const exception = UnknownNetworkException();
      final failure = exception.toFailure();
      expect(failure, isA<failures.Failure>());
      expect(failure.message, exception.message);
    });
  });

  group('ApiError', () {
    test('should create validation error', () {
      final exception = ApiError.validation(
        message: 'Validation failed',
        errors: {
          'email': ['Invalid format'],
        },
      );
      expect(exception, isA<ValidationException>());
      expect(exception.message, 'Validation failed');
      expect(exception.errors, {
        'email': ['Invalid format'],
      });
    });

    test('should create bad request error', () {
      final exception = ApiError.badRequest(message: 'Bad request');
      expect(exception, isA<BadRequestException>());
      expect(exception.message, 'Bad request');
    });

    test('should create unauthorized error', () {
      final exception = ApiError.unauthorized();
      expect(exception, isA<UnauthorizedException>());
      expect(exception.message, 'Unauthorized. Please login again.');
    });

    test('should create server error', () {
      final exception = ApiError.server(statusCode: 503);
      expect(exception, isA<ServerException>());
      expect(exception.statusCode, 503);
    });

    test('should create network error', () {
      final exception = ApiError.network();
      expect(exception, isA<NoInternetException>());
    });

    test('should create timeout error', () {
      final exception = ApiError.timeout();
      expect(exception, isA<TimeoutException>());
    });

    test('should create unknown error', () {
      final exception = ApiError.unknown(message: 'Unknown error');
      expect(exception, isA<UnknownNetworkException>());
      expect(exception.message, 'Unknown error');
    });
  });
}
