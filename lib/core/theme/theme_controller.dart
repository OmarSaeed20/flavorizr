// lib/core/theme/theme_controller.dart

/// Riverpod-based theme controller with SharedPreferences persistence.
///
/// The controller owns a single [ThemeSettings] state object and
/// automatically persists every mutation to disk.
///
/// ```dart
/// // Read
/// final settings = ref.watch(themeControllerProvider);
///
/// // Write
/// ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.dark);
/// ```
library;

import 'dart:convert';

import 'package:fast_golden_taxi/core/theme/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key for the serialised [ThemeSettings].
const String _kThemeSettingsKey = 'theme_settings';

// ═══════════════════════════════════════════════════════════════════════════════
// PROVIDER
// ═══════════════════════════════════════════════════════════════════════════════

/// Global provider for theme settings.
///
/// Consumers should `watch` this provider to rebuild when the user
/// changes any theme preference.
final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeSettings>(ThemeController.new);

// ═══════════════════════════════════════════════════════════════════════════════
// CONTROLLER
// ═══════════════════════════════════════════════════════════════════════════════

/// Manages theme preferences with automatic persistence.
class ThemeController extends Notifier<ThemeSettings> {
  SharedPreferences? _prefs;

  @override
  ThemeSettings build() {
    // Kick off async load; state starts at defaults.
    _loadSettings();
    return ThemeSettings.defaults;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Persistence helpers
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _loadSettings() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs?.getString(_kThemeSettingsKey);
      if (raw != null) {
        state = ThemeSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('ThemeController: failed to load settings – $e');
    }
  }

  Future<void> _save() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs?.setString(_kThemeSettingsKey, jsonEncode(state.toJson()));
    } catch (e) {
      debugPrint('ThemeController: failed to save settings – $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Public mutators
  // ─────────────────────────────────────────────────────────────────────────

  /// Sets the theme mode (light / dark / system).
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _save();
  }

  /// Toggles system dynamic-color usage (Android 12+).
  Future<void> setUseDynamicColor(bool value) async {
    state = state.copyWith(useDynamicColor: value);
    await _save();
  }

  /// Toggles OLED true-black dark mode.
  Future<void> setUseOledBlack(bool value) async {
    state = state.copyWith(useOledBlack: value);
    await _save();
  }

  /// Updates the global text scale factor (clamped 0.8 – 1.4).
  Future<void> setTextScaleFactor(double factor) async {
    state = state.copyWith(textScaleFactor: factor.clamp(0.8, 1.4));
    await _save();
  }

  /// Toggles high-contrast mode.
  Future<void> setUseHighContrast(bool value) async {
    state = state.copyWith(useHighContrast: value);
    await _save();
  }

  /// Cycles theme modes: system → light → dark → system.
  Future<void> cycleThemeMode() async {
    final next = switch (state.themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(next);
  }

  /// Replaces the entire settings object.
  Future<void> updateSettings(ThemeSettings settings) async {
    state = settings;
    await _save();
  }

  /// Resets everything to factory defaults.
  Future<void> resetToDefaults() async {
    state = ThemeSettings.defaults;
    await _save();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DERIVED PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Convenience provider for the current brightness.
///
/// Note: this returns a *best guess* based on [ThemeMode] alone.
/// The actual brightness used by the framework also depends on
/// `MediaQuery.platformBrightnessOf(context)`.
final currentBrightnessProvider = Provider<Brightness>((ref) {
  final mode = ref.watch(themeControllerProvider).themeMode;
  return mode == ThemeMode.dark ? Brightness.dark : Brightness.light;
});

/// Whether dark mode is likely active.
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(currentBrightnessProvider) == Brightness.dark;
});
