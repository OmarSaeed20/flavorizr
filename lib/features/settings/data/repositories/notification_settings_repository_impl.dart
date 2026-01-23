// lib/features/settings/data/repositories/notification_settings_repository_impl.dart
import 'dart:async';
import 'dart:convert';

import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/settings/domain/entities/notification_settings.dart';
import 'package:flavorizr/features/settings/domain/repositories/notification_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [NotificationSettingsRepository] using SharedPreferences.
///
/// This implementation stores notification settings locally using SharedPreferences.
/// In a production app, this would also sync with a remote API.
class NotificationSettingsRepositoryImpl implements NotificationSettingsRepository {
  NotificationSettingsRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;
  static const String _settingsKey = 'notification_settings';

  final _settingsController = StreamController<NotificationSettings>.broadcast();

  @override
  Future<({NotificationSettings? data, Failure? failure})> getSettings() async {
    try {
      final cached = await getCachedSettings();
      if (cached != null) {
        return (data: cached, failure: null);
      }
      return (data: const NotificationSettings(), failure: null);
    } catch (e) {
      return (
        data: null,
        failure: CacheFailure(message: 'Failed to get notification settings: $e'),
      );
    }
  }

  @override
  Future<({NotificationSettings? data, Failure? failure})> updateSettings(
    NotificationSettings settings,
  ) async {
    try {
      await cacheSettings(settings);
      _settingsController.add(settings);
      return (data: settings, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: CacheFailure(message: 'Failed to update notification settings: $e'),
      );
    }
  }

  @override
  Future<({NotificationSettings? data, Failure? failure})> resetToDefaults() async {
    try {
      const defaults = NotificationSettings();
      await cacheSettings(defaults);
      _settingsController.add(defaults);
      return (data: defaults, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: CacheFailure(message: 'Failed to reset notification settings: $e'),
      );
    }
  }

  @override
  Future<NotificationSettings?> getCachedSettings() async {
    final jsonString = _prefs.getString(_settingsKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return NotificationSettings.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheSettings(NotificationSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, jsonString);
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_settingsKey);
  }

  @override
  Stream<NotificationSettings> get settingsUpdates => _settingsController.stream;

  /// Disposes resources.
  void dispose() {
    _settingsController.close();
  }
}
