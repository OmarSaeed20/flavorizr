/// Entity representing driver settings.
///
/// Based on the FAST App API documentation for driver settings data structure
class DriverSettings {
  final String id;
  final String driverId;
  final bool isOnline;
  final bool isAvailable;
  final String language;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;
  final bool showPhone;
  final bool showLocation;
  final bool allowRatings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const DriverSettings({
    required this.id,
    required this.driverId,
    required this.isOnline,
    required this.isAvailable,
    required this.language,
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.pushNotifications,
    required this.showPhone,
    required this.showLocation,
    required this.allowRatings,
    required this.createdAt,
    this.updatedAt,
  });
}
