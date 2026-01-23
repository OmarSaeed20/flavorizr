import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/exception/dio_exception_handler.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';

abstract class BaseRepository {
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
        message: resData != null ? (resData is Map ? resData['message'].toString() : '') : '',
        statusCode: response.statusCode,
      );
    } on NetworkException catch (e) {
      return ApiResponse.error(e.message, statusCode: e.statusCode);
    } on DioException catch (e) {
      final failure = DioExceptionHandler.handleException(e);
      return ApiResponse.error(failure.message, statusCode: e.response?.statusCode ?? 0);
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }
}
