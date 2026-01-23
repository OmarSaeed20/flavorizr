// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'dart:convert';

import 'package:flavorizr/features/auth/data/models/user_model.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching auth data.
///
/// Uses:
/// - flutter_secure_storage for tokens (encrypted)
/// - SharedPreferences for user data (not sensitive)
abstract class AuthLocalDataSource {
  /// Saves auth tokens securely.
  Future<void> saveTokens(AuthTokens tokens);

  /// Gets saved auth tokens.
  Future<AuthTokens?> getTokens();

  /// Deletes auth tokens.
  Future<void> deleteTokens();

  /// Saves user data.
  Future<void> saveUser(UserModel user);

  /// Gets saved user data.
  Future<UserModel?> getUser();

  /// Deletes user data.
  Future<void> deleteUser();

  /// Checks if user is logged in (has tokens).
  Future<bool> isLoggedIn();

  /// Clears all auth data.
  Future<void> clearAll();

  // Biometric-related storage

  /// Saves credentials for biometric login.
  Future<void> saveBiometricCredentials({required String email, required String password});

  /// Gets biometric credentials.
  Future<({String email, String password})?> getBiometricCredentials();

  /// Checks if biometric credentials are saved.
  Future<bool> hasBiometricCredentials();

  /// Deletes biometric credentials.
  Future<void> deleteBiometricCredentials();
}

/// Implementation of [AuthLocalDataSource].
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
  }) : _secureStorage = secureStorage,
       _prefs = prefs;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  // Keys
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _accessTokenExpiryKey = 'auth_access_token_expiry';
  static const String _refreshTokenExpiryKey = 'auth_refresh_token_expiry';
  static const String _tokenTypeKey = 'auth_token_type';
  static const String _userKey = 'auth_user';
  static const String _biometricEmailKey = 'biometric_email';
  static const String _biometricPasswordKey = 'biometric_password';

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken),
      _secureStorage.write(
        key: _accessTokenExpiryKey,
        value: tokens.accessTokenExpiresAt.toIso8601String(),
      ),
      if (tokens.refreshTokenExpiresAt != null)
        _secureStorage.write(
          key: _refreshTokenExpiryKey,
          value: tokens.refreshTokenExpiresAt!.toIso8601String(),
        ),
      _secureStorage.write(key: _tokenTypeKey, value: tokens.tokenType),
    ]);
  }

  @override
  Future<AuthTokens?> getTokens() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    final accessTokenExpiry = await _secureStorage.read(key: _accessTokenExpiryKey);
    final refreshTokenExpiry = await _secureStorage.read(key: _refreshTokenExpiryKey);
    final tokenType = await _secureStorage.read(key: _tokenTypeKey);

    if (accessToken == null || refreshToken == null || accessTokenExpiry == null) {
      return null;
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresAt: DateTime.parse(accessTokenExpiry),
      refreshTokenExpiresAt: refreshTokenExpiry != null ? DateTime.parse(refreshTokenExpiry) : null,
      tokenType: tokenType ?? 'Bearer',
    );
  }

  @override
  Future<void> deleteTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _accessTokenExpiryKey),
      _secureStorage.delete(key: _refreshTokenExpiryKey),
      _secureStorage.delete(key: _tokenTypeKey),
    ]);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, json);
  }

  @override
  Future<UserModel?> getUser() async {
    final json = _prefs.getString(_userKey);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await _prefs.remove(_userKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final tokens = await getTokens();
    return tokens != null && !tokens.isFullyExpired;
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([deleteTokens(), deleteUser()]);
  }

  @override
  Future<void> saveBiometricCredentials({required String email, required String password}) async {
    await Future.wait([
      _secureStorage.write(key: _biometricEmailKey, value: email),
      _secureStorage.write(key: _biometricPasswordKey, value: password),
    ]);
  }

  @override
  Future<({String email, String password})?> getBiometricCredentials() async {
    final email = await _secureStorage.read(key: _biometricEmailKey);
    final password = await _secureStorage.read(key: _biometricPasswordKey);

    if (email == null || password == null) return null;

    return (email: email, password: password);
  }

  @override
  Future<bool> hasBiometricCredentials() async {
    final email = await _secureStorage.read(key: _biometricEmailKey);
    final password = await _secureStorage.read(key: _biometricPasswordKey);
    return email != null && password != null;
  }

  @override
  Future<void> deleteBiometricCredentials() async {
    await Future.wait([
      _secureStorage.delete(key: _biometricEmailKey),
      _secureStorage.delete(key: _biometricPasswordKey),
    ]);
  }
}
