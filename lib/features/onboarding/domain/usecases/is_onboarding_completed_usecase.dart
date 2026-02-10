// lib/features/onboarding/domain/usecases/is_onboarding_completed_usecase.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Use case for checking if onboarding is completed.
class IsOnboardingCompletedUseCase {
  const IsOnboardingCompletedUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Executes the use case.
  Future<ApiResult<bool>> call() {
    return _repository.isOnboardingCompleted();
  }
}
