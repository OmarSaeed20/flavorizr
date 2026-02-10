// lib/core/theme/app_text_styles.dart
/// App text styles for backward compatibility.
///
/// This file provides static text style properties that can be used
/// throughout the app. These styles are theme-aware and will
/// update based on the current theme.
library;

import 'package:flutter/material.dart';

/// App text styles that can be used throughout the application.
///
/// These text styles are designed to be used with the current theme's
/// TextTheme. For theme-aware styles, use [of] to get styles
/// based on the current BuildContext.
class AppTextStyles {
  // AppTextStyles._();

  /// Get theme-aware text styles from the current BuildContext.
  static AppTextStyles of(BuildContext context) {
    final theme = Theme.of(context);
    return AppTextStyles._fromTheme(theme);
  }

  /// Create AppTextStyles from a ThemeData.
  static AppTextStyles _fromTheme(ThemeData theme) {
    final textTheme = theme.textTheme;
    return AppTextStyles._internal(
      headlineLarge: textTheme.headlineLarge!,
      headlineMedium: textTheme.headlineMedium!,
      headlineSmall: textTheme.headlineSmall!,
      titleLarge: textTheme.titleLarge!,
      titleMedium: textTheme.titleMedium!,
      titleSmall: textTheme.titleSmall!,
      bodyLarge: textTheme.bodyLarge!,
      bodyMedium: textTheme.bodyMedium!,
      bodySmall: textTheme.bodySmall!,
      labelLarge: textTheme.labelLarge!,
      labelMedium: textTheme.labelMedium!,
      labelSmall: textTheme.labelSmall!,
    );
  }

  // Internal constructor for creating instances
  const AppTextStyles._internal({
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

  // Display styles
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  // Title styles
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  // Body styles
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  // Label styles
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  // Static styles for backward compatibility
  static const String fontFamily = 'Roboto';
}
