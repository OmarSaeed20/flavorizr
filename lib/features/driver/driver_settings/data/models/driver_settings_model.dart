import 'package:fast_golden_taxi/features/driver/driver_settings/domain/entities/driver_settings.dart';

/// Model for DriverSettings entity.
///
/// Based on the FAST App API documentation for driver settings data structure
class DriverSettingsModel extends DriverSettings {
  DriverSettingsModel({
    required super.id,
    required super.driverId,
    required super.isOnline,
    required super.isAvailable,
    required super.language,
    required super.notificationsEnabled,
    required super.emailNotifications,
    required super.smsNotifications,
    required super.pushNotifications,
    required super.showPhone,
    required super.showLocation,
    required super.allowRatings,
    required super.createdAt,
    super.updatedAt,
  });

  factory DriverSettingsModel.fromJson(Map<String, dynamic> json) {
    return DriverSettingsModel(
      id: json['id']?.toString() ?? '',
      driverId: json['driver_id']?.toString() ?? '',
      isOnline: json['is_online'] as bool? ?? true,
      isAvailable: json['is_available'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      smsNotifications: json['sms_notifications'] as bool? ?? false,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      showPhone: json['show_phone'] as bool? ?? false,
      showLocation: json['show_location'] as bool? ?? true,
      allowRatings: json['allow_ratings'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'is_online': isOnline,
      'is_available': isAvailable,
      'language': language,
      'notifications_enabled': notificationsEnabled,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'push_notifications': pushNotifications,
      'show_phone': showPhone,
      'show_location': showLocation,
      'allow_ratings': allowRatings,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  DriverSettings toEntity() {
    return DriverSettings(
      id: id,
      driverId: driverId,
      isOnline: isOnline,
      isAvailable: isAvailable,
      language: language,
      notificationsEnabled: notificationsEnabled,
      emailNotifications: emailNotifications,
      smsNotifications: smsNotifications,
      pushNotifications: pushNotifications,
      showPhone: showPhone,
      showLocation: showLocation,
      allowRatings: allowRatings,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
