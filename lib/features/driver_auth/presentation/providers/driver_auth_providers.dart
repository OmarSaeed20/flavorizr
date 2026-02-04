import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/driver_auth/data/datasources/driver_auth_remote_datasource.dart';
import 'package:flavorizr/features/driver_auth/data/repositories/driver_auth_repository_impl.dart';
import 'package:flavorizr/features/driver_auth/domain/repositories/driver_auth_repository.dart';
import 'package:flavorizr/features/driver_auth/domain/usecases/driver_login_usecase.dart';
import 'package:flavorizr/features/driver_auth/domain/usecases/driver_logout_usecase.dart';
import 'package:flavorizr/features/driver_auth/domain/usecases/driver_register_usecase.dart';
import 'package:flavorizr/features/driver_auth/domain/usecases/reset_driver_password_usecase.dart';
import 'package:flavorizr/features/driver_auth/domain/usecases/verify_driver_phone_usecase.dart';
import 'package:flavorizr/features/driver_auth/presentation/controllers/driver_auth_controller.dart';

/// Provider for DriverAuthRemoteDataSource.
final driverAuthRemoteDataSourceProvider = Provider<DriverAuthRemoteDataSource>((ref) {
  return DriverAuthRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Provider for DriverAuthRepository.
final driverAuthRepositoryProvider = Provider<DriverAuthRepository>((ref) {
  final remoteDataSource = ref.watch(driverAuthRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DriverAuthRepositoryImpl(remoteDataSource: remoteDataSource, networkInfo: networkInfo);
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
