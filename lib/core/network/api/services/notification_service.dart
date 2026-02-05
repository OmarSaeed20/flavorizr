/* import 'package:flavorizr/core/network/api/models/api_notification.dart';
import 'package:flavorizr/core/network/api/parameters/notification_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/notification_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// Notification Service
/// Business logic layer for notification operations
class NotificationService {
  final NotificationRepository _repository;

  NotificationService({required NotificationRepository repository}) : _repository = repository;

  /// Get notifications
  /// Returns NetworkResult with List<ApiNotification> on success
  Future<ApiResult<ApiResponse<List<ApiNotification>>>> getNotifications({
    int page = 1,
    int pageSize = 20,
  }) async {
    final parameters = GetNotificationsParameters.builder()
        .withPage(page)
        .withPageSize(pageSize)
        .build();

    return _repository.getNotifications(parameters);
  }

  /// Get notification count
  /// Returns NetworkResult with ApiNotificationCount on success
  Future<ApiResult<ApiResponse<ApiNotificationCount>>> getNotificationCount() async {
    final parameters = GetNotificationCountParameters.builder().build();

    return _repository.getNotificationCount(parameters);
  }
}
 */
