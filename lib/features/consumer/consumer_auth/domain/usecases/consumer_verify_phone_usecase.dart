// lib/features/consumer/consumer_auth/domain/usecases/consumer_verify_phone_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';

/// Use case for consumer phone verification.
///
/// Handles the business logic for verifying consumer phone with OTP.
/// Validates input parameters and delegates to repository.
class ConsumerVerifyPhoneUseCase
    extends BaseUseCase<AuthResult, ConsumerVerifyPhoneParameters> {
  const ConsumerVerifyPhoneUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  @override
  Future<Either<Failure, AuthResult>> call(
    ConsumerVerifyPhoneParameters params,
  ) async {
    // Validate phone number
    if (params.phone.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone number is required'));
    }

    // Validate phone ISO code
    if (params.phoneIsoCode.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Phone ISO code is required'),
      );
    }

    // Validate verification code
    if (params.code.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Verification code is required'),
      );
    }

    // Validate code length (typically 4-6 digits)
    if (params.code.length < 4 || params.code.length > 6) {
      return const Left(
        ValidationFailure(message: 'Invalid verification code length'),
      );
    }

    // Validate code is numeric
    final codeRegex = RegExp(r'^\d+$');
    if (!codeRegex.hasMatch(params.code)) {
      return const Left(
        ValidationFailure(message: 'Verification code must be numeric'),
      );
    }

    // Call repository
    return _repository.verifyPhone(params);
  }
}
