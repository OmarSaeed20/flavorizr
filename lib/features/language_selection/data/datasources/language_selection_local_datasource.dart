// lib/features/language_selection/data/datasources/language_selection_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for persisting language selection state.
class LanguageSelectionLocalDataSource {
  const LanguageSelectionLocalDataSource(this._prefs);
  final SharedPreferences _prefs;

  static const String _languageSelectedKey = 'language_selected';
  static const String _selectedLocaleKey = 'selected_locale';

  /// Returns `true` if the user has previously selected a language.
  bool isLanguageSelected() => _prefs.getBool(_languageSelectedKey) ?? false;

  /// Gets the stored locale code (e.g. 'ar', 'en').
  String? getSelectedLocale() => _prefs.getString(_selectedLocaleKey);

  /// Persists the language selection flag and locale code.
  Future<void> setLanguage(String localeCode) async {
    await _prefs.setBool(_languageSelectedKey, true);
    await _prefs.setString(_selectedLocaleKey, localeCode);
  }
}
