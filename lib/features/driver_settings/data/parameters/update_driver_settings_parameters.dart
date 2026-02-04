class UpdateDriverSettingsParameters {
  final bool? isOnline;
  final bool? isAvailable;
  final bool? notificationsEnabled;
  final bool? soundEnabled;
  final bool? vibrationEnabled;
  final String? preferredVehicleType;
  final double? maxDistance;
  final String? language;
  final String? currency;

  const UpdateDriverSettingsParameters({
    this.isOnline,
    this.isAvailable,
    this.notificationsEnabled,
    this.soundEnabled,
    this.vibrationEnabled,
    this.preferredVehicleType,
    this.maxDistance,
    this.language,
    this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      if (isOnline != null) 'is_online': isOnline,
      if (isAvailable != null) 'is_available': isAvailable,
      if (notificationsEnabled != null) 'notifications_enabled': notificationsEnabled,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (vibrationEnabled != null) 'vibration_enabled': vibrationEnabled,
      if (preferredVehicleType != null) 'preferred_vehicle_type': preferredVehicleType,
      if (maxDistance != null) 'max_distance': maxDistance,
      if (language != null) 'language': language,
      if (currency != null) 'currency': currency,
    };
  }
}