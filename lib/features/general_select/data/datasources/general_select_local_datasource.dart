import 'dart:convert';

import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/general_select/data/models/select_option_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for general select operations.
///
/// Handles caching of select options using SharedPreferences.
/// Returns ApiResult with success or error data.
abstract class GeneralSelectLocalDataSource {
  /// Gets cached select options by type.
  Future<ApiResult<List<SelectOptionModel>>> getCachedSelectOptions(String type);

  /// Saves select options to cache by type.
  Future<ApiResult<void>> cacheSelectOptions(String type, List<SelectOptionModel> options);

  /// Gets cached vehicle types.
  Future<ApiResult<List<SelectOptionModel>>> getCachedVehicleTypes();

  /// Saves vehicle types to cache.
  Future<ApiResult<void>> cacheVehicleTypes(List<SelectOptionModel> vehicleTypes);

  /// Gets cached cities.
  Future<ApiResult<List<SelectOptionModel>>> getCachedCities();

  /// Saves cities to cache.
  Future<ApiResult<void>> cacheCities(List<SelectOptionModel> cities);

  /// Gets cached common problems.
  Future<ApiResult<List<SelectOptionModel>>> getCachedCommonProblems();

  /// Saves common problems to cache.
  Future<ApiResult<void>> cacheCommonProblems(List<SelectOptionModel> problems);

  /// Gets cached countries.
  Future<ApiResult<List<SelectOptionModel>>> getCachedCountries();

  /// Saves countries to cache.
  Future<ApiResult<void>> cacheCountries(List<SelectOptionModel> countries);

  /// Gets cached about us data.
  Future<ApiResult<Map<String, dynamic>?>> getCachedAboutUs();

  /// Saves about us data to cache.
  Future<ApiResult<void>> cacheAboutUs(Map<String, dynamic> aboutUs);

  /// Gets cached questions/FAQs.
  Future<ApiResult<List<Map<String, dynamic>>?>> getCachedQuestions();

  /// Saves questions/FAQs to cache.
  Future<ApiResult<void>> cacheQuestions(List<Map<String, dynamic>> questions);

  /// Gets cached policies.
  Future<ApiResult<Map<String, dynamic>?>> getCachedPolicies();

  /// Saves policies to cache.
  Future<ApiResult<void>> cachePolicies(Map<String, dynamic> policies);

  /// Gets cached general settings.
  Future<ApiResult<Map<String, dynamic>?>> getCachedGeneralSettings();

  /// Saves general settings to cache.
  Future<ApiResult<void>> cacheGeneralSettings(Map<String, dynamic> settings);

  /// Clears all cached select options.
  Future<ApiResult<void>> clearAllCache();

  /// Clears cached select options by type.
  Future<ApiResult<void>> clearCacheByType(String type);
}

