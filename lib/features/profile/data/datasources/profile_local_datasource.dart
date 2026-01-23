// lib/features/profile/data/datasources/profile_local_datasource.dart
import 'dart:convert';

import 'package:flavorizr/features/profile/data/models/profile_model.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching profile data.
///
/// Uses SharedPreferences for caching profile information locally.
abstract class ProfileLocalDataSource {
  /// Saves profile to local cache.
  Future<void> saveProfile(ProfileModel profile);

  /// Gets cached profile.
  Future<ProfileModel?> getProfile();

  /// Gets cached profile by user ID.
  Future<ProfileModel?> getProfileById(String userId);

  /// Saves a profile for a specific user ID.
  Future<void> saveProfileById(String userId, ProfileModel profile);

  /// Deletes cached profile.
  Future<void> deleteProfile();

  /// Gets cached preferences.
  Future<ProfilePreferences?> getPreferences();

  /// Saves preferences to cache.
  Future<void> savePreferences(ProfilePreferences preferences);

  /// Checks if profile is cached.
  Future<bool> hasProfile();

  /// Clears all profile cache.
  Future<void> clearAll();
}

/// Implementation of [ProfileLocalDataSource].
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  // Keys
  static const String _profileKey = 'cached_profile';
  static const String _profileByIdPrefix = 'cached_profile_';
  static const String _preferencesKey = 'cached_profile_preferences';

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    final json = jsonEncode(profile.toJson());
    await _prefs.setString(_profileKey, json);
  }

  @override
  Future<ProfileModel?> getProfile() async {
    final jsonString = _prefs.getString(_profileKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProfileModel.fromJson(json);
    } catch (_) {
      // Invalid cache, clear it
      await deleteProfile();
      return null;
    }
  }

  @override
  Future<ProfileModel?> getProfileById(String userId) async {
    final jsonString = _prefs.getString('$_profileByIdPrefix$userId');
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProfileModel.fromJson(json);
    } catch (_) {
      // Invalid cache, clear it
      await _prefs.remove('$_profileByIdPrefix$userId');
      return null;
    }
  }

  @override
  Future<void> saveProfileById(String userId, ProfileModel profile) async {
    final json = jsonEncode(profile.toJson());
    await _prefs.setString('$_profileByIdPrefix$userId', json);
  }

  @override
  Future<void> deleteProfile() async {
    await _prefs.remove(_profileKey);
  }

  @override
  Future<ProfilePreferences?> getPreferences() async {
    final jsonString = _prefs.getString(_preferencesKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProfilePreferencesModel.fromJson(json);
    } catch (_) {
      await _prefs.remove(_preferencesKey);
      return null;
    }
  }

  @override
  Future<void> savePreferences(ProfilePreferences preferences) async {
    final model = ProfilePreferencesModel.fromEntity(preferences);
    final json = jsonEncode(model.toJson());
    await _prefs.setString(_preferencesKey, json);
  }

  @override
  Future<bool> hasProfile() async {
    return _prefs.containsKey(_profileKey);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(_profileKey);
    await _prefs.remove(_preferencesKey);

    // Clear all cached profiles by ID
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_profileByIdPrefix)) {
        await _prefs.remove(key);
      }
    }
  }
}
