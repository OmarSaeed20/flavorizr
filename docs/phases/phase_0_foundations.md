# Phase 0 — Foundations

> **Duration:** 2 weeks  
> **Priority:** Critical  
> **Dependencies:** None (Starting point)

---

## 📋 Overview

Phase 0 establishes the architectural skeleton and core infrastructure that all subsequent phases will build upon. This phase focuses on creating a solid, scalable foundation with proper project structure, theming, navigation, dependency injection, and CI/CD pipelines.

**Key Deliverables:**
- Project structure and mono-repo setup
- Design system and theming infrastructure
- Navigation and routing system
- Dependency injection framework
- Feature flag system
- CI/CD pipelines
- Error handling framework

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| Scalable Architecture | Clean Architecture layers properly separated |
| Theme System | Light/Dark/System modes working with persistence |
| Navigation | Deep linking and route guards functional |
| CI/CD | Automated builds for all flavors (dev/staging/prod) |
| Developer Experience | Hot reload works, code generation automated |

---

## 📁 Tasks Breakdown

### Task 0.1: Project Structure & Mono-repo Setup

**Estimated Time:** 2-3 days

#### Objectives
- Initialize Flutter project with proper structure
- Set up Melos for mono-repo management (if using packages)
- Configure analysis options and linting rules
- Set up Git hooks for pre-commit checks

#### Implementation Steps

1. **Initialize Project Structure**
   ```
   lib/
   ├── main.dart                    # Entry point
   ├── main_dev.dart                # Dev flavor entry
   ├── main_staging.dart            # Staging flavor entry
   ├── main_prod.dart               # Production flavor entry
   ├── app.dart                     # MaterialApp setup
   ├── bootstrap.dart               # App initialization
   ├── config/                      # Configuration files
   ├── core/                        # Core utilities and services
   ├── features/                    # Feature modules
   └── shared/                      # Shared widgets and entities
   ```

2. **Configure `pubspec.yaml`**
   ```yaml
   name: base_app
   description: Production-grade Flutter starter application
   version: 1.0.0+1
   
   environment:
     sdk: '>=3.0.0 <4.0.0'
     flutter: '>=3.16.0'
   
   dependencies:
     flutter:
       sdk: flutter
     flutter_localizations:
       sdk: flutter
     
     # State Management
     flutter_riverpod: ^2.5.0
     riverpod_annotation: ^2.3.0
     
     # Navigation
     go_router: ^14.0.0
     
     # Networking
     dio: ^5.4.0
     retrofit: ^4.1.0
     
     # Local Storage
     hive_flutter: ^1.1.0
     flutter_secure_storage: ^9.0.0
     shared_preferences: ^2.2.0
     
     # Theming
     flex_color_scheme: ^8.4.0
     dynamic_color: ^1.7.0
     
     # Modals & Dialogs
     modal_bottom_sheet: ^3.0.0
     
     # Utilities
     freezed_annotation: ^2.4.0
     json_annotation: ^4.8.0
     equatable: ^2.0.5
     dartz: ^0.10.1
     intl: ^0.19.0
     
   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^4.0.0
     build_runner: ^2.4.0
     freezed: ^2.4.0
     json_serializable: ^6.7.0
     riverpod_generator: ^2.4.0
     retrofit_generator: ^8.1.0
     mockito: ^5.4.0
     mocktail: ^1.0.0
   ```

3. **Configure `analysis_options.yaml`**
   ```yaml
   include: package:flutter_lints/flutter.yaml
   
   analyzer:
     exclude:
       - '**/*.g.dart'
       - '**/*.freezed.dart'
     errors:
       invalid_annotation_target: ignore
     language:
       strict-casts: true
       strict-inference: true
       strict-raw-types: true
   
   linter:
     rules:
       # Error prevention
       - always_use_package_imports
       - avoid_dynamic_calls
       - avoid_returning_null_for_future
       - avoid_slow_async_io
       - cancel_subscriptions
       - close_sinks
       - literal_only_boolean_expressions
       - throw_in_finally
       - unnecessary_statements
       
       # Style
       - always_declare_return_types
       - always_put_required_named_parameters_first
       - avoid_bool_literals_in_conditional_expressions
       - avoid_catches_without_on_clauses
       - avoid_catching_errors
       - avoid_classes_with_only_static_members
       - avoid_double_and_int_checks
       - avoid_equals_and_hash_code_on_mutable_classes
       - avoid_escaping_inner_quotes
       - avoid_field_initializers_in_const_classes
       - avoid_final_parameters
       - avoid_implementing_value_types
       - avoid_multiple_declarations_per_line
       - avoid_positional_boolean_parameters
       - avoid_private_typedef_functions
       - avoid_redundant_argument_values
       - avoid_returning_this
       - avoid_setters_without_getters
       - avoid_type_to_string
       - avoid_types_on_closure_parameters
       - avoid_unused_constructor_parameters
       - avoid_void_async
       - cascade_invocations
       - cast_nullable_to_non_nullable
       - combinators_ordering
       - conditional_uri_does_not_exist
       - deprecated_consistency
       - directives_ordering
       - eol_at_end_of_file
       - join_return_with_assignment
       - leading_newlines_in_multiline_strings
       - missing_whitespace_between_adjacent_strings
       - no_adjacent_strings_in_list
       - no_runtimeType_toString
       - noop_primitive_operations
       - omit_local_variable_types
       - one_member_abstracts
       - only_throw_errors
       - parameter_assignments
       - prefer_asserts_in_initializer_lists
       - prefer_asserts_with_message
       - prefer_const_constructors
       - prefer_const_constructors_in_immutables
       - prefer_const_declarations
       - prefer_const_literals_to_create_immutables
       - prefer_constructors_over_static_methods
       - prefer_expression_function_bodies
       - prefer_final_in_for_each
       - prefer_final_locals
       - prefer_final_parameters
       - prefer_foreach
       - prefer_if_elements_to_conditional_expressions
       - prefer_int_literals
       - prefer_mixin
       - prefer_null_aware_method_calls
       - prefer_single_quotes
       - require_trailing_commas
       - sort_constructors_first
       - sort_unnamed_constructors_first
       - tighten_type_of_initializing_formals
       - type_annotate_public_apis
       - unawaited_futures
       - unnecessary_await_in_return
       - unnecessary_breaks
       - unnecessary_lambdas
       - unnecessary_null_aware_operator_assignment
       - unnecessary_null_checks
       - unnecessary_parenthesis
       - unnecessary_raw_strings
       - unnecessary_to_list_in_spreads
       - unreachable_from_main
       - use_colored_box
       - use_decorated_box
       - use_enums
       - use_if_null_to_convert_nulls_to_bools
       - use_is_even_rather_than_modulo
       - use_late_for_private_fields_used_only_in_one_instance
       - use_named_constants
       - use_raw_strings
       - use_setters_to_change_properties
       - use_string_buffers
       - use_string_in_part_of_directives
       - use_super_parameters
       - use_test_throws_matchers
       - use_to_and_as_if_applicable
   ```

4. **Set up Melos (Optional - for mono-repo)**
   ```yaml
   # melos.yaml
   name: base_app_workspace
   
   packages:
     - apps/*
     - packages/*
   
   scripts:
     analyze:
       run: melos exec -- flutter analyze
       description: Analyze all packages
     
     test:
       run: melos exec -- flutter test
       description: Run tests in all packages
     
     build_runner:
       run: melos exec -- dart run build_runner build --delete-conflicting-outputs
       description: Run build_runner in all packages
     
     clean:
       run: melos exec -- flutter clean
       description: Clean all packages
     
     get:
       run: melos exec -- flutter pub get
       description: Get dependencies for all packages
   ```

#### Acceptance Criteria
- [ ] Project compiles without errors
- [ ] Linting passes with no warnings
- [ ] Build runner generates code successfully
- [ ] All flavors can be built (dev/staging/prod)

---

### Task 0.2: Environment Configuration & Flavors

**Estimated Time:** 1-2 days

#### Objectives
- Set up environment-specific configurations
- Configure Android and iOS build flavors
- Create flavor-specific entry points

#### Implementation Steps

1. **Create `lib/config/flavors.dart`**
   ```dart
   /// Enum representing the different application flavors/environments.
   /// 
   /// Each flavor has its own:
   /// - API endpoints
   /// - Firebase configuration
   /// - Feature flags
   /// - App identifiers
   enum Flavor {
     /// Development environment for local development and testing.
     /// Uses mock services and verbose logging.
     dev,
     
     /// Staging environment for QA and pre-production testing.
     /// Connects to staging backend services.
     staging,
     
     /// Production environment for end users.
     /// Optimized for performance with minimal logging.
     prod,
   }
   
   /// Extension methods for [Flavor] enum providing environment-specific values.
   extension FlavorExtension on Flavor {
     /// Returns the display name for the flavor.
     String get name {
       switch (this) {
         case Flavor.dev:
           return 'Development';
         case Flavor.staging:
           return 'Staging';
         case Flavor.prod:
           return 'Production';
       }
     }
     
     /// Returns the app name suffix for the flavor.
     /// Used to distinguish different flavor installations on a device.
     String get appNameSuffix {
       switch (this) {
         case Flavor.dev:
           return ' (Dev)';
         case Flavor.staging:
           return ' (Staging)';
         case Flavor.prod:
           return '';
       }
     }
     
     /// Returns whether verbose logging should be enabled.
     bool get enableLogging {
       switch (this) {
         case Flavor.dev:
         case Flavor.staging:
           return true;
         case Flavor.prod:
           return false;
       }
     }
     
     /// Returns whether analytics should be enabled.
     bool get enableAnalytics {
       switch (this) {
         case Flavor.dev:
           return false;
         case Flavor.staging:
         case Flavor.prod:
           return true;
       }
     }
     
     /// Returns whether crash reporting should be enabled.
     bool get enableCrashReporting {
       switch (this) {
         case Flavor.dev:
           return false;
         case Flavor.staging:
         case Flavor.prod:
           return true;
       }
     }
   }
   ```

