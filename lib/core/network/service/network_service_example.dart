// lib/core/network/service/network_service_example.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/interceptor/network_interceptor.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';

/// Example network service demonstrating proper exception handling.
///
/// This service showcases:
/// - Proper Dio setup with interceptors
/// - Error handling using NetworkException
/// - Conversion to domain failures
/// - Guarded operations
class NetworkServiceExample {
  late final Dio _dio;

  NetworkServiceExample() {
    _dio = Dio();
    _setupInterceptors();
  }

  /// Setup interceptors for the Dio client
  void _setupInterceptors() {
    _dio.interceptors.add(NetworkInterceptor());
  }

  /// Fetch data from an endpoint with proper error handling
  Future<ApiResult<T>> fetchData<T>(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);

      // Validate response
      if (response.statusCode == null || response.statusCode! >= 400) {
        throw ServerException(
          message: 'Server returned error status: ${response.statusCode}',
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      // Parse and return data
      return ApiResult.success(response.data as T);
    } on NetworkException catch (e) {
      // Convert to domain failure
      return ApiResult.exception(e);
    } catch (e, stack) {
      // Handle any other unexpected errors
      final exception = NetworkExceptionFactory.mapExceptionToFailure(e, stack);
      return ApiResult.exception(exception);
    }
  }

  /// Post data to an endpoint with proper error handling
  Future<ApiResult<T>> postData<T>(String endpoint, dynamic data) async {
    return NetworkExceptionFactory.guard(() async {
      final response = await _dio.post(endpoint, data: data);

      // Validate response
      if (response.statusCode == null || response.statusCode! >= 400) {
        throw ServerException(
          message: 'Server returned error status: ${response.statusCode}',
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      return response.data as T;
    }).then(
      (value) => value != null
          ? ApiResult.success(value)
          : ApiResult.exception(
              const UnknownNetworkException(message: 'Unknown error occurred'),
            ),
    );
  }

  /// Update data at an endpoint with proper error handling
  Future<ApiResult<T>> putData<T>(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);

      // Validate response
      if (response.statusCode == null || response.statusCode! >= 400) {
        throw ServerException(
          message: 'Server returned error status: ${response.statusCode}',
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      return ApiResult.success(response.data as T);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, stack) {
      final exception = NetworkExceptionFactory.mapExceptionToFailure(e, stack);
      return ApiResult.exception(exception);
    }
  }

  /// Delete data at an endpoint with proper error handling
  Future<ApiResult<void>> deleteData(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);

      // Validate response
      if (response.statusCode == null || response.statusCode! >= 400) {
        throw ServerException(
          message: 'Server returned error status: ${response.statusCode}',
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, stack) {
      final exception = NetworkExceptionFactory.mapExceptionToFailure(e, stack);
      return ApiResult.exception(exception);
    }
  }
}
