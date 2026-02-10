import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/endpoints/schedule_trip_endpoints.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/models/scheduled_trip_model.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/parameters/create_scheduled_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/parameters/get_scheduled_trips_parameters.dart';

/// Remote data source for schedule trip operations.
///
/// Handles all HTTP requests related to scheduled trips.
/// Returns ApiResult with success or error data.
abstract class ScheduleTripRemoteDataSource {
  /// Creates a new scheduled trip.
  Future<ApiResult<ScheduledTripModel>> createScheduledTrip(
    CreateScheduledTripParameters parameters,
  );

  /// Gets scheduled trips for the user.
  Future<ApiResult<List<ScheduledTripModel>>> getScheduledTrips(
    GetScheduledTripsParameters parameters,
  );

  /// Gets a specific scheduled trip by ID.
  Future<ApiResult<ScheduledTripModel>> getScheduledTripById(String tripId);

  /// Cancels a scheduled trip.
  Future<ApiResult<void>> cancelScheduledTrip(String tripId);

  /// Updates a scheduled trip.
  Future<ApiResult<ScheduledTripModel>> updateScheduledTrip(
    String tripId,
    CreateScheduledTripParameters parameters,
  );
}

/// Implementation of [ScheduleTripRemoteDataSource] using BaseRemoteDataSource.
class ScheduleTripRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements ScheduleTripRemoteDataSource {
  const ScheduleTripRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<ScheduledTripModel>> createScheduledTrip(
    CreateScheduledTripParameters parameters,
  ) async {
    return post<ScheduledTripModel>(
      path: ScheduleTripEndpoints.createScheduledTrip,
      data: parameters.toJson(),
      decoder: (data) => ScheduledTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<ScheduledTripModel>>> getScheduledTrips(
    GetScheduledTripsParameters parameters,
  ) async {
    return get<List<ScheduledTripModel>>(
      path: ScheduleTripEndpoints.scheduledTrips,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => ScheduledTripModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<ScheduledTripModel>> getScheduledTripById(String tripId) async {
    return get<ScheduledTripModel>(
      path: ScheduleTripEndpoints.scheduledTripById(tripId),
      decoder: (data) => ScheduledTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> cancelScheduledTrip(String tripId) async {
    return post<void>(path: ScheduleTripEndpoints.cancelScheduledTrip(tripId), decoder: (data) {});
  }

  @override
  Future<ApiResult<ScheduledTripModel>> updateScheduledTrip(
    String tripId,
    CreateScheduledTripParameters parameters,
  ) async {
    return put<ScheduledTripModel>(
      path: ScheduleTripEndpoints.updateScheduledTrip(tripId),
      data: parameters.toJson(),
      decoder: (data) => ScheduledTripModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
