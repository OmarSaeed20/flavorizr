import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/driver/driver_home/data/datasources/driver_home_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_home/data/repositories/driver_home_repository_impl.dart';
import 'package:flavorizr/features/driver/driver_home/domain/repositories/driver_home_repository.dart';
import 'package:flavorizr/features/driver/driver_home/domain/usecases/get_driver_earnings.dart';
import 'package:flavorizr/features/driver/driver_home/domain/usecases/get_driver_home_data.dart';
import 'package:flavorizr/features/driver/driver_home/domain/usecases/get_driver_stats.dart';
import 'package:flavorizr/features/driver/driver_home/domain/usecases/get_driver_trip_by_id.dart';
import 'package:flavorizr/features/driver/driver_home/domain/usecases/get_driver_trips.dart';
import 'package:flavorizr/features/driver/driver_home/domain/usecases/update_availability_status.dart';
import 'package:flavorizr/features/driver/driver_home/domain/usecases/update_online_status.dart';
import 'package:flavorizr/features/driver/driver_home/presentation/controllers/driver_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DriverHomeRemoteDataSource
final driverHomeRemoteDataSourceProvider = Provider<DriverHomeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DriverHomeRemoteDataSourceImpl(apiClient);
});

/// Provider for DriverHomeRepository
final driverHomeRepositoryProvider = Provider<DriverHomeRepository>((ref) {
  final remoteDataSource = ref.watch(driverHomeRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DriverHomeRepositoryImpl(remoteDataSource: remoteDataSource, networkInfo: networkInfo);
});

/// Provider for GetDriverHomeData use case
final getDriverHomeDataProvider = Provider<GetDriverHomeData>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return GetDriverHomeData(repository);
});

/// Provider for GetDriverEarnings use case
final getDriverEarningsProvider = Provider<GetDriverEarnings>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return GetDriverEarnings(repository);
});

/// Provider for GetDriverStats use case
final getDriverStatsProvider = Provider<GetDriverStats>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return GetDriverStats(repository);
});

/// Provider for GetDriverTrips use case
final getDriverTripsProvider = Provider<GetDriverTrips>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return GetDriverTrips(repository);
});

/// Provider for GetDriverTripById use case
final getDriverTripByIdProvider = Provider<GetDriverTripById>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return GetDriverTripById(repository);
});

/// Provider for UpdateOnlineStatus use case
final updateOnlineStatusProvider = Provider<UpdateOnlineStatus>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return UpdateOnlineStatus(repository);
});

/// Provider for UpdateAvailabilityStatus use case
final updateAvailabilityStatusProvider = Provider<UpdateAvailabilityStatus>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return UpdateAvailabilityStatus(repository);
});

/// Provider for DriverHomeController
final driverHomeControllerProvider = StateNotifierProvider<DriverHomeController, DriverHomeState>((
  ref,
) {
  return DriverHomeController(
    getDriverHomeData: ref.watch(getDriverHomeDataProvider),
    getDriverEarnings: ref.watch(getDriverEarningsProvider),
    getDriverStats: ref.watch(getDriverStatsProvider),
    getDriverTrips: ref.watch(getDriverTripsProvider),
    getDriverTripById: ref.watch(getDriverTripByIdProvider),
    updateOnlineStatus: ref.watch(updateOnlineStatusProvider),
    updateAvailabilityStatus: ref.watch(updateAvailabilityStatusProvider),
  );
});
