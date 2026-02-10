// lib/features/consumer/consumer_auth/domain/usecases/consumer_login_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_login_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';

/// Use case for consumer login.
///
/// Handles the business logic for authenticating a consumer.
/// Validates input parameters and delegates to repository.
class ConsumerLoginUseCase
    extends BaseUseCase<AuthResult, ConsumerLoginParameters> {
  const ConsumerLoginUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  @override
  Future<Either<Failure, AuthResult>> call(
    ConsumerLoginParameters params,
  ) async {
    // Validate phone number
    if (params.phone.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone number is required'));
    }

    // Validate password
    if (params.password.isEmpty) {
      return const Left(ValidationFailure(message: 'Password is required'));
    }

    // Validate phone ISO code
    if (params.phoneIsoCode.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Phone ISO code is required'),
      );
    }

    // Validate Firebase token
    if (params.firebaseToken.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Firebase token is required'),
      );
    }

    // Call repository
    return _repository.login(params);
  }
}
