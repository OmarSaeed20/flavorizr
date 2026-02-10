// lib/core/theme/typography.dart

/// Typography configuration for Fast Golden Taxi.
///
/// **Fonts** (from Figma):
/// - **Poppins** – primary UI font (headings, buttons, labels).
/// - **Inter** – secondary font (body text, form inputs).
/// - **Roboto** – chat messages and real-time content.
/// - **Omnia Arabic ITF** – status bar / Arabic locale support.
///
/// The text theme follows Material 3 type-scale ratios with
/// Figma-accurate font weights:
///   w400 (Regular), w500 (Medium), w600 (SemiBold), w700 (Bold).
///
/// > SF Pro Text appears in the Figma file only for iOS system
/// > keyboard rendering and is **not** bundled in the app.
///
/// ## Dark-Mode Notes
///
/// Text colors are injected via [createTextTheme]'s `displayColor`
/// and `bodyColor` parameters. The [ColorScheme] drives these values:
/// - Dark: `onSurface` → `#FFFFFF` (white), `onSurfaceVariant` → `#D1D1D1`
/// - Light: `onSurface` → `#000000` (black), `onSurfaceVariant` → `#686868`
library;

import 'package:flutter/material.dart';

/// Centralised typography tokens.
///
/// ```dart
/// // Inside ThemeData:
/// textTheme: AppTypography.createTextTheme(),
/// ```
class AppTypography {
  const AppTypography._();

  // ═════════════════════════════════════════════════════════════════════════
  // FONT FAMILIES
  // ═════════════════════════════════════════════════════════════════════════

  /// Primary UI font – used for headings, buttons, navigation.
  static const String fontFamily = 'Poppins';

  /// Display / headline font family.
  static const String displayFontFamily = 'Poppins';

  /// Body / form-input font family.
  static const String bodyFontFamily = 'Inter';

  /// Monospace font for code snippets or OTP fields.
  static const String monoFontFamily = 'Roboto Mono';

  /// Chat message font (Figma: Roboto for real-time messaging).
  static const String chatFontFamily = 'Roboto';

  /// Arabic locale / status bar font (Figma: Omnia Arabic ITF).
  static const String arabicFontFamily = 'Omnia Arabic ITF';

  // ═════════════════════════════════════════════════════════════════════════
  // TEXT THEME FACTORY
  // ═════════════════════════════════════════════════════════════════════════

  /// Builds a Material 3 [TextTheme] with optional color overrides and a
  /// global [scaleFactor] for accessibility.
  ///
  /// The scale factor is clamped to `0.8 – 1.4` to prevent layout breakage.
  static TextTheme createTextTheme({
    Color? displayColor,
    Color? bodyColor,
    double scaleFactor = 1.0,
  }) {
    final s = scaleFactor.clamp(0.8, 1.4);

    return TextTheme(
      // ── Display (Poppins) ──────────────────────────────────────────────
      displayLarge: TextStyle(
        fontSize: 57 * s,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),
      displayMedium: TextStyle(
        fontSize: 45 * s,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),
      displaySmall: TextStyle(
        fontSize: 36 * s,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),

      // ── Headline (Poppins) ─────────────────────────────────────────────
      headlineLarge: TextStyle(
        fontSize: 32 * s,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28 * s,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24 * s,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.33,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),

      // ── Title (Poppins) ────────────────────────────────────────────────
      titleLarge: TextStyle(
        fontSize: 22 * s,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16 * s,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14 * s,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
        fontFamily: displayFontFamily,
        color: displayColor,
      ),

      // ── Label (Poppins – buttons, chips, tabs) ─────────────────────────
      labelLarge: TextStyle(
        fontSize: 14 * s,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        fontFamily: displayFontFamily,
        color: bodyColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12 * s,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        fontFamily: displayFontFamily,
        color: bodyColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11 * s,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        fontFamily: displayFontFamily,
        color: bodyColor,
      ),

      // ── Body (Inter – paragraphs, form inputs) ─────────────────────────
      bodyLarge: TextStyle(
        fontSize: 16 * s,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
        fontFamily: bodyFontFamily,
        color: bodyColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14 * s,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        fontFamily: bodyFontFamily,
        color: bodyColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12 * s,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        fontFamily: bodyFontFamily,
        color: bodyColor,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  // ONE-OFF STYLES (not part of Material type-scale)
  // ═════════════════════════════════════════════════════════════════════════

  /// Tiny caption – meta info, timestamps.
  static TextStyle caption({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 10 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.2,
    fontFamily: bodyFontFamily,
    color: color,
  );

  /// ALL-CAPS overline – section labels.
  static TextStyle overline({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 10 * scaleFactor,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.2,
    fontFamily: displayFontFamily,
    color: color,
  );

  /// Button text – used when a widget can't inherit from [labelLarge].
  static TextStyle button({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 14 * scaleFactor,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
    height: 1.43,
    fontFamily: displayFontFamily,
    color: color,
  );

  /// Monospaced – OTP fields, code snippets.
  static TextStyle code({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 14 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.43,
    fontFamily: monoFontFamily,
    color: color,
  );

  /// Italic quote style.
  static TextStyle quote({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 16 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    fontStyle: FontStyle.italic,
    fontFamily: bodyFontFamily,
    color: color,
  );

  /// Underlined link style.
  static TextStyle link({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 14 * scaleFactor,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: bodyFontFamily,
    color: color,
    decoration: TextDecoration.underline,
  );

  /// Chat message text style (Roboto – used in messaging bubbles).
  ///
  /// Figma: 14px Roboto Regular with 1.43 line height.
  static TextStyle chat({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 14 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: chatFontFamily,
    color: color,
  );

  /// Chat timestamp text style.
  static TextStyle chatTimestamp({Color? color, double scaleFactor = 1.0}) => TextStyle(
    fontSize: 10 * scaleFactor,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.2,
    fontFamily: chatFontFamily,
    color: color,
  );
}
