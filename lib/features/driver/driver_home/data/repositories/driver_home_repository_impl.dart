import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_home/data/datasources/driver_home_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_home/data/parameters/get_driver_trips_parameters.dart';
import 'package:flavorizr/features/driver/driver_home/data/parameters/update_availability_status_parameters.dart';
import 'package:flavorizr/features/driver/driver_home/data/parameters/update_online_status_parameters.dart';
import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_earnings.dart';
import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_home_data.dart';
import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_stats.dart';
import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_trip.dart';
import 'package:flavorizr/features/driver/driver_home/domain/repositories/driver_home_repository.dart';

/// Implementation of driver home repository.
///
/// Extends BaseRepository for consistent error handling and network checks.
class DriverHomeRepositoryImpl extends BaseRepository implements DriverHomeRepository {
  final DriverHomeRemoteDataSource remoteDataSource;

  DriverHomeRepositoryImpl({required this.remoteDataSource, required NetworkInfo networkInfo})
    : _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<DriverHomeData> getDriverHomeData() async {
    final result = await executeRemoteRequest(request: remoteDataSource.getDriverHomeData);
    return result.when(success: (data) => data, exception: (error) => error);
  }

  @override
  Future<DriverEarnings> getDriverEarnings() async {
    final result = await executeRemoteRequest(request: remoteDataSource.getDriverEarnings);
    return result.when(success: (data) => data, exception: (error) => error);
  }

  @override
  Future<DriverStats> getDriverStats() async {
    final result = await executeRemoteRequest(request: remoteDataSource.getDriverStats);
    return result.when(success: (data) => data, exception: (error) => error);
  }

  @override
  Future<List<DriverTrip>> getDriverTrips({int page = 1, int limit = 10, String? status}) async {
    final parameters = GetDriverTripsParameters(page: page, limit: limit, status: status);
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.getDriverTrips(parameters),
    );
    return result.when(success: (data) => data, exception: (error) => error);
  }

  @override
  Future<DriverTrip> getDriverTripById(String tripId) async {
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.getDriverTripById(tripId),
    );
    return result.when(success: (data) => data, exception: (error) => error);
  }

  @override
  Future<bool> updateOnlineStatus(bool isOnline) async {
    final parameters = UpdateOnlineStatusParameters(isOnline: isOnline);
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.updateOnlineStatus(parameters),
    );
    return result.when(success: (data) => data, exception: (error) => error);
  }

  @override
  Future<bool> updateAvailabilityStatus(bool isAvailable) async {
    final parameters = UpdateAvailabilityStatusParameters(isAvailable: isAvailable);
    final result = await executeRemoteRequest(
      request: () => remoteDataSource.updateAvailabilityStatus(parameters),
    );
    return result.when(success: (data) => data, exception: (error) => error);
  }
}
