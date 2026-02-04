import 'package:flavorizr/features/driver_settings/domain/entities/driver_settings.dart';

class DriverSettingsModel extends DriverSettings {
  const DriverSettingsModel({
    required super.id,
    required super.isOnline,
    required super.isAvailable,
    required super.notificationsEnabled,
    required super.soundEnabled,
    required super.vibrationEnabled,
    super.preferredVehicleType,
    super.maxDistance,
    super.language,
    super.currency,
    required super.updatedAt,
  });

  factory DriverSettingsModel.fromJson(Map<String, dynamic> json) {
    return DriverSettingsModel(
      id: json['id'] as String,
      isOnline: json['is_online'] as bool,
      isAvailable: json['is_available'] as bool,
      notificationsEnabled: json['notifications_enabled'] as bool,
      soundEnabled: json['sound_enabled'] as bool,
      vibrationEnabled: json['vibration_enabled'] as bool,
      preferredVehicleType: json['preferred_vehicle_type'] as String?,
      maxDistance: json['max_distance'] as double?,
      language: json['language'] as String?,
      currency: json['currency'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_online': isOnline,
      'is_available': isAvailable,
      'notifications_enabled': notificationsEnabled,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'preferred_vehicle_type': preferredVehicleType,
      'max_distance': maxDistance,
      'language': language,
      'currency': currency,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DriverSettings toEntity() => this;
}