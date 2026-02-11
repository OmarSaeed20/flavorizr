// lib/features/language_selection/domain/repositories/language_selection_repository.dart

/// Contract for language selection persistence.
abstract class LanguageSelectionRepository {
  /// Returns `true` if the user has already selected a language.
  Future<bool> isLanguageSelected();

  /// Persists the selected locale code (e.g. 'ar', 'en').
  Future<void> setLanguage(String localeCode);

  /// Returns the currently selected locale code, or `null` if not set.
  Future<String?> getSelectedLanguage();
}
