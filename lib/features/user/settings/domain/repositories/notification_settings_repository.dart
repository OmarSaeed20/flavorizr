// lib/features/settings/domain/repositories/notification_settings_repository.dart
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/settings/domain/entities/notification_settings.dart';

/// Repository interface for notification settings operations.
///
/// Defines the contract for notification settings data operations.
/// Implementations should handle both remote API and local storage.
abstract class NotificationSettingsRepository {
  /// Gets the current notification settings.
  ///
  /// Returns the settings if found, or default settings if not.
  Future<ApiResult<NotificationSettings>> getSettings();

  /// Updates the notification settings.
  ///
  /// Returns the updated settings on success.
  Future<ApiResult<NotificationSettings>> updateSettings(NotificationSettings settings);

  /// Resets the notification settings to defaults.
  ///
  /// Returns the default settings on success.
  Future<ApiResult<NotificationSettings>> resetToDefaults();

  /// Gets the cached notification settings.
  Future<NotificationSettings?> getCachedSettings();

  /// Caches the notification settings locally.
  Future<void> cacheSettings(NotificationSettings settings);

  /// Clears the cached settings.
  Future<void> clearSettingsCache();

  /// Stream of notification settings updates.
  Stream<NotificationSettings> get settingsUpdates;
}
