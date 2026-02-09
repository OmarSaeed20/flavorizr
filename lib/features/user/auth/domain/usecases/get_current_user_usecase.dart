// lib/features/auth/domain/usecases/get_current_user_usecase.dart
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/user.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

/// Use case for getting the currently authenticated user.
///
/// Returns null if no user is logged in.
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  GetCurrentUserUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<User?> call(NoParams params) async {
    return _repository.getCurrentUser();
  }
}

/// Stream-based use case for observing authentication state changes.
class ObserveAuthStateUseCase extends StreamUseCase<User?, NoParams> {
  ObserveAuthStateUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseStreamResult<User?> call(NoParams params) {
    return _repository.authStateChanges.map((user) {
      return ApiResult.success(user);
    });
  }
}
