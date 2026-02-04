// lib/features/notification/data/endpoints/notification_endpoints.dart
/// Defines all API endpoints for notification operations.
abstract class NotificationEndpoints {
  const NotificationEndpoints._();

  /// Gets notifications with pagination.
  static const String notifications = '/user/notification';

  /// Gets a specific notification by ID.
  static String notificationById(String notificationId) => '/user/notification/$notificationId';

  /// Gets notification count.
  static const String notificationCount = '/user/notification/count';

  /// Marks a notification as read.
  static String markAsRead(String notificationId) => '/user/notification/$notificationId/read';

  /// Marks all notifications as read.
  static const String markAllAsRead = '/user/notification/read-all';

  /// Deletes a notification.
  static String deleteNotification(String notificationId) => '/user/notification/$notificationId';

  /// Clears all notifications.
  static const String clearAll = '/user/notification/clear';

  /// Gets unread notifications.
  static const String unreadNotifications = '/user/notification/unread';

  /// Gets notification settings.
  static const String notificationSettings = '/user/notification/settings';

  /// Updates notification settings.
  static const String updateNotificationSettings = '/user/notification/settings';

  /// Registers device for push notifications.
  static const String registerDevice = '/devices';

  /// Unregisters device.
  static String unregisterDevice(String deviceId) => '/devices/$deviceId';

  /// Updates device token.
  static String updateDeviceToken(String deviceId) => '/devices/$deviceId/token';
}
