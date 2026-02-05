// lib/features/settings/data/repositories/notification_settings_repository_impl.dart
import 'dart:async';
import 'dart:convert';

import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/settings/domain/entities/notification_settings.dart';
import 'package:flavorizr/features/user/settings/domain/repositories/notification_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [NotificationSettingsRepository] using SharedPreferences.
///
/// This implementation stores notification settings locally using SharedPreferences.
/// Extends BaseRepository for consistent error handling patterns.
/// In a production app, this would also sync with a remote API.
class NotificationSettingsRepositoryImpl extends BaseRepository
    implements NotificationSettingsRepository {
  NotificationSettingsRepositoryImpl({
    required SharedPreferences prefs,
    required NetworkInfo networkInfo,
  }) : _prefs = prefs,
       _networkInfo = networkInfo;

  final SharedPreferences _prefs;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  static const String _settingsKey = 'notification_settings';

  final _settingsController =
      StreamController<NotificationSettings>.broadcast();

  NotificationSettings? _currentSettings;

  @override
  Future<ApiResult<NotificationSettings>> getSettings() async {
    try {
      // Return cached settings if available
      if (_currentSettings != null) {
        return ApiResult.success(_currentSettings!);
      }

      // Load from local storage
      final cached = await _loadFromStorage();
      if (cached != null) {
        _currentSettings = cached;
        _settingsController.add(_currentSettings!);
        return ApiResult.success(_currentSettings!);
      }

      // Return default settings
      const defaults = NotificationSettings();
      _currentSettings = defaults;
      _settingsController.add(_currentSettings!);
      return const ApiResult.success(defaults);
    } catch (e) {
      // Return cached settings with error if available
      if (_currentSettings != null) {
        return ApiResult.success(
          _currentSettings!,
          NetworkExceptionFactory.mapExceptionToFailure(e),
        );
      }
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e),
      );
    }
  }

  @override
  Future<ApiResult<NotificationSettings>> updateSettings(
    NotificationSettings settings,
  ) async {
    try {
      // Save to local storage
      await _saveToStorage(settings);
      _currentSettings = settings;
      _settingsController.add(settings);
      return ApiResult.success(settings);
    } catch (e) {
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e),
      );
    }
  }

  @override
  Future<ApiResult<NotificationSettings>> resetToDefaults() async {
    try {
      const defaults = NotificationSettings();
      await _saveToStorage(defaults);
      _currentSettings = defaults;
      _settingsController.add(defaults);
      return const ApiResult.success(defaults);
    } catch (e) {
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e),
      );
    }
  }

  @override
  Future<NotificationSettings?> getCachedSettings() async {
    return _currentSettings ?? await _loadFromStorage();
  }

  @override
  Future<void> cacheSettings(NotificationSettings settings) async {
    await _saveToStorage(settings);
    _currentSettings = settings;
  }

  @override
  Future<void> clearSettingsCache() async {
    await _prefs.remove(_settingsKey);
    _currentSettings = null;
    _settingsController.add(const NotificationSettings());
  }

  @override
  Future<ApiResult<void>> clearAllCache({
    required Future<void> Function() clearer,
  }) async {
    try {
      await clearer();
      _currentSettings = null;
      _settingsController.add(const NotificationSettings());
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.exception(
        NetworkExceptionFactory.mapExceptionToFailure(e),
      );
    }
  }

  @override
  Stream<NotificationSettings> get settingsUpdates =>
      _settingsController.stream;

  /// Loads settings from local storage.
  Future<NotificationSettings?> _loadFromStorage() async {
    final jsonString = _prefs.getString(_settingsKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return NotificationSettings.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Saves settings to local storage.
  Future<void> _saveToStorage(NotificationSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, jsonString);
  }

  /// Disposes resources.
  void dispose() {
    _settingsController.close();
  }
}
