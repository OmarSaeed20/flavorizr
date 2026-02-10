// lib/features/consumer/consumer_auth/domain/usecases/consumer_register_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_register_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';

/// Use case for consumer registration.
///
/// Handles the business logic for registering a new consumer.
/// Validates input parameters and delegates to repository.
class ConsumerRegisterUseCase extends BaseUseCase<AuthResult, ConsumerRegisterParameters> {
  const ConsumerRegisterUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  @override
  Future<Either<Failure, AuthResult>> call(ConsumerRegisterParameters params) async {
    // Validate company type (should be "customer" for consumers)
    if (params.companyType != 'customer') {
      return const Left(ValidationFailure(message: 'Invalid company type for consumer'));
    }

    // Validate name
    if (params.name.isEmpty) {
      return const Left(ValidationFailure(message: 'Name is required'));
    }

    // Validate phone number
    if (params.phone.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone number is required'));
    }

    // Validate phone ISO code
    if (params.phoneIso2Code.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone ISO code is required'));
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

    // Validate country ID
    if (params.countryId <= 0) {
      return const Left(ValidationFailure(message: 'Valid country ID is required'));
    }

    // Validate governorate ID
    if (params.governorateId <= 0) {
      return const Left(ValidationFailure(message: 'Valid governorate ID is required'));
    }

    // Validate birthdate format (YYYY-MM-DD)
    final birthdateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!birthdateRegex.hasMatch(params.birthdate)) {
      return const Left(ValidationFailure(message: 'Invalid birthdate format (YYYY-MM-DD)'));
    }

    // Validate birthdate is not in the future
    try {
      final birthdate = DateTime.parse(params.birthdate);
      if (birthdate.isAfter(DateTime.now())) {
        return const Left(ValidationFailure(message: 'Birthdate cannot be in the future'));
      }
    } catch (e) {
      return const Left(ValidationFailure(message: 'Invalid birthdate'));
    }

    // Validate gender
    if (params.gender != 'male' && params.gender != 'female') {
      return const Left(ValidationFailure(message: 'Gender must be "male" or "female"'));
    }

    // Call repository
    return _repository.register(params);
  }
}
