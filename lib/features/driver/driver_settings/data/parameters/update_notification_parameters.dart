/// Parameters for updating driver notification preferences.
///
/// Based on the FAST App API documentation for POST /driver/settings/notifications
class UpdateNotificationParameters {
  final bool? notificationsEnabled;
  final bool? emailNotifications;
  final bool? smsNotifications;
  final bool? pushNotifications;

  UpdateNotificationParameters({
    this.notificationsEnabled,
    this.emailNotifications,
    this.smsNotifications,
    this.pushNotifications,
  });

  Map<String, dynamic> toJson() {
    return {
      if (notificationsEnabled != null) 'notifications_enabled': notificationsEnabled,
      if (emailNotifications != null) 'email_notifications': emailNotifications,
      if (smsNotifications != null) 'sms_notifications': smsNotifications,
      if (pushNotifications != null) 'push_notifications': pushNotifications,
    };
  }
}
