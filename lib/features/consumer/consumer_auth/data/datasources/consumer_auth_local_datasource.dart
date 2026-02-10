// lib/features/consumer/consumer_auth/data/datasources/consumer_auth_local_datasource.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Local data source for consumer authentication operations.
///
/// Handles secure storage of tokens and user data.
/// Uses FlutterSecureStorage for sensitive data (tokens).
/// Uses SharedPreferences for non-sensitive data (user info, settings).
abstract class ConsumerAuthLocalDataSource {
  /// Saves authentication tokens securely.
  Future<void> saveTokens(AuthTokens tokens);

  /// Gets stored access token.
  Future<String?> getAccessToken();

  /// Gets stored refresh token.
  Future<String?> getRefreshToken();

  /// Gets stored token expiry timestamp.
  Future<DateTime?> getAccessTokenExpiry();

  /// Clears all stored tokens.
  Future<void> clearTokens();

  /// Saves user data locally.
  Future<void> saveUser(UserModel user);

  /// Gets stored user data.
  Future<UserModel?> getUser();

  /// Clears stored user data.
  Future<void> clearUser();

  /// Checks if user is authenticated (has valid token).
  Future<bool> isAuthenticated();

  /// Checks if onboarding is completed.
  Future<bool> isOnboardingCompleted();

  /// Sets onboarding completion status.
  Future<void> setOnboardingCompleted(bool completed);

  /// Saves biometric credentials (if enabled).
  Future<void> saveBiometricCredentials(String phone, String password);

  /// Gets stored biometric credentials.
  Future<Map<String, String>?> getBiometricCredentials();

  /// Clears biometric credentials.
  Future<void> clearBiometricCredentials();
}

/// Implementation of [ConsumerAuthLocalDataSource].
class ConsumerAuthLocalDataSourceImpl implements ConsumerAuthLocalDataSource {
  const ConsumerAuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  // Storage keys
  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyAccessTokenExpiry = 'auth_access_token_expiry';
  static const String _keyRefreshTokenExpiry = 'auth_refresh_token_expiry';
  static const String _keyUser = 'auth_user';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyBiometricPhone = 'biometric_phone';
  static const String _keyBiometricPassword = 'biometric_password';

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    await secureStorage.write(key: _keyAccessToken, value: tokens.accessToken);
    await secureStorage.write(key: _keyRefreshToken, value: tokens.refreshToken);
    await secureStorage.write(
      key: _keyAccessTokenExpiry,
      value: tokens.accessTokenExpiresAt.toIso8601String(),
    );
    if (tokens.refreshTokenExpiresAt != null) {
      await secureStorage.write(
        key: _keyRefreshTokenExpiry,
        value: tokens.refreshTokenExpiresAt!.toIso8601String(),
      );
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return secureStorage.read(key: _keyAccessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return secureStorage.read(key: _keyRefreshToken);
  }

  @override
  Future<DateTime?> getAccessTokenExpiry() async {
    final expiryStr = await secureStorage.read(key: _keyAccessTokenExpiry);
    if (expiryStr == null) return null;
    return DateTime.parse(expiryStr);
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.delete(key: _keyAccessToken);
    await secureStorage.delete(key: _keyRefreshToken);
    await secureStorage.delete(key: _keyAccessTokenExpiry);
    await secureStorage.delete(key: _keyRefreshTokenExpiry);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(_keyUser, user.toJson().toString());
  }

  @override
  Future<UserModel?> getUser() async {
    final userStr = sharedPreferences.getString(_keyUser);
    if (userStr == null) return null;
    try {
      final userJson = userStr as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(_keyUser);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    final expiry = await getAccessTokenExpiry();
    if (token == null || expiry == null) return false;
    return DateTime.now().isBefore(expiry);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(_keyOnboardingCompleted) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await sharedPreferences.setBool(_keyOnboardingCompleted, completed);
  }

  @override
  Future<void> saveBiometricCredentials(String phone, String password) async {
    await secureStorage.write(key: _keyBiometricPhone, value: phone);
    await secureStorage.write(key: _keyBiometricPassword, value: password);
  }

  @override
  Future<Map<String, String>?> getBiometricCredentials() async {
    final phone = await secureStorage.read(key: _keyBiometricPhone);
    final password = await secureStorage.read(key: _keyBiometricPassword);
    if (phone == null || password == null) return null;
    return {'phone': phone, 'password': password};
  }

  @override
  Future<void> clearBiometricCredentials() async {
    await secureStorage.delete(key: _keyBiometricPhone);
    await secureStorage.delete(key: _keyBiometricPassword);
  }
}
