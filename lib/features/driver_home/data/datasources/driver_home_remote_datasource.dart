import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_home/data/endpoints/driver_home_endpoints.dart';
import 'package:flavorizr/features/driver_home/data/models/driver_home_data_model.dart';
import 'package:flavorizr/features/driver_home/data/models/driver_earnings_model.dart';
import 'package:flavorizr/features/driver_home/data/models/driver_stats_model.dart';
import 'package:flavorizr/features/driver_home/data/models/driver_trip_model.dart';
import 'package:flavorizr/features/driver_home/data/parameters/get_driver_trips_parameters.dart';
import 'package:flavorizr/features/driver_home/data/parameters/update_online_status_parameters.dart';
import 'package:flavorizr/features/driver_home/data/parameters/update_availability_status_parameters.dart';

/// Remote data source for driver home data.
///
/// Handles all HTTP requests related to driver home page data.
/// Returns ApiResult with success or error data.
abstract class DriverHomeRemoteDataSource {
  /// Gets complete driver home data.
  Future<ApiResult<DriverHomeDataModel>> getDriverHomeData();

  /// Gets driver earnings.
  Future<ApiResult<DriverEarningsModel>> getDriverEarnings();

  /// Gets driver statistics.
  Future<ApiResult<DriverStatsModel>> getDriverStats();

  /// Gets driver trips with pagination.
  Future<ApiResult<List<DriverTripModel>>> getDriverTrips(GetDriverTripsParameters parameters);

  /// Gets a specific trip by ID.
  Future<ApiResult<DriverTripModel>> getDriverTripById(String tripId);

  /// Updates driver online status.
  Future<ApiResult<bool>> updateOnlineStatus(UpdateOnlineStatusParameters parameters);

  /// Updates driver availability status.
  Future<ApiResult<bool>> updateAvailabilityStatus(UpdateAvailabilityStatusParameters parameters);

  /// Gets driver current trip.
  Future<ApiResult<DriverTripModel?>> getCurrentTrip();

  /// Gets driver pending trips.
  Future<ApiResult<List<DriverTripModel>>> getPendingTrips();

  /// Gets driver completed trips.
  Future<ApiResult<List<DriverTripModel>>> getCompletedTrips({int page = 1, int limit = 20});
}

/// Implementation of [DriverHomeRemoteDataSource] using BaseRemoteDataSource.
class DriverHomeRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverHomeRemoteDataSource {
  const DriverHomeRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<DriverHomeDataModel>> getDriverHomeData() async {
    return get<DriverHomeDataModel>(
      path: DriverHomeEndpoints.homeData,
      decoder: (data) => DriverHomeDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverEarningsModel>> getDriverEarnings() async {
    return get<DriverEarningsModel>(
      path: DriverHomeEndpoints.earnings,
      decoder: (data) => DriverEarningsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverStatsModel>> getDriverStats() async {
    return get<DriverStatsModel>(
      path: DriverHomeEndpoints.stats,
      decoder: (data) => DriverStatsModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverTripModel>>> getDriverTrips(
    GetDriverTripsParameters parameters,
  ) async {
    return get<List<DriverTripModel>>(
      path: DriverHomeEndpoints.trips,
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
      path: DriverHomeEndpoints.tripById(tripId),
      decoder: (data) => DriverTripModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<bool>> updateOnlineStatus(UpdateOnlineStatusParameters parameters) async {
    return put<bool>(
      path: DriverHomeEndpoints.updateOnlineStatus,
      data: parameters.toJson(),
      decoder: (data) => (data as Map<String, dynamic>)['success'] as bool? ?? false,
    );
  }

  @override
  Future<ApiResult<bool>> updateAvailabilityStatus(
    UpdateAvailabilityStatusParameters parameters,
  ) async {
    return put<bool>(
      path: DriverHomeEndpoints.updateAvailabilityStatus,
      data: parameters.toJson(),
      decoder: (data) => (data as Map<String, dynamic>)['success'] as bool? ?? false,
    );
  }

  @override
  Future<ApiResult<DriverTripModel?>> getCurrentTrip() async {
    return get<DriverTripModel?>(
      path: DriverHomeEndpoints.currentTrip,
      decoder: (data) {
        if (data == null) return null;
        return DriverTripModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<ApiResult<List<DriverTripModel>>> getPendingTrips() async {
    return get<List<DriverTripModel>>(
      path: DriverHomeEndpoints.pendingTrips,
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
  Future<ApiResult<List<DriverTripModel>>> getCompletedTrips({int page = 1, int limit = 20}) async {
    return get<List<DriverTripModel>>(
      path: DriverHomeEndpoints.completedTrips,
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
}
