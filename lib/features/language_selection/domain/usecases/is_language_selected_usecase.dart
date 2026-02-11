// lib/features/language_selection/domain/usecases/is_language_selected_usecase.dart
import 'package:fast_golden_taxi/features/language_selection/domain/repositories/language_selection_repository.dart';

/// Checks whether the user has already selected a language.
class IsLanguageSelectedUseCase {
  const IsLanguageSelectedUseCase(this._repository);
  final LanguageSelectionRepository _repository;

  Future<bool> call() => _repository.isLanguageSelected();
}
