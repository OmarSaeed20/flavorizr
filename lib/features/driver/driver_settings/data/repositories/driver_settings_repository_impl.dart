import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_settings/data/datasources/driver_settings_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_settings/data/models/driver_settings_model.dart';
import 'package:flavorizr/features/driver/driver_settings/data/parameters/update_driver_settings_parameters.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/entities/driver_settings.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/repositories/driver_settings_repository.dart';

/// Implementation of [DriverSettingsRepository].
class DriverSettingsRepositoryImpl extends BaseRepository implements DriverSettingsRepository {
  final DriverSettingsRemoteDataSource _remoteDataSource;

  DriverSettingsRepositoryImpl({
    required DriverSettingsRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<DriverSettings>> getDriverSettings() async {
    final result = await executeRemoteRequest(request: _remoteDataSource.getDriverSettings);
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<DriverSettings>> updateDriverSettings(
    UpdateDriverSettingsParameters params,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateDriverSettings(params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<DriverSettings>> toggleOnlineStatus(bool isOnline) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.toggleOnlineStatus(isOnline),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<DriverSettings>> toggleAvailabilityStatus(bool isAvailable) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.toggleAvailabilityStatus(isAvailable),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }
}
