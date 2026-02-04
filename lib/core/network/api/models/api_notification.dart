import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_notification.freezed.dart';
part 'api_notification.g.dart';

/// API Notification model
/// Represents a notification in the system
@freezed
abstract class ApiNotification with _$ApiNotification {
  const factory ApiNotification({
    /// Notification ID
    required int id,

    /// Notification title
    required String title,

    /// Notification message/body
    required String message,

    /// Notification type (e.g., 'trip', 'payment', 'system')
    String? type,

    /// Whether the notification has been read
    @Default(false) bool isRead,

    /// Notification data (additional information)
    Map<String, dynamic>? data,

    /// Created at timestamp
    String? createdAt,

    /// Updated at timestamp
    String? updatedAt,
  }) = _ApiNotification;

  factory ApiNotification.fromJson(Map<String, dynamic> json) =>
      _$ApiNotificationFromJson(json);
}

/// API Notification Count model
/// Represents the count of unread notifications
@freezed
abstract class ApiNotificationCount with _$ApiNotificationCount {
  const factory ApiNotificationCount({
    /// Total count of unread notifications
    required int count,

    /// Total count of all notifications
    int? totalCount,
  }) = _ApiNotificationCount;

  factory ApiNotificationCount.fromJson(Map<String, dynamic> json) =>
      _$ApiNotificationCountFromJson(json);
}
