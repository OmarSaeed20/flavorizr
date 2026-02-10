import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/data/datasources/driver_home_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/data/datasources/driver_home_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/data/repositories/driver_home_repository_impl.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/repositories/driver_home_repository.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/usecases/get_driver_home_data.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/presentation/controllers/driver_home_controller.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DriverHomeRemoteDataSource
final driverHomeRemoteDataSourceProvider = Provider<DriverHomeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DriverHomeRemoteDataSourceImpl(apiClient);
});

/// Provider for DriverHomeLocalDataSource
final driverHomeLocalDataSourceProvider = Provider<DriverHomeLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).value;
  return DriverHomeLocalDataSourceImpl(sharedPreferences!);
});

/// Provider for DriverHomeRepository
final driverHomeRepositoryProvider = Provider<DriverHomeRepository>((ref) {
  final remoteDataSource = ref.watch(driverHomeRemoteDataSourceProvider);
  final localDataSource = ref.watch(driverHomeLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DriverHomeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

/// Provider for GetDriverHomeData use case
final getDriverHomeDataProvider = Provider<GetDriverHomeData>((ref) {
  final repository = ref.watch(driverHomeRepositoryProvider);
  return GetDriverHomeData(repository);
});

/// Provider for DriverHomeController
final driverHomeControllerProvider = StateNotifierProvider<DriverHomeController, DriverHomeState>((
  ref,
) {
  return DriverHomeController(getDriverHomeData: ref.watch(getDriverHomeDataProvider));
});