2. **Create `lib/config/app_config.dart`**
   ```dart
   import 'flavors.dart';
   
   /// Application configuration that varies by environment.
   /// 
   /// This class holds all environment-specific settings including:
   /// - API base URLs
   /// - Feature flags
   /// - Third-party service configurations
   /// 
   /// Usage:
   /// ```dart
   /// final config = AppConfig.forFlavor(Flavor.dev);
   /// print(config.apiBaseUrl);
   /// ```
   class AppConfig {
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
     });
     
     /// Factory constructor that creates a configuration for the specified [flavor].
     /// 
     /// Each flavor has pre-defined settings that are appropriate for that environment.
     factory AppConfig.forFlavor(Flavor flavor) {
       switch (flavor) {
         case Flavor.dev:
           return const AppConfig._(
             flavor: Flavor.dev,
             apiBaseUrl: 'https://api-dev.example.com/v1',
             wsBaseUrl: 'wss://ws-dev.example.com',
             showDebugBanner: true,
             showPerformanceOverlay: false,
             connectionTimeout: 30000,
             receiveTimeout: 30000,
             maxRetryAttempts: 3,
           );
         case Flavor.staging:
           return const AppConfig._(
             flavor: Flavor.staging,
             apiBaseUrl: 'https://api-staging.example.com/v1',
             wsBaseUrl: 'wss://ws-staging.example.com',
             showDebugBanner: true,
             showPerformanceOverlay: false,
             connectionTimeout: 15000,
             receiveTimeout: 15000,
             maxRetryAttempts: 3,
           );
         case Flavor.prod:
           return const AppConfig._(
             flavor: Flavor.prod,
             apiBaseUrl: 'https://api.example.com/v1',
             wsBaseUrl: 'wss://ws.example.com',
             showDebugBanner: false,
             showPerformanceOverlay: false,
             connectionTimeout: 10000,
             receiveTimeout: 10000,
             maxRetryAttempts: 5,
           );
       }
     }
     
     /// The singleton instance of the current configuration.
     static AppConfig? _instance;
     
     /// Gets the current app configuration.
     /// 
     /// Throws [StateError] if [initialize] has not been called.
     static AppConfig get instance {
       if (_instance == null) {
         throw StateError(
           'AppConfig has not been initialized. '
           'Call AppConfig.initialize() first.',
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
     
     /// Returns the full app name including any flavor suffix.
     String get appName => 'Base App${flavor.appNameSuffix}';
     
     /// Whether the app is running in development mode.
     bool get isDev => flavor == Flavor.dev;
     
     /// Whether the app is running in staging mode.
     bool get isStaging => flavor == Flavor.staging;
     
     /// Whether the app is running in production mode.
     bool get isProd => flavor == Flavor.prod;
   }
   ```

3. **Create flavor-specific entry points**
   
   **`lib/main_dev.dart`**
   ```dart
   import 'package:base_app/bootstrap.dart';
   import 'package:base_app/config/flavors.dart';
   
   /// Entry point for the Development flavor.
   /// 
   /// This configuration enables:
   /// - Debug banner
   /// - Verbose logging
   /// - Mock services (optional)
   /// - Development API endpoints
   void main() => bootstrap(Flavor.dev);
   ```
   
   **`lib/main_staging.dart`**
   ```dart
   import 'package:base_app/bootstrap.dart';
   import 'package:base_app/config/flavors.dart';
   
   /// Entry point for the Staging flavor.
   /// 
   /// This configuration enables:
   /// - Debug banner
   /// - Analytics (staging)
   /// - Crash reporting (staging)
   /// - Staging API endpoints
   void main() => bootstrap(Flavor.staging);
   ```
   
   **`lib/main_prod.dart`**
   ```dart
   import 'package:base_app/bootstrap.dart';
   import 'package:base_app/config/flavors.dart';
   
   /// Entry point for the Production flavor.
   /// 
   /// This configuration enables:
   /// - Analytics
   /// - Crash reporting
   /// - Performance optimizations
   /// - Production API endpoints
   void main() => bootstrap(Flavor.prod);
   ```

4. **Create `lib/bootstrap.dart`**
   ```dart
   import 'dart:async';
   
   import 'package:flutter/foundation.dart';
   import 'package:flutter/material.dart';
   import 'package:flutter/services.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   
   import 'app.dart';
   import 'config/app_config.dart';
   import 'config/flavors.dart';
   import 'core/error/error_handler.dart';
   import 'core/logger/app_logger.dart';
   
   /// Bootstraps the application with the specified [flavor].
   /// 
   /// This function:
   /// 1. Ensures Flutter bindings are initialized
   /// 2. Sets up error handling
   /// 3. Initializes app configuration
   /// 4. Initializes core services (logging, storage, etc.)
   /// 5. Runs the app
   /// 
   /// All errors during initialization are caught and logged.
   Future<void> bootstrap(Flavor flavor) async {
     // Catch all errors during bootstrap
     await runZonedGuarded(
       () async {
         // Ensure Flutter bindings are initialized
         WidgetsFlutterBinding.ensureInitialized();
         
         // Initialize app configuration
         AppConfig.initialize(flavor);
         
         // Initialize logger
         AppLogger.initialize(
           enableLogging: flavor.enableLogging,
           minLevel: flavor == Flavor.prod ? LogLevel.warning : LogLevel.debug,
         );
         
         AppLogger.info('Starting app with flavor: ${flavor.name}');
         
         // Set preferred orientations
         await SystemChrome.setPreferredOrientations([
           DeviceOrientation.portraitUp,
           DeviceOrientation.portraitDown,
         ]);
         
         // Set system UI overlay style
         SystemChrome.setSystemUIOverlayStyle(
           const SystemUIOverlayStyle(
             statusBarColor: Colors.transparent,
             statusBarIconBrightness: Brightness.dark,
             systemNavigationBarColor: Colors.transparent,
             systemNavigationBarIconBrightness: Brightness.dark,
           ),
         );
         
         // Initialize core services
         await _initializeServices();
         
         // Set up Flutter error handling
         FlutterError.onError = (details) {
           FlutterError.presentError(details);
           ErrorHandler.handleFlutterError(details);
         };
         
         // Set up platform dispatcher error handling
         PlatformDispatcher.instance.onError = (error, stack) {
           ErrorHandler.handlePlatformError(error, stack);
           return true;
         };
         
         // Run the app
         runApp(
           ProviderScope(
             observers: [
               if (kDebugMode) _ProviderLogger(),
             ],
             child: const App(),
           ),
         );
       },
       (error, stackTrace) {
         // Handle any uncaught errors
         ErrorHandler.handleUncaughtError(error, stackTrace);
       },
     );
   }
   
   /// Initializes core services required by the app.
   /// 
   /// Services initialized:
   /// - Local storage (Hive)
   /// - Secure storage
   /// - Firebase (if enabled)
   /// - Analytics
   /// - Crash reporting
   Future<void> _initializeServices() async {
     // TODO: Initialize services here
     // await Hive.initFlutter();
     // await Firebase.initializeApp();
     // etc.
   }
   
   /// A Riverpod observer that logs provider state changes in debug mode.
   class _ProviderLogger extends ProviderObserver {
     @override
     void didAddProvider(
       ProviderBase<Object?> provider,
       Object? value,
       ProviderContainer container,
     ) {
       AppLogger.debug('Provider added: ${provider.name ?? provider.runtimeType}');
     }
     
     @override
     void didDisposeProvider(
       ProviderBase<Object?> provider,
       ProviderContainer container,
     ) {
       AppLogger.debug('Provider disposed: ${provider.name ?? provider.runtimeType}');
     }
     
     @override
     void didUpdateProvider(
       ProviderBase<Object?> provider,
       Object? previousValue,
       Object? newValue,
       ProviderContainer container,
     ) {
       AppLogger.debug(
         'Provider updated: ${provider.name ?? provider.runtimeType}\n'
         'Previous: $previousValue\n'
         'New: $newValue',
       );
     }
     
     @override
     void providerDidFail(
       ProviderBase<Object?> provider,
       Object error,
       StackTrace stackTrace,
       ProviderContainer container,
     ) {
       AppLogger.error(
         'Provider failed: ${provider.name ?? provider.runtimeType}',
         error: error,
         stackTrace: stackTrace,
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] Each flavor builds successfully
- [ ] Flavor-specific configurations are applied correctly
- [ ] Debug banner only shows in dev/staging
- [ ] Correct API endpoints are used per flavor

---

### Task 0.3: Theme System Setup (flex_color_scheme)

**Estimated Time:** 2-3 days

#### Objectives
- Implement comprehensive theming with flex_color_scheme
- Support light/dark/system theme modes
- Add dynamic color support (Android 12+)
- Persist theme preferences
- Create OLED true black option

#### Implementation Steps

1. **Create `lib/core/theme/theme_settings.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:freezed_annotation/freezed_annotation.dart';
   
   part 'theme_settings.freezed.dart';
   part 'theme_settings.g.dart';
   
   /// User's theme preferences that are persisted locally.
   /// 
   /// This class holds all configurable theme options:
   /// - Theme mode (light/dark/system)
   /// - Color scheme selection
   /// - Typography scale
   /// - OLED mode for true black backgrounds
   @freezed
   class ThemeSettings with _$ThemeSettings {
     const ThemeSettings._();
     
     const factory ThemeSettings({
       /// The selected theme mode.
       /// Defaults to [ThemeMode.system] to follow device settings.
       @Default(ThemeMode.system) ThemeMode themeMode,
       
       /// The selected color scheme index.
       /// Corresponds to a scheme in [AppColorSchemes.schemes].
       @Default(0) int colorSchemeIndex,
       
       /// Whether to use dynamic colors from the system (Android 12+).
       /// When true, ignores [colorSchemeIndex] and uses wallpaper colors.
       @Default(true) bool useDynamicColors,
       
       /// Whether to use true black backgrounds in dark mode.
       /// Recommended for OLED screens to save battery.
       @Default(false) bool useOledBlack,
       
       /// Text scale factor multiplier (0.8 to 1.4).
       /// Applied on top of system accessibility settings.
       @Default(1.0) double textScaleFactor,
       
       /// Whether to use high contrast mode.
       /// Increases contrast ratios for better accessibility.
       @Default(false) bool useHighContrast,
     }) = _ThemeSettings;
     
     /// Creates settings from JSON for persistence.
     factory ThemeSettings.fromJson(Map<String, dynamic> json) =>
         _$ThemeSettingsFromJson(json);
     
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
   }
   
   /// JSON converter for [ThemeMode] enum.
   class ThemeModeConverter implements JsonConverter<ThemeMode, String> {
     const ThemeModeConverter();
     
     @override
     ThemeMode fromJson(String json) {
       switch (json) {
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
     String toJson(ThemeMode object) => object.name;
   }
   ```

2. **Create `lib/core/theme/color_schemes.dart`**
   ```dart
   import 'package:flex_color_scheme/flex_color_scheme.dart';
   import 'package:flutter/material.dart';
   
   /// Pre-defined color schemes available in the app.
   /// 
   /// Users can select from these schemes in settings,
   /// or the app can use dynamic colors from the system.
   class AppColorSchemes {
     AppColorSchemes._();
     
     /// List of available color schemes with their display names.
     static const List<({String name, FlexScheme scheme})> schemes = [
       (name: 'Material Blue', scheme: FlexScheme.material),
       (name: 'Material High Contrast', scheme: FlexScheme.materialHc),
       (name: 'Blue', scheme: FlexScheme.blue),
       (name: 'Indigo', scheme: FlexScheme.indigo),
       (name: 'Hippie Blue', scheme: FlexScheme.hippieBlue),
       (name: 'Aqua Blue', scheme: FlexScheme.aquaBlue),
       (name: 'Teal', scheme: FlexScheme.teal),
       (name: 'Green', scheme: FlexScheme.green),
       (name: 'Jungle', scheme: FlexScheme.jungle),
       (name: 'Red', scheme: FlexScheme.red),
       (name: 'Sakura', scheme: FlexScheme.sakura),
       (name: 'Mandarin Red', scheme: FlexScheme.mandyRed),
       (name: 'Mango', scheme: FlexScheme.mango),
       (name: 'Amber', scheme: FlexScheme.amber),
       (name: 'Gold', scheme: FlexScheme.gold),
       (name: 'Deep Purple', scheme: FlexScheme.deepPurple),
       (name: 'Eggplant', scheme: FlexScheme.eggplant),
       (name: 'Pink', scheme: FlexScheme.pinkM3),
       (name: 'Purple', scheme: FlexScheme.purpleM3),
     ];
     
     /// Gets the [FlexScheme] at the specified [index].
     /// Returns [FlexScheme.material] if index is out of bounds.
     static FlexScheme getScheme(int index) {
       if (index < 0 || index >= schemes.length) {
         return FlexScheme.material;
       }
       return schemes[index].scheme;
     }
     
     /// Gets the display name for the scheme at [index].
     static String getSchemeName(int index) {
       if (index < 0 || index >= schemes.length) {
         return 'Material Blue';
       }
       return schemes[index].name;
     }
   }
   
   /// Semantic colors for specific UI states.
   /// 
   /// These colors are used consistently throughout the app
   /// for success, warning, error, and info states.
   class SemanticColors {
     SemanticColors._();
     
     /// Success state color (green).
     static const Color success = Color(0xFF4CAF50);
     
     /// Success state color for dark mode.
     static const Color successDark = Color(0xFF81C784);
     
     /// Warning state color (orange/amber).
     static const Color warning = Color(0xFFFF9800);
     
     /// Warning state color for dark mode.
     static const Color warningDark = Color(0xFFFFB74D);
     
     /// Error state color (red).
     static const Color error = Color(0xFFF44336);
     
     /// Error state color for dark mode.
     static const Color errorDark = Color(0xFFE57373);
     
     /// Info state color (blue).
     static const Color info = Color(0xFF2196F3);
     
     /// Info state color for dark mode.
     static const Color infoDark = Color(0xFF64B5F6);
   }
   ```

3. **Create `lib/core/theme/app_theme.dart`**
   ```dart
   import 'package:dynamic_color/dynamic_color.dart';
   import 'package:flex_color_scheme/flex_color_scheme.dart';
   import 'package:flutter/material.dart';
   
   import 'color_schemes.dart';
   import 'theme_settings.dart';
   import 'typography.dart';
   
   /// Builds Material 3 themes using flex_color_scheme.
   /// 
   /// This class handles:
   /// - Light and dark theme generation
   /// - Dynamic color integration (Android 12+)
   /// - OLED true black mode
   /// - Custom typography
   /// - Component-specific theming
   class AppTheme {
     AppTheme._();
     
     /// Builds a light theme based on the provided [settings].
     /// 
     /// If [dynamicColorScheme] is provided and [settings.useDynamicColors]
     /// is true, the theme will use the device's wallpaper colors.
     static ThemeData light({
       required ThemeSettings settings,
       ColorScheme? dynamicColorScheme,
     }) {
       // Use dynamic colors if available and enabled
       if (settings.useDynamicColors && dynamicColorScheme != null) {
         return _buildThemeFromColorScheme(
           colorScheme: dynamicColorScheme,
           isDark: false,
           settings: settings,
         );
       }
       
       // Use flex_color_scheme with selected scheme
       final scheme = AppColorSchemes.getScheme(settings.colorSchemeIndex);
       
       return FlexThemeData.light(
         scheme: scheme,
         useMaterial3: true,
         
         // Surface blending for depth
         surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
         blendLevel: 7,
         
         // App bar theming
         appBarStyle: FlexAppBarStyle.surface,
         appBarElevation: 0,
         
         // Bottom navigation theming
         bottomAppBarElevation: 1,
         
         // Tab bar theming
         tabBarStyle: FlexTabBarStyle.forAppBar,
         
         // Sub-themes for Material 3 components
         subThemesData: _subThemesData(settings),
         
         // Typography
         fontFamily: AppTypography.fontFamily,
         textTheme: AppTypography.textTheme,
         primaryTextTheme: AppTypography.textTheme,
         
         // Visual density
         visualDensity: FlexColorScheme.comfortablePlatformDensity,
       );
     }
     
     /// Builds a dark theme based on the provided [settings].
     /// 
     /// If [settings.useOledBlack] is true, uses true black backgrounds
     /// for OLED screen optimization.
     static ThemeData dark({
       required ThemeSettings settings,
       ColorScheme? dynamicColorScheme,
     }) {
       // Use dynamic colors if available and enabled
       if (settings.useDynamicColors && dynamicColorScheme != null) {
         return _buildThemeFromColorScheme(
           colorScheme: dynamicColorScheme,
           isDark: true,
           settings: settings,
         );
       }
       
       // Use flex_color_scheme with selected scheme
       final scheme = AppColorSchemes.getScheme(settings.colorSchemeIndex);
       
       return FlexThemeData.dark(
         scheme: scheme,
         useMaterial3: true,
         
         // Dark mode specific settings
         darkIsTrueBlack: settings.useOledBlack,
         
         // Surface blending for depth
         surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
         blendLevel: 13,
         
         // App bar theming
         appBarStyle: FlexAppBarStyle.surface,
         appBarElevation: 0,
         
         // Bottom navigation theming
         bottomAppBarElevation: 1,
         
         // Tab bar theming
         tabBarStyle: FlexTabBarStyle.forAppBar,
         
         // Sub-themes for Material 3 components
         subThemesData: _subThemesData(settings),
         
         // Typography
         fontFamily: AppTypography.fontFamily,
         textTheme: AppTypography.textTheme,
         primaryTextTheme: AppTypography.textTheme,
         
         // Visual density
         visualDensity: FlexColorScheme.comfortablePlatformDensity,
       );
     }
     
     /// Builds a theme from a dynamic [ColorScheme].
     static ThemeData _buildThemeFromColorScheme({
       required ColorScheme colorScheme,
       required bool isDark,
       required ThemeSettings settings,
     }) {
       // Apply OLED black if enabled
       final adjustedScheme = settings.useOledBlack && isDark
           ? colorScheme.copyWith(
               surface: Colors.black,
               surfaceDim: Colors.black,
               surfaceContainerLowest: Colors.black,
               surfaceContainerLow: const Color(0xFF121212),
               surfaceContainer: const Color(0xFF1E1E1E),
               surfaceContainerHigh: const Color(0xFF252525),
               surfaceContainerHighest: const Color(0xFF2C2C2C),
             )
           : colorScheme;
       
       return ThemeData(
         useMaterial3: true,
         colorScheme: adjustedScheme,
         brightness: isDark ? Brightness.dark : Brightness.light,
         
         // Typography
         fontFamily: AppTypography.fontFamily,
         textTheme: AppTypography.textTheme,
         
         // Visual density
         visualDensity: VisualDensity.comfortable,
         
         // Component themes
         appBarTheme: AppBarTheme(
           elevation: 0,
           scrolledUnderElevation: 1,
           backgroundColor: adjustedScheme.surface,
           foregroundColor: adjustedScheme.onSurface,
           centerTitle: true,
         ),
         
         cardTheme: CardTheme(
           elevation: 0,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12),
           ),
           clipBehavior: Clip.antiAlias,
         ),
         
         elevatedButtonTheme: ElevatedButtonThemeData(
           style: ElevatedButton.styleFrom(
             elevation: 0,
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
             ),
           ),
         ),
         
         filledButtonTheme: FilledButtonThemeData(
           style: FilledButton.styleFrom(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
             ),
           ),
         ),
         
         outlinedButtonTheme: OutlinedButtonThemeData(
           style: OutlinedButton.styleFrom(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
             ),
           ),
         ),
         
         textButtonTheme: TextButtonThemeData(
           style: TextButton.styleFrom(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
             ),
           ),
         ),
         
         inputDecorationTheme: InputDecorationTheme(
           filled: true,
           fillColor: adjustedScheme.surfaceContainerHighest.withOpacity(0.5),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide.none,
           ),
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide.none,
           ),
           focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: adjustedScheme.primary, width: 2),
           ),
           errorBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: adjustedScheme.error),
           ),
           focusedErrorBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: adjustedScheme.error, width: 2),
           ),
           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
         ),
         
         bottomSheetTheme: BottomSheetThemeData(
           backgroundColor: adjustedScheme.surface,
           surfaceTintColor: adjustedScheme.surfaceTint,
           shape: const RoundedRectangleBorder(
             borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
           ),
           showDragHandle: true,
           dragHandleColor: adjustedScheme.onSurfaceVariant.withOpacity(0.4),
         ),
         
         dialogTheme: DialogTheme(
           backgroundColor: adjustedScheme.surface,
           surfaceTintColor: adjustedScheme.surfaceTint,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(28),
           ),
         ),
         
         snackBarTheme: SnackBarThemeData(
           behavior: SnackBarBehavior.floating,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
           ),
         ),
         
         chipTheme: ChipThemeData(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
           ),
         ),
         
         navigationBarTheme: NavigationBarThemeData(
           elevation: 0,
           backgroundColor: adjustedScheme.surface,
           indicatorColor: adjustedScheme.secondaryContainer,
           labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
         ),
         
         navigationRailTheme: NavigationRailThemeData(
           elevation: 0,
           backgroundColor: adjustedScheme.surface,
           indicatorColor: adjustedScheme.secondaryContainer,
           labelType: NavigationRailLabelType.all,
         ),
       );
     }
     
     /// Sub-themes configuration for flex_color_scheme.
     static FlexSubThemesData _subThemesData(ThemeSettings settings) {
       return FlexSubThemesData(
         // Interaction effects
         interactionEffects: true,
         tintedDisabledControls: true,
         
         // Blend levels
         blendOnLevel: 10,
         blendOnColors: true,
         
         // Use Material 3 defaults
         useM2StyleDividerInM3: false,
         
         // Default border radius
         defaultRadius: 12,
         
         // Button settings
         elevatedButtonSchemeColor: SchemeColor.primary,
         elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
         filledButtonSchemeColor: SchemeColor.primary,
         outlinedButtonSchemeColor: SchemeColor.primary,
         outlinedButtonOutlineSchemeColor: SchemeColor.outline,
         textButtonSchemeColor: SchemeColor.primary,
         
         // Toggle buttons
         toggleButtonsSchemeColor: SchemeColor.primary,
         toggleButtonsUnselectedSchemeColor: SchemeColor.outline,
         
         // Segmented buttons
         segmentedButtonSchemeColor: SchemeColor.primary,
         segmentedButtonUnselectedSchemeColor: SchemeColor.surface,
         
         // FAB
         fabUseShape: true,
         fabSchemeColor: SchemeColor.primaryContainer,
         fabRadius: 16,
         
         // Chip
         chipSchemeColor: SchemeColor.primary,
         chipRadius: 8,
         
         // Card
         cardRadius: 12,
         
         // Dialogs
         dialogRadius: 28,
         dialogElevation: 6,
         
         // Snackbar
         snackBarRadius: 8,
         snackBarElevation: 4,
         snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
         
         // App bar
         appBarScrolledUnderElevation: 1,
         appBarCenterTitle: true,
         
         // Bottom navigation
         bottomNavigationBarElevation: 0,
         bottomNavigationBarShowUnselectedLabels: true,
         
         // Navigation bar (M3)
         navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
         navigationBarElevation: 0,
         navigationBarHeight: 80,
         
         // Navigation rail
         navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
         navigationRailElevation: 0,
         
         // Drawer
         drawerRadius: 16,
         drawerElevation: 1,
         drawerWidth: 304,
         
         // Bottom sheet
         bottomSheetRadius: 28,
         bottomSheetElevation: 2,
         bottomSheetModalElevation: 4,
         
         // Input decoration
         inputDecoratorSchemeColor: SchemeColor.primary,
         inputDecoratorIsFilled: true,
         inputDecoratorRadius: 12,
         inputDecoratorUnfocusedHasBorder: false,
         inputDecoratorFocusedHasBorder: true,
         inputDecoratorPrefixIconSchemeColor: SchemeColor.onSurfaceVariant,
         
         // Tooltips
         tooltipRadius: 4,
         tooltipSchemeColor: SchemeColor.inverseSurface,
         tooltipOpacity: 0.9,
         
         // Switch, checkbox, radio
         switchSchemeColor: SchemeColor.primary,
         checkboxSchemeColor: SchemeColor.primary,
         radioSchemeColor: SchemeColor.primary,
         
         // Slider
         sliderValueTinted: true,
         sliderTrackHeight: 4,
         
         // Menu
         menuRadius: 8,
         menuElevation: 3,
         menuBarRadius: 0,
         menuBarElevation: 1,
         
         // Date picker
         datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
         datePickerDividerSchemeColor: SchemeColor.outline,
         
         // Time picker
         timePickerDialogRadius: 28,
       );
     }
   }
   ```

4. **Create `lib/core/theme/typography.dart`**
   ```dart
   import 'package:flutter/material.dart';
   
   /// App typography configuration.
   /// 
   /// Defines the font family and text styles used throughout the app.
   /// Follows Material 3 type scale with customizations.
   class AppTypography {
     AppTypography._();
     
     /// The primary font family used in the app.
     /// Uses the system font for better performance and native feel.
     static const String fontFamily = '.SF Pro Text';
     
     /// Alternative font family for display text (headings).
     static const String displayFontFamily = '.SF Pro Display';
     
     /// The base text theme with all style definitions.
     /// 
     /// Scale follows Material 3 type scale:
     /// - Display: Large marketing headlines
     /// - Headline: Section headers
     /// - Title: Card titles, dialogs
     /// - Body: Main content text
     /// - Label: Buttons, captions, tags
     static const TextTheme textTheme = TextTheme(
       // Display styles - for large marketing headlines
       displayLarge: TextStyle(
         fontSize: 57,
         fontWeight: FontWeight.w400,
         letterSpacing: -0.25,
         height: 1.12,
       ),
       displayMedium: TextStyle(
         fontSize: 45,
         fontWeight: FontWeight.w400,
         letterSpacing: 0,
         height: 1.16,
       ),
       displaySmall: TextStyle(
         fontSize: 36,
         fontWeight: FontWeight.w400,
         letterSpacing: 0,
         height: 1.22,
       ),
       
       // Headline styles - for section headers
       headlineLarge: TextStyle(
         fontSize: 32,
         fontWeight: FontWeight.w400,
         letterSpacing: 0,
         height: 1.25,
       ),
       headlineMedium: TextStyle(
         fontSize: 28,
         fontWeight: FontWeight.w400,
         letterSpacing: 0,
         height: 1.29,
       ),
       headlineSmall: TextStyle(
         fontSize: 24,
         fontWeight: FontWeight.w400,
         letterSpacing: 0,
         height: 1.33,
       ),
       
       // Title styles - for card titles, dialogs, etc.
       titleLarge: TextStyle(
         fontSize: 22,
         fontWeight: FontWeight.w500,
         letterSpacing: 0,
         height: 1.27,
       ),
       titleMedium: TextStyle(
         fontSize: 16,
         fontWeight: FontWeight.w500,
         letterSpacing: 0.15,
         height: 1.5,
       ),
       titleSmall: TextStyle(
         fontSize: 14,
         fontWeight: FontWeight.w500,
         letterSpacing: 0.1,
         height: 1.43,
       ),
       
       // Body styles - for main content text
       bodyLarge: TextStyle(
         fontSize: 16,
         fontWeight: FontWeight.w400,
         letterSpacing: 0.5,
         height: 1.5,
       ),
       bodyMedium: TextStyle(
         fontSize: 14,
         fontWeight: FontWeight.w400,
         letterSpacing: 0.25,
         height: 1.43,
       ),
       bodySmall: TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w400,
         letterSpacing: 0.4,
         height: 1.33,
       ),
       
       // Label styles - for buttons, captions, tags
       labelLarge: TextStyle(
         fontSize: 14,
         fontWeight: FontWeight.w500,
         letterSpacing: 0.1,
         height: 1.43,
       ),
       labelMedium: TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w500,
         letterSpacing: 0.5,
         height: 1.33,
       ),
       labelSmall: TextStyle(
         fontSize: 11,
         fontWeight: FontWeight.w500,
         letterSpacing: 0.5,
         height: 1.45,
       ),
     );
   }
   ```

5. **Create `lib/core/theme/theme_controller.dart`**
   ```dart
   import 'dart:convert';
   
   import 'package:flutter/material.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   
   import 'theme_settings.dart';
   
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
   final themeControllerProvider =
       StateNotifierProvider<ThemeController, ThemeSettings>((ref) {
     return ThemeController();
   });
   
   /// Controls theme settings with persistence.
   /// 
   /// This controller:
   /// - Loads saved settings on initialization
   /// - Persists changes to SharedPreferences
   /// - Provides methods to update individual settings
   class ThemeController extends StateNotifier<ThemeSettings> {
     ThemeController() : super(ThemeSettings.defaults) {
       _loadSettings();
     }
     
     /// Loads theme settings from persistent storage.
     Future<void> _loadSettings() async {
       try {
         final prefs = await SharedPreferences.getInstance();
         final jsonString = prefs.getString(_themeSettingsKey);
         
         if (jsonString != null) {
           final json = jsonDecode(jsonString) as Map<String, dynamic>;
           state = ThemeSettings.fromJson(json);
         }
       } catch (e) {
         // If loading fails, keep default settings
         debugPrint('Failed to load theme settings: $e');
       }
     }
     
     /// Saves current theme settings to persistent storage.
     Future<void> _saveSettings() async {
       try {
         final prefs = await SharedPreferences.getInstance();
         final jsonString = jsonEncode(state.toJson());
         await prefs.setString(_themeSettingsKey, jsonString);
       } catch (e) {
         debugPrint('Failed to save theme settings: $e');
       }
     }
     
     /// Updates the theme mode (light/dark/system).
     /// 
     /// Changes are automatically persisted.
     Future<void> setThemeMode(ThemeMode mode) async {
       state = state.copyWith(themeMode: mode);
       await _saveSettings();
     }
     
     /// Updates the color scheme index.
     /// 
     /// The index corresponds to a scheme in [AppColorSchemes.schemes].
     Future<void> setColorScheme(int index) async {
       state = state.copyWith(colorSchemeIndex: index);
       await _saveSettings();
     }
     
     /// Toggles dynamic color usage.
     /// 
     /// When enabled, uses Android 12+ wallpaper colors.
     Future<void> setUseDynamicColors(bool value) async {
       state = state.copyWith(useDynamicColors: value);
       await _saveSettings();
     }
     
     /// Toggles OLED true black mode for dark theme.
     /// 
     /// Recommended for OLED screens to save battery.
     Future<void> setUseOledBlack(bool value) async {
       state = state.copyWith(useOledBlack: value);
       await _saveSettings();
     }
     
     /// Updates the text scale factor.
     /// 
     /// Valid range: 0.8 to 1.4
     Future<void> setTextScaleFactor(double value) async {
       final clampedValue = value.clamp(0.8, 1.4);
       state = state.copyWith(textScaleFactor: clampedValue);
       await _saveSettings();
     }
     
     /// Toggles high contrast mode for accessibility.
     Future<void> setUseHighContrast(bool value) async {
       state = state.copyWith(useHighContrast: value);
       await _saveSettings();
     }
     
     /// Resets all theme settings to defaults.
     Future<void> resetToDefaults() async {
       state = ThemeSettings.defaults;
       await _saveSettings();
     }
   }
   ```

#### Acceptance Criteria
- [ ] Light/Dark/System themes work correctly
- [ ] Theme preference persists across app restarts
- [ ] Dynamic colors work on Android 12+ devices
- [ ] OLED black mode produces true black backgrounds
- [ ] Color scheme selection works
- [ ] Typography scales correctly

---

### Task 0.4: Navigation & Routing (go_router)

**Estimated Time:** 2-3 days

#### Objectives
- Set up declarative routing with go_router
- Implement deep linking support
- Create route guards for authentication
- Add custom page transitions

#### Implementation Steps

1. **Create `lib/core/router/routes.dart`**
   ```dart
   /// Defines all route paths used in the application.
   /// 
   /// Using constants for route paths prevents typos and enables
   /// easy refactoring. All paths should be defined here.
   /// 
   /// Naming convention:
   /// - Use lowercase with hyphens for paths
   /// - Use descriptive names that match the page purpose
   abstract class Routes {
     Routes._();
     
     // ==================== Root Routes ====================
     
     /// Splash screen shown during app initialization.
     static const String splash = '/splash';
     
     /// Main home screen after authentication.
     static const String home = '/';
     
     // ==================== Auth Routes ====================
     
     /// Login page.
     static const String login = '/login';
     
     /// Registration page.
     static const String register = '/register';
     
     /// Forgot password page.
     static const String forgotPassword = '/forgot-password';
     
     /// OTP verification page.
     static const String otpVerification = '/otp-verification';
     
     /// Biometric setup page.
     static const String biometricSetup = '/biometric-setup';
     
     // ==================== Onboarding Routes ====================
     
     /// Welcome/onboarding page for new users.
     static const String onboarding = '/onboarding';
     
     /// Permission request page.
     static const String permissions = '/permissions';
     
     // ==================== Main App Routes ====================
     
     /// Feed page (part of bottom nav).
     static const String feed = '/feed';
     
     /// Search page (part of bottom nav).
     static const String search = '/search';
     
     /// Notifications page (part of bottom nav).
     static const String notifications = '/notifications';
     
     /// Profile page (part of bottom nav).
     static const String profile = '/profile';
     
     // ==================== Feed Sub-routes ====================
     
     /// Post detail page.
     /// Parameter: postId
     static const String postDetail = '/feed/:postId';
     
     /// Create post page.
     static const String createPost = '/feed/create';
     
     // ==================== Profile Sub-routes ====================
     
     /// Edit profile page.
     static const String editProfile = '/profile/edit';
     
     /// User's posts page.
     static const String myPosts = '/profile/posts';
     
     // ==================== Settings Routes ====================
     
     /// Main settings page.
     static const String settings = '/settings';
     
     /// Theme settings page.
     static const String themeSettings = '/settings/theme';
     
     /// Language settings page.
     static const String languageSettings = '/settings/language';
     
     /// Privacy settings page.
     static const String privacySettings = '/settings/privacy';
     
     /// Security settings page.
     static const String securitySettings = '/settings/security';
     
     /// Notification settings page.
     static const String notificationSettings = '/settings/notifications';
     
     /// About page.
     static const String about = '/settings/about';
     
     // ==================== Chat Routes ====================
     
     /// Conversations list page.
     static const String conversations = '/chat';
     
     /// Individual chat page.
     /// Parameter: chatId
     static const String chat = '/chat/:chatId';
     
     /// Chat info/settings page.
     /// Parameter: chatId
     static const String chatInfo = '/chat/:chatId/info';
     
     // ==================== Payments Routes ====================
     
     /// Subscription page.
     static const String subscription = '/subscription';
     
     /// Payment methods page.
     static const String paymentMethods = '/payment-methods';
     
     /// Purchase history page.
     static const String purchaseHistory = '/purchase-history';
     
     // ==================== Admin Routes ====================
     
     /// Admin dashboard.
     static const String adminDashboard = '/admin';
     
     /// Content moderation page.
     static const String moderation = '/admin/moderation';
     
     /// Analytics dashboard.
     static const String analytics = '/admin/analytics';
     
     // ==================== Error Routes ====================
     
     /// Error page.
     static const String error = '/error';
     
     /// Maintenance page.
     static const String maintenance = '/maintenance';
     
     /// Not found (404) page.
     static const String notFound = '/not-found';
   }
   ```

2. **Create `lib/core/router/route_guards.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:go_router/go_router.dart';
   
   import 'routes.dart';
   
   /// Collection of route guards for protecting routes.
   /// 
   /// Guards can be combined and used in the router configuration
   /// to control access to specific routes based on:
   /// - Authentication status
   /// - User roles
   /// - Feature flags
   /// - Onboarding completion
   class RouteGuards {
     RouteGuards._();
     
     /// Checks if the user is authenticated.
     /// 
     /// Redirects to login if not authenticated.
     /// Should be used for routes that require authentication.
     /// 
     /// Usage in GoRouter:
     /// ```dart
     /// GoRoute(
     ///   path: Routes.profile,
     ///   redirect: RouteGuards.requireAuth,
     ///   builder: (context, state) => const ProfilePage(),
     /// )
     /// ```
     static String? requireAuth(BuildContext context, GoRouterState state) {
       // TODO: Replace with actual auth check
       final isAuthenticated = false; // authRepository.isAuthenticated;
       
       if (!isAuthenticated) {
         // Encode the current location so we can redirect back after login
         final redirectTo = Uri.encodeComponent(state.uri.toString());
         return '${Routes.login}?redirect=$redirectTo';
       }
       
       return null; // No redirect needed
     }
     
     /// Checks if the user is NOT authenticated (for auth pages).
     /// 
     /// Redirects to home if already authenticated.
     /// Should be used for login/register pages.
     static String? requireNoAuth(BuildContext context, GoRouterState state) {
       // TODO: Replace with actual auth check
       final isAuthenticated = false; // authRepository.isAuthenticated;
       
       if (isAuthenticated) {
         return Routes.home;
       }
       
       return null;
     }
     
     /// Checks if the user has completed onboarding.
     /// 
     /// Redirects to onboarding if not completed.
     static String? requireOnboarding(BuildContext context, GoRouterState state) {
       // TODO: Replace with actual check
       final hasCompletedOnboarding = true; // preferencesRepository.hasCompletedOnboarding;
       
       if (!hasCompletedOnboarding) {
         return Routes.onboarding;
       }
       
       return null;
     }
     
     /// Checks if the user has admin role.
     /// 
     /// Redirects to home if not an admin.
     /// Should be used for admin routes.
     static String? requireAdmin(BuildContext context, GoRouterState state) {
       // TODO: Replace with actual check
       final isAdmin = false; // authRepository.currentUser?.isAdmin ?? false;
       
       if (!isAdmin) {
         return Routes.home;
       }
       
       return null;
     }
     
     /// Checks if a feature flag is enabled.
     /// 
     /// Returns a redirect function for the specified feature flag.
     /// 
     /// Usage:
     /// ```dart
     /// GoRoute(
     ///   path: Routes.chat,
     ///   redirect: RouteGuards.requireFeature('chat.enabled'),
     ///   builder: (context, state) => const ChatPage(),
     /// )
     /// ```
     static GoRouterRedirect requireFeature(String featureFlag) {
       return (BuildContext context, GoRouterState state) {
         // TODO: Replace with actual feature flag check
         final isEnabled = true; // featureFlagService.isEnabled(featureFlag);
         
         if (!isEnabled) {
           return Routes.home;
         }
         
         return null;
       };
     }
     
     /// Combines multiple guards into one.
     /// 
     /// Returns the first non-null redirect from the guards.
     /// 
     /// Usage:
     /// ```dart
     /// GoRoute(
     ///   path: Routes.adminDashboard,
     ///   redirect: RouteGuards.combine([
     ///     RouteGuards.requireAuth,
     ///     RouteGuards.requireAdmin,
     ///   ]),
     ///   builder: (context, state) => const AdminDashboardPage(),
     /// )
     /// ```
     static GoRouterRedirect combine(List<GoRouterRedirect> guards) {
       return (BuildContext context, GoRouterState state) {
         for (final guard in guards) {
           final redirect = guard(context, state);
           if (redirect != null) {
             return redirect;
           }
         }
         return null;
       };
     }
   }
   ```

3. **Create `lib/core/router/route_transitions.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:go_router/go_router.dart';
   
   /// Custom page transitions for different navigation patterns.
   /// 
   /// These transitions enhance the UX by providing visual feedback
   /// about the navigation hierarchy and direction.
   class RouteTransitions {
     RouteTransitions._();
     
     /// Default transition duration.
     static const Duration defaultDuration = Duration(milliseconds: 300);
     
     /// Fast transition for quick interactions.
     static const Duration fastDuration = Duration(milliseconds: 200);
     
     /// Slow transition for dramatic effects.
     static const Duration slowDuration = Duration(milliseconds: 400);
     
     /// Creates a fade transition.
     /// 
     /// Best for:
     /// - Root-level navigation changes
     /// - Modal-like presentations
     /// - Splash to home transition
     static CustomTransitionPage<T> fade<T>({
       required Widget child,
       required GoRouterState state,
       Duration duration = defaultDuration,
     }) {
       return CustomTransitionPage<T>(
         key: state.pageKey,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
             child: child,
           );
         },
       );
     }
     
     /// Creates a slide transition from the right.
     /// 
     /// Best for:
     /// - Push navigation (going deeper into hierarchy)
     /// - Detail pages
     /// - Settings sub-pages
     static CustomTransitionPage<T> slideFromRight<T>({
       required Widget child,
       required GoRouterState state,
       Duration duration = defaultDuration,
     }) {
       return CustomTransitionPage<T>(
         key: state.pageKey,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final offsetAnimation = Tween<Offset>(
             begin: const Offset(1.0, 0.0),
             end: Offset.zero,
           ).animate(CurvedAnimation(
             parent: animation,
             curve: Curves.easeOutCubic,
             reverseCurve: Curves.easeInCubic,
           ));
           
           return SlideTransition(
             position: offsetAnimation,
             child: child,
           );
         },
       );
     }
     
     /// Creates a slide transition from the bottom.
     /// 
     /// Best for:
     /// - Modal presentations
     /// - Full-screen dialogs
     /// - Bottom sheet alternatives
     static CustomTransitionPage<T> slideFromBottom<T>({
       required Widget child,
       required GoRouterState state,
       Duration duration = defaultDuration,
     }) {
       return CustomTransitionPage<T>(
         key: state.pageKey,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final offsetAnimation = Tween<Offset>(
             begin: const Offset(0.0, 1.0),
             end: Offset.zero,
           ).animate(CurvedAnimation(
             parent: animation,
             curve: Curves.easeOutCubic,
             reverseCurve: Curves.easeInCubic,
           ));
           
           return SlideTransition(
             position: offsetAnimation,
             child: child,
           );
         },
       );
     }
     
     /// Creates a scale transition with fade.
     /// 
     /// Best for:
     /// - Dialogs
     /// - Action results
     /// - Zoom-in effects
     static CustomTransitionPage<T> scale<T>({
       required Widget child,
       required GoRouterState state,
       Duration duration = fastDuration,
       Alignment alignment = Alignment.center,
     }) {
       return CustomTransitionPage<T>(
         key: state.pageKey,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final scaleAnimation = Tween<double>(
             begin: 0.9,
             end: 1.0,
           ).animate(CurvedAnimation(
             parent: animation,
             curve: Curves.easeOutCubic,
           ));
           
           final fadeAnimation = CurvedAnimation(
             parent: animation,
             curve: Curves.easeInOut,
           );
           
           return ScaleTransition(
             scale: scaleAnimation,
             alignment: alignment,
             child: FadeTransition(
               opacity: fadeAnimation,
               child: child,
             ),
           );
         },
       );
     }
     
     /// Creates a shared axis transition (Material 3 style).
     /// 
     /// Best for:
     /// - Tab navigation
     /// - Sibling page navigation
     /// - Wizard-style flows
     static CustomTransitionPage<T> sharedAxis<T>({
       required Widget child,
       required GoRouterState state,
       Duration duration = defaultDuration,
       bool forward = true,
     }) {
       return CustomTransitionPage<T>(
         key: state.pageKey,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final direction = forward ? 1.0 : -1.0;
           
           final offsetAnimation = Tween<Offset>(
             begin: Offset(0.1 * direction, 0.0),
             end: Offset.zero,
           ).animate(CurvedAnimation(
             parent: animation,
             curve: Curves.easeOutCubic,
           ));
           
           final fadeAnimation = CurvedAnimation(
             parent: animation,
             curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
           );
           
           return FadeTransition(
             opacity: fadeAnimation,
             child: SlideTransition(
               position: offsetAnimation,
               child: child,
             ),
           );
         },
       );
     }
     
     /// Creates no transition (instant navigation).
     /// 
     /// Best for:
     /// - Deep link navigation
     /// - State restoration
     /// - When user expects instant change
     static CustomTransitionPage<T> none<T>({
       required Widget child,
       required GoRouterState state,
     }) {
       return CustomTransitionPage<T>(
         key: state.pageKey,
         child: child,
         transitionDuration: Duration.zero,
         reverseTransitionDuration: Duration.zero,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return child;
         },
       );
     }
   }
   ```

4. **Create `lib/core/router/app_router.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:go_router/go_router.dart';
   
   import '../../features/auth/presentation/pages/login_page.dart';
   import '../../features/feed/presentation/pages/feed_page.dart';
   import '../../features/profile/presentation/pages/profile_page.dart';
   import '../../features/settings/presentation/pages/settings_page.dart';
   import '../../shared/presentation/pages/error_page.dart';
   import '../../shared/presentation/pages/splash_page.dart';
   import '../../shared/presentation/widgets/layout/app_scaffold.dart';
   import 'route_guards.dart';
   import 'route_transitions.dart';
   import 'routes.dart';
   
   /// Provider for the GoRouter instance.
   /// 
   /// Usage:
   /// ```dart
   /// final router = ref.watch(routerProvider);
   /// ```
   final routerProvider = Provider<GoRouter>((ref) {
     return AppRouter.createRouter(ref);
   });
   
   /// Navigation key for accessing navigator without context.
   final rootNavigatorKey = GlobalKey<NavigatorState>();
   
   /// Shell navigator key for bottom navigation.
   final shellNavigatorKey = GlobalKey<NavigatorState>();
   
   /// Creates and configures the app router.
   /// 
   /// The router is structured with:
   /// - Global routes (splash, auth, error)
   /// - Shell route (main app with bottom navigation)
   /// - Feature-specific sub-routes
   class AppRouter {
     AppRouter._();
     
     /// Creates the GoRouter instance with all route configurations.
     static GoRouter createRouter(Ref ref) {
       return GoRouter(
         navigatorKey: rootNavigatorKey,
         initialLocation: Routes.splash,
         debugLogDiagnostics: true, // Enable in debug mode
         
         // Global redirect for auth checks
         redirect: (context, state) {
           // Skip auth check for public routes
           final publicRoutes = [
             Routes.splash,
             Routes.login,
             Routes.register,
             Routes.forgotPassword,
             Routes.onboarding,
             Routes.error,
             Routes.maintenance,
           ];
           
           if (publicRoutes.contains(state.matchedLocation)) {
             return null;
           }
           
           // Apply auth guard to all other routes
           return RouteGuards.requireAuth(context, state);
         },
         
         // Error handler
         errorBuilder: (context, state) => ErrorPage(
           error: state.error,
         ),
         
         // Route definitions
         routes: [
           // ==================== Public Routes ====================
           
           GoRoute(
             path: Routes.splash,
             pageBuilder: (context, state) => RouteTransitions.fade(
               child: const SplashPage(),
               state: state,
             ),
           ),
           
           GoRoute(
             path: Routes.login,
             pageBuilder: (context, state) => RouteTransitions.fade(
               child: const LoginPage(),
               state: state,
             ),
           ),
           
           GoRoute(
             path: Routes.register,
             pageBuilder: (context, state) => RouteTransitions.slideFromRight(
               child: const Placeholder(), // TODO: RegisterPage
               state: state,
             ),
           ),
           
           GoRoute(
             path: Routes.forgotPassword,
             pageBuilder: (context, state) => RouteTransitions.slideFromRight(
               child: const Placeholder(), // TODO: ForgotPasswordPage
               state: state,
             ),
           ),
           
           GoRoute(
             path: Routes.onboarding,
             pageBuilder: (context, state) => RouteTransitions.fade(
               child: const Placeholder(), // TODO: OnboardingPage
               state: state,
             ),
           ),
           
           // ==================== Main App Shell ====================
           
           ShellRoute(
             navigatorKey: shellNavigatorKey,
             builder: (context, state, child) {
               return AppScaffold(child: child);
             },
             routes: [
               // Home / Feed
               GoRoute(
                 path: Routes.home,
                 pageBuilder: (context, state) => RouteTransitions.fade(
                   child: const FeedPage(),
                   state: state,
                 ),
                 routes: [
                   // Post detail
                   GoRoute(
                     path: 'post/:postId',
                     pageBuilder: (context, state) {
                       final postId = state.pathParameters['postId']!;
                       return RouteTransitions.slideFromRight(
                         child: Placeholder(), // TODO: PostDetailPage(postId: postId)
                         state: state,
                       );
                     },
                   ),
                   // Create post
                   GoRoute(
                     path: 'create',
                     pageBuilder: (context, state) => RouteTransitions.slideFromBottom(
                       child: const Placeholder(), // TODO: CreatePostPage
                       state: state,
                     ),
                   ),
                 ],
               ),
               
               // Search
               GoRoute(
                 path: Routes.search,
                 pageBuilder: (context, state) => RouteTransitions.fade(
                   child: const Placeholder(), // TODO: SearchPage
                   state: state,
                 ),
               ),
               
               // Notifications
               GoRoute(
                 path: Routes.notifications,
                 pageBuilder: (context, state) => RouteTransitions.fade(
                   child: const Placeholder(), // TODO: NotificationsPage
                   state: state,
                 ),
               ),
               
               // Profile
               GoRoute(
                 path: Routes.profile,
                 pageBuilder: (context, state) => RouteTransitions.fade(
                   child: const ProfilePage(),
                   state: state,
                 ),
                 routes: [
                   GoRoute(
                     path: 'edit',
                     pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                       child: const Placeholder(), // TODO: EditProfilePage
                       state: state,
                     ),
                   ),
                 ],
               ),
             ],
           ),
           
           // ==================== Settings Routes ====================
           
           GoRoute(
             path: Routes.settings,
             pageBuilder: (context, state) => RouteTransitions.slideFromRight(
               child: const SettingsPage(),
               state: state,
             ),
             routes: [
               GoRoute(
                 path: 'theme',
                 pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                   child: const Placeholder(), // TODO: ThemeSettingsPage
                   state: state,
                 ),
               ),
               GoRoute(
                 path: 'language',
                 pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                   child: const Placeholder(), // TODO: LanguageSettingsPage
                   state: state,
                 ),
               ),
               GoRoute(
                 path: 'privacy',
                 pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                   child: const Placeholder(), // TODO: PrivacySettingsPage
                   state: state,
                 ),
               ),
               GoRoute(
                 path: 'security',
                 pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                   child: const Placeholder(), // TODO: SecuritySettingsPage
                   state: state,
                 ),
               ),
               GoRoute(
                 path: 'about',
                 pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                   child: const Placeholder(), // TODO: AboutPage
                   state: state,
                 ),
               ),
             ],
           ),
           
           // ==================== Chat Routes ====================
           
           GoRoute(
             path: Routes.conversations,
             redirect: RouteGuards.requireFeature('chat.enabled'),
             pageBuilder: (context, state) => RouteTransitions.slideFromRight(
               child: const Placeholder(), // TODO: ConversationsPage
               state: state,
             ),
             routes: [
               GoRoute(
                 path: ':chatId',
                 pageBuilder: (context, state) {
                   final chatId = state.pathParameters['chatId']!;
                   return RouteTransitions.slideFromRight(
                     child: Placeholder(), // TODO: ChatPage(chatId: chatId)
                     state: state,
                   );
                 },
                 routes: [
                   GoRoute(
                     path: 'info',
                     pageBuilder: (context, state) {
                       final chatId = state.pathParameters['chatId']!;
                       return RouteTransitions.slideFromRight(
                         child: Placeholder(), // TODO: ChatInfoPage(chatId: chatId)
                         state: state,
                       );
                     },
                   ),
                 ],
               ),
             ],
           ),
           
           // ==================== Admin Routes ====================
           
           GoRoute(
             path: Routes.adminDashboard,
             redirect: RouteGuards.combine([
               RouteGuards.requireAuth,
               RouteGuards.requireAdmin,
             ]),
             pageBuilder: (context, state) => RouteTransitions.fade(
               child: const Placeholder(), // TODO: AdminDashboardPage
               state: state,
             ),
             routes: [
               GoRoute(
                 path: 'moderation',
                 pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                   child: const Placeholder(), // TODO: ModerationPage
                   state: state,
                 ),
               ),
               GoRoute(
                 path: 'analytics',
                 pageBuilder: (context, state) => RouteTransitions.slideFromRight(
                   child: const Placeholder(), // TODO: AnalyticsDashboardPage
                   state: state,
                 ),
               ),
             ],
           ),
           
           // ==================== Error Routes ====================
           
           GoRoute(
             path: Routes.error,
             pageBuilder: (context, state) => RouteTransitions.fade(
               child: ErrorPage(error: state.extra as Exception?),
               state: state,
             ),
           ),
           
           GoRoute(
             path: Routes.maintenance,
             pageBuilder: (context, state) => RouteTransitions.fade(
               child: const Placeholder(), // TODO: MaintenancePage
               state: state,
             ),
           ),
         ],
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] All defined routes are navigable
- [ ] Deep links work correctly
- [ ] Route guards redirect appropriately
- [ ] Page transitions are smooth
- [ ] Bottom navigation shell works
- [ ] Back button behavior is correct

