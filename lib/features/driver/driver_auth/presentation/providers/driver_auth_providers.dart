import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/datasources/driver_auth_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/datasources/driver_auth_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/repositories/driver_auth_repository_impl.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/usecases/driver_login_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/usecases/driver_logout_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/usecases/driver_register_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/usecases/reset_driver_password_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/usecases/verify_driver_phone_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/controllers/driver_auth_controller.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DriverAuthRemoteDataSource.
final driverAuthRemoteDataSourceProvider = Provider<DriverAuthRemoteDataSource>((ref) {
  return DriverAuthRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Provider for DriverAuthLocalDataSource.
final driverAuthLocalDataSourceProvider = Provider<DriverAuthLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).value;
  return DriverAuthLocalDataSourceImpl(sharedPreferences!);
});

/// Provider for DriverAuthRepository.
final driverAuthRepositoryProvider = Provider<DriverAuthRepository>((ref) {
  final remoteDataSource = ref.watch(driverAuthRemoteDataSourceProvider);
  final localDataSource = ref.watch(driverAuthLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DriverAuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

/// Provider for DriverLoginUseCase.
final driverLoginUseCaseProvider = Provider<DriverLoginUseCase>((ref) {
  return DriverLoginUseCase(ref.watch(driverAuthRepositoryProvider));
});

/// Provider for DriverLogoutUseCase.
final driverLogoutUseCaseProvider = Provider<DriverLogoutUseCase>((ref) {
  return DriverLogoutUseCase(ref.watch(driverAuthRepositoryProvider));
});

/// Provider for DriverRegisterUseCase.
final driverRegisterUseCaseProvider = Provider<DriverRegisterUseCase>((ref) {
  return DriverRegisterUseCase(ref.watch(driverAuthRepositoryProvider));
});

/// Provider for VerifyDriverPhoneUseCase.
final verifyDriverPhoneUseCaseProvider = Provider<VerifyDriverPhoneUseCase>((ref) {
  return VerifyDriverPhoneUseCase(ref.watch(driverAuthRepositoryProvider));
});

/// Provider for ResetDriverPasswordUseCase.
final resetDriverPasswordUseCaseProvider = Provider<ResetDriverPasswordUseCase>((ref) {
  return ResetDriverPasswordUseCase(ref.watch(driverAuthRepositoryProvider));
});

/// Provider for DriverAuthController.
final driverAuthControllerProvider = StateNotifierProvider<DriverAuthController, DriverAuthState>((
  ref,
) {
  return DriverAuthController(
    ref.watch(driverLoginUseCaseProvider),
    ref.watch(driverLogoutUseCaseProvider),
    ref.watch(driverRegisterUseCaseProvider),
    ref.watch(verifyDriverPhoneUseCaseProvider),
    ref.watch(resetDriverPasswordUseCaseProvider),
  );
});
