// lib/features/language_selection/domain/usecases/set_language_usecase.dart
import 'package:fast_golden_taxi/features/language_selection/domain/repositories/language_selection_repository.dart';

/// Persists the user's language selection.
class SetLanguageUseCase {
  const SetLanguageUseCase(this._repository);
  final LanguageSelectionRepository _repository;

  Future<void> call(String localeCode) => _repository.setLanguage(localeCode);
}
