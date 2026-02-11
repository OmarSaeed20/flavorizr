// lib/features/language_selection/domain/usecases/get_selected_language_usecase.dart
import 'package:fast_golden_taxi/features/language_selection/domain/repositories/language_selection_repository.dart';

/// Retrieves the previously selected locale code.
class GetSelectedLanguageUseCase {
  const GetSelectedLanguageUseCase(this._repository);
  final LanguageSelectionRepository _repository;

  Future<String?> call() => _repository.getSelectedLanguage();
}
