// lib/features/company/company_auth/data/datasources/company_auth_local_datasource.dart
import 'dart:convert';

import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Company Authentication Local Data Source
///
/// Handles local storage for company authentication data.
/// Uses FlutterSecureStorage for sensitive data (tokens).
/// Uses SharedPreferences for non-sensitive data (user info).
class CompanyAuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  // Storage keys
  static const String _accessTokenKey = 'company_access_token';
  static const String _refreshTokenKey = 'company_refresh_token';
  static const String _userKey = 'company_user';

  CompanyAuthLocalDataSource({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  }) : _secureStorage = secureStorage,
       _sharedPreferences = sharedPreferences;

  /// Save auth tokens
  Future<void> saveTokens(AuthTokens tokens) async {
    await _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  /// Get auth tokens
  Future<AuthTokens?> getTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    // get accessTokenExpiresAt from accessToken
    final accessTokenExpiresAt = DateTime.now().add(const Duration(hours: 1));
    if (accessToken != null && refreshToken != null) {
      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessTokenExpiresAt: accessTokenExpiresAt,
      );
    }
    return null;
  }

  /// Save user data
  Future<void> saveUser(UserModel user) async {
    await _sharedPreferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Get user data
  Future<UserModel?> getUser() async {
    final userJson = _sharedPreferences.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    }
    return null;
  }

  /// Clear all auth data
  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _sharedPreferences.remove(_userKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }

  /// Clear all data (for logout)
  Future<void> clearAll() async {
    await clearAuthData();
  }
}
