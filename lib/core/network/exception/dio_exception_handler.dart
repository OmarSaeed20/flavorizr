import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';

class DioExceptionHandler {
  static Future<NetworkException> handleDioException(
    DioException error,
  ) async => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => NetworkException.requestTimeout(),

    DioExceptionType.badResponse => _handleStatusCode(
      error.response?.statusCode,
    ),

    DioExceptionType.cancel => NetworkException.requestCancelled(),

    DioExceptionType.connectionError => _handel,

    DioExceptionType.unknown => NetworkException.unexpectedError(),

    DioExceptionType.badCertificate => NetworkException.unexpectedError(),
  };

  static Future<NetworkException> get _handel async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return switch (connectivityResult.first == ConnectivityResult.none) {
      true => NetworkException.noInternetConnection(),
      false => NetworkException.unexpectedError(),
    };
  }

  static NetworkException _handleStatusCode(int? statusCode) =>
      switch (statusCode) {
        400 => const NetworkException(
          message: 'Bad request',
          statusCode: 400,
          errorCode: 'BAD_REQUEST',
        ),
        401 => NetworkException.unauthorizedRequest(),
        403 => NetworkException.forbidden(),
        404 => NetworkException.notFound(),
        500 || 502 || 503 || 504 => NetworkException.serverError(statusCode!),
        _ => NetworkException.unexpectedError(),
      };
}
