// lib/features/splash/presentation/controllers/splash_controller.dart
import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/splash/domain/usecases/check_app_initialization_usecase.dart';
import 'package:fast_golden_taxi/features/splash/presentation/providers/splash_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the splash screen.
class SplashState {
  const SplashState({this.isLoading = true, this.result, this.error});

  /// Whether the splash is still loading.
  final bool isLoading;

  /// The initialization result after loading completes.
  final InitializationResult? result;

  /// Error message if initialization failed.
  final String? error;

  /// Creates a copy with updated values.
  SplashState copyWith({
    bool? isLoading,
    InitializationResult? result,
    String? error,
    bool clearError = false,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for the splash screen using Riverpod 3.x Notifier.
///
/// Handles app initialization and determines navigation destination.
class SplashController extends Notifier<SplashState> {
  late final CheckAppInitializationUseCase _checkAppInitialization;

  @override
  SplashState build() {
    _checkAppInitialization = ref.watch(checkAppInitializationUseCaseProvider);
    return const SplashState();
  }

  /// Initializes the app and determines where to navigate.
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Add minimum splash display time for branding
    final minimumDelay = Future<void>.delayed(const Duration(seconds: 2));

    final result = await _checkAppInitialization();

    // Wait for minimum delay
    await minimumDelay;

    result.when(
      exception: (failure) {
        AppLogger.instance.logError(
          'Splash initialization failed',
          data: {'error': failure.message},
        );
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      success: (initResult, _) {
        AppLogger.instance.logInfo(
          'Splash initialization complete',
          data: {'result': initResult.name},
        );
        state = state.copyWith(isLoading: false, result: initResult);
      },
    );
  }
}

/// Provider for SplashController.
final splashControllerProvider = NotifierProvider<SplashController, SplashState>(
  SplashController.new,
);
