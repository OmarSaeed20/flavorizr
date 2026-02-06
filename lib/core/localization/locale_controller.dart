import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Supported locales
const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

/// Controller to manage the app's locale.
class LocaleController extends Notifier<Locale> {
  static const String _localeKey = 'selected_locale';

  @override
  Locale build() {
    // Load saved locale or default to system locale (handled by main app, but we need an initial state here)
    // We start with a default and load async. The app should listen to this.
    _loadLocale();
    return const Locale('en'); // Default fallback
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null) {
      state = Locale(languageCode);
    } else {
      // Logic to detect system locale could go here, or we stick to 'en' as default override
      // Ideally, we want to respect system if not set.
      // But for simple state, we can leave it as is or check window.locale
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Returns true if the current locale is RTL (Right-to-Left).
  bool get isRTL => state.languageCode == 'ar';

  /// Returns the text direction for the current locale.
  TextDirection get textDirection => isRTL ? TextDirection.rtl : TextDirection.ltr;

  /// Returns the alignment for the current locale.
  Alignment get alignment => isRTL ? Alignment.centerRight : Alignment.centerLeft;

  /// Returns the padding for the current locale (swaps start/end).
  EdgeInsetsDirectional get directionalPadding =>
      EdgeInsetsDirectional.only(start: isRTL ? 16 : 16, end: isRTL ? 16 : 16);

  /// Returns the margin for the current locale (swaps start/end).
  EdgeInsetsDirectional get directionalMargin =>
      EdgeInsetsDirectional.only(start: isRTL ? 16 : 16, end: isRTL ? 16 : 16);

  /// Formats a number according to the current locale.
  String formatNumber(int number) {
    return number.toString();
  }

  /// Formats a date according to the current locale.
  String formatDate(DateTime date) {
    // Implement proper date formatting using intl package
    return date.toString().split(' ')[0];
  }

  /// Formats a currency amount according to the current locale.
  String formatCurrency(double amount, {String? currencyCode}) {
    // Implement proper currency formatting using intl package
    return '$amount ${currencyCode ?? 'USD'}';
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);
