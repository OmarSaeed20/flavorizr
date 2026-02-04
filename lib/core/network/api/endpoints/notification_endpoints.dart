/// Notification API Endpoints
/// Defines all notification-related API endpoint paths
class NotificationEndpoints {
  // Base path for notification endpoints
  static const String _basePath = '/user/notification';

  /// Get notifications
  /// GET /user/notification
  static const String getNotifications = _basePath;

  /// Get notification count
  /// GET /user/notification/count
  static const String getNotificationCount = '$_basePath/count';
}