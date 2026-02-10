// lib/features/auth/domain/usecases/biometric_auth_usecase.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/save_biometric_credentials_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

/// Use case for checking if biometric authentication is available.
class CheckBiometricAvailabilityUseCase implements UseCase<bool, NoParams> {
  CheckBiometricAvailabilityUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<bool> call(NoParams params) async {
    try {
      final isAvailable = await _repository.isBiometricAvailable();
      return ApiResult.success(isAvailable);
    } catch (e) {
      return ApiResult.exception(
        UnknownNetworkException(
          message: 'Failed to check biometric availability',
          exception: e,
        ),
      );
    }
  }
}

/// Use case for enabling biometric authentication.
class EnableBiometricUseCase
    implements UseCase<void, SaveBiometricCredentialsParameters> {
  EnableBiometricUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(SaveBiometricCredentialsParameters params) async {
    // Check if biometric is available first
    final isAvailable = await _repository.isBiometricAvailable();
    if (!isAvailable) {
      return const ApiResult.exception(
        BadRequestException(
          message: 'Biometric authentication is not available on this device',
        ),
      );
    }

    return _repository.enableBiometric(params);
  }
}

/// Use case for disabling biometric authentication.
class DisableBiometricUseCase implements UseCase<void, NoParams> {
  DisableBiometricUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(NoParams params) async {
    return _repository.disableBiometric();
  }
}

/// Use case for signing in with biometrics.
class BiometricSignInUseCase implements UseCase<AuthResult, NoParams> {
  BiometricSignInUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<AuthResult> call(NoParams params) async {
    // Check if biometric is available
    final isAvailable = await _repository.isBiometricAvailable();
    if (!isAvailable) {
      return const ApiResult.exception(
        BadRequestException(
          message: 'Biometric authentication is not available on this device',
        ),
      );
    }

    // Check if biometric is enabled
    final isEnabled = await _repository.isBiometricEnabled();
    if (!isEnabled) {
      return const ApiResult.exception(
        UnauthorizedException(
          message:
              'Biometric authentication is not enabled. Please enable it first.',
        ),
      );
    }

    return _repository.signInWithBiometric();
  }
}
