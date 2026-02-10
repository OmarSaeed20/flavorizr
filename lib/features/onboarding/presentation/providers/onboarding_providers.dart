// lib/features/onboarding/presentation/providers/onboarding_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:fast_golden_taxi/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/usecases/is_onboarding_completed_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== Data Sources ====================

/// Provider for OnboardingLocalDataSource.
final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingLocalDataSourceImpl(prefs: prefs);
});

// ==================== Repository ====================

/// Provider for OnboardingRepository.
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final localDataSource = ref.watch(onboardingLocalDataSourceProvider);
  return OnboardingRepositoryImpl(localDataSource: localDataSource);
});

// ==================== Use Cases ====================

/// Provider for GetOnboardingPagesUseCase.
final getOnboardingPagesUseCaseProvider = Provider<GetOnboardingPagesUseCase>((ref) {
  return GetOnboardingPagesUseCase(ref.watch(onboardingRepositoryProvider));
});

/// Provider for CompleteOnboardingUseCase.
final completeOnboardingUseCaseProvider = Provider<CompleteOnboardingUseCase>((ref) {
  return CompleteOnboardingUseCase(ref.watch(onboardingRepositoryProvider));
});

/// Provider for IsOnboardingCompletedUseCase.
final isOnboardingCompletedUseCaseProvider = Provider<IsOnboardingCompletedUseCase>((ref) {
  return IsOnboardingCompletedUseCase(ref.watch(onboardingRepositoryProvider));
});

// ==================== State Providers ====================

/// Provider for checking if onboarding is completed.
final isOnboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final useCase = ref.watch(isOnboardingCompletedUseCaseProvider);
  final result = await useCase();
  return result.data ?? false;
});
