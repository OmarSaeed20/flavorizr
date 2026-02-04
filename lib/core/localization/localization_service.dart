// lib/core/localization/localization_service.dart
/// Localization service for managing app localization.
///
/// Provides utilities for:
/// - Language switching
/// - RTL support
/// - Number and date formatting
/// - Pluralization
library;

import 'package:flavorizr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

/// Service for localization utilities.
class LocalizationService {
  LocalizationService._();

  /// Gets the AppLocalizations instance from the given context.
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// Returns true if the current locale is RTL (Right-to-Left).
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Returns the text direction for the current locale.
  static TextDirection textDirection(BuildContext context) {
    return Directionality.of(context);
  }

  /// Returns the alignment for the current locale.
  static Alignment alignment(BuildContext context) {
    return isRTL(context) ? Alignment.centerRight : Alignment.centerLeft;
  }

  /// Returns the cross alignment for the current locale.
  static CrossAxisAlignment crossAxisAlignment(BuildContext context) {
    return isRTL(context) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  /// Returns the text align for the current locale.
  static TextAlign textAlign(BuildContext context) {
    return isRTL(context) ? TextAlign.right : TextAlign.left;
  }

  /// Formats a number according to the current locale.
  static String formatNumber(BuildContext context, int number) {
    final locale = Localizations.localeOf(context);
    return NumberFormat.decimalPattern(locale.languageCode).format(number);
  }

  /// Formats a decimal number according to the current locale.
  static String formatDecimal(BuildContext context, double number, {int decimalDigits = 2}) {
    final locale = Localizations.localeOf(context);
    return NumberFormat.decimalPatternDigits(
      locale: locale.languageCode,
      decimalDigits: decimalDigits,
    ).format(number);
  }

  /// Formats a percentage according to the current locale.
  static String formatPercent(BuildContext context, double value, {int decimalDigits = 0}) {
    final locale = Localizations.localeOf(context);
    return NumberFormat.decimalPatternDigits(
      locale: locale.languageCode,
      decimalDigits: decimalDigits,
    ).format(value);
  }

  /// Formats a date according to the current locale.
  static String formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMd(locale.languageCode).format(date);
  }

  /// Formats a date with time according to the current locale.
  static String formatDateTime(BuildContext context, DateTime dateTime) {
    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMd(locale.languageCode).add_jm().format(dateTime);
  }

  /// Formats a time according to the current locale.
  static String formatTime(BuildContext context, DateTime time) {
    final locale = Localizations.localeOf(context);
    return DateFormat.jm(locale.languageCode).format(time);
  }

  /// Formats a relative date (e.g., "2 hours ago").
  static String formatRelativeDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return LocalizationService.of(context).justNow;
        }
        return LocalizationService.of(context).minutesAgo(difference.inMinutes);
      }
      return LocalizationService.of(context).hoursAgo(difference.inHours);
    } else if (difference.inDays == 1) {
      return LocalizationService.of(context).yesterday;
    } else if (difference.inDays < 7) {
      return LocalizationService.of(context).daysAgo(difference.inDays);
    } else {
      return formatDate(context, date);
    }
  }

  /// Formats a currency amount according to the current locale.
  static String formatCurrency(
    BuildContext context,
    double amount, {
    String? currencyCode,
    String? symbol,
  }) {
    final locale = Localizations.localeOf(context);
    return NumberFormat.currency(
      locale: locale.languageCode,
      name: currencyCode,
      symbol: symbol,
    ).format(amount);
  }

  /// Formats a file size in human-readable format.
  static String formatFileSize(BuildContext context, int bytes) {
    if (bytes < 1024) {
      return '$bytes ${LocalizationService.of(context).bytes}';
    } else if (bytes < 1024 * 1024) {
      final kb = (bytes / 1024).toStringAsFixed(1);
      return '$kb ${LocalizationService.of(context).kb}';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
      return '$mb ${LocalizationService.of(context).mb}';
    } else {
      final gb = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(1);
      return '$gb ${LocalizationService.of(context).gb}';
    }
  }

  /// Formats a duration in human-readable format.
  static String formatDuration(BuildContext context, Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return LocalizationService.of(context).durationHoursMinutes(hours, minutes);
    } else if (minutes > 0) {
      return LocalizationService.of(context).durationMinutesSeconds(minutes, seconds);
    } else {
      return LocalizationService.of(context).durationSeconds(seconds);
    }
  }

  /// Returns the plural form of a word based on count.
  static String pluralize(BuildContext context, int count, String singular, String plural) {
    return count == 1 ? singular : plural;
  }

  /// Returns a localized string with interpolation.
  static String interpolate(BuildContext context, String template, Map<String, String> values) {
    String result = template;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  /// Returns the appropriate start padding based on text direction.
  static EdgeInsetsDirectional getStartPadding(BuildContext context, double value) {
    return EdgeInsetsDirectional.only(start: value);
  }

  /// Returns the appropriate end padding based on text direction.
  static EdgeInsetsDirectional getEndPadding(BuildContext context, double value) {
    return EdgeInsetsDirectional.only(end: value);
  }

  /// Returns the appropriate start margin based on text direction.
  static EdgeInsetsDirectional getStartMargin(BuildContext context, double value) {
    return EdgeInsetsDirectional.only(start: value);
  }

  /// Returns the appropriate end margin based on text direction.
  static EdgeInsetsDirectional getEndMargin(BuildContext context, double value) {
    return EdgeInsetsDirectional.only(end: value);
  }

  /// Wraps a widget with Directionality based on the current locale.
  static Widget withDirectionality({required BuildContext context, required Widget child}) {
    return Directionality(textDirection: textDirection(context), child: child);
  }

  /// Returns the appropriate icon for RTL/LTR.
  static IconData getDirectionalIcon(BuildContext context, IconData ltrIcon, IconData rtlIcon) {
    return isRTL(context) ? rtlIcon : ltrIcon;
  }

  /// Flips an icon horizontally for RTL.
  static Transform flipIconForRTL({required BuildContext context, required Widget child}) {
    if (!isRTL(context)) return Transform(transform: Matrix4.identity(), child: child);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.14159),
      child: child,
    );
  }
}

