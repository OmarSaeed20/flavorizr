// lib/features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:flavorizr/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Use case for getting onboarding pages.
class GetOnboardingPagesUseCase {
  const GetOnboardingPagesUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Executes the use case.
  Future<ApiResult<List<OnboardingPage>>> call() {
    return _repository.getOnboardingPages();
  }
}