---

### Task 0.5: Error Handling Framework

**Estimated Time:** 1-2 days

#### Objectives
- Create unified failure types
- Implement global error handler
- Set up error boundary widget
- Configure crash reporting integration

#### Implementation Steps

1. **Create `lib/core/error/failures.dart`**
   ```dart
   import 'package:equatable/equatable.dart';
   
   /// Base class for all failures in the domain layer.
   /// 
   /// Failures represent expected error conditions that are part of
   /// the business logic. They are used with Either<Failure, Success>
   /// pattern for explicit error handling.
   /// 
   /// Use failures for:
   /// - Network errors
   /// - Validation errors
   /// - Business rule violations
   /// - Permission errors
   /// - Not found errors
   abstract class Failure extends Equatable {
     /// Human-readable error message for display.
     final String message;
     
     /// Optional error code for programmatic handling.
     final String? code;
     
     /// Optional original exception for debugging.
     final Object? originalException;
     
     const Failure({
       required this.message,
       this.code,
       this.originalException,
     });
     
     @override
     List<Object?> get props => [message, code, originalException];
     
     @override
     String toString() => 'Failure(message: $message, code: $code)';
   }
   
   // ==================== Network Failures ====================
   
   /// Failure when no internet connection is available.
   class NetworkFailure extends Failure {
     const NetworkFailure({
       super.message = 'No internet connection. Please check your network settings.',
       super.code = 'NETWORK_ERROR',
       super.originalException,
     });
   }
   
   /// Failure when server returns an error response.
   class ServerFailure extends Failure {
     /// HTTP status code if available.
     final int? statusCode;
     
     const ServerFailure({
       required super.message,
       this.statusCode,
       super.code = 'SERVER_ERROR',
       super.originalException,
     });
     
     @override
     List<Object?> get props => [...super.props, statusCode];
   }
   
   /// Failure when request times out.
   class TimeoutFailure extends Failure {
     const TimeoutFailure({
       super.message = 'Request timed out. Please try again.',
       super.code = 'TIMEOUT_ERROR',
       super.originalException,
     });
   }
   
   /// Failure when connection is cancelled.
   class CancelledFailure extends Failure {
     const CancelledFailure({
       super.message = 'Request was cancelled.',
       super.code = 'CANCELLED_ERROR',
       super.originalException,
     });
   }
   
   // ==================== Auth Failures ====================
   
   /// Failure when user is not authenticated.
   class UnauthenticatedFailure extends Failure {
     const UnauthenticatedFailure({
       super.message = 'Please log in to continue.',
       super.code = 'UNAUTHENTICATED',
       super.originalException,
     });
   }
   
   /// Failure when user doesn't have permission.
   class UnauthorizedFailure extends Failure {
     const UnauthorizedFailure({
       super.message = 'You do not have permission to perform this action.',
       super.code = 'UNAUTHORIZED',
       super.originalException,
     });
   }
   
   /// Failure when login credentials are invalid.
   class InvalidCredentialsFailure extends Failure {
     const InvalidCredentialsFailure({
       super.message = 'Invalid email or password.',
       super.code = 'INVALID_CREDENTIALS',
       super.originalException,
     });
   }
   
   /// Failure when session has expired.
   class SessionExpiredFailure extends Failure {
     const SessionExpiredFailure({
       super.message = 'Your session has expired. Please log in again.',
       super.code = 'SESSION_EXPIRED',
       super.originalException,
     });
   }
   
   // ==================== Validation Failures ====================
   
   /// Failure for input validation errors.
   class ValidationFailure extends Failure {
     /// Map of field names to error messages.
     final Map<String, String>? fieldErrors;
     
     const ValidationFailure({
       required super.message,
       this.fieldErrors,
       super.code = 'VALIDATION_ERROR',
       super.originalException,
     });
     
     @override
     List<Object?> get props => [...super.props, fieldErrors];
   }
   
   // ==================== Data Failures ====================
   
   /// Failure when requested data is not found.
   class NotFoundFailure extends Failure {
     const NotFoundFailure({
       super.message = 'The requested resource was not found.',
       super.code = 'NOT_FOUND',
       super.originalException,
     });
   }
   
   /// Failure when there's a conflict (e.g., duplicate entry).
   class ConflictFailure extends Failure {
     const ConflictFailure({
       required super.message,
       super.code = 'CONFLICT',
       super.originalException,
     });
   }
   
   /// Failure for local storage/cache errors.
   class CacheFailure extends Failure {
     const CacheFailure({
       super.message = 'Failed to access local storage.',
       super.code = 'CACHE_ERROR',
       super.originalException,
     });
   }
   
   // ==================== Feature Failures ====================
   
   /// Failure when a feature is disabled.
   class FeatureDisabledFailure extends Failure {
     const FeatureDisabledFailure({
       super.message = 'This feature is currently unavailable.',
       super.code = 'FEATURE_DISABLED',
       super.originalException,
     });
   }
   
   /// Failure when user needs to upgrade their plan.
   class UpgradeRequiredFailure extends Failure {
     const UpgradeRequiredFailure({
       super.message = 'Please upgrade your plan to access this feature.',
       super.code = 'UPGRADE_REQUIRED',
       super.originalException,
     });
   }
   
   // ==================== Generic Failures ====================
   
   /// Failure for unexpected errors.
   class UnexpectedFailure extends Failure {
     const UnexpectedFailure({
       super.message = 'An unexpected error occurred. Please try again.',
       super.code = 'UNEXPECTED_ERROR',
       super.originalException,
     });
   }
   ```

