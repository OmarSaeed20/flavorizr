// lib/core/theme/theme_controller.dart
import 'dart:convert';

import 'package:flavorizr/core/theme/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key used to store theme settings in SharedPreferences.
const String _themeSettingsKey = 'theme_settings';

/// Provider for accessing and modifying theme settings.
///
/// Usage:
/// ```dart
/// // Read current settings
/// final settings = ref.watch(themeControllerProvider);
///
/// // Update settings
/// ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.dark);
/// ```
final themeControllerProvider = NotifierProvider<ThemeController, ThemeSettings>(
  ThemeController.new,
);

/// Controls theme settings with persistence.
///
/// This controller:
/// - Loads saved settings on initialization
/// - Persists changes to SharedPreferences
/// - Provides methods to update individual settings
class ThemeController extends Notifier<ThemeSettings> {
  SharedPreferences? _prefs;

  @override
  ThemeSettings build() {
    _loadSettings();
    return ThemeSettings.defaults;
  }

  /// Loads theme settings from SharedPreferences.
  Future<void> _loadSettings() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final json = _prefs?.getString(_themeSettingsKey);
      if (json != null) {
        final data = jsonDecode(json) as Map<String, dynamic>;
        state = ThemeSettings.fromJson(data);
      }
    } catch (e) {
      // If loading fails, keep default settings
      debugPrint('Failed to load theme settings: $e');
    }
  }

  /// Saves current theme settings to SharedPreferences.
  Future<void> _saveSettings() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final json = jsonEncode(state.toJson());
      await _prefs?.setString(_themeSettingsKey, json);
    } catch (e) {
      debugPrint('Failed to save theme settings: $e');
    }
  }

  /// Updates the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _saveSettings();
  }

  /// Updates the color scheme index.
  Future<void> setColorScheme(int index) async {
    state = state.copyWith(colorSchemeIndex: index);
    await _saveSettings();
  }

  /// Toggles dynamic color usage.
  Future<void> setUseDynamicColor(bool value) async {
    state = state.copyWith(useDynamicColor: value);
    await _saveSettings();
  }

  /// Toggles OLED black mode.
  Future<void> setUseOledBlack(bool value) async {
    state = state.copyWith(useOledBlack: value);
    await _saveSettings();
  }

  /// Updates the text scale factor.
  Future<void> setTextScaleFactor(double factor) async {
    // Clamp factor between 0.8 and 1.4
    final clampedFactor = factor.clamp(0.8, 1.4);
    state = state.copyWith(textScaleFactor: clampedFactor);
    await _saveSettings();
  }

  /// Toggles high contrast mode.
  Future<void> setUseHighContrast(bool value) async {
    state = state.copyWith(useHighContrast: value);
    await _saveSettings();
  }

  /// Toggles Material 3 mode.
  Future<void> setUseMaterial3(bool value) async {
    state = state.copyWith(useMaterial3: value);
    await _saveSettings();
  }

  /// Resets all settings to defaults.
  Future<void> resetToDefaults() async {
    state = ThemeSettings.defaults;
    await _saveSettings();
  }

  /// Cycles through theme modes: system -> light -> dark -> system
  Future<void> cycleThemeMode() async {
    final nextMode = switch (state.themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(nextMode);
  }

  /// Updates multiple settings at once.
  Future<void> updateSettings(ThemeSettings settings) async {
    state = settings;
    await _saveSettings();
  }
}

/// Provider for the current brightness based on theme mode and platform.
final currentBrightnessProvider = Provider<Brightness>((ref) {
  final settings = ref.watch(themeControllerProvider);
  // This will be overridden by the actual platform brightness
  // when building the MaterialApp
  return settings.themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
});

/// Provider for whether dark mode is active.
final isDarkModeProvider = Provider<bool>((ref) {
  final brightness = ref.watch(currentBrightnessProvider);
  return brightness == Brightness.dark;
});
