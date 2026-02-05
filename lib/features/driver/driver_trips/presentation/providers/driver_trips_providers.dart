import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/driver/driver_trips/data/datasources/driver_trips_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_trips/data/repositories/driver_trips_repository_impl.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/repositories/driver_trips_repository.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/accept_trip.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/cancel_trip.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/complete_trip.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/get_driver_trip_by_id.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/get_driver_trips.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/get_pending_trips.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/reject_trip.dart';
import 'package:flavorizr/features/driver/driver_trips/domain/usecases/start_trip.dart';
import 'package:flavorizr/features/driver/driver_trips/presentation/controllers/driver_trips_controller.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DriverTripsRemoteDataSource
final driverTripsRemoteDataSourceProvider =
    Provider<DriverTripsRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return DriverTripsRemoteDataSourceImpl(apiClient);
    });

/// Provider for DriverTripsRepository
final driverTripsRepositoryProvider = Provider<DriverTripsRepository>((ref) {
  final remoteDataSource = ref.watch(driverTripsRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final localDataSource = ref.watch(driverTripsLocalDataSourceProvider);
  return DriverTripsRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

/// Provider for GetDriverTrips use case
final getDriverTripsProvider = Provider<GetDriverTrips>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return GetDriverTrips(repository);
});

/// Provider for GetDriverTripById use case
final getDriverTripByIdProvider = Provider<GetDriverTripById>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return GetDriverTripById(repository);
});

/// Provider for GetPendingTrips use case
final getPendingTripsProvider = Provider<GetPendingTrips>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return GetPendingTrips(repository);
});

/// Provider for AcceptTrip use case
final acceptTripProvider = Provider<AcceptTrip>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return AcceptTrip(repository);
});

/// Provider for RejectTrip use case
final rejectTripProvider = Provider<RejectTrip>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return RejectTrip(repository);
});

/// Provider for StartTrip use case
final startTripProvider = Provider<StartTrip>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return StartTrip(repository);
});

/// Provider for CompleteTrip use case
final completeTripProvider = Provider<CompleteTrip>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return CompleteTrip(repository);
});

/// Provider for CancelTrip use case
final cancelTripProvider = Provider<CancelTrip>((ref) {
  final repository = ref.watch(driverTripsRepositoryProvider);
  return CancelTrip(repository);
});

/// Provider for DriverTripsController
final driverTripsControllerProvider =
    StateNotifierProvider<DriverTripsController, DriverTripsState>((ref) {
      return DriverTripsController(
        getDriverTrips: ref.watch(getDriverTripsProvider),
        getDriverTripById: ref.watch(getDriverTripByIdProvider),
        getPendingTrips: ref.watch(getPendingTripsProvider),
        acceptTrip: ref.watch(acceptTripProvider),
        rejectTrip: ref.watch(rejectTripProvider),
        startTrip: ref.watch(startTripProvider),
        completeTrip: ref.watch(completeTripProvider),
        cancelTrip: ref.watch(cancelTripProvider),
      );
    });