2. **Create `lib/core/error/error_handler.dart`**
   ```dart
   import 'dart:async';
   import 'dart:io';
   
   import 'package:dio/dio.dart';
   import 'package:flutter/foundation.dart';
   
   import '../logger/app_logger.dart';
   import 'failures.dart';
   
   /// Global error handler for the application.
   /// 
   /// Provides centralized error handling for:
   /// - Flutter framework errors
   /// - Platform dispatcher errors
   /// - Uncaught zone errors
   /// - API/Network errors
   /// 
   /// Also integrates with crash reporting services.
   class ErrorHandler {
     ErrorHandler._();
     
     /// Handles Flutter framework errors.
     /// 
     /// Called by FlutterError.onError.
     static void handleFlutterError(FlutterErrorDetails details) {
       AppLogger.error(
         'Flutter Error',
         error: details.exception,
         stackTrace: details.stack,
       );
       
       _reportToCrashService(
         details.exception,
         details.stack,
         reason: 'Flutter Framework Error',
       );
     }
     
     /// Handles platform dispatcher errors.
     /// 
     /// Called by PlatformDispatcher.instance.onError.
     static void handlePlatformError(Object error, StackTrace stackTrace) {
       AppLogger.error(
         'Platform Error',
         error: error,
         stackTrace: stackTrace,
       );
       
       _reportToCrashService(
         error,
         stackTrace,
         reason: 'Platform Dispatcher Error',
       );
     }
     
     /// Handles uncaught errors from runZonedGuarded.
     static void handleUncaughtError(Object error, StackTrace stackTrace) {
       AppLogger.error(
         'Uncaught Error',
         error: error,
         stackTrace: stackTrace,
       );
       
       _reportToCrashService(
         error,
         stackTrace,
         reason: 'Uncaught Zone Error',
       );
     }
     
     /// Converts exceptions to domain failures.
     /// 
     /// Use this to transform data layer exceptions into
     /// domain layer failures for the Either pattern.
     /// 
     /// Usage:
     /// ```dart
     /// try {
     ///   final result = await api.getData();
     ///   return Right(result);
     /// } catch (e, s) {
     ///   return Left(ErrorHandler.handleException(e, s));
     /// }
     /// ```
     static Failure handleException(Object exception, [StackTrace? stackTrace]) {
       AppLogger.error(
         'Handled Exception',
         error: exception,
         stackTrace: stackTrace,
       );
       
       // DioException handling
       if (exception is DioException) {
         return _handleDioException(exception);
       }
       
       // Socket/Network exceptions
       if (exception is SocketException) {
         return const NetworkFailure();
       }
       
       // Timeout exceptions
       if (exception is TimeoutException) {
         return const TimeoutFailure();
       }
       
       // Format exceptions (parsing errors)
       if (exception is FormatException) {
         return ServerFailure(
           message: 'Invalid response format: ${exception.message}',
           originalException: exception,
         );
       }
       
       // Type errors
       if (exception is TypeError) {
         _reportToCrashService(exception, stackTrace, reason: 'Type Error');
         return UnexpectedFailure(
           message: 'Data type mismatch error.',
           originalException: exception,
         );
       }
       
       // Default to unexpected failure
       _reportToCrashService(exception, stackTrace, reason: 'Unhandled Exception');
       return UnexpectedFailure(originalException: exception);
     }
     
     /// Handles Dio-specific exceptions.
     static Failure _handleDioException(DioException exception) {
       switch (exception.type) {
         case DioExceptionType.connectionTimeout:
         case DioExceptionType.sendTimeout:
         case DioExceptionType.receiveTimeout:
           return TimeoutFailure(originalException: exception);
           
         case DioExceptionType.cancel:
           return CancelledFailure(originalException: exception);
           
         case DioExceptionType.connectionError:
           return NetworkFailure(originalException: exception);
           
         case DioExceptionType.badResponse:
           return _handleBadResponse(exception);
           
         case DioExceptionType.badCertificate:
           return ServerFailure(
             message: 'Security certificate error. Please update the app.',
             originalException: exception,
           );
           
         case DioExceptionType.unknown:
           if (exception.error is SocketException) {
             return NetworkFailure(originalException: exception);
           }
           return UnexpectedFailure(originalException: exception);
       }
     }
     
     /// Handles bad response (HTTP errors).
     static Failure _handleBadResponse(DioException exception) {
       final statusCode = exception.response?.statusCode;
       final data = exception.response?.data;
       
       // Try to extract error message from response
       String message = 'Server error occurred.';
       if (data is Map<String, dynamic>) {
         message = data['message'] as String? ??
             data['error'] as String? ??
             message;
       }
       
       switch (statusCode) {
         case 400:
           return ValidationFailure(
             message: message,
             originalException: exception,
           );
           
         case 401:
           return UnauthenticatedFailure(
             message: message,
             originalException: exception,
           );
           
         case 403:
           return UnauthorizedFailure(
             message: message,
             originalException: exception,
           );
           
         case 404:
           return NotFoundFailure(
             message: message,
             originalException: exception,
           );
           
         case 409:
           return ConflictFailure(
             message: message,
             originalException: exception,
           );
           
         case 422:
           Map<String, String>? fieldErrors;
           if (data is Map<String, dynamic> && data['errors'] != null) {
             final errors = data['errors'] as Map<String, dynamic>;
             fieldErrors = errors.map(
               (key, value) => MapEntry(
                 key,
                 value is List ? value.first.toString() : value.toString(),
               ),
             );
           }
           return ValidationFailure(
             message: message,
             fieldErrors: fieldErrors,
             originalException: exception,
           );
           
         case 429:
           return ServerFailure(
             message: 'Too many requests. Please wait and try again.',
             statusCode: statusCode,
             originalException: exception,
           );
           
         case 500:
         case 502:
         case 503:
         case 504:
           return ServerFailure(
             message: 'Server is temporarily unavailable. Please try again later.',
             statusCode: statusCode,
             originalException: exception,
           );
           
         default:
           return ServerFailure(
             message: message,
             statusCode: statusCode,
             originalException: exception,
           );
       }
     }
     
     /// Reports error to crash reporting service.
     static void _reportToCrashService(
       Object error,
       StackTrace? stackTrace, {
       String? reason,
     }) {
       // TODO: Implement crash reporting
       // Examples:
       // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason);
       // Sentry.captureException(error, stackTrace: stackTrace);
       
       if (kDebugMode) {
         debugPrint('📊 Would report to crash service: $reason');
         debugPrint('Error: $error');
         if (stackTrace != null) {
           debugPrint('Stack: $stackTrace');
         }
       }
     }
   }
   ```

3. **Create `lib/core/error/error_boundary.dart`**
   ```dart
   import 'package:flutter/material.dart';
   
   import '../logger/app_logger.dart';
   
   /// Widget that catches and handles errors in its child widget tree.
   /// 
   /// Use this to wrap feature modules or sections of the app to prevent
   /// a single error from crashing the entire app.
   /// 
   /// Usage:
   /// ```dart
   /// ErrorBoundary(
   ///   onError: (error, stack) => analytics.logError(error),
   ///   child: FeatureModule(),
   /// )
   /// ```
   class ErrorBoundary extends StatefulWidget {
     /// The child widget tree to wrap.
     final Widget child;
     
     /// Optional callback when an error occurs.
     final void Function(Object error, StackTrace? stack)? onError;
     
     /// Optional custom error widget builder.
     final Widget Function(Object error, VoidCallback retry)? errorBuilder;
     
     const ErrorBoundary({
       super.key,
       required this.child,
       this.onError,
       this.errorBuilder,
     });
   
     @override
     State<ErrorBoundary> createState() => _ErrorBoundaryState();
   }
   
   class _ErrorBoundaryState extends State<ErrorBoundary> {
     Object? _error;
     StackTrace? _stackTrace;
   
     @override
     void initState() {
       super.initState();
     }
   
     void _handleError(Object error, StackTrace? stackTrace) {
       AppLogger.error(
         'ErrorBoundary caught error',
         error: error,
         stackTrace: stackTrace,
       );
       
       widget.onError?.call(error, stackTrace);
       
       if (mounted) {
         setState(() {
           _error = error;
           _stackTrace = stackTrace;
         });
       }
     }
   
     void _retry() {
       setState(() {
         _error = null;
         _stackTrace = null;
       });
     }
   
     @override
     Widget build(BuildContext context) {
       if (_error != null) {
         if (widget.errorBuilder != null) {
           return widget.errorBuilder!(_error!, _retry);
         }
         return _DefaultErrorWidget(
           error: _error!,
           onRetry: _retry,
         );
       }
       
       return _ErrorCatcher(
         onError: _handleError,
         child: widget.child,
       );
     }
   }
   
   /// Internal widget that catches errors during build.
   class _ErrorCatcher extends StatelessWidget {
     final Widget child;
     final void Function(Object error, StackTrace? stackTrace) onError;
   
     const _ErrorCatcher({
       required this.child,
       required this.onError,
     });
   
     @override
     Widget build(BuildContext context) {
       // Note: This catches errors during build phase.
       // For runtime errors, use additional error handling.
       ErrorWidget.builder = (FlutterErrorDetails details) {
         onError(details.exception, details.stack);
         return const SizedBox.shrink();
       };
       
       return child;
     }
   }
   
   /// Default error widget shown when ErrorBoundary catches an error.
   class _DefaultErrorWidget extends StatelessWidget {
     final Object error;
     final VoidCallback onRetry;
   
     const _DefaultErrorWidget({
       required this.error,
       required this.onRetry,
     });
   
     @override
     Widget build(BuildContext context) {
       final theme = Theme.of(context);
       
       return Center(
         child: Padding(
           padding: const EdgeInsets.all(24),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(
                 Icons.error_outline,
                 size: 64,
                 color: theme.colorScheme.error,
               ),
               const SizedBox(height: 16),
               Text(
                 'Something went wrong',
                 style: theme.textTheme.titleLarge,
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 8),
               Text(
                 'An unexpected error occurred. Please try again.',
                 style: theme.textTheme.bodyMedium?.copyWith(
                   color: theme.colorScheme.onSurfaceVariant,
                 ),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 24),
               FilledButton.icon(
                 onPressed: onRetry,
                 icon: const Icon(Icons.refresh),
                 label: const Text('Retry'),
               ),
             ],
           ),
         ),
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] All error types are defined
- [ ] Errors are properly logged
- [ ] Error boundary catches widget errors
- [ ] Crash reporting integration point exists
- [ ] API errors map to correct failure types

