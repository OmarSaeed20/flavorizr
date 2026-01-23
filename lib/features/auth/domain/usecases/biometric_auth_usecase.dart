// lib/features/auth/domain/usecases/biometric_auth_usecase.dart
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for checking if biometric authentication is available.
class CheckBiometricAvailabilityUseCase implements UseCase<bool, NoParams> {
  CheckBiometricAvailabilityUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<bool> call(NoParams params) async {
    try {
      final isAvailable = await _repository.isBiometricAvailable();
      return Result.success(isAvailable);
    } catch (e) {
      return Result.failure(
        UnexpectedFailure(message: 'Failed to check biometric availability', exception: e),
      );
    }
  }
}

/// Use case for enabling biometric authentication.
class EnableBiometricUseCase implements UseCase<void, NoParams> {
  EnableBiometricUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(NoParams params) async {
    // Check if biometric is available first
    final isAvailable = await _repository.isBiometricAvailable();
    if (!isAvailable) {
      return Result.failure(
        const UnsupportedFailure(
          message: 'Biometric authentication is not available on this device',
          code: 'BIOMETRIC_NOT_AVAILABLE',
        ),
      );
    }

    return _repository.enableBiometric();
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
      return Result.failure(
        const UnsupportedFailure(
          message: 'Biometric authentication is not available on this device',
          code: 'BIOMETRIC_NOT_AVAILABLE',
        ),
      );
    }

    // Check if biometric is enabled
    final isEnabled = await _repository.isBiometricEnabled();
    if (!isEnabled) {
      return Result.failure(
        const UnauthenticatedFailure(
          message: 'Biometric authentication is not enabled. Please enable it first.',
          code: 'BIOMETRIC_NOT_ENABLED',
        ),
      );
    }

    return _repository.signInWithBiometric();
  }
}
