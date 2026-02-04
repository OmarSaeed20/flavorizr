/// Entity representing driver settings.
class DriverSettings {
  final String id;
  final bool isOnline;
  final bool isAvailable;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String? preferredVehicleType;
  final double? maxDistance;
  final String? language;
  final String? currency;
  final DateTime updatedAt;

  const DriverSettings({
    required this.id,
    required this.isOnline,
    required this.isAvailable,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    this.preferredVehicleType,
    this.maxDistance,
    this.language,
    this.currency,
    required this.updatedAt,
  });
}