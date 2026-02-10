// lib/core/theme/app_text_styles.dart

/// Theme-aware text-style accessor for Fast Golden Taxi.
///
/// Wraps the Material [TextTheme] resolved from the current
/// [BuildContext] so callsites can write:
///
/// ```dart
/// final styles = AppTextStyles.of(context);
/// Text('Title', style: styles.titleLarge);
/// ```
///
/// For the raw type-scale configuration see [AppTypography].
library;

import 'package:fast_golden_taxi/core/theme/typography.dart';
import 'package:flutter/material.dart';

/// Convenience wrapper around [TextTheme] for backward compatibility.
///
/// Prefer `Theme.of(context).textTheme` or the `context.textTheme`
/// extension (from `app_theme.dart`) in new code.
class AppTextStyles {
  const AppTextStyles._({
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// Resolves text styles from the nearest [Theme].
  static AppTextStyles of(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return AppTextStyles._(
      headlineLarge: tt.headlineLarge!,
      headlineMedium: tt.headlineMedium!,
      headlineSmall: tt.headlineSmall!,
      titleLarge: tt.titleLarge!,
      titleMedium: tt.titleMedium!,
      titleSmall: tt.titleSmall!,
      bodyLarge: tt.bodyLarge!,
      bodyMedium: tt.bodyMedium!,
      bodySmall: tt.bodySmall!,
      labelLarge: tt.labelLarge!,
      labelMedium: tt.labelMedium!,
      labelSmall: tt.labelSmall!,
    );
  }

  // ── Headline ────────────────────────────────────────────────────────────
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  // ── Title ───────────────────────────────────────────────────────────────
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  // ── Body ────────────────────────────────────────────────────────────────
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  // ── Label ───────────────────────────────────────────────────────────────
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  /// Default font family (static constant for quick reference).
  static const String fontFamily = AppTypography.fontFamily; // Poppins
}
