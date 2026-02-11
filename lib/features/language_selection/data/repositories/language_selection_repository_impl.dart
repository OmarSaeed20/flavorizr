// lib/features/language_selection/data/repositories/language_selection_repository_impl.dart
import 'package:fast_golden_taxi/features/language_selection/data/datasources/language_selection_local_datasource.dart';
import 'package:fast_golden_taxi/features/language_selection/domain/repositories/language_selection_repository.dart';

/// Concrete implementation of [LanguageSelectionRepository].
class LanguageSelectionRepositoryImpl implements LanguageSelectionRepository {
  const LanguageSelectionRepositoryImpl(this._localDataSource);
  final LanguageSelectionLocalDataSource _localDataSource;

  @override
  Future<bool> isLanguageSelected() async {
    return _localDataSource.isLanguageSelected();
  }

  @override
  Future<void> setLanguage(String localeCode) async {
    await _localDataSource.setLanguage(localeCode);
  }

  @override
  Future<String?> getSelectedLanguage() async {
    return _localDataSource.getSelectedLocale();
  }
}
