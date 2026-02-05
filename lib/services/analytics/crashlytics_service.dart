// lib/services/analytics/crashlytics_service.dart
import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Service for crash reporting using Firebase Crashlytics.
///
/// Provides methods for:
/// - Recording non-fatal errors
/// - Logging custom keys for debugging
/// - Setting user identifiers
/// - Recording fatal errors
///
/// Usage:
/// ```dart
/// final crashlytics = CrashlyticsService.instance;
/// crashlytics.recordError(error, stackTrace, reason: 'API call failed');
/// ```
class CrashlyticsService {
  CrashlyticsService._();

  static CrashlyticsService? _instance;
  static CrashlyticsService get instance =>
      _instance ??= CrashlyticsService._();

  /// The Firebase Crashlytics instance.
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Whether crash reporting is enabled.
  bool _isEnabled = true;

  /// Initializes the crashlytics service.
  ///
  /// Should be called once during app startup.
  Future<void> initialize({bool enabled = true}) async {
    _isEnabled = enabled;
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);

    if (kDebugMode) {
      debugPrint('🔥 Crashlytics initialized (enabled: $enabled)');
    }
  }

  /// Enables or disables crash reporting.
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  // ==================== User Identification ====================

  /// Sets the user identifier for crash reports.
  Future<void> setUserId(String? userId) async {
    if (!_isEnabled) return;
    await _crashlytics.setUserIdentifier(userId ?? '');
  }

  // ==================== Custom Keys ====================

  /// Sets a custom key-value pair for crash reports.
  Future<void> setCustomKey(String key, Object value) async {
    if (!_isEnabled) return;
    await _crashlytics.setCustomKey(key, value);
  }

  /// Sets multiple custom keys at once.
  Future<void> setCustomKeys(Map<String, Object> keys) async {
    for (final entry in keys.entries) {
      await setCustomKey(entry.key, entry.value);
    }
  }

  /// Sets the current screen name for better context in crash reports.
  Future<void> setCurrentScreen(String screenName) async {
    await setCustomKey('current_screen', screenName);
  }

  /// Sets the current user action for context.
  Future<void> setCurrentAction(String action) async {
    await setCustomKey('current_action', action);
  }

  // ==================== Logging ====================

  /// Logs a message to Crashlytics.
  ///
  /// These logs are included in crash reports for debugging.
  Future<void> log(String message) async {
    if (!_isEnabled) return;
    await _crashlytics.log(message);
    if (kDebugMode) {
      debugPrint('📝 Crashlytics Log: $message');
    }
  }

  // ==================== Error Recording ====================

  /// Records a non-fatal error.
  ///
  /// Use this for errors that don't crash the app but should be tracked.
  ///
  /// Parameters:
  /// - [error] - The error object
  /// - [stackTrace] - Optional stack trace
  /// - [reason] - Human-readable description of when/why error occurred
  /// - [fatal] - Whether to treat as a fatal error (default: false)
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_isEnabled) return;

    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );

    if (kDebugMode) {
      debugPrint('🔥 ${fatal ? 'Fatal' : 'Non-fatal'} error recorded: $error');
      if (reason != null) debugPrint('   Reason: $reason');
    }
  }

  /// Records a Flutter error.
  ///
  /// Use this in FlutterError.onError handler.
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    if (!_isEnabled) return;
    await _crashlytics.recordFlutterError(details);
  }

  /// Records a fatal Flutter error.
  ///
  /// Use this for errors that cause the app to crash.
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    if (!_isEnabled) return;
    await _crashlytics.recordFlutterFatalError(details);
  }

  // ==================== Convenience Methods ====================

  /// Records an API error.
  Future<void> recordApiError({
    required String endpoint,
    required int? statusCode,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey('api_endpoint', endpoint);
    await setCustomKey('api_status_code', statusCode ?? 'unknown');
    await recordError(
      error,
      stackTrace,
      reason: 'API Error: $endpoint (${statusCode ?? 'unknown'})',
    );
  }

  /// Records a network error.
  Future<void> recordNetworkError({
    required String url,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey('network_url', url);
    await recordError(error, stackTrace, reason: 'Network Error: $url');
  }

  /// Records a parsing error.
  Future<void> recordParsingError({
    required String dataType,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey('parsing_type', dataType);
    await recordError(error, stackTrace, reason: 'Parsing Error: $dataType');
  }

  /// Records an authentication error.
  Future<void> recordAuthError({
    required String method,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey('auth_method', method);
    await recordError(error, stackTrace, reason: 'Auth Error: $method');
  }

  /// Records a storage error.
  Future<void> recordStorageError({
    required String operation,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey('storage_operation', operation);
    await recordError(error, stackTrace, reason: 'Storage Error: $operation');
  }

  // ==================== Test Methods ====================

  /// Forces a test crash (DEBUG ONLY).
  ///
  /// Use this to verify Crashlytics is working correctly.
  void testCrash() {
    if (kDebugMode) {
      debugPrint('🔥 Test crash triggered');
    }
    _crashlytics.crash();
  }

  /// Checks if crash reporting is supported.
  Future<bool> checkSupported() async {
    return _crashlytics.isCrashlyticsCollectionEnabled;
  }
}
