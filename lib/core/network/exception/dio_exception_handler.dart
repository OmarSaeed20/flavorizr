// import 'package:dio/dio.dart';
// import 'package:flavorizr/core/error/failures.dart';
// import 'package:flavorizr/core/network/exception/network_exceptions.dart';

// /// Handles DioExceptions and converts them to appropriate failures
// class DioExceptionHandler {
//   /// Convert a DioException to a Failure
//   static Failure handleException(DioException e) {
//     final networkException = NetworkExceptionFactory.fromDioException(e);
//     return _mapExceptionToFailure(networkException);
//   }

//   /// Convert a generic exception to a Failure
//   static Failure handleGenericException(Object e, [StackTrace? stackTrace]) {
//     if (e is DioException) {
//       return handleException(e);
//     }
//     if (e is NetworkException) {
//       return _mapExceptionToFailure(e);
//     }
//     return UnexpectedFailure(message: e.toString());
//   }

//   static Failure _mapExceptionToFailure(NetworkException e) {
//     return switch (e) {
//       NoInternetException() => const NetworkFailure(),
//       TimeoutException() => const TimeoutFailure(),
//       ServerException() => ServerFailure(message: e.message, statusCode: e.statusCode),
//       BadRequestException() => BadRequestFailure(message: e.message),
//       UnauthorizedException() => const UnauthenticatedFailure(
//         message: 'Session expired. Please login again.',
//       ),
//       ForbiddenException() => const UnauthorizedFailure(
//         message: 'You do not have permission to perform this action.',
//       ),
//       NotFoundException() => NotFoundFailure(message: e.message),
//       ConflictException() => ConflictFailure(message: e.message),
//       ValidationException(errors: final errors) => ValidationFailure(
//         message: e.message,
//         fieldErrors: errors ?? {},
//       ),
//       RateLimitException() => RateLimitFailure(
//         message: e.message,
//         retryAfter: e.retryAfter?.inSeconds,
//       ),
//       RequestCancelledException() => const CancelledFailure(),
//       UnknownNetworkException() => UnexpectedFailure(message: e.message),
//     };
//   }
// }
