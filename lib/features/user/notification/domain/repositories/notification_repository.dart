import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/notification/data/parameters/get_notifications_parameters.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<ApiResult<List<Notification>>> getNotifications(GetNotificationsParameters params);
  Future<ApiResult<int>> getNotificationCount();
  Future<ApiResult<void>> markAsRead(int notificationId);
  Future<ApiResult<void>> markAllAsRead();
}
