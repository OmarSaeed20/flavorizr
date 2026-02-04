import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_trips/data/datasources/driver_trips_remote_datasource.dart';
import 'package:flavorizr/features/driver_trips/data/parameters/cancel_trip_parameters.dart';
import 'package:flavorizr/features/driver_trips/data/parameters/complete_trip_parameters.dart';
import 'package:flavorizr/features/driver_trips/data/parameters/get_driver_trips_parameters.dart';
import 'package:flavorizr/features/driver_trips/data/parameters/reject_trip_parameters.dart';
import 'package:flavorizr/features/driver_trips/data/parameters/update_trip_location_parameters.dart';
import 'package:flavorizr/features/driver_trips/domain/entities/driver_trip.dart';
import 'package:flavorizr/features/driver_trips/domain/repositories/driver_trips_repository.dart';

/// Implementation of driver trips repository
class DriverTripsRepositoryImpl extends BaseRepository implements DriverTripsRepository {
  final DriverTripsRemoteDataSource remoteDataSource;

  DriverTripsRepositoryImpl({required this.remoteDataSource, required NetworkInfo networkInfo})
    : _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;
  @override
  Future<List<DriverTrip>> getDriverTrips({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final parameters = GetDriverTripsParameters(
      page: page,
      limit: limit,
      status: status,
      startDate: startDate?.toIso8601String(),
      endDate: endDate?.toIso8601String(),
    );
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.getDriverTrips(parameters),
    );
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<DriverTrip> getDriverTripById(String tripId) async {
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.getDriverTripById(tripId),
    );
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<List<DriverTrip>> getPendingTrips() async {
    final result = await executeRemoteRequest(request: remoteDataSource.getPendingTrips);
    return result.when(
      success: (data, _) => data.map((model) => model).toList(),
      exception: (error) => throw error,
    );
  }

  @override
  Future<DriverTrip> acceptTrip(String tripId) async {
    final result = await executeRemoteRequest(request: () => remoteDataSource.acceptTrip(tripId));
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<bool> rejectTrip(String tripId, String? reason) async {
    final parameters = RejectTripParameters(tripId: tripId, reason: reason);
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.rejectTrip(parameters),
    );
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<DriverTrip> startTrip(String tripId) async {
    final result = await executeRemoteRequest(request: () => remoteDataSource.startTrip(tripId));
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<DriverTrip> completeTrip(String tripId, double actualFare) async {
    final parameters = CompleteTripParameters(tripId: tripId, actualFare: actualFare);
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.completeTrip(parameters),
    );
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<bool> cancelTrip(String tripId, String reason) async {
    final parameters = CancelTripParameters(tripId: tripId, reason: reason);
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.cancelTrip(parameters),
    );
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<bool> updateTripLocation(String tripId, double latitude, double longitude) async {
    final parameters = UpdateTripLocationParameters(
      tripId: tripId,
      latitude: latitude,
      longitude: longitude,
    );
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.updateTripLocation(parameters),
    );
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }

  @override
  Future<Map<String, dynamic>> getTripStats() async {
    final result = await executeRemoteRequest(request: remoteDataSource.getTripStats);
    return result.when(success: (data, _) => data, exception: (error) => throw error);
  }
}
