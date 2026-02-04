import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/notification/domain/entities/notification.dart';
import 'package:flavorizr/features/notification/data/parameters/get_notifications_parameters.dart';

abstract class NotificationRepository {
  Future<ApiResult<List<Notification>>> getNotifications(GetNotificationsParameters params);
  Future<ApiResult<int>> getNotificationCount();
  Future<ApiResult<void>> markAsRead(int notificationId);
  Future<ApiResult<void>> markAllAsRead();
}