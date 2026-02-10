// lib/features/splash/data/datasources/splash_local_datasource.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for splash screen operations.
abstract class SplashLocalDataSource {
  /// Checks if the user has a valid authentication token.
  Future<bool> hasValidToken();

  /// Checks if onboarding has been completed.
  Future<bool> isOnboardingCompleted();

  /// Checks if the user has selected a language.
  Future<bool> isLanguageSelected();

  /// Checks if this is the first launch.
  Future<bool> isFirstLaunch();

  /// Marks first launch as completed.
  Future<void> markFirstLaunchCompleted();

  /// Gets the cached auth token.
  Future<String?> getCachedToken();
}

/// Implementation of [SplashLocalDataSource].
class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  const SplashLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
  }) : _secureStorage = secureStorage,
       _prefs = prefs;

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _languageSelectedKey = 'language_selected';
  static const String _firstLaunchKey = 'first_launch_completed';

  @override
  Future<bool> hasValidToken() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  @override
  Future<bool> isLanguageSelected() async {
    return _prefs.getBool(_languageSelectedKey) ?? false;
  }

  @override
  Future<bool> isFirstLaunch() async {
    return !(_prefs.getBool(_firstLaunchKey) ?? false);
  }

  @override
  Future<void> markFirstLaunchCompleted() async {
    await _prefs.setBool(_firstLaunchKey, true);
  }

  @override
  Future<String?> getCachedToken() async {
    return _secureStorage.read(key: _tokenKey);
  }
}
