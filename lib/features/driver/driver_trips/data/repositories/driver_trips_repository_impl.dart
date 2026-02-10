import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/datasources/driver_trips_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/datasources/driver_trips_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/models/driver_trip_model.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/accept_trip_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/arrived_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/cancel_trip_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/complete_trip_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/create_schedule_request_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/get_schedule_requests_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/reject_trip_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/data/parameters/start_trip_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Implementation of DriverTripsRepository.
///
/// Extends BaseRepository for consistent error handling and network checks.
/// Provides offline capability with local caching.
class DriverTripsRepositoryImpl extends BaseRepository
    implements DriverTripsRepository {
  final DriverTripsRemoteDataSource _remoteDataSource;
  final DriverTripsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  DriverTripsRepositoryImpl({
    required DriverTripsRemoteDataSource remoteDataSource,
    required DriverTripsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<DriverTrip>> acceptTrip(String tripId) async {
    final parameters = AcceptTripParameters.builder()
        .withTripId(tripId)
        .build();
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.acceptTrip(parameters),
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> rejectTrip(String tripId) async {
    final parameters = RejectTripParameters.builder()
        .withTripId(tripId)
        .build();
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.rejectTrip(parameters),
    );

    return result.when(
      success: (data, _) => const ApiResult.success(null),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverTrip>> startTrip(String tripId) async {
    final parameters = StartTripParameters.builder().withTripId(tripId).build();
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.startTrip(parameters),
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverTrip>> arrived(String tripId) async {
    final parameters = ArrivedParameters.builder().withTripId(tripId).build();
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.arrived(parameters),
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverTrip>> completeTrip(String tripId) async {
    final parameters = CompleteTripParameters.builder()
        .withTripId(tripId)
        .build();
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.completeTrip(parameters),
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> cancelTrip(String tripId) async {
    final parameters = CancelTripParameters.builder()
        .withTripId(tripId)
        .build();
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.cancelTrip(parameters),
    );

    return result.when(
      success: (data, _) => const ApiResult.success(null),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<DriverTrip>>> getScheduleTrips() async {
    final result = await fetchWithCache<List<DriverTripModel>>(
      cacheKey: 'driver_schedule_trips',
      remoteFetcher: _remoteDataSource.getScheduleTrips,
      localFetcher: _localDataSource.getCachedScheduleTrips,
      cacheSaver: _localDataSource.cacheScheduleTrips,
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverTrip>> createScheduleRequest({
    required String pickUpLongitude,
    required String pickUpLatitude,
    required String destinationLongitude,
    required String destinationLatitude,
    required String pickupName,
    required String destinationName,
    required String date,
    required String pickUpTime,
    required String dropUpTime,
    required int vehicleTypeId,
  }) async {
    final parameters = CreateScheduleRequestParameters.builder()
        .withPickUpLongitude(pickUpLongitude)
        .withPickUpLatitude(pickUpLatitude)
        .withDestinationLongitude(destinationLongitude)
        .withDestinationLatitude(destinationLatitude)
        .withPickupName(pickupName)
        .withDestinationName(destinationName)
        .withDate(date)
        .withPickUpTime(pickUpTime)
        .withDropUpTime(dropUpTime)
        .withVehicleTypeId(vehicleTypeId)
        .build();

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.createScheduleRequest(parameters),
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<DriverTrip>>> getScheduleRequests({
    String? date,
    String? status,
  }) async {
    final builder = GetScheduleRequestsParameters.builder();
    if (date != null) builder.withDate(date);
    if (status != null) builder.withStatus(status);
    final parameters = builder.build();

    final result = await fetchWithCache<List<DriverTripModel>>(
      cacheKey: 'driver_schedule_requests_${date ?? ''}_${status ?? ''}',
      remoteFetcher: () => _remoteDataSource.getScheduleRequests(parameters),
      localFetcher: _localDataSource.getCachedScheduleRequests,
      cacheSaver: _localDataSource.cacheScheduleRequests,
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }
}
