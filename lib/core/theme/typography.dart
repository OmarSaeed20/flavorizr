// lib/core/theme/typography.dart
import 'package:flutter/material.dart';

/// App typography configuration.
///
/// Defines the font family and text styles used throughout the app.
/// Follows Material 3 type scale with customizations.
class AppTypography {
  AppTypography._();

  /// Default font family for the app.
  static const String fontFamily = 'Roboto';

  /// Font family for display text (headlines, titles).
  static const String displayFontFamily = 'Roboto';

  /// Font family for body text.
  static const String bodyFontFamily = 'Roboto';

  /// Font family for monospace text (code).
  static const String monoFontFamily = 'Roboto Mono';

  /// Creates the base text theme.
  static TextTheme createTextTheme({
    Color? displayColor,
    Color? bodyColor,
    double scaleFactor = 1.0,
  }) => TextTheme(
    // Display styles - largest text
    displayLarge: TextStyle(
      fontSize: 57 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      fontFamily: displayFontFamily,
      color: displayColor,
    ),
    displayMedium: TextStyle(
      fontSize: 45 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      fontFamily: displayFontFamily,
      color: displayColor,
    ),
    displaySmall: TextStyle(
      fontSize: 36 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      fontFamily: displayFontFamily,
      color: displayColor,
    ),

    // Headline styles - section headers
    headlineLarge: TextStyle(
      fontSize: 32 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
      fontFamily: displayFontFamily,
      color: displayColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 28 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
      fontFamily: displayFontFamily,
      color: displayColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 24 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
      fontFamily: displayFontFamily,
      color: displayColor,
    ),

    // Title styles - component titles
    titleLarge: TextStyle(
      fontSize: 22 * scaleFactor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
      fontFamily: bodyFontFamily,
      color: displayColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
      fontFamily: bodyFontFamily,
      color: displayColor,
    ),
    titleSmall: TextStyle(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      fontFamily: bodyFontFamily,
      color: displayColor,
    ),

    // Label styles - buttons, tabs, navigation
    labelLarge: TextStyle(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      fontFamily: bodyFontFamily,
      color: bodyColor,
    ),
    labelMedium: TextStyle(
      fontSize: 12 * scaleFactor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      fontFamily: bodyFontFamily,
      color: bodyColor,
    ),
    labelSmall: TextStyle(
      fontSize: 11 * scaleFactor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      fontFamily: bodyFontFamily,
      color: bodyColor,
    ),

    // Body styles - main content
    bodyLarge: TextStyle(
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
      fontFamily: bodyFontFamily,
      color: bodyColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      fontFamily: bodyFontFamily,
      color: bodyColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12 * scaleFactor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      fontFamily: bodyFontFamily,
      color: bodyColor,
    ),
  );

  /// Custom text styles for specific use cases.
  static TextStyle caption({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 10 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.2,
    fontFamily: bodyFontFamily,
    color: color,
  );

  static TextStyle overline({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 10 * scaleFactor,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.2,
    fontFamily: bodyFontFamily,
    color: color,
  );

  static TextStyle button({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 14 * scaleFactor,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
    height: 1.43,
    fontFamily: bodyFontFamily,
    color: color,
  );

  static TextStyle code({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 14 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.43,
    fontFamily: monoFontFamily,
    color: color,
  );

  static TextStyle quote({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 16 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    fontStyle: FontStyle.italic,
    fontFamily: bodyFontFamily,
    color: color,
  );

  static TextStyle link({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 14 * scaleFactor,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: bodyFontFamily,
    color: color,
    decoration: TextDecoration.underline,
  );
}