---

### Task 0.6: CI/CD Pipeline Setup

**Estimated Time:** 2-3 days

#### Objectives
- Set up GitHub Actions workflows
- Configure automated testing
- Set up build pipelines for all flavors
- Configure code quality checks

#### Implementation Steps

1. **Create `.github/workflows/ci.yml`**
   ```yaml
   # Continuous Integration workflow
   # Runs on every push and pull request
   
   name: CI
   
   on:
     push:
       branches: [main, dev]
     pull_request:
       branches: [main, dev]
   
   concurrency:
     group: ${{ github.workflow }}-${{ github.ref }}
     cancel-in-progress: true
   
   jobs:
     # ==================== Code Quality ====================
     quality:
       name: Code Quality
       runs-on: ubuntu-latest
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.24.0'
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Verify formatting
           run: dart format --output=none --set-exit-if-changed .
         
         - name: Analyze code
           run: flutter analyze --fatal-infos
         
         - name: Check for outdated packages
           run: flutter pub outdated
           continue-on-error: true
   
     # ==================== Unit Tests ====================
     test:
       name: Unit Tests
       runs-on: ubuntu-latest
       needs: quality
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.24.0'
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Run build_runner
           run: dart run build_runner build --delete-conflicting-outputs
         
         - name: Run tests with coverage
           run: flutter test --coverage
         
         - name: Upload coverage to Codecov
           uses: codecov/codecov-action@v4
           with:
             file: coverage/lcov.info
             fail_ci_if_error: false
   
     # ==================== Build Android ====================
     build-android:
       name: Build Android
       runs-on: ubuntu-latest
       needs: test
       strategy:
         matrix:
           flavor: [dev, staging, prod]
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Java
           uses: actions/setup-java@v4
           with:
             distribution: 'zulu'
             java-version: '17'
             cache: 'gradle'
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.24.0'
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Run build_runner
           run: dart run build_runner build --delete-conflicting-outputs
         
         - name: Build APK
           run: flutter build apk --flavor=${{ matrix.flavor }} --dart-define=FLAVOR=${{ matrix.flavor }}
         
         - name: Upload APK artifact
           uses: actions/upload-artifact@v4
           with:
             name: android-${{ matrix.flavor }}-apk
             path: build/app/outputs/flutter-apk/app-${{ matrix.flavor }}-release.apk
             retention-days: 7
   
     # ==================== Build iOS ====================
     build-ios:
       name: Build iOS
       runs-on: macos-latest
       needs: test
       strategy:
         matrix:
           flavor: [dev, staging, prod]
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.24.0'
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Run build_runner
           run: dart run build_runner build --delete-conflicting-outputs
         
         - name: Build iOS (no codesign)
           run: flutter build ios --flavor=${{ matrix.flavor }} --dart-define=FLAVOR=${{ matrix.flavor }} --no-codesign
         
         # Note: For actual releases, you'd need to set up code signing
         # and build an IPA file
   
     # ==================== Build Web ====================
     build-web:
       name: Build Web
       runs-on: ubuntu-latest
       needs: test
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.24.0'
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Run build_runner
           run: dart run build_runner build --delete-conflicting-outputs
         
         - name: Build Web
           run: flutter build web --release
         
         - name: Upload Web artifact
           uses: actions/upload-artifact@v4
           with:
             name: web-build
             path: build/web
             retention-days: 7
   ```

