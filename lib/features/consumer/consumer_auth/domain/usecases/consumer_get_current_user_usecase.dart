// lib/features/consumer/consumer_auth/domain/usecases/consumer_get_current_user_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/shared/usecases/base_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Use case for getting current consumer user.
///
/// Handles the business logic for retrieving current consumer profile.
/// Returns cached user data if available, otherwise fetches from remote.
class ConsumerGetCurrentUserUseCase extends BaseUseCase<UserModel, void> {
  const ConsumerGetCurrentUserUseCase(this._repository);

  final ConsumerAuthRepository _repository;

  @override
  Future<Either<Failure, UserModel>> call(void params) async {
    // Call repository
    return _repository.getCurrentUser();
  }
}
