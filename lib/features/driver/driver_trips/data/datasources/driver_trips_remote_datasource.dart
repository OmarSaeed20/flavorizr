import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_trips/data/endpoints/driver_trips_endpoints.dart';
import 'package:flavorizr/features/driver/driver_trips/data/models/driver_trip_model.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/get_driver_trips_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/reject_trip_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/complete_trip_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/cancel_trip_parameters.dart';
import 'package:flavorizr/features/driver/driver_trips/data/parameters/update_trip_location_parameters.dart';

/// Remote data source for driver trips.
///
/// Handles all HTTP requests related to driver trip management.
/// Returns ApiResult with success or error data.
abstract class DriverTripsRemoteDataSource {
  /// Gets driver trips with pagination and filtering.
  Future<ApiResult<List<DriverTripModel>>> getDriverTrips(GetDriverTripsParameters parameters);

  /// Gets a specific trip by ID.
  Future<ApiResult<DriverTripModel>> getDriverTripById(String tripId);

  /// Gets pending trip requests.
  Future<ApiResult<List<DriverTripModel>>> getPendingTrips();

  /// Accepts a trip request.
  Future<ApiResult<DriverTripModel>> acceptTrip(String tripId);

  /// Rejects a trip request.
  Future<ApiResult<bool>> rejectTrip(RejectTripParameters parameters);

  /// Starts a trip.
  Future<ApiResult<DriverTripModel>> startTrip(String tripId);

  /// Completes a trip.
  Future<ApiResult<DriverTripModel>> completeTrip(CompleteTripParameters parameters);

  /// Cancels a trip.
  Future<ApiResult<bool>> cancelTrip(CancelTripParameters parameters);

  /// Updates trip location.
  Future<ApiResult<bool>> updateTripLocation(UpdateTripLocationParameters parameters);

  /// Gets trip route.
  Future<ApiResult<Map<String, dynamic>>> getTripRoute(String tripId);

  /// Updates trip status.
  Future<ApiResult<DriverTripModel>> updateTripStatus({
    required String tripId,
    required String status,
    Map<String, dynamic>? additionalData,
  });

  /// Gets trip history.
  Future<ApiResult<List<DriverTripModel>>> getTripHistory({int page = 1, int limit = 20});

  /// Gets current active trip.
  Future<ApiResult<DriverTripModel?>> getCurrentTrip();
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
  Future<ApiResult<List<DriverTripModel>>> getDriverTrips(
    GetDriverTripsParameters parameters,
  ) async {
    return get<List<DriverTripModel>>(
      path: DriverTripsEndpoints.trips,
      queryParameters: parameters.toJson(),
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['trips'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> getDriverTripById(String tripId) async {
    return get<DriverTripModel>(
      path: DriverTripsEndpoints.tripById(tripId),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverTripModel>>> getPendingTrips() async {
    return get<List<DriverTripModel>>(
      path: DriverTripsEndpoints.pendingTrips,
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['trips'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> acceptTrip(String tripId) async {
    return post<DriverTripModel>(
      path: DriverTripsEndpoints.acceptTrip(tripId),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<bool>> rejectTrip(RejectTripParameters parameters) async {
    return post<bool>(
      path: DriverTripsEndpoints.rejectTrip(parameters.tripId),
      data: parameters.toJson(),
      decoder: (data) => (data as Map<String, dynamic>)['success'] as bool? ?? false,
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> startTrip(String tripId) async {
    return post<DriverTripModel>(
      path: DriverTripsEndpoints.startTrip(tripId),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> completeTrip(CompleteTripParameters parameters) async {
    return post<DriverTripModel>(
      path: DriverTripsEndpoints.completeTrip(parameters.tripId),
      data: parameters.toJson(),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<bool>> cancelTrip(CancelTripParameters parameters) async {
    return post<bool>(
      path: DriverTripsEndpoints.cancelTrip(parameters.tripId),
      data: parameters.toJson(),
      decoder: (data) => (data as Map<String, dynamic>)['success'] as bool? ?? false,
    );
  }

  @override
  Future<ApiResult<bool>> updateTripLocation(UpdateTripLocationParameters parameters) async {
    return put<bool>(
      path: DriverTripsEndpoints.updateLocation(parameters.tripId),
      data: parameters.toJson(),
      decoder: (data) => (data as Map<String, dynamic>)['success'] as bool? ?? false,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getTripRoute(String tripId) async {
    return get<Map<String, dynamic>>(
      path: DriverTripsEndpoints.tripRoute(tripId),
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<DriverTripModel>> updateTripStatus({
    required String tripId,
    required String status,
    Map<String, dynamic>? additionalData,
  }) async {
    return put<DriverTripModel>(
      path: DriverTripsEndpoints.updateStatus(tripId),
      data: {'status': status, if (additionalData != null) ...additionalData},
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverTripModel>>> getTripHistory({int page = 1, int limit = 20}) async {
    return get<List<DriverTripModel>>(
      path: DriverTripsEndpoints.tripHistory,
      queryParameters: {'page': page, 'limit': limit},
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['trips'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<DriverTripModel?>> getCurrentTrip() async {
    return get<DriverTripModel?>(
      path: DriverTripsEndpoints.currentTrip,
      decoder: (data) {
        if (data == null) return null;
        return DriverTripModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }
}
