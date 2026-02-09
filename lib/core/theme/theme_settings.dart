// lib/core/theme/theme_settings.dart
import 'package:fast_golden_taxi/core/core.dart' show AppColorSchemes;
import 'package:fast_golden_taxi/core/theme/color_schemes.dart' show AppColorSchemes;
import 'package:fast_golden_taxi/core/theme/theme.dart' show AppColorSchemes;
import 'package:flutter/material.dart';

/// User's theme preferences that are persisted locally.
///
/// This class holds all configurable theme options:
/// - Theme mode (light/dark/system)
/// - Color scheme selection
/// - Typography scale
/// - OLED mode for true black backgrounds
class ThemeSettings {
  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.colorSchemeIndex = 0,
    this.useDynamicColor = true,
    this.useOledBlack = false,
    this.textScaleFactor = 1.0,
    this.useHighContrast = false,
    this.useMaterial3 = true,
  });

  /// Creates settings from JSON for persistence.
  factory ThemeSettings.fromJson(Map<String, dynamic> json) => ThemeSettings(
    themeMode: _themeModeFromString(json['themeMode'] as String? ?? 'system'),
    colorSchemeIndex: json['colorSchemeIndex'] as int? ?? 0,
    useDynamicColor: json['useDynamicColor'] as bool? ?? true,
    useOledBlack: json['useOledBlack'] as bool? ?? false,
    textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
    useHighContrast: json['useHighContrast'] as bool? ?? false,
    useMaterial3: json['useMaterial3'] as bool? ?? true,
  );

  /// The selected theme mode.
  final ThemeMode themeMode;

  /// Index of the selected color scheme from [AppColorSchemes.schemes].
  final int colorSchemeIndex;

  /// Whether to use dynamic colors from the system (Android 12+).
  final bool useDynamicColor;

  /// Whether to use true black for dark mode (OLED optimization).
  final bool useOledBlack;

  /// Typography scale factor (0.8 - 1.2).
  final double textScaleFactor;

  /// Whether to use high contrast for accessibility.
  final bool useHighContrast;

  /// Whether Material You style is enabled.
  final bool useMaterial3;

  /// Default theme settings for new users.
  static const ThemeSettings defaults = ThemeSettings();

  /// Returns true if dark mode is currently active based on [themeMode]
  /// and the provided [platformBrightness].
  bool isDarkMode(Brightness platformBrightness) {
    switch (themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return platformBrightness == Brightness.dark;
    }
  }

  /// Creates a copy with modified values.
  ThemeSettings copyWith({
    ThemeMode? themeMode,
    int? colorSchemeIndex,
    bool? useDynamicColor,
    bool? useOledBlack,
    double? textScaleFactor,
    bool? useHighContrast,
    bool? useMaterial3,
  }) => ThemeSettings(
    themeMode: themeMode ?? this.themeMode,
    colorSchemeIndex: colorSchemeIndex ?? this.colorSchemeIndex,
    useDynamicColor: useDynamicColor ?? this.useDynamicColor,
    useOledBlack: useOledBlack ?? this.useOledBlack,
    textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    useHighContrast: useHighContrast ?? this.useHighContrast,
    useMaterial3: useMaterial3 ?? this.useMaterial3,
  );

  /// Converts settings to JSON for persistence.
  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.name,
    'colorSchemeIndex': colorSchemeIndex,
    'useDynamicColor': useDynamicColor,
    'useOledBlack': useOledBlack,
    'textScaleFactor': textScaleFactor,
    'useHighContrast': useHighContrast,
    'useMaterial3': useMaterial3,
  };

  static ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeSettings &&
        other.themeMode == themeMode &&
        other.colorSchemeIndex == colorSchemeIndex &&
        other.useDynamicColor == useDynamicColor &&
        other.useOledBlack == useOledBlack &&
        other.textScaleFactor == textScaleFactor &&
        other.useHighContrast == useHighContrast &&
        other.useMaterial3 == useMaterial3;
  }

  @override
  int get hashCode => Object.hash(
    themeMode,
    colorSchemeIndex,
    useDynamicColor,
    useOledBlack,
    textScaleFactor,
    useHighContrast,
    useMaterial3,
  );
}