/// Implementation of [GeneralSelectLocalDataSource] using BaseLocalDataSource.
class GeneralSelectLocalDataSourceImpl
    with BaseLocalDataSource
    implements GeneralSelectLocalDataSource {
  const GeneralSelectLocalDataSourceImpl();

  /// Cache key prefix
  static const String _cacheKeyPrefix = 'general_select_';

  /// Cache expiration duration (24 hours)
  static const Duration _cacheExpiration = Duration(hours: 24);

  /// Get cache key for a type
  String _getCacheKey(String type) => '$_cacheKeyPrefix$type';

  /// Get cache timestamp key for a type
  String _getTimestampKey(String type) => '$_cacheKeyPrefix${type}_timestamp';

  /// Check if cache is still valid
  Future<bool> _isCacheValid(String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_getTimestampKey(type));
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final isValid = DateTime.now().difference(cacheTime) < _cacheExpiration;
      return isValid;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCachedSelectOptions(String type) async {
    return getLocalDataList<SelectOptionModel>(
      key: _getCacheKey(type),
      fetcher: () async {
        if (!await _isCacheValid(type)) {
          return null;
        }
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString(_getCacheKey(type));
        if (jsonString == null) return null;

        final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
        return jsonList.map((e) => SelectOptionModel.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheSelectOptions(String type, List<SelectOptionModel> options) async {
    return saveLocalDataList(
      key: _getCacheKey(type),
      data: options,
      saver: (data) async {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = data.map((e) => e.toJson()).toString();
        await prefs.setString(_getCacheKey(type), jsonString);
        await prefs.setInt(_getTimestampKey(type), DateTime.now().millisecondsSinceEpoch);
      },
    );
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCachedVehicleTypes() {
    return getCachedSelectOptions('vehicle_types');
  }

  @override
  Future<ApiResult<void>> cacheVehicleTypes(List<SelectOptionModel> vehicleTypes) {
    return cacheSelectOptions('vehicle_types', vehicleTypes);
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCachedCities() {
    return getCachedSelectOptions('cities');
  }

  @override
  Future<ApiResult<void>> cacheCities(List<SelectOptionModel> cities) {
    return cacheSelectOptions('cities', cities);
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCachedCommonProblems() {
    return getCachedSelectOptions('common_problems');
  }

  @override
  Future<ApiResult<void>> cacheCommonProblems(List<SelectOptionModel> problems) {
    return cacheSelectOptions('common_problems', problems);
  }

  @override
  Future<ApiResult<List<SelectOptionModel>>> getCachedCountries() {
    return getCachedSelectOptions('countries');
  }

  @override
  Future<ApiResult<void>> cacheCountries(List<SelectOptionModel> countries) {
    return cacheSelectOptions('countries', countries);
  }

  @override
  Future<ApiResult<Map<String, dynamic>?>> getCachedAboutUs() async {
    return getLocalData<Map<String, dynamic>>(
      key: _getCacheKey('about_us'),
      fetcher: () async {
        if (!await _isCacheValid('about_us')) {
          return null;
        }
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString(_getCacheKey('about_us'));
        if (jsonString == null) return null;
        return json.decode(jsonString) as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheAboutUs(Map<String, dynamic> aboutUs) async {
    return saveLocalData<Map<String, dynamic>>(
      key: _getCacheKey('about_us'),
      data: aboutUs,
      saver: (data) async {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = json.encode(data);
        await prefs.setString(_getCacheKey('about_us'), jsonString);
        await prefs.setInt(_getTimestampKey('about_us'), DateTime.now().millisecondsSinceEpoch);
      },
    );
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>?>> getCachedQuestions() async {
    return getLocalDataList<Map<String, dynamic>>(
      key: _getCacheKey('questions'),
      fetcher: () async {
        if (!await _isCacheValid('questions')) {
          return null;
        }
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString(_getCacheKey('questions'));
        if (jsonString == null) return null;
        final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
        return jsonList.map((e) => e as Map<String, dynamic>).toList();
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheQuestions(List<Map<String, dynamic>> questions) async {
    return saveLocalDataList(
      key: _getCacheKey('questions'),
      data: questions,
      saver: (data) async {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = json.encode(data);
        await prefs.setString(_getCacheKey('questions'), jsonString);
        await prefs.setInt(_getTimestampKey('questions'), DateTime.now().millisecondsSinceEpoch);
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>?>> getCachedPolicies() async {
    return getLocalData<Map<String, dynamic>>(
      key: _getCacheKey('policies'),
      fetcher: () async {
        if (!await _isCacheValid('policies')) {
          return null;
        }
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString(_getCacheKey('policies'));
        if (jsonString == null) return null;
        return json.decode(jsonString) as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<void>> cachePolicies(Map<String, dynamic> policies) async {
    return saveLocalData<Map<String, dynamic>>(
      key: _getCacheKey('policies'),
      data: policies,
      saver: (data) async {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = json.encode(data);
        await prefs.setString(_getCacheKey('policies'), jsonString);
        await prefs.setInt(_getTimestampKey('policies'), DateTime.now().millisecondsSinceEpoch);
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>?>> getCachedGeneralSettings() async {
    return getLocalData<Map<String, dynamic>>(
      key: _getCacheKey('general_settings'),
      fetcher: () async {
        if (!await _isCacheValid('general_settings')) {
          return null;
        }
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString(_getCacheKey('general_settings'));
        if (jsonString == null) return null;
        return json.decode(jsonString) as Map<String, dynamic>;
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheGeneralSettings(Map<String, dynamic> settings) async {
    return saveLocalData<Map<String, dynamic>>(
      key: _getCacheKey('general_settings'),
      data: settings,
      saver: (data) async {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = json.encode(data);
        await prefs.setString(_getCacheKey('general_settings'), jsonString);
        await prefs.setInt(
          _getTimestampKey('general_settings'),
          DateTime.now().millisecondsSinceEpoch,
        );
      },
    );
  }

  @override
  Future<ApiResult<void>> clearAllCache() async {
    return clearAllLocalData(
      clearer: () async {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys().where((key) => key.startsWith(_cacheKeyPrefix)).toList();
        for (final key in keys) {
          await prefs.remove(key);
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> clearCacheByType(String type) async {
    return deleteLocalData(
      key: _getCacheKey(type),
      deleter: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_getCacheKey(type));
        await prefs.remove(_getTimestampKey(type));
      },
    );
  }
}
