import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api/endpoints/notification_endpoints.dart';
import 'package:flavorizr/core/network/api/models/api_notification.dart';
import 'package:flavorizr/core/network/api/parameters/notification_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/notification_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Notification Repository Implementation
/// Implements the notification repository interface using Dio for API calls
class NotificationRepositoryImpl implements NotificationRepository {
  final Dio _dio;

  NotificationRepositoryImpl(this._dio);

  @override
  Future<ApiResult<ApiResponse<List<ApiNotification>>>> getNotifications(
    GetNotificationsParameters parameters,
  ) async {
    try {
      final response = await _dio.get(
        NotificationEndpoints.getNotifications,
        queryParameters: {'page': parameters.page, 'page_size': parameters.pageSize},
      );

      final apiResponse = ApiResponse<List<ApiNotification>>.fromJson(
        response.data,
        (json) => (json as List)
            .map((item) => ApiNotification.fromJson(item as Map<String, dynamic>))
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
          message: e.message ?? 'Failed to get notifications',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(UnknownNetworkException(message: 'An unexpected error occurred: $e', exception: e));
    }
  }

  @override
  Future<ApiResult<ApiResponse<ApiNotificationCount>>> getNotificationCount(
    GetNotificationCountParameters parameters,
  ) async {
    try {
      final response = await _dio.get(NotificationEndpoints.getNotificationCount);

      final apiResponse = ApiResponse<ApiNotificationCount>.fromJson(
        response.data,
        (json) => ApiNotificationCount.fromJson(json as Map<String, dynamic>),
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
          message: e.message ?? 'Failed to get notification count',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ApiResult.exception(UnknownNetworkException(message: 'An unexpected error occurred: $e', exception: e));
    }
  }
}