2. **Create `.github/workflows/release.yml`**
   ```yaml
   # Release workflow
   # Triggered manually or on tag push
   
   name: Release
   
   on:
     push:
       tags:
         - 'v*'
     workflow_dispatch:
       inputs:
         flavor:
           description: 'Build flavor'
           required: true
           default: 'prod'
           type: choice
           options:
             - dev
             - staging
             - prod
         platform:
           description: 'Target platform'
           required: true
           default: 'all'
           type: choice
           options:
             - all
             - android
             - ios
             - web
   
   jobs:
     # ==================== Prepare Release ====================
     prepare:
       name: Prepare Release
       runs-on: ubuntu-latest
       outputs:
         version: ${{ steps.version.outputs.version }}
         flavor: ${{ steps.params.outputs.flavor }}
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Extract version
           id: version
           run: |
             if [[ "${{ github.ref }}" == refs/tags/* ]]; then
               VERSION=${GITHUB_REF#refs/tags/v}
             else
               VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //')
             fi
             echo "version=$VERSION" >> $GITHUB_OUTPUT
         
         - name: Set parameters
           id: params
           run: |
             if [[ "${{ github.event_name }}" == "workflow_dispatch" ]]; then
               echo "flavor=${{ github.event.inputs.flavor }}" >> $GITHUB_OUTPUT
             else
               echo "flavor=prod" >> $GITHUB_OUTPUT
             fi
   
     # ==================== Build Release Android ====================
     release-android:
       name: Release Android
       runs-on: ubuntu-latest
       needs: prepare
       if: github.event.inputs.platform == 'all' || github.event.inputs.platform == 'android' || github.event_name == 'push'
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Java
           uses: actions/setup-java@v4
           with:
             distribution: 'zulu'
             java-version: '17'
             cache: 'gradle'
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.24.0'
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Run build_runner
           run: dart run build_runner build --delete-conflicting-outputs
         
         # Decode keystore for signing
         - name: Decode Keystore
           env:
             KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
           run: |
             echo $KEYSTORE_BASE64 | base64 --decode > android/app/release-keystore.jks
         
         # Create key.properties
         - name: Create key.properties
           env:
             KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
             KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
             KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
           run: |
             echo "storePassword=$KEYSTORE_PASSWORD" > android/key.properties
             echo "keyPassword=$KEY_PASSWORD" >> android/key.properties
             echo "keyAlias=$KEY_ALIAS" >> android/key.properties
             echo "storeFile=release-keystore.jks" >> android/key.properties
         
         - name: Build App Bundle
           run: |
             flutter build appbundle \
               --flavor=${{ needs.prepare.outputs.flavor }} \
               --dart-define=FLAVOR=${{ needs.prepare.outputs.flavor }} \
               --build-number=${{ github.run_number }}
         
         - name: Upload to Play Store
           uses: r0adkll/upload-google-play@v1
           with:
             serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT_JSON }}
             packageName: com.example.baseapp.${{ needs.prepare.outputs.flavor }}
             releaseFiles: build/app/outputs/bundle/${{ needs.prepare.outputs.flavor }}Release/app-${{ needs.prepare.outputs.flavor }}-release.aab
             track: internal
             status: draft
   
     # ==================== Build Release iOS ====================
     release-ios:
       name: Release iOS
       runs-on: macos-latest
       needs: prepare
       if: github.event.inputs.platform == 'all' || github.event.inputs.platform == 'ios' || github.event_name == 'push'
       
       steps:
         - name: Checkout code
           uses: actions/checkout@v4
         
         - name: Setup Flutter
           uses: subosito/flutter-action@v2
           with:
             flutter-version: '3.24.0'
             channel: 'stable'
             cache: true
         
         - name: Install dependencies
           run: flutter pub get
         
         - name: Run build_runner
           run: dart run build_runner build --delete-conflicting-outputs
         
         # Install Apple certificate and provisioning profile
         - name: Install Apple Certificate
           env:
             BUILD_CERTIFICATE_BASE64: ${{ secrets.APPLE_BUILD_CERTIFICATE_BASE64 }}
             P12_PASSWORD: ${{ secrets.APPLE_P12_PASSWORD }}
             KEYCHAIN_PASSWORD: ${{ secrets.APPLE_KEYCHAIN_PASSWORD }}
           run: |
             # Create variables
             CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
             KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db
             
             # Import certificate
             echo -n "$BUILD_CERTIFICATE_BASE64" | base64 --decode -o $CERTIFICATE_PATH
             
             # Create temporary keychain
             security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
             security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
             security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
             
             # Import certificate to keychain
             security import $CERTIFICATE_PATH -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
             security list-keychain -d user -s $KEYCHAIN_PATH
         
         - name: Install Provisioning Profile
           env:
             PROVISIONING_PROFILE_BASE64: ${{ secrets.APPLE_PROVISIONING_PROFILE_BASE64 }}
           run: |
             PP_PATH=$RUNNER_TEMP/build_pp.mobileprovision
             echo -n "$PROVISIONING_PROFILE_BASE64" | base64 --decode -o $PP_PATH
             mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
             cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles
         
         - name: Build IPA
           run: |
             flutter build ipa \
               --flavor=${{ needs.prepare.outputs.flavor }} \
               --dart-define=FLAVOR=${{ needs.prepare.outputs.flavor }} \
               --build-number=${{ github.run_number }} \
               --export-options-plist=ios/ExportOptions.plist
         
         - name: Upload to App Store Connect
           env:
             APP_STORE_CONNECT_API_KEY_ID: ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
             APP_STORE_CONNECT_API_ISSUER_ID: ${{ secrets.APP_STORE_CONNECT_API_ISSUER_ID }}
             APP_STORE_CONNECT_API_KEY_BASE64: ${{ secrets.APP_STORE_CONNECT_API_KEY_BASE64 }}
           run: |
             xcrun altool --upload-app \
               --type ios \
               --file build/ios/ipa/*.ipa \
               --apiKey $APP_STORE_CONNECT_API_KEY_ID \
               --apiIssuer $APP_STORE_CONNECT_API_ISSUER_ID
   
     # ==================== Create GitHub Release ====================
     github-release:
       name: Create GitHub Release
       runs-on: ubuntu-latest
       needs: [prepare, release-android, release-ios]
       if: github.event_name == 'push' && startsWith(github.ref, 'refs/tags/')
       
       steps:
         - name: Download Android artifact
           uses: actions/download-artifact@v4
           with:
             name: android-prod-apk
             path: artifacts
         
         - name: Create Release
           uses: softprops/action-gh-release@v1
           with:
             name: Release v${{ needs.prepare.outputs.version }}
             body: |
               ## What's New
               
               See [CHANGELOG.md](CHANGELOG.md) for details.
               
               ## Downloads
               
               - **Android APK**: Attached to this release
               - **Google Play**: [Download from Play Store](https://play.google.com/store/apps/details?id=com.example.baseapp)
               - **App Store**: [Download from App Store](https://apps.apple.com/app/baseapp/id123456789)
             files: |
               artifacts/*.apk
             draft: false
             prerelease: false
   ```

