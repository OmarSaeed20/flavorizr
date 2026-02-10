// lib/core/theme/app_colors.dart
/// App colors for backward compatibility.
///
/// This file provides static color properties that can be used
/// throughout the app. These colors are theme-aware and will
/// update based on the current theme.
library;

import 'package:flutter/material.dart';

/// App colors that can be used throughout the application.
///
/// These colors are designed to be used with the current theme's
/// ColorScheme. For theme-aware colors, use [of] to get colors
/// based on the current BuildContext.
class AppColors {
  // AppColors._();

  /// Get theme-aware colors from the current BuildContext.
  static AppColors of(BuildContext context) {
    final theme = Theme.of(context);
    return AppColors._fromTheme(theme);
  }

  /// Create AppColors from a ThemeData.
  static AppColors _fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return AppColors._internal(
      primary: colorScheme.primary,
      secondary: colorScheme.secondary,
      tertiary: colorScheme.tertiary,
      error: colorScheme.error,
      surface: colorScheme.surface,
      onSurface: colorScheme.onSurface,
      background: colorScheme.surface,
      onBackground: colorScheme.onSurface,
      textPrimary: colorScheme.onSurface,
      textSecondary: colorScheme.onSurfaceVariant,
      success: Colors.green,
      warning: Colors.orange,
      info: Colors.blue,
    );
  }

  // Internal constructor for creating instances
  const AppColors._internal({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.info,
  });

  // Theme colors
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color onBackground;

  // Text colors
  final Color textPrimary;
  final Color textSecondary;

  // Status colors
  final Color success;
  final Color warning;
  final Color info;

  // Brand colors (static)
  static const Color brandPrimary = Color(0xFF6750A4);
  static const Color brandSecondary = Color(0xFF625B71);
  static const Color brandAccent = Color(0xFF7D5260);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6750A4), Color(0xFF9A82DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF625B71), Color(0xFF958DA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF7D5260), Color(0xFFB58392)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Social colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color apple = Color(0xFF000000);
  static const Color github = Color(0xFF333333);

  // Shimmer colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF424242);
  static const Color shimmerHighlightDark = Color(0xFF616161);
}
