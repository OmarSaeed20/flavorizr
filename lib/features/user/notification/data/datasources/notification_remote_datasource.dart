import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/notification/data/endpoints/notification_endpoints.dart';
import 'package:fast_golden_taxi/features/user/notification/data/models/notification_model.dart';
import 'package:fast_golden_taxi/features/user/notification/data/parameters/get_notifications_parameters.dart';

/// Remote data source for notification operations.
///
/// Handles all HTTP requests related to notifications.
/// Returns ApiResult with success or error data.
abstract class NotificationRemoteDataSource {
  /// Gets notifications with pagination.
  Future<ApiResult<List<NotificationModel>>> getNotifications(
    GetNotificationsParameters parameters,
  );

  /// Gets notification count.
  Future<ApiResult<int>> getNotificationCount();

  /// Marks a notification as read.
  Future<ApiResult<void>> markAsRead(int notificationId);

  /// Marks all notifications as read.
  Future<ApiResult<void>> markAllAsRead();
}

/// Implementation of [NotificationRemoteDataSource] using BaseRemoteDataSource.
class NotificationRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<List<NotificationModel>>> getNotifications(
    GetNotificationsParameters parameters,
  ) async {
    return get<List<NotificationModel>>(
      path: NotificationEndpoints.notifications,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<int>> getNotificationCount() async {
    return get<int>(
      path: NotificationEndpoints.notificationCount,
      decoder: (data) => data['count'] as int,
    );
  }

  @override
  Future<ApiResult<void>> markAsRead(int notificationId) async {
    return post<void>(path: NotificationEndpoints.markAsRead(notificationId.toString()));
  }

  @override
  Future<ApiResult<void>> markAllAsRead() async {
    return post<void>(path: NotificationEndpoints.markAllAsRead);
  }
}
