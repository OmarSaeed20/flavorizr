// lib/features/consumer/consumer_auth/domain/usecases/consumer_logout_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_logout_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';

/// Use case for consumer logout.
///
/// Handles the business logic for logging out a consumer.
/// Delegates to repository which clears tokens and user data.
class ConsumerLogoutUseCase
    extends BaseUseCase<void, ConsumerLogoutParameters> {
  const ConsumerLogoutUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(ConsumerLogoutParameters params) async {
    // Call repository
    return _repository.logout(params);
  }
}
