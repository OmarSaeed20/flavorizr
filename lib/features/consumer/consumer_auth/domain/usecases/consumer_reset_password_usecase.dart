// lib/features/consumer/consumer_auth/domain/usecases/consumer_reset_password_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';

/// Use case for consumer reset password.
///
/// Handles the business logic for resetting password with verification code.
/// Validates input parameters and delegates to repository.
class ConsumerResetPasswordUseCase extends BaseUseCase<void, ConsumerResetPasswordParameters> {
  const ConsumerResetPasswordUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(ConsumerResetPasswordParameters params) async {
    // Validate phone number
    if (params.phone.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone number is required'));
    }

    // Validate phone ISO code
    if (params.phoneIsoCode.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone ISO code is required'));
    }

    // Validate verification code
    if (params.code.isEmpty) {
      return const Left(ValidationFailure(message: 'Verification code is required'));
    }

    // Validate code length (typically 4-6 digits)
    if (params.code.length < 4 || params.code.length > 6) {
      return const Left(ValidationFailure(message: 'Invalid verification code length'));
    }

    // Validate code is numeric
    final codeRegex = RegExp(r'^\d+$');
    if (!codeRegex.hasMatch(params.code)) {
      return const Left(ValidationFailure(message: 'Verification code must be numeric'));
    }

    // Validate password
    if (params.password.isEmpty) {
      return const Left(ValidationFailure(message: 'Password is required'));
    }

    // Validate password confirmation
    if (params.passwordConfirmation.isEmpty) {
      return const Left(ValidationFailure(message: 'Password confirmation is required'));
    }

    // Validate password match
    if (params.password != params.passwordConfirmation) {
      return const Left(ValidationFailure(message: 'Passwords do not match'));
    }

    // Validate password strength (minimum 6 characters)
    if (params.password.length < 6) {
      return const Left(ValidationFailure(message: 'Password must be at least 6 characters'));
    }

    // Call repository
    return _repository.resetPassword(params);
  }
}
