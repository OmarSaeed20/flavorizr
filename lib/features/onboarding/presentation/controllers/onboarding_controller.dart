// lib/features/onboarding/presentation/controllers/onboarding_controller.dart
import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fast_golden_taxi/features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';
import 'package:fast_golden_taxi/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the onboarding screen.
class OnboardingState {
  const OnboardingState({
    this.pages = const [],
    this.currentPageIndex = 0,
    this.isLoading = true,
    this.isCompleting = false,
    this.error,
  });

  /// List of onboarding pages.
  final List<OnboardingPage> pages;

  /// Current page index.
  final int currentPageIndex;

  /// Whether pages are being loaded.
  final bool isLoading;

  /// Whether onboarding is being completed.
  final bool isCompleting;

  /// Error message if any.
  final String? error;

  /// Whether the user is on the last page.
  bool get isLastPage => currentPageIndex == pages.length - 1;

  /// Whether the user is on the first page.
  bool get isFirstPage => currentPageIndex == 0;

  /// Current page or null if no pages.
  OnboardingPage? get currentPage =>
      pages.isNotEmpty && currentPageIndex < pages.length
      ? pages[currentPageIndex]
      : null;

  /// Progress percentage (0.0 to 1.0).
  double get progress =>
      pages.isEmpty ? 0.0 : (currentPageIndex + 1) / pages.length;

  /// Creates a copy with updated values.
  OnboardingState copyWith({
    List<OnboardingPage>? pages,
    int? currentPageIndex,
    bool? isLoading,
    bool? isCompleting,
    String? error,
    bool clearError = false,
  }) {
    return OnboardingState(
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      isCompleting: isCompleting ?? this.isCompleting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for the onboarding screen using Riverpod 3.x Notifier.
class OnboardingController extends Notifier<OnboardingState> {
  late final GetOnboardingPagesUseCase _getOnboardingPages;
  late final CompleteOnboardingUseCase _completeOnboarding;

  @override
  OnboardingState build() {
    _getOnboardingPages = ref.watch(getOnboardingPagesUseCaseProvider);
    _completeOnboarding = ref.watch(completeOnboardingUseCaseProvider);

    // Defer loading pages until after the initial state is returned
    Future.microtask(_loadPages);

    return const OnboardingState();
  }

  /// Loads the onboarding pages.
  Future<void> _loadPages() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getOnboardingPages();

    result.when(
      exception: (failure) {
        AppLogger.instance.logError(
          'Failed to load onboarding pages',
          data: {'error': failure.message},
        );
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      success: (pages, _) {
        AppLogger.instance.logInfo(
          'Loaded onboarding pages',
          data: {'count': pages.length},
        );
        state = state.copyWith(isLoading: false, pages: pages);
      },
    );
  }

  /// Reloads the onboarding pages.
  Future<void> reload() => _loadPages();

  /// Goes to the next page.
  void nextPage() {
    if (!state.isLastPage) {
      state = state.copyWith(currentPageIndex: state.currentPageIndex + 1);
    }
  }

  /// Goes to the previous page.
  void previousPage() {
    if (!state.isFirstPage) {
      state = state.copyWith(currentPageIndex: state.currentPageIndex - 1);
    }
  }

  /// Goes to a specific page.
  void goToPage(int index) {
    if (index >= 0 && index < state.pages.length) {
      state = state.copyWith(currentPageIndex: index);
    }
  }

  /// Completes the onboarding and marks it as done.
  ///
  /// Returns true if successful.
  Future<bool> completeOnboarding() async {
    state = state.copyWith(isCompleting: true, clearError: true);

    final result = await _completeOnboarding();

    return result.when(
      exception: (failure) {
        AppLogger.instance.logError(
          'Failed to complete onboarding',
          data: {'error': failure.message},
        );
        state = state.copyWith(isCompleting: false, error: failure.message);
        return false;
      },
      success: (_, __) {
        AppLogger.instance.logInfo('Onboarding completed');
        state = state.copyWith(isCompleting: false);
        return true;
      },
    );
  }

  /// Skips onboarding and marks it as done.
  Future<bool> skipOnboarding() => completeOnboarding();
}

/// Provider for OnboardingController.
final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
      OnboardingController.new,
    );
