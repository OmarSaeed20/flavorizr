import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api/endpoints/chat_endpoints.dart';
import 'package:flavorizr/core/network/api/models/api_chat.dart';
import 'package:flavorizr/core/network/api/parameters/chat_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/chat_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Chat Repository Implementation
/// Implements the chat repository interface using Dio for API calls
class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;

  ChatRepositoryImpl(this._dio);

  @override
  Future<ApiResult<ApiResponse<List<ApiChatMessage>>>> getChatByOrder(
    GetChatByOrderParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        ChatEndpoints.getChatByOrder,
        data: {'order_id': parameters.orderId},
        queryParameters: {
          'page': parameters.page,
          'per_page': parameters.pageSize,
        },
      );

      final apiResponse = ApiResponse<List<ApiChatMessage>>.fromJson(
        response.data,
        (json) => (json as List)
            .map(
              (item) => ApiChatMessage.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );

      return ApiResult.success(apiResponse);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ApiResult.exception(TimeoutException());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const ApiResult.exception(NoInternetException());
      }
      return ApiResult.exception(
        ServerException(
          message: e.message ?? 'Failed to get chat messages',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiChatMessage>>> saveMessage(
    SaveMessageParameters parameters,
  ) async {
    try {
      final response = await _dio.post(
        ChatEndpoints.saveMessage,
        data: {
          'order_id': parameters.orderId,
          'driver_id': parameters.driverId,
          'message': parameters.message,
        },
      );

      final apiResponse = ApiResponse<ApiChatMessage>.fromJson(
        response.data,
        (json) => ApiChatMessage.fromJson(json as Map<String, dynamic>),
      );

      return ApiResult.success(apiResponse);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ApiResult.exception(TimeoutException());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const ApiResult.exception(NoInternetException());
      }
      return ApiResult.exception(
        ServerException(
          message: e.message ?? 'Failed to save message',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'An unexpected error occurred: $e',
          exception: e,
        ),
      );
    }
  }
}
