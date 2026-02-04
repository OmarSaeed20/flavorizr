// lib/features/profile/data/datasources/profile_local_datasource.dart
import 'dart:convert';

import 'package:flavorizr/core/network/base/datasource/base_local_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/profile/data/models/profile_model.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching profile data.
///
/// Uses SharedPreferences for caching profile information locally.
abstract class ProfileLocalDataSource {
  /// Saves profile to local cache.
  Future<ApiResult<ProfileModel>> saveProfile(ProfileModel profile);

  /// Gets cached profile.
  Future<ApiResult<ProfileModel>> getProfile();

  /// Gets cached profile by user ID.
  Future<ApiResult<ProfileModel>> getProfileById(String userId);

  /// Saves a profile for a specific user ID.
  Future<ApiResult<ProfileModel>> saveProfileById(String userId, ProfileModel profile);

  /// Deletes cached profile.
  Future<ApiResult<void>> deleteProfile();

  /// Gets cached preferences.
  Future<ApiResult<ProfilePreferences>> getPreferences();

  /// Saves preferences to cache.
  Future<ApiResult<ProfilePreferences>> savePreferences(ProfilePreferences preferences);

  /// Checks if profile is cached.
  Future<ApiResult<bool>> hasProfile();

  /// Clears all profile cache.
  Future<ApiResult<void>> clearAll();
}

/// Implementation of [ProfileLocalDataSource] using BaseLocalDataSource.
class ProfileLocalDataSourceImpl with BaseLocalDataSource implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  // Keys
  static const String _profileKey = 'cached_profile';
  static const String _profileByIdPrefix = 'cached_profile_';
  static const String _preferencesKey = 'cached_profile_preferences';

  @override
  Future<ApiResult<ProfileModel>> saveProfile(ProfileModel profile) async {
    return saveLocalData<ProfileModel>(
      key: _profileKey,
      data: profile,
      saver: (data) async {
        final json = jsonEncode(data.toJson());
        await _prefs.setString(_profileKey, json);
      },
    );
  }

  @override
  Future<ApiResult<ProfileModel>> getProfile() async {
    return getLocalData<ProfileModel>(
      key: _profileKey,
      fetcher: () async {
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
      },
    );
  }

  @override
  Future<ApiResult<ProfileModel>> getProfileById(String userId) async {
    return getLocalData<ProfileModel>(
      key: '$_profileByIdPrefix$userId',
      fetcher: () async {
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
      },
    );
  }

  @override
  Future<ApiResult<ProfileModel>> saveProfileById(String userId, ProfileModel profile) async {
    return saveLocalData<ProfileModel>(
      key: '$_profileByIdPrefix$userId',
      data: profile,
      saver: (data) async {
        final json = jsonEncode(data.toJson());
        await _prefs.setString('$_profileByIdPrefix$userId', json);
      },
    );
  }

  @override
  Future<ApiResult<void>> deleteProfile() async {
    return deleteLocalData(key: _profileKey, deleter: () => _prefs.remove(_profileKey));
  }

  @override
  Future<ApiResult<ProfilePreferences>> getPreferences() async {
    return getLocalData<ProfilePreferences>(
      key: _preferencesKey,
      fetcher: () async {
        final jsonString = _prefs.getString(_preferencesKey);
        if (jsonString == null) return null;

        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return ProfilePreferencesModel.fromJson(json);
        } catch (_) {
          await _prefs.remove(_preferencesKey);
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<ProfilePreferences>> savePreferences(ProfilePreferences preferences) async {
    return saveLocalData<ProfilePreferences>(
      key: _preferencesKey,
      data: preferences,
      saver: (data) async {
        final model = ProfilePreferencesModel.fromEntity(data);
        final json = jsonEncode(model.toJson());
        await _prefs.setString(_preferencesKey, json);
      },
    );
  }

  @override
  Future<ApiResult<bool>> hasProfile() async {
    return hasLocalData(key: _profileKey, checker: () async => _prefs.containsKey(_profileKey));
  }

  @override
  Future<ApiResult<void>> clearAll() async {
    return clearAllLocalData(
      clearer: () async {
        await _prefs.remove(_profileKey);
        await _prefs.remove(_preferencesKey);

        // Clear all cached profiles by ID
        final keys = _prefs.getKeys();
        for (final key in keys) {
          if (key.startsWith(_profileByIdPrefix)) {
            await _prefs.remove(key);
          }
        }
      },
    );
  }
}
