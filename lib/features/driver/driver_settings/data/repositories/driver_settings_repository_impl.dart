import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/datasources/driver_settings_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/datasources/driver_settings_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_driver_settings_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_language_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_notification_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_privacy_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/entities/driver_settings.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/repositories/driver_settings_repository.dart';

/// Implementation of [DriverSettingsRepository].
///
/// Extends BaseRepository for consistent error handling and network checks.
/// Provides offline capability with local caching.
/// Based on the FAST App API documentation.
class DriverSettingsRepositoryImpl extends BaseRepository implements DriverSettingsRepository {
  final DriverSettingsRemoteDataSource _remoteDataSource;
  final DriverSettingsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  DriverSettingsRepositoryImpl({
    required DriverSettingsRemoteDataSource remoteDataSource,
    required DriverSettingsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<DriverSettings>> getSettings() async {
    final result = await fetchWithCache(
      cacheKey: 'driver_settings',
      remoteFetcher: _remoteDataSource.getSettings,
      localFetcher: _localDataSource.getCachedSettings,
      cacheSaver: (data) async {
        if (data != null) {
          await _localDataSource.cacheSettings(data);
        }
      },
    );

    return result.when(
      success: (data, e) {
        if (data == null) {
          return ApiResult.exception(
            e ?? const UnknownNetworkException(message: 'No cached driver settings found'),
          );
        }
        return ApiResult.success(data);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverSettings>> updateSettings(
    UpdateDriverSettingsParameters parameters,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateSettings(parameters),
    );

    return result.when(
      success: (data, _) async {
        // Cache updated settings
        await _localDataSource.cacheSettings(data);
        return ApiResult.success(data);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverSettings>> updateNotifications(
    UpdateNotificationParameters parameters,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateNotifications(parameters),
    );

    return result.when(
      success: (data, _) async {
        // Cache updated settings
        await _localDataSource.cacheSettings(data);
        return ApiResult.success(data);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverSettings>> updateLanguage(UpdateLanguageParameters parameters) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateLanguage(parameters),
    );

    return result.when(
      success: (data, _) async {
        // Cache updated settings and language preference
        await _localDataSource.cacheSettings(data);
        await _localDataSource.saveLanguage(parameters.language);
        return ApiResult.success(data);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverSettings>> updatePrivacy(UpdatePrivacyParameters parameters) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updatePrivacy(parameters),
    );

    return result.when(
      success: (data, _) async {
        // Cache updated settings
        await _localDataSource.cacheSettings(data);
        return ApiResult.success(data);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> deleteAccount() async {
    final result = await executeRemoteRequest(request: _remoteDataSource.deleteAccount);

    return result.when(
      success: (_, __) async {
        // Clear all cached settings
        await _localDataSource.clearSettings();
        return const ApiResult.success(null);
      },
      exception: ApiResult.exception,
    );
  }
}
