// lib/features/consumer/consumer_auth/domain/usecases/consumer_forget_password_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';

/// Use case for consumer forget password.
///
/// Handles the business logic for requesting password reset code.
/// Validates input parameters and delegates to repository.
class ConsumerForgetPasswordUseCase
    extends BaseUseCase<void, ConsumerForgetPasswordParameters> {
  const ConsumerForgetPasswordUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(
    ConsumerForgetPasswordParameters params,
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

    // Call repository
    return _repository.forgetPassword(params);
  }
}