/// Extension methods for BuildContext to access localization utilities.
extension LocalizationContextExtensions on BuildContext {
  /// Gets the AppLocalizations instance.
  AppLocalizations get l10n => LocalizationService.of(this);

  /// Returns true if the current locale is RTL.
  bool get isRTL => LocalizationService.isRTL(this);

  /// Returns the text direction for the current locale.
  TextDirection get textDirection => LocalizationService.textDirection(this);

  /// Returns the alignment for the current locale.
  Alignment get localeAlignment => LocalizationService.alignment(this);

  /// Returns the cross alignment for the current locale.
  CrossAxisAlignment get localeCrossAxisAlignment => LocalizationService.crossAxisAlignment(this);

  /// Returns the text align for the current locale.
  TextAlign get localeTextAlign => LocalizationService.textAlign(this);

  /// Formats a number according to the current locale.
  String formatNumber(int number) => LocalizationService.formatNumber(this, number);

  /// Formats a decimal number according to the current locale.
  String formatDecimal(double number, {int decimalDigits = 2}) =>
      LocalizationService.formatDecimal(this, number, decimalDigits: decimalDigits);

  /// Formats a percentage according to the current locale.
  String formatPercent(double value, {int decimalDigits = 0}) =>
      LocalizationService.formatPercent(this, value, decimalDigits: decimalDigits);

  /// Formats a date according to the current locale.
  String formatDate(DateTime date) => LocalizationService.formatDate(this, date);

  /// Formats a date with time according to the current locale.
  String formatDateTime(DateTime dateTime) => LocalizationService.formatDateTime(this, dateTime);

  /// Formats a time according to the current locale.
  String formatTime(DateTime time) => LocalizationService.formatTime(this, time);

  /// Formats a relative date.
  String formatRelativeDate(DateTime date) => LocalizationService.formatRelativeDate(this, date);

  /// Formats a currency amount according to the current locale.
  String formatCurrency(double amount, {String? currencyCode, String? symbol}) =>
      LocalizationService.formatCurrency(this, amount, currencyCode: currencyCode, symbol: symbol);

  /// Formats a file size in human-readable format.
  String formatFileSize(int bytes) => LocalizationService.formatFileSize(this, bytes);

  /// Formats a duration in human-readable format.
  String formatDuration(Duration duration) => LocalizationService.formatDuration(this, duration);

  /// Returns the plural form of a word based on count.
  String pluralize(int count, String singular, String plural) =>
      LocalizationService.pluralize(this, count, singular, plural);

  /// Returns a localized string with interpolation.
  String interpolate(String template, Map<String, String> values) =>
      LocalizationService.interpolate(this, template, values);

  /// Returns the appropriate start padding based on text direction.
  EdgeInsetsDirectional getStartPadding(double value) =>
      LocalizationService.getStartPadding(this, value);

  /// Returns the appropriate end padding based on text direction.
  EdgeInsetsDirectional getEndPadding(double value) =>
      LocalizationService.getEndPadding(this, value);

  /// Returns the appropriate start margin based on text direction.
  EdgeInsetsDirectional getStartMargin(double value) =>
      LocalizationService.getStartMargin(this, value);

  /// Returns the appropriate end margin based on text direction.
  EdgeInsetsDirectional getEndMargin(double value) => LocalizationService.getEndMargin(this, value);

  /// Wraps a widget with Directionality based on the current locale.
  Widget withDirectionality(Widget child) =>
      LocalizationService.withDirectionality(context: this, child: child);

  /// Returns the appropriate icon for RTL/LTR.
  IconData getDirectionalIcon(IconData ltrIcon, IconData rtlIcon) =>
      LocalizationService.getDirectionalIcon(this, ltrIcon, rtlIcon);

  /// Flips an icon horizontally for RTL.
  Transform flipIconForRTL(Widget child) =>
      LocalizationService.flipIconForRTL(context: this, child: child);
}
