// lib/core/theme/theme_settings.dart

/// User's theme preferences that are persisted locally.
///
/// All fields have sensible defaults so the app launches correctly
/// even before the user touches any setting.
///
/// Serialisation is handled via hand-written `toJson` / `fromJson`
/// to avoid code-generation overhead for such a small model.
library;

import 'package:flutter/material.dart';

/// Immutable data class holding every user-configurable theme option.
///
/// ```dart
/// // Read
/// final settings = ref.watch(themeControllerProvider);
///
/// // Modify
/// ref.read(themeControllerProvider.notifier)
///   .setThemeMode(ThemeMode.dark);
/// ```
class ThemeSettings {
  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.useDynamicColor = true,
    this.useOledBlack = false,
    this.textScaleFactor = 1.0,
    this.useHighContrast = false,
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Fields
  // ─────────────────────────────────────────────────────────────────────────

  /// Light / Dark / System.
  final ThemeMode themeMode;

  /// Whether to use system dynamic colors (Android 12+).
  final bool useDynamicColor;

  /// Whether to use true black for OLED screens in dark mode.
  final bool useOledBlack;

  /// Global text scale factor (clamped 0.8 – 1.4).
  final double textScaleFactor;

  /// High-contrast mode for accessibility.
  final bool useHighContrast;

  // ─────────────────────────────────────────────────────────────────────────
  // Defaults
  // ─────────────────────────────────────────────────────────────────────────

  /// Factory default settings for first-launch.
  static const ThemeSettings defaults = ThemeSettings();

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns `true` if dark mode is active given [platformBrightness].
  bool isDarkMode(Brightness platformBrightness) => switch (themeMode) {
    ThemeMode.light => false,
    ThemeMode.dark => true,
    ThemeMode.system => platformBrightness == Brightness.dark,
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Copy-with
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns a copy with the specified fields overridden.
  ThemeSettings copyWith({
    ThemeMode? themeMode,
    bool? useDynamicColor,
    bool? useOledBlack,
    double? textScaleFactor,
    bool? useHighContrast,
  }) => ThemeSettings(
    themeMode: themeMode ?? this.themeMode,
    useDynamicColor: useDynamicColor ?? this.useDynamicColor,
    useOledBlack: useOledBlack ?? this.useOledBlack,
    textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    useHighContrast: useHighContrast ?? this.useHighContrast,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Serialisation
  // ─────────────────────────────────────────────────────────────────────────

  /// Deserialises from a `Map<String, dynamic>` (SharedPreferences JSON).
  factory ThemeSettings.fromJson(Map<String, dynamic> json) => ThemeSettings(
    themeMode: _themeModeFromString(json['themeMode'] as String? ?? 'system'),
    useDynamicColor: json['useDynamicColor'] as bool? ?? true,
    useOledBlack: json['useOledBlack'] as bool? ?? false,
    textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
    useHighContrast: json['useHighContrast'] as bool? ?? false,
  );

  /// Serialises to a `Map<String, dynamic>` for SharedPreferences.
  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.name,
    'useDynamicColor': useDynamicColor,
    'useOledBlack': useOledBlack,
    'textScaleFactor': textScaleFactor,
    'useHighContrast': useHighContrast,
  };

  static ThemeMode _themeModeFromString(String value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Equality
  // ─────────────────────────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettings &&
          other.themeMode == themeMode &&
          other.useDynamicColor == useDynamicColor &&
          other.useOledBlack == useOledBlack &&
          other.textScaleFactor == textScaleFactor &&
          other.useHighContrast == useHighContrast;

  @override
  int get hashCode =>
      Object.hash(themeMode, useDynamicColor, useOledBlack, textScaleFactor, useHighContrast);

  @override
  String toString() =>
      'ThemeSettings(mode: ${themeMode.name}, dynamic: $useDynamicColor, '
      'oled: $useOledBlack, scale: $textScaleFactor, '
      'highContrast: $useHighContrast)';
}
