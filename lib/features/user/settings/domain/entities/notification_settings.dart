// lib/features/settings/domain/entities/notification_settings.dart
import 'package:flutter/foundation.dart';

/// Represents notification settings for the user.
///
/// Contains all notification preferences that can be toggled by the user.
@immutable
class NotificationSettings {
  const NotificationSettings({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.inAppEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.badgeEnabled = true,
    this.previewEnabled = true,
    this.messagesEnabled = true,
    this.mentionsEnabled = true,
    this.commentsEnabled = true,
    this.likesEnabled = true,
    this.followsEnabled = true,
    this.directMessagesEnabled = true,
    this.groupMessagesEnabled = true,
    this.promotionalEnabled = false,
    this.updatesEnabled = true,
    this.securityAlertsEnabled = true,
    this.reminderEnabled = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  /// Creates from a JSON map.
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      smsEnabled: json['smsEnabled'] as bool? ?? false,
      inAppEnabled: json['inAppEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      badgeEnabled: json['badgeEnabled'] as bool? ?? true,
      previewEnabled: json['previewEnabled'] as bool? ?? true,
      messagesEnabled: json['messagesEnabled'] as bool? ?? true,
      mentionsEnabled: json['mentionsEnabled'] as bool? ?? true,
      commentsEnabled: json['commentsEnabled'] as bool? ?? true,
      likesEnabled: json['likesEnabled'] as bool? ?? true,
      followsEnabled: json['followsEnabled'] as bool? ?? true,
      directMessagesEnabled: json['directMessagesEnabled'] as bool? ?? true,
      groupMessagesEnabled: json['groupMessagesEnabled'] as bool? ?? true,
      promotionalEnabled: json['promotionalEnabled'] as bool? ?? false,
      updatesEnabled: json['updatesEnabled'] as bool? ?? true,
      securityAlertsEnabled: json['securityAlertsEnabled'] as bool? ?? true,
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as int?,
      quietHoursEnd: json['quietHoursEnd'] as int?,
    );
  }

  // ==================== General Settings ====================

  /// Whether push notifications are enabled.
  final bool pushEnabled;

  /// Whether email notifications are enabled.
  final bool emailEnabled;

  /// Whether SMS notifications are enabled.
  final bool smsEnabled;

  /// Whether in-app notifications are enabled.
  final bool inAppEnabled;

  // ==================== Delivery Settings ====================

  /// Whether notification sounds are enabled.
  final bool soundEnabled;

  /// Whether notification vibration is enabled.
  final bool vibrationEnabled;

  /// Whether notification badge count is enabled.
  final bool badgeEnabled;

  /// Whether notification preview is shown.
  final bool previewEnabled;

  // ==================== Social Notifications ====================

  /// Whether message notifications are enabled.
  final bool messagesEnabled;

  /// Whether mention notifications are enabled.
  final bool mentionsEnabled;

  /// Whether comment notifications are enabled.
  final bool commentsEnabled;

  /// Whether like notifications are enabled.
  final bool likesEnabled;

  /// Whether follow notifications are enabled.
  final bool followsEnabled;

  /// Whether direct message notifications are enabled.
  final bool directMessagesEnabled;

  /// Whether group message notifications are enabled.
  final bool groupMessagesEnabled;

  // ==================== Other Notifications ====================

  /// Whether promotional notifications are enabled.
  final bool promotionalEnabled;

  /// Whether update notifications are enabled.
  final bool updatesEnabled;

  /// Whether security alert notifications are enabled.
  final bool securityAlertsEnabled;

  /// Whether reminder notifications are enabled.
  final bool reminderEnabled;

  // ==================== Quiet Hours ====================

  /// Whether quiet hours are enabled.
  final bool quietHoursEnabled;

  /// Start time of quiet hours (hour in 24-hour format).
  final int? quietHoursStart;

  /// End time of quiet hours (hour in 24-hour format).
  final int? quietHoursEnd;

  /// Creates a copy with the given fields replaced.
  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? inAppEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? badgeEnabled,
    bool? previewEnabled,
    bool? messagesEnabled,
    bool? mentionsEnabled,
    bool? commentsEnabled,
    bool? likesEnabled,
    bool? followsEnabled,
    bool? directMessagesEnabled,
    bool? groupMessagesEnabled,
    bool? promotionalEnabled,
    bool? updatesEnabled,
    bool? securityAlertsEnabled,
    bool? reminderEnabled,
    bool? quietHoursEnabled,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      badgeEnabled: badgeEnabled ?? this.badgeEnabled,
      previewEnabled: previewEnabled ?? this.previewEnabled,
      messagesEnabled: messagesEnabled ?? this.messagesEnabled,
      mentionsEnabled: mentionsEnabled ?? this.mentionsEnabled,
      commentsEnabled: commentsEnabled ?? this.commentsEnabled,
      likesEnabled: likesEnabled ?? this.likesEnabled,
      followsEnabled: followsEnabled ?? this.followsEnabled,
      directMessagesEnabled:
          directMessagesEnabled ?? this.directMessagesEnabled,
      groupMessagesEnabled: groupMessagesEnabled ?? this.groupMessagesEnabled,
      promotionalEnabled: promotionalEnabled ?? this.promotionalEnabled,
      updatesEnabled: updatesEnabled ?? this.updatesEnabled,
      securityAlertsEnabled:
          securityAlertsEnabled ?? this.securityAlertsEnabled,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  /// Converts to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
      'smsEnabled': smsEnabled,
      'inAppEnabled': inAppEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'badgeEnabled': badgeEnabled,
      'previewEnabled': previewEnabled,
      'messagesEnabled': messagesEnabled,
      'mentionsEnabled': mentionsEnabled,
      'commentsEnabled': commentsEnabled,
      'likesEnabled': likesEnabled,
      'followsEnabled': followsEnabled,
      'directMessagesEnabled': directMessagesEnabled,
      'groupMessagesEnabled': groupMessagesEnabled,
      'promotionalEnabled': promotionalEnabled,
      'updatesEnabled': updatesEnabled,
      'securityAlertsEnabled': securityAlertsEnabled,
      'reminderEnabled': reminderEnabled,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationSettings &&
        other.pushEnabled == pushEnabled &&
        other.emailEnabled == emailEnabled &&
        other.smsEnabled == smsEnabled &&
        other.inAppEnabled == inAppEnabled &&
        other.soundEnabled == soundEnabled &&
        other.vibrationEnabled == vibrationEnabled &&
        other.badgeEnabled == badgeEnabled &&
        other.previewEnabled == previewEnabled &&
        other.messagesEnabled == messagesEnabled &&
        other.mentionsEnabled == mentionsEnabled &&
        other.commentsEnabled == commentsEnabled &&
        other.likesEnabled == likesEnabled &&
        other.followsEnabled == followsEnabled &&
        other.directMessagesEnabled == directMessagesEnabled &&
        other.groupMessagesEnabled == groupMessagesEnabled &&
        other.promotionalEnabled == promotionalEnabled &&
        other.updatesEnabled == updatesEnabled &&
        other.securityAlertsEnabled == securityAlertsEnabled &&
        other.reminderEnabled == reminderEnabled &&
        other.quietHoursEnabled == quietHoursEnabled &&
        other.quietHoursStart == quietHoursStart &&
        other.quietHoursEnd == quietHoursEnd;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      pushEnabled,
      emailEnabled,
      smsEnabled,
      inAppEnabled,
      soundEnabled,
      vibrationEnabled,
      badgeEnabled,
      previewEnabled,
      messagesEnabled,
      mentionsEnabled,
      commentsEnabled,
      likesEnabled,
      followsEnabled,
      directMessagesEnabled,
      groupMessagesEnabled,
      promotionalEnabled,
      updatesEnabled,
      securityAlertsEnabled,
      reminderEnabled,
      quietHoursEnabled,
      quietHoursStart,
      quietHoursEnd,
    ]);
  }
}
