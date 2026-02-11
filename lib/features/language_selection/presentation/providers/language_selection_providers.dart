// lib/features/language_selection/presentation/providers/language_selection_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/language_selection/data/datasources/language_selection_local_datasource.dart';
import 'package:fast_golden_taxi/features/language_selection/data/repositories/language_selection_repository_impl.dart';
import 'package:fast_golden_taxi/features/language_selection/domain/repositories/language_selection_repository.dart';
import 'package:fast_golden_taxi/features/language_selection/domain/usecases/get_selected_language_usecase.dart';
import 'package:fast_golden_taxi/features/language_selection/domain/usecases/is_language_selected_usecase.dart';
import 'package:fast_golden_taxi/features/language_selection/domain/usecases/set_language_usecase.dart';
import 'package:fast_golden_taxi/features/language_selection/presentation/controllers/language_selection_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────── Data Sources ───────────────────

final languageSelectionLocalDataSourceProvider = Provider<LanguageSelectionLocalDataSource>((ref) {
  return LanguageSelectionLocalDataSource(ref.watch(sharedPreferencesProvider));
});

// ─────────────────── Repository ───────────────────

final languageSelectionRepositoryProvider = Provider<LanguageSelectionRepository>((ref) {
  return LanguageSelectionRepositoryImpl(ref.watch(languageSelectionLocalDataSourceProvider));
});

// ─────────────────── Use Cases ───────────────────

final isLanguageSelectedUseCaseProvider = Provider<IsLanguageSelectedUseCase>((ref) {
  return IsLanguageSelectedUseCase(ref.watch(languageSelectionRepositoryProvider));
});

final setLanguageUseCaseProvider = Provider<SetLanguageUseCase>((ref) {
  return SetLanguageUseCase(ref.watch(languageSelectionRepositoryProvider));
});

final getSelectedLanguageUseCaseProvider = Provider<GetSelectedLanguageUseCase>((ref) {
  return GetSelectedLanguageUseCase(ref.watch(languageSelectionRepositoryProvider));
});

// ─────────────────── Controller ───────────────────

final languageSelectionControllerProvider =
    AutoDisposeNotifierProvider<LanguageSelectionController, LanguageSelectionState>(
      LanguageSelectionController.new,
    );
