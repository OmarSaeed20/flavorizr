import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/models/driver_credentials_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for driver authentication operations.
///
/// Handles caching of driver credentials and authentication data.
/// Provides offline capability by storing authentication tokens locally.
/// Based on the FAST App API documentation.
abstract class DriverAuthLocalDataSource {
  /// Get cached driver credentials.
  Future<ApiResult<DriverCredentialsModel?>> getCachedCredentials();

  /// Save driver credentials to local storage.
  Future<ApiResult<void>> cacheCredentials(DriverCredentialsModel credentials);

  /// Clear cached driver credentials.
  Future<ApiResult<void>> clearCredentials();

  /// Get cached access token.
  Future<ApiResult<String?>> getAccessToken();

  /// Save access token to local storage.
  Future<ApiResult<void>> saveAccessToken(String token);

  /// Clear access token from local storage.
  Future<ApiResult<void>> clearAccessToken();

  /// Get cached refresh token.
  Future<ApiResult<String?>> getRefreshToken();

  /// Save refresh token to local storage.
  Future<ApiResult<void>> saveRefreshToken(String token);

  /// Clear refresh token from local storage.
  Future<ApiResult<void>> clearRefreshToken();

  /// Check if driver is logged in.
  Future<ApiResult<bool>> isLoggedIn();

  /// Get cached driver ID.
  Future<ApiResult<String?>> getDriverId();

  /// Save driver ID to local storage.
  Future<ApiResult<void>> saveDriverId(String driverId);

  /// Clear driver ID from local storage.
  Future<ApiResult<void>> clearDriverId();
}

/// Implementation of [DriverAuthLocalDataSource] using BaseLocalDataSource.
class DriverAuthLocalDataSourceImpl
    with BaseLocalDataSource
    implements DriverAuthLocalDataSource {
  const DriverAuthLocalDataSourceImpl(this._preferences);
  final SharedPreferences _preferences;

  // Storage keys
  static const String _keyCredentials = 'driver_credentials';
  static const String _keyAccessToken = 'driver_access_token';
  static const String _keyRefreshToken = 'driver_refresh_token';
  static const String _keyDriverId = 'driver_id';

  @override
  Future<ApiResult<DriverCredentialsModel?>> getCachedCredentials() async {
    return getLocalData<DriverCredentialsModel?>(
      key: _keyCredentials,
      fetcher: () async {
        final jsonString = _preferences.getString(_keyCredentials);
        if (jsonString == null) return null;
        return DriverCredentialsModel.fromJson(
          Map<String, dynamic>.from(
            // ignore: avoid_dynamic_calls
            (_preferences.getString(_keyCredentials)) != null ? {} : {},
          ),
        );
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheCredentials(
    DriverCredentialsModel credentials,
  ) async {
    return saveLocalData<DriverCredentialsModel>(
      key: _keyCredentials,
      data: credentials,
      saver: (data) async {
        await _preferences.setString(_keyCredentials, data.toJson().toString());
      },
    );
  }

  @override
  Future<ApiResult<void>> clearCredentials() async {
    return deleteLocalData(
      key: _keyCredentials,
      deleter: () async {
        await _preferences.remove(_keyCredentials);
      },
    );
  }

  @override
  Future<ApiResult<String?>> getAccessToken() async {
    return getLocalData<String?>(
      key: _keyAccessToken,
      fetcher: () async => _preferences.getString(_keyAccessToken),
    );
  }

  @override
  Future<ApiResult<void>> saveAccessToken(String token) async {
    return saveLocalData<String>(
      key: _keyAccessToken,
      data: token,
      saver: (data) async {
        await _preferences.setString(_keyAccessToken, data);
      },
    );
  }

  @override
  Future<ApiResult<void>> clearAccessToken() async {
    return deleteLocalData(
      key: _keyAccessToken,
      deleter: () async {
        await _preferences.remove(_keyAccessToken);
      },
    );
  }

  @override
  Future<ApiResult<String?>> getRefreshToken() async {
    return getLocalData<String?>(
      key: _keyRefreshToken,
      fetcher: () async => _preferences.getString(_keyRefreshToken),
    );
  }

  @override
  Future<ApiResult<void>> saveRefreshToken(String token) async {
    return saveLocalData<String>(
      key: _keyRefreshToken,
      data: token,
      saver: (data) async {
        await _preferences.setString(_keyRefreshToken, data);
      },
    );
  }

  @override
  Future<ApiResult<void>> clearRefreshToken() async {
    return deleteLocalData(
      key: _keyRefreshToken,
      deleter: () async {
        await _preferences.remove(_keyRefreshToken);
      },
    );
  }

  @override
  Future<ApiResult<bool>> isLoggedIn() async {
    return hasLocalData(
      key: _keyAccessToken,
      checker: () async {
        final token = _preferences.getString(_keyAccessToken);
        return token != null && token.isNotEmpty;
      },
    );
  }

  @override
  Future<ApiResult<String?>> getDriverId() async {
    return getLocalData<String?>(
      key: _keyDriverId,
      fetcher: () async => _preferences.getString(_keyDriverId),
    );
  }

  @override
  Future<ApiResult<void>> saveDriverId(String driverId) async {
    return saveLocalData<String>(
      key: _keyDriverId,
      data: driverId,
      saver: (data) async {
        await _preferences.setString(_keyDriverId, data);
      },
    );
  }

  @override
  Future<ApiResult<void>> clearDriverId() async {
    return deleteLocalData(
      key: _keyDriverId,
      deleter: () async {
        await _preferences.remove(_keyDriverId);
      },
    );
  }
}
