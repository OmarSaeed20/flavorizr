// lib/features/driver_settings/data/endpoints/driver_settings_endpoints.dart
/// Defines all API endpoints for driver settings operations.
abstract class DriverSettingsEndpoints {
  const DriverSettingsEndpoints._();

  /// Gets driver settings.
  static const String settings = '/driver/settings';

  /// Updates driver settings.
  static const String updateSettings = '/driver/settings';

  /// Toggles online status.
  static const String toggleOnline = '/driver/settings/toggle-online';

  /// Toggles availability status.
  static const String toggleAvailability = '/driver/settings/toggle-availability';

  /// Gets driver notification preferences.
  static const String notificationPreferences = '/driver/settings/notifications';

  /// Updates driver notification preferences.
  static const String updateNotificationPreferences = '/driver/settings/notifications';

  /// Gets driver privacy settings.
  static const String privacySettings = '/driver/settings/privacy';

  /// Updates driver privacy settings.
  static const String updatePrivacySettings = '/driver/settings/privacy';

  /// Gets driver payment settings.
  static const String paymentSettings = '/driver/settings/payment';

  /// Updates driver payment settings.
  static const String updatePaymentSettings = '/driver/settings/payment';
}
