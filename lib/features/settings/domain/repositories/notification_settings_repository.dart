// lib/features/settings/domain/repositories/notification_settings_repository.dart
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/settings/domain/entities/notification_settings.dart';

/// Repository interface for notification settings operations.
///
/// Defines the contract for notification settings data operations.
/// Implementations should handle both remote API and local storage.
abstract class NotificationSettingsRepository {
  /// Gets the current notification settings.
  ///
  /// Returns the settings if found, or default settings if not.
  Future<({NotificationSettings? data, Failure? failure})> getSettings();

  /// Updates the notification settings.
  ///
  /// Returns the updated settings on success.
  Future<({NotificationSettings? data, Failure? failure})> updateSettings(
    NotificationSettings settings,
  );

  /// Resets the notification settings to defaults.
  ///
  /// Returns the default settings on success.
  Future<({NotificationSettings? data, Failure? failure})> resetToDefaults();

  /// Gets the cached notification settings.
  Future<NotificationSettings?> getCachedSettings();

  /// Caches the notification settings locally.
  Future<void> cacheSettings(NotificationSettings settings);

  /// Clears the cached settings.
  Future<void> clearCache();

  /// Stream of notification settings updates.
  Stream<NotificationSettings> get settingsUpdates;
}