3. **Create `.github/PULL_REQUEST_TEMPLATE.md`**
   ```markdown
   ## Description
   
   <!-- Describe your changes in detail -->
   
   ## Type of Change
   
   <!-- Mark the appropriate option with an [x] -->
   
   - [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
   - [ ] ✨ New feature (non-breaking change which adds functionality)
   - [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
   - [ ] 📚 Documentation update
   - [ ] 🔧 Configuration change
   - [ ] ♻️ Refactoring (no functional changes)
   - [ ] 🧪 Test update
   
   ## Related Issues
   
   <!-- Link to related issues: Fixes #123, Closes #456 -->
   
   ## Checklist
   
   <!-- Mark completed items with an [x] -->
   
   - [ ] My code follows the project's coding guidelines
   - [ ] I have performed a self-review of my code
   - [ ] I have commented my code, particularly in hard-to-understand areas
   - [ ] I have made corresponding changes to the documentation
   - [ ] My changes generate no new warnings
   - [ ] I have added tests that prove my fix is effective or that my feature works
   - [ ] New and existing unit tests pass locally with my changes
   - [ ] Any dependent changes have been merged and published
   
   ## Screenshots (if applicable)
   
   <!-- Add screenshots to help explain your changes -->
   
   ## Testing Instructions
   
   <!-- Describe how to test your changes -->
   
   1. 
   2. 
   3. 
   
   ## Additional Notes
   
   <!-- Any additional information that reviewers should know -->
   ```

#### Acceptance Criteria
- [ ] CI runs on every push and PR
- [ ] All flavors build successfully
- [ ] Tests run with coverage reporting
- [ ] Code quality checks pass
- [ ] Release workflow is functional

---

## 📊 Phase 0 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 0.1 Project Structure | ⬜ | |
| 0.2 Environment & Flavors | ⬜ | |
| 0.3 Theme System | ⬜ | |
| 0.4 Navigation & Routing | ⬜ | |
| 0.5 Error Handling | ⬜ | |
| 0.6 CI/CD Pipeline | ⬜ | |

---

## 🔗 Dependencies for Next Phase

Phase 1 requires the following from Phase 0:
- ✅ Project structure and DI setup
- ✅ Theme system for consistent UI
- ✅ Router for navigation
- ✅ Error handling for API calls
- ✅ CI/CD for automated testing

---

## 📝 Notes

- All code follows Clean Architecture principles
- Each module should be independently testable
- Theme and config should be environment-aware
- Router guards are prepared for auth implementation in Phase 1
