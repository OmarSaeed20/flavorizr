// lib/features/consumer/consumer_auth/domain/usecases/consumer_biometric_auth_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';

/// Use case for consumer biometric authentication.
///
/// Handles the business logic for saving and retrieving biometric credentials.
/// Used for quick login with fingerprint or face ID.
class ConsumerBiometricAuthUseCase {
  const ConsumerBiometricAuthUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  /// Saves biometric credentials for quick login.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> saveCredentials(String phone, String password) async {
    // Validate phone number
    if (phone.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone number is required'));
    }

    // Validate password
    if (password.isEmpty) {
      return const Left(ValidationFailure(message: 'Password is required'));
    }

    // Call repository
    return _repository.saveBiometricCredentials(phone, password);
  }

  /// Gets stored biometric credentials.
  ///
  /// Returns null if no credentials are stored.
  /// Returns [Failure] on error.
  Future<Either<Failure, Map<String, String>?>> getCredentials() async {
    // Call repository
    return _repository.getBiometricCredentials();
  }

  /// Clears stored biometric credentials.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> clearCredentials() async {
    // Call repository
    return _repository.clearBiometricCredentials();
  }
}
