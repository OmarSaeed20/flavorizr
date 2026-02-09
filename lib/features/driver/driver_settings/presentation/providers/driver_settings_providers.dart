import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/datasources/driver_settings_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/datasources/driver_settings_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/repositories/driver_settings_repository_impl.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/repositories/driver_settings_repository.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/usecases/get_driver_settings_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/usecases/toggle_availability_status_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/usecases/toggle_online_status_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/usecases/update_driver_settings_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/presentation/controllers/driver_settings_controller.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DriverSettingsRemoteDataSource.
final driverSettingsRemoteDataSourceProvider = Provider<DriverSettingsRemoteDataSource>((ref) {
  return DriverSettingsRemoteDataSourceImpl(ref.watch(apiClientProvider));
});
final driverSettingsLocalDataSourceProvider = Provider<DriverSettingsLocalDataSource>((ref) {
  return DriverSettingsLocalDataSourceImpl(ref.watch(sharedPreferencesProvider));
});

/// Provider for DriverSettingsRepository.
final driverSettingsRepositoryProvider = Provider<DriverSettingsRepository>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final remoteDataSource = ref.watch(driverSettingsRemoteDataSourceProvider);
  final localDataSource = ref.watch(driverSettingsLocalDataSourceProvider);
  return DriverSettingsRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

/// Provider for GetDriverSettingsUseCase.
final getDriverSettingsUseCaseProvider = Provider<GetDriverSettingsUseCase>((ref) {
  return GetDriverSettingsUseCase(ref.watch(driverSettingsRepositoryProvider));
});

/// Provider for UpdateDriverSettingsUseCase.
final updateDriverSettingsUseCaseProvider = Provider<UpdateDriverSettingsUseCase>((ref) {
  return UpdateDriverSettingsUseCase(ref.watch(driverSettingsRepositoryProvider));
});

/// Provider for ToggleOnlineStatusUseCase.
final toggleOnlineStatusUseCaseProvider = Provider<ToggleOnlineStatusUseCase>((ref) {
  return ToggleOnlineStatusUseCase(ref.watch(driverSettingsRepositoryProvider));
});

/// Provider for ToggleAvailabilityStatusUseCase.
final toggleAvailabilityStatusUseCaseProvider = Provider<ToggleAvailabilityStatusUseCase>((ref) {
  return ToggleAvailabilityStatusUseCase(ref.watch(driverSettingsRepositoryProvider));
});

/// Provider for DriverSettingsController.
final driverSettingsControllerProvider =
    StateNotifierProvider<DriverSettingsController, DriverSettingsState>((ref) {
      return DriverSettingsController(
        ref.watch(getDriverSettingsUseCaseProvider),
        ref.watch(updateDriverSettingsUseCaseProvider),
        ref.watch(toggleOnlineStatusUseCaseProvider),
        ref.watch(toggleAvailabilityStatusUseCaseProvider),
      );
    });
