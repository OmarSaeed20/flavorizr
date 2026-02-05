import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_trips/data/endpoints/driver_trips_endpoints.dart';
import 'package:flavorizr/features/driver/driver_trips/data/models/driver_trip_model.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/accept_trip_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/arrived_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/cancel_trip_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/complete_trip_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/create_schedule_request_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/get_schedule_requests_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/reject_trip_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/start_trip_parameters.dart';

/// Remote data source for driver trips.
///
/// Handles all HTTP requests related to driver trip management.
/// Returns ApiResult with success or error data.
abstract class DriverTripsRemoteDataSource {
  /// Accepts a trip request.
  Future<ApiResult<DriverTripModel>> acceptTrip(
    AcceptTripParameters parameters,
  );

  /// Rejects a trip request.
  Future<ApiResult<void>> rejectTrip(RejectTripParameters parameters);

  /// Starts a trip.
  Future<ApiResult<DriverTripModel>> startTrip(StartTripParameters parameters);

  /// Marks driver as arrived at pickup location.
  Future<ApiResult<DriverTripModel>> arrived(ArrivedParameters parameters);

  /// Completes a trip.
  Future<ApiResult<DriverTripModel>> completeTrip(
    CompleteTripParameters parameters,
  );

  /// Cancels a trip.
  Future<ApiResult<void>> cancelTrip(CancelTripParameters parameters);

  /// Gets driver's scheduled trips.
  Future<ApiResult<List<DriverTripModel>>> getScheduleTrips();

  /// Creates a schedule trip request.
  Future<ApiResult<DriverTripModel>> createScheduleRequest(
    CreateScheduleRequestParameters parameters,
  );

  /// Gets driver's schedule trip requests.
  Future<ApiResult<List<DriverTripModel>>> getScheduleRequests(
    GetScheduleRequestsParameters parameters,
  );
}

/// Implementation of [DriverTripsRemoteDataSource] using BaseRemoteDataSource.
class DriverTripsRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverTripsRemoteDataSource {
  const DriverTripsRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<DriverTripModel>> acceptTrip(
    AcceptTripParameters parameters,
  ) async {
    return post<DriverTripModel>(
      path: DriverTripsEndpoints.acceptTrip,
      data: parameters.toJson(),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> rejectTrip(RejectTripParameters parameters) async {
    return post<void>(
      path: DriverTripsEndpoints.rejectTrip,
      data: parameters.toJson(),
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> startTrip(
    StartTripParameters parameters,
  ) async {
    return patch<DriverTripModel>(
      path: DriverTripsEndpoints.startTrip,
      data: parameters.toJson(),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> arrived(
    ArrivedParameters parameters,
  ) async {
    return patch<DriverTripModel>(
      path: DriverTripsEndpoints.arrived,
      data: parameters.toJson(),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> completeTrip(
    CompleteTripParameters parameters,
  ) async {
    return patch<DriverTripModel>(
      path: DriverTripsEndpoints.completeTrip,
      data: parameters.toJson(),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> cancelTrip(CancelTripParameters parameters) async {
    return patch<void>(
      path: DriverTripsEndpoints.cancelTrip,
      data: parameters.toJson(),
    );
  }

  @override
  Future<ApiResult<List<DriverTripModel>>> getScheduleTrips() async {
    return get<List<DriverTripModel>>(
      path: DriverTripsEndpoints.getScheduleTrips,
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items =
            (jsonData['trips'] as List? ?? jsonData['data'] as List? ?? [])
                .map((e) => DriverTripModel.fromJson(e as Map<String, dynamic>))
                .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> createScheduleRequest(
    CreateScheduleRequestParameters parameters,
  ) async {
    return post<DriverTripModel>(
      path: DriverTripsEndpoints.createScheduleRequest,
      data: parameters.toJson(),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverTripModel>>> getScheduleRequests(
    GetScheduleRequestsParameters parameters,
  ) async {
    return post<List<DriverTripModel>>(
      path: DriverTripsEndpoints.getScheduleRequests,
      data: parameters.toJson(),
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items =
            (jsonData['trips'] as List? ?? jsonData['data'] as List? ?? [])
                .map((e) => DriverTripModel.fromJson(e as Map<String, dynamic>))
                .toList();
        return items;
      },
    );
  }
}
