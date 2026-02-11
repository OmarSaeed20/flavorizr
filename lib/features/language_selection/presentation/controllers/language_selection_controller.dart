// lib/features/language_selection/presentation/controllers/language_selection_controller.dart
import 'dart:ui';

import 'package:fast_golden_taxi/features/language_selection/domain/usecases/set_language_usecase.dart';
import 'package:fast_golden_taxi/features/language_selection/presentation/providers/language_selection_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Available languages in the app.
enum AppLanguage {
  arabic('ar', 'Arabic', 'العربية'),
  english('en', 'English', 'English'),
  kurdish('ku', 'Kurdish', 'کوردی');

  const AppLanguage(this.code, this.nameEn, this.nameNative);

  final String code;
  final String nameEn;
  final String nameNative;

  Locale get locale => Locale(code);
}

/// State for the language selection screen.
class LanguageSelectionState {
  const LanguageSelectionState({
    this.selectedLanguage,
    this.isLoading = false,
    this.isConfirmed = false,
    this.errorMessage,
  });

  final AppLanguage? selectedLanguage;
  final bool isLoading;
  final bool isConfirmed;
  final String? errorMessage;

  bool get canConfirm => selectedLanguage != null && !isLoading;

  LanguageSelectionState copyWith({
    AppLanguage? selectedLanguage,
    bool? isLoading,
    bool? isConfirmed,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LanguageSelectionState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// Controller for the language selection screen.
class LanguageSelectionController extends AutoDisposeNotifier<LanguageSelectionState> {
  late final SetLanguageUseCase _setLanguageUseCase;

  @override
  LanguageSelectionState build() {
    _setLanguageUseCase = ref.watch(setLanguageUseCaseProvider);
    return const LanguageSelectionState();
  }

  /// Selects a language (does not persist yet).
  void selectLanguage(AppLanguage language) {
    state = state.copyWith(selectedLanguage: language, clearError: true);
  }

  /// Confirms the selection: persists to SharedPreferences.
  Future<void> confirm() async {
    final language = state.selectedLanguage;
    if (language == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _setLanguageUseCase(language.code);
      state = state.copyWith(isLoading: false, isConfirmed: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save language selection. Please try again.',
      );
    }
  }
}
