import 'package:fast_golden_taxi/config/firebase/firebase_config.dart';
import 'package:fast_golden_taxi/config/flavors.dart'
    show F, Flavor, FlavorExtension;
import 'package:flutter/foundation.dart';

/// Application configuration that varies by environment.
///
/// This class holds all environment-specific settings including:
/// - API base URLs
/// - Feature flags
/// - Third-party service configurations
///
/// Usage:
/// ```dart
/// final config = AppConfig.instance;
/// print(config.apiBaseUrl);
/// ```
class AppConfig {
  /// Private constructor to enforce factory pattern.
  const AppConfig._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.showDebugBanner,
    required this.showPerformanceOverlay,
    required this.connectionTimeout,
    required this.receiveTimeout,
    required this.maxRetryAttempts,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.enablePerformanceMonitoring,
  });

  /// Factory constructor that creates a configuration for the specified [flavor].
  ///
  /// Each flavor has pre-defined settings that are appropriate for that environment.
  factory AppConfig.forFlavor(Flavor flavor) => AppConfig._(
    flavor: flavor,
    apiBaseUrl: flavor.baseUrl,
    wsBaseUrl: flavor.wsUrl,
    showDebugBanner: flavor.showDebugBanner,
    showPerformanceOverlay: flavor.showPerformanceOverlay,
    connectionTimeout: flavor.connectionTimeout,
    receiveTimeout: flavor.receiveTimeout,
    maxRetryAttempts: flavor.maxRetryAttempts,
    enableLogging: flavor.enableLogging,
    enableAnalytics: flavor.enableAnalytics,
    enableCrashReporting: flavor.enableCrashReporting,
    enablePerformanceMonitoring: flavor.enablePerformanceMonitoring,
  );

  /// The current flavor/environment.
  final Flavor flavor;

  /// Base URL for the REST API.
  final String apiBaseUrl;

  /// Base URL for WebSocket connections.
  final String wsBaseUrl;

  /// Whether to show debug banners and overlays.
  final bool showDebugBanner;

  /// Whether to enable performance overlay.
  final bool showPerformanceOverlay;

  /// Connection timeout for API requests in milliseconds.
  final int connectionTimeout;

  /// Receive timeout for API requests in milliseconds.
  final int receiveTimeout;

  /// Maximum number of retry attempts for failed requests.
  final int maxRetryAttempts;

  /// Whether logging is enabled.
  final bool enableLogging;

  /// Whether analytics are enabled.
  final bool enableAnalytics;

  /// Whether crash reporting is enabled.
  final bool enableCrashReporting;

  /// Whether performance monitoring is enabled.
  final bool enablePerformanceMonitoring;

  /// The singleton instance of the current configuration.
  static AppConfig? _instance;

  /// Gets the current app configuration.
  ///
  /// Throws [StateError] if [initialize] has not been called.
  static AppConfig get instance {
    if (_instance == null) {
      throw StateError(
        'AppConfig not initialized. Call AppConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initializes the app configuration for the specified [flavor].
  ///
  /// This should be called once at app startup before accessing [instance].
  static void initialize(Flavor flavor) {
    _instance = AppConfig.forFlavor(flavor);
  }

  /// Initializes with the current flavor from [F.appFlavor].
  static void initializeFromCurrentFlavor() {
    initialize(F.appFlavor);
  }

  /// Returns the full app name including any flavor suffix.
  String get appName => 'Fast Golden Taxi${flavor.appNameSuffix}';

  /// Whether the app is running in development mode.
  bool get isDev => flavor == Flavor.dev;

  /// Whether the app is running in staging mode.
  bool get isStaging => flavor == Flavor.staging;

  /// Whether the app is running in production mode.
  bool get isProd => flavor == Flavor.prod;

  /// Whether the app is running in debug mode (any flavor in debug build).
  bool get isDebugMode => kDebugMode || flavor.isDebugMode;

  /// Gets the flavor name.
  static String get flavorName => F.name;

  /// Gets Firebase configuration as a map.
  static Map<String, dynamic> get firebaseConfig => {
    'projectId': FirebaseConfig.projectId,
    'flavor': flavorName,
    'debugMode': _instance?.isDebugMode ?? kDebugMode,
  };

  /// Creates a copy with modified values.
  AppConfig copyWith({
    Flavor? flavor,
    String? apiBaseUrl,
    String? wsBaseUrl,
    bool? showDebugBanner,
    bool? showPerformanceOverlay,
    int? connectionTimeout,
    int? receiveTimeout,
    int? maxRetryAttempts,
    bool? enableLogging,
    bool? enableAnalytics,
    bool? enableCrashReporting,
    bool? enablePerformanceMonitoring,
  }) => AppConfig._(
    flavor: flavor ?? this.flavor,
    apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
    wsBaseUrl: wsBaseUrl ?? this.wsBaseUrl,
    showDebugBanner: showDebugBanner ?? this.showDebugBanner,
    showPerformanceOverlay:
        showPerformanceOverlay ?? this.showPerformanceOverlay,
    connectionTimeout: connectionTimeout ?? this.connectionTimeout,
    receiveTimeout: receiveTimeout ?? this.receiveTimeout,
    maxRetryAttempts: maxRetryAttempts ?? this.maxRetryAttempts,
    enableLogging: enableLogging ?? this.enableLogging,
    enableAnalytics: enableAnalytics ?? this.enableAnalytics,
    enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
    enablePerformanceMonitoring:
        enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
  );

  @override
  String toString() =>
      'AppConfig('
      'flavor: $flavor, '
      'apiBaseUrl: $apiBaseUrl, '
      'enableLogging: $enableLogging, '
      'enableAnalytics: $enableAnalytics'
      ')';
}
