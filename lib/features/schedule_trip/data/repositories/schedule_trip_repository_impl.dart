import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/schedule_trip/data/datasources/schedule_trip_remote_datasource.dart';
import 'package:flavorizr/features/schedule_trip/data/models/scheduled_trip_model.dart';
import 'package:flavorizr/features/schedule_trip/data/parameters/create_scheduled_trip_parameters.dart';
import 'package:flavorizr/features/schedule_trip/data/parameters/get_scheduled_trips_parameters.dart';
import 'package:flavorizr/features/schedule_trip/domain/entities/scheduled_trip.dart';
import 'package:flavorizr/features/schedule_trip/domain/repositories/schedule_trip_repository.dart';

/// Implementation of [ScheduleTripRepository].
class ScheduleTripRepositoryImpl extends BaseRepository implements ScheduleTripRepository {
  final ScheduleTripRemoteDataSource _remoteDataSource;

  ScheduleTripRepositoryImpl({
    required ScheduleTripRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<ScheduledTrip>> createScheduledTrip(CreateScheduledTripParameters params) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.createScheduledTrip(params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<List<ScheduledTrip>>> getScheduledTrips(
    GetScheduledTripsParameters params,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.getScheduledTrips(params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<ScheduledTrip>> getScheduledTripById(String tripId) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.getScheduledTripById(tripId),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<void>> cancelScheduledTrip(String tripId) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.cancelScheduledTrip(tripId),
    );
    return result.map(
      success: (data) => const ApiResult.success(null),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<ScheduledTrip>> updateScheduledTrip(
    String tripId,
    CreateScheduledTripParameters params,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateScheduledTrip(tripId, params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }
}
