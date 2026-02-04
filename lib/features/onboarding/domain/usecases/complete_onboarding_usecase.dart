// lib/features/onboarding/domain/usecases/complete_onboarding_usecase.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Use case for completing onboarding.
class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Executes the use case.
  Future<ApiResult<void>> call() {
    return _repository.completeOnboarding();
  }
}
