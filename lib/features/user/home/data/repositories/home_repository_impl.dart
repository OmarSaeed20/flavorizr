import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/home/data/datasources/home_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/home/data/parameters/get_available_trips_parameters.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/advertisement.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/available_trip.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/banner.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/home_data.dart';
import 'package:fast_golden_taxi/features/user/home/domain/repositories/home_repository.dart';

/// Implementation of [HomeRepository].
///
/// Extends BaseRepository for consistent error handling and network checks.
class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<HomeData>> getHomeData() async {
    final result = await executeRemoteRequest(
      request: _remoteDataSource.getHomeData,
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<List<Banner>>> getBanners() async {
    final result = await executeRemoteRequest(
      request: _remoteDataSource.getBanners,
    );
    return result.map(
      success: (data) =>
          ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<List<Advertisement>>> getAdvertisements() async {
    final result = await executeRemoteRequest(
      request: _remoteDataSource.getAdvertisements,
    );
    return result.map(
      success: (data) =>
          ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<List<AvailableTrip>>> getAvailableTrips(
    GetAvailableTripsParameters params,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.getAvailableTrips(params),
    );
    return result.map(
      success: (data) =>
          ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<int>> getNotificationCount() async {
    return executeRemoteRequest(
      request: _remoteDataSource.getNotificationCount,
    );
  }
}
