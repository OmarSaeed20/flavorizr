// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'dart:convert';

import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching auth data.
///
/// Uses:
/// - flutter_secure_storage for tokens (encrypted)
/// - SharedPreferences for user data (not sensitive)
abstract class AuthLocalDataSource {
  /// Saves auth tokens securely.
  Future<ApiResult<AuthTokens>> saveTokens(AuthTokens tokens);

  /// Gets saved auth tokens.
  Future<ApiResult<AuthTokens>> getTokens();

  /// Deletes auth tokens.
  Future<ApiResult<void>> deleteTokens();

  /// Saves user data.
  Future<ApiResult<UserModel>> saveUser(UserModel user);

  /// Gets saved user data.
  Future<ApiResult<UserModel>> getUser();

  /// Deletes user data.
  Future<ApiResult<void>> deleteUser();

  /// Checks if user is logged in (has tokens).
  Future<ApiResult<bool>> isLoggedIn();

  /// Clears all auth data.
  Future<ApiResult<void>> clearAll();

  // Biometric-related storage

  /// Saves credentials for biometric login.
  Future<ApiResult<void>> saveBiometricCredentials({
    required String email,
    required String password,
  });

  /// Gets biometric credentials.
  Future<ApiResult<({String email, String password})>>
  getBiometricCredentials();

  /// Checks if biometric credentials are saved.
  Future<ApiResult<bool>> hasBiometricCredentials();

  /// Deletes biometric credentials.
  Future<ApiResult<void>> deleteBiometricCredentials();
}

/// Implementation of [AuthLocalDataSource] using BaseLocalDataSource.
class AuthLocalDataSourceImpl
    with BaseLocalDataSource
    implements AuthLocalDataSource {
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
  Future<ApiResult<AuthTokens>> saveTokens(AuthTokens tokens) async {
    return saveLocalData<AuthTokens>(
      key: _accessTokenKey,
      data: tokens,
      saver: (data) async {
        await Future.wait([
          _secureStorage.write(key: _accessTokenKey, value: data.accessToken),
          _secureStorage.write(key: _refreshTokenKey, value: data.refreshToken),
          _secureStorage.write(
            key: _accessTokenExpiryKey,
            value: data.accessTokenExpiresAt.toIso8601String(),
          ),
          if (data.refreshTokenExpiresAt != null)
            _secureStorage.write(
              key: _refreshTokenExpiryKey,
              value: data.refreshTokenExpiresAt!.toIso8601String(),
            ),
          _secureStorage.write(key: _tokenTypeKey, value: data.tokenType),
        ]);
      },
    );
  }

  @override
  Future<ApiResult<AuthTokens>> getTokens() async {
    return getLocalData<AuthTokens>(
      key: _accessTokenKey,
      fetcher: () async {
        final accessToken = await _secureStorage.read(key: _accessTokenKey);
        final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
        final accessTokenExpiry = await _secureStorage.read(
          key: _accessTokenExpiryKey,
        );
        final refreshTokenExpiry = await _secureStorage.read(
          key: _refreshTokenExpiryKey,
        );
        final tokenType = await _secureStorage.read(key: _tokenTypeKey);

        if (accessToken == null ||
            refreshToken == null ||
            accessTokenExpiry == null) {
          return null;
        }

        return AuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          accessTokenExpiresAt: DateTime.parse(accessTokenExpiry),
          refreshTokenExpiresAt: refreshTokenExpiry != null
              ? DateTime.parse(refreshTokenExpiry)
              : null,
          tokenType: tokenType ?? 'Bearer',
        );
      },
    );
  }

  @override
  Future<ApiResult<void>> deleteTokens() async {
    return deleteLocalData(
      key: _accessTokenKey,
      deleter: () async {
        await Future.wait([
          _secureStorage.delete(key: _accessTokenKey),
          _secureStorage.delete(key: _refreshTokenKey),
          _secureStorage.delete(key: _accessTokenExpiryKey),
          _secureStorage.delete(key: _refreshTokenExpiryKey),
          _secureStorage.delete(key: _tokenTypeKey),
        ]);
      },
    );
  }

  @override
  Future<ApiResult<UserModel>> saveUser(UserModel user) async {
    return saveLocalData<UserModel>(
      key: _userKey,
      data: user,
      saver: (data) async {
        final json = jsonEncode(data.toJson());
        await _prefs.setString(_userKey, json);
      },
    );
  }

  @override
  Future<ApiResult<UserModel>> getUser() async {
    return getLocalData<UserModel>(
      key: _userKey,
      fetcher: () async {
        final json = _prefs.getString(_userKey);
        if (json == null) return null;

        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          return UserModel.fromJson(map);
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> deleteUser() async {
    return deleteLocalData(
      key: _userKey,
      deleter: () => _prefs.remove(_userKey),
    );
  }

  @override
  Future<ApiResult<bool>> isLoggedIn() async {
    return hasLocalData(
      key: _accessTokenKey,
      checker: () async {
        final tokensResult = await getTokens();
        return tokensResult.isSuccess &&
            tokensResult.data != null &&
            !tokensResult.data!.isFullyExpired;
      },
    );
  }

  @override
  Future<ApiResult<void>> clearAll() async {
    return clearAllLocalData(
      clearer: () async {
        await Future.wait([deleteTokens(), deleteUser()]);
      },
    );
  }

  @override
  Future<ApiResult<void>> saveBiometricCredentials({
    required String email,
    required String password,
  }) async {
    return saveLocalData<void>(
      key: _biometricEmailKey,
      data: null,
      saver: (data) async {
        await Future.wait([
          _secureStorage.write(key: _biometricEmailKey, value: email),
          _secureStorage.write(key: _biometricPasswordKey, value: password),
        ]);
      },
    );
  }

  @override
  Future<ApiResult<({String email, String password})>>
  getBiometricCredentials() async {
    return getLocalData<({String email, String password})>(
      key: _biometricEmailKey,
      fetcher: () async {
        final email = await _secureStorage.read(key: _biometricEmailKey);
        final password = await _secureStorage.read(key: _biometricPasswordKey);

        if (email == null || password == null) return null;

        return (email: email, password: password);
      },
    );
  }

  @override
  Future<ApiResult<bool>> hasBiometricCredentials() async {
    return hasLocalData(
      key: _biometricEmailKey,
      checker: () async {
        final email = await _secureStorage.read(key: _biometricEmailKey);
        final password = await _secureStorage.read(key: _biometricPasswordKey);
        return email != null && password != null;
      },
    );
  }

  @override
  Future<ApiResult<void>> deleteBiometricCredentials() async {
    return deleteLocalData(
      key: _biometricEmailKey,
      deleter: () async {
        await Future.wait([
          _secureStorage.delete(key: _biometricEmailKey),
          _secureStorage.delete(key: _biometricPasswordKey),
        ]);
      },
    );
  }
}
