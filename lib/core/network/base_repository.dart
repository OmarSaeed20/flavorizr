import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/exception/dio_exception_handler.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';

abstract class BaseRepository {
  // final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<T>> safeApiCall<T>(
    Future<Response<T?>> apiCall,
    T Function(dynamic) dataParser,
  ) async {
    try {
      final response = await apiCall;
      final resData = response.data;
      final parsedData = dataParser(resData);

      return ApiResponse.success(
        parsedData,
        message: resData != null
            ? (resData is Map ? resData['message'].toString() : '')
            : '',
        statusCode: response.statusCode,
      );
    } on NetworkException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } catch (e) {
      switch (e.runtimeType) {
        case DioException _:
          final networkException = await DioExceptionHandler.handleDioException(
            e as DioException,
          );
          return ApiResponse.error(
            networkException.message,
            statusCode: e.response?.statusCode ?? 0,
          );

        default:
          return ApiResponse.error('Unexpected error occurred: $e',);
      }
    }
  }
}

// Example usage:
// lib/data/repositories/user_repository.dart
/*
class UserRepository extends BaseRepository {
  Future<ApiResponse<User>> getUser(String userId) async {
    return safeApiCall(
      apiClient.get('/users/$userId'),
      (data) => User.fromJson(data),
    );
  }

  Future<ApiResponse<List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    CancelToken? cancelToken,
  }) async {
    return safeApiCall(
      apiClient.get(
        '/users',
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: cancelToken,
      ),
      (data) => (data['users'] as List)
          .map((user) => User.fromJson(user))
          .toList(),
    );
  }
}
*/
