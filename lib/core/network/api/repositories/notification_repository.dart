import 'package:flavorizr/core/network/api/models/api_notification.dart';
import 'package:flavorizr/core/network/api/parameters/notification_parameters.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Notification Repository Interface
/// Defines the contract for notification data operations
abstract class NotificationRepository {
  /// Get notifications
  /// Returns NetworkResult with List<ApiNotification> on success
  Future<ApiResult<ApiResponse<List<ApiNotification>>>> getNotifications(
    GetNotificationsParameters parameters,
  );

  /// Get notification count
  /// Returns NetworkResult with ApiNotificationCount on success
  Future<ApiResult<ApiResponse<ApiNotificationCount>>> getNotificationCount(
    GetNotificationCountParameters parameters,
  );
}
