// lib/features/onboarding/domain/usecases/complete_onboarding_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Use case for completing onboarding.
class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Executes the use case.
  Future<Either<Failure, void>> call() {
    return _repository.completeOnboarding();
  }
}
