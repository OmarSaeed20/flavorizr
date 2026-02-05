import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_home/data/datasources/driver_home_local_datasource.dart';
import 'package:flavorizr/features/driver/driver_home/data/datasources/driver_home_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_home/data/models/driver_home_data_model.dart';
import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_home_data.dart';
import 'package:flavorizr/features/driver/driver_home/domain/repositories/driver_home_repository.dart';

/// Implementation of DriverHomeRepository.
///
/// Extends BaseRepository for consistent error handling and network checks.
/// Provides offline capability with local caching.
class DriverHomeRepositoryImpl extends BaseRepository implements DriverHomeRepository {
  final DriverHomeRemoteDataSource _remoteDataSource;
  final DriverHomeLocalDataSource _localDataSource;

  DriverHomeRepositoryImpl({
    required DriverHomeRemoteDataSource remoteDataSource,
    required DriverHomeLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<DriverHomeData>> getDriverHomeData() async {
    final result = await fetchWithCache<DriverHomeDataModel>(
      cacheKey: 'driver_home_data',
      remoteFetcher: _remoteDataSource.getDriverHomeData,
      localFetcher: _localDataSource.getCachedHomeData,
      cacheSaver: (data) async {
        await _localDataSource.cacheHomeData(data);
      },
    );

    return result.when(
      success: (data, _) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }
}
