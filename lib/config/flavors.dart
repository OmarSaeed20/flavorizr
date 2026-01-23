import 'package:flutter/foundation.dart';

/// Enum representing the different application flavors/environments.
///
/// Each flavor has its own:
/// - API endpoints
/// - Firebase configuration
/// - Feature flags
/// - App identifiers
enum Flavor { dev, staging, prod }

/// Global flavor configuration singleton.
class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title => switch (appFlavor) {
    Flavor.dev => 'Flavorizr Dev',
    Flavor.staging => 'Flavorizr Staging',
    Flavor.prod => 'Flavorizr',
  };
}

/// Extension methods for [Flavor] enum providing environment-specific values.
extension FlavorExtension on Flavor {
  /// Returns whether this is the production environment.
  bool get isProduction => this == Flavor.prod;

  /// Returns whether this is the staging environment.
  bool get isStaging => this == Flavor.staging;

  /// Returns whether this is the development environment.
  bool get isDevelopment => this == Flavor.dev;

  /// Returns the display name for the flavor.
  String get name => switch (this) {
    Flavor.dev => 'dev',
    Flavor.staging => 'staging',
    Flavor.prod => 'prod',
  };

  /// Returns the display name for the flavor (user-friendly).
  String get displayName => switch (this) {
    Flavor.dev => 'Development',
    Flavor.staging => 'Staging',
    Flavor.prod => 'Production',
  };

  /// Returns the app name suffix for the flavor.
  /// Used to distinguish different flavor installations on a device.
  String get appNameSuffix => switch (this) {
    Flavor.dev => ' (Dev)',
    Flavor.staging => ' (Staging)',
    Flavor.prod => '',
  };

  /// Returns the base URL for API requests.
  String get baseUrl => switch (this) {
    Flavor.dev => 'https://dev-api.example.com',
    Flavor.staging => 'https://staging-api.example.com',
    Flavor.prod => 'https://api.example.com',
  };

  /// Returns the WebSocket URL for real-time communication.
  String get wsUrl => switch (this) {
    Flavor.dev => 'wss://dev-ws.example.com',
    Flavor.staging => 'wss://staging-ws.example.com',
    Flavor.prod => 'wss://ws.example.com',
  };

  /// Returns whether verbose logging should be enabled.
  bool get enableLogging => switch (this) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => kDebugMode,
  };

  /// Returns whether debug mode is active.
  bool get isDebugMode => switch (this) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => kDebugMode,
  };

  /// Returns whether analytics should be enabled.
  bool get enableAnalytics => switch (this) {
    Flavor.dev => false,
    Flavor.staging => true,
    Flavor.prod => true,
  };

  /// Returns whether crash reporting should be enabled.
  bool get enableCrashReporting => switch (this) {
    Flavor.dev => false,
    Flavor.staging => true,
    Flavor.prod => true,
  };

  /// Returns whether performance monitoring should be enabled.
  bool get enablePerformanceMonitoring => switch (this) {
    Flavor.dev => false,
    Flavor.staging => true,
    Flavor.prod => true,
  };

  /// Returns the connection timeout in milliseconds.
  int get connectionTimeout => switch (this) {
    Flavor.dev => 60000,
    Flavor.staging => 30000,
    Flavor.prod => 30000,
  };

  /// Returns the receive timeout in milliseconds.
  int get receiveTimeout => switch (this) {
    Flavor.dev => 60000,
    Flavor.staging => 30000,
    Flavor.prod => 30000,
  };

  /// Returns the maximum number of retry attempts.
  int get maxRetryAttempts => switch (this) {
    Flavor.dev => 1,
    Flavor.staging => 2,
    Flavor.prod => 3,
  };

  /// Returns whether to show the debug banner.
  bool get showDebugBanner => switch (this) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => false,
  };

  /// Returns whether to show performance overlay.
  bool get showPerformanceOverlay => switch (this) {
    Flavor.dev => false,
    Flavor.staging => false,
    Flavor.prod => false,
  };

  /// Returns the Firebase project ID suffix.
  String get firebaseProjectSuffix => switch (this) {
    Flavor.dev => '-dev',
    Flavor.staging => '-staging',
    Flavor.prod => '',
  };
}
