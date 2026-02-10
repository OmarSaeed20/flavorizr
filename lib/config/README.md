# Configuration Module

The configuration module provides environment-specific settings, flavor management, and Firebase configuration for the Fast Golden Taxi application.

## 📁 Directory Structure

```
lib/config/
├── app_config.dart           # Application configuration
├── flavors.dart              # Flavor definitions and extensions
└── firebase/                 # Firebase configuration
    ├── firebase_config.dart  # Firebase setup
    └── firebase_options/     # Per-flavor Firebase options
        ├── firebase_options_dev.dart
        ├── firebase_options_staging.dart
        └── firebase_options_prod.dart
```

## 🎯 Key Components

### 1. Flavors (`flavors.dart`)

Flavor definitions for different environments (dev, staging, prod).

**Flavor Types:**
- `dev` - Development environment
- `staging` - Staging environment
- `prod` - Production environment

**Features:**
- Environment-specific URLs
- Feature flags
- App identifiers
- Display names

**Usage:**
```dart
// Get current flavor
final flavor = F.appFlavor;

// Check flavor type
if (flavor.isProduction) {
  // Production-specific code
}

if (flavor.isDevelopment) {
  // Development-specific code
}

// Get flavor name
final name = F.name; // 'dev', 'staging', or 'prod'

// Get app title
final title = F.title; // 'Fast Golden Taxi Dev', etc.
```

**Flavor Extensions:**

```dart
extension FlavorExtension on Flavor {
  // Environment checks
  bool get isProduction => this == Flavor.prod;
  bool get isStaging => this == Flavor.staging;
  bool get isDevelopment => this == Flavor.dev;

  // Display names
  String get name => switch (this) {
    Flavor.dev => 'dev',
    Flavor.staging => 'staging',
    Flavor.prod => 'prod',
  };

  String get displayName => switch (this) {
    Flavor.dev => 'Development',
    Flavor.staging => 'Staging',
    Flavor.prod => 'Production',
  };

  // App identifiers
  String get appNameSuffix => switch (this) {
    Flavor.dev => ' Dev',
    Flavor.staging => ' Staging',
    Flavor.prod => '',
  };

  // URLs
  String get baseUrl => switch (this) {
    Flavor.dev => 'https://fasttaxi.questifysolutions.com/api/v1',
    Flavor.staging => 'https://fasttaxi.questifysolutions.com/api/v1',
    Flavor.prod => 'https://fasttaxi.questifysolutions.com/api/v1',
  };

  String get wsUrl => switch (this) {
    Flavor.dev => 'wss://fasttaxi.questifysolutions.com/ws',
    Flavor.staging => 'wss://fasttaxi.questifysolutions.com/ws',
    Flavor.prod => 'wss://fasttaxi.questifysolutions.com/ws',
  };

  // Feature flags
  bool get enableLogging => switch (this) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => kDebugMode,
  };

  bool get enableAnalytics => switch (this) {
    Flavor.dev => false,
    Flavor.staging => true,
    Flavor.prod => true,
  };

  bool get enableCrashReporting => switch (this) {
    Flavor.dev => false,
    Flavor.staging => true,
    Flavor.prod => true,
  };

  bool get enablePerformanceMonitoring => switch (this) {
    Flavor.dev => false,
    Flavor.staging => true,
    Flavor.prod => true,
  };

  // UI settings
  bool get showDebugBanner => switch (this) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => false,
  };

  bool get showPerformanceOverlay => switch (this) {
    Flavor.dev => true,
    Flavor.staging => false,
    Flavor.prod => false,
  };

  // Timeouts
  Duration get connectionTimeout => switch (this) {
    Flavor.dev => const Duration(seconds: 30),
    Flavor.staging => const Duration(seconds: 30),
    Flavor.prod => const Duration(seconds: 30),
  };

  Duration get receiveTimeout => switch (this) {
    Flavor.dev => const Duration(seconds: 30),
    Flavor.staging => const Duration(seconds: 30),
    Flavor.prod => const Duration(seconds: 30),
  };

  // Retry settings
  int get maxRetryAttempts => switch (this) {
    Flavor.dev => 3,
    Flavor.staging => 3,
    Flavor.prod => 3,
  };
}
```

### 2. AppConfig (`app_config.dart`)

Application configuration that varies by environment.

**Features:**
- Singleton pattern
- Environment-specific settings
- Feature flags
- Timeout configurations

**Usage:**
```dart
// Initialize configuration
AppConfig.initialize(flavor);

// Access configuration
final config = AppConfig.instance;

// Get settings
final baseUrl = config.apiBaseUrl;
final wsBaseUrl = config.wsBaseUrl;
final enableLogging = config.enableLogging;
final connectionTimeout = config.connectionTimeout;
```

**Configuration Properties:**

```dart
class AppConfig {
  // Environment
  final Flavor flavor;

  // URLs
  final String apiBaseUrl;
  final String wsBaseUrl;

  // UI settings
  final bool showDebugBanner;
  final bool showPerformanceOverlay;

  // Timeouts
  final int connectionTimeout;
  final int receiveTimeout;

  // Retry settings
  final int maxRetryAttempts;

  // Feature flags
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enablePerformanceMonitoring;
}
```

### 3. FirebaseConfig (`firebase_config.dart`)

Firebase configuration and initialization.

**Features:**
- Per-flavor Firebase options
- Firebase initialization
- Project ID access
- Flavor-specific configuration

**Usage:**
```dart
// Initialize Firebase
await FirebaseConfig.setup();

// Get project ID
final projectId = FirebaseConfig.projectId;

// Get flavor name
final flavorName = FirebaseConfig.flavorName;

// Get flavor display name
final flavorDisplayName = FirebaseConfig.flavorDisplayName;
```

**Firebase Options:**

```dart
static FirebaseOptions getFirebaseOptions() => switch (F.appFlavor) {
  Flavor.dev => fb_options_dev.DefaultFirebaseOptions.currentPlatform,
  Flavor.staging => fb_options_staging.DefaultFirebaseOptions.currentPlatform,
  Flavor.prod => fb_options_prod.DefaultFirebaseOptions.currentPlatform,
};
```

## 🏗️ Architecture

### Configuration Flow

```
1. App starts
2. Determine flavor from build configuration
3. Initialize AppConfig with flavor
4. Initialize Firebase with flavor-specific options
5. Use configuration throughout app
```

### Flavor Detection

```dart
// In main.dart
void main() {
  // Determine flavor from platform
  final flavor = Flavor.values.firstWhere(
    (f) => f.name == appFlavor,
    orElse: () => Flavor.dev,
  );

  // Bootstrap with flavor
  bootstrap(flavor);
}
```

## 📝 Best Practices

### 1. Use Flavor Extensions

```dart
// Good
if (F.appFlavor.isProduction) {
  // Production code
}

// Bad
if (F.appFlavor == Flavor.prod) {
  // Production code
}
```

### 2. Use AppConfig for Settings

```dart
// Good
final config = AppConfig.instance;
if (config.enableLogging) {
  // Log something
}

// Bad
if (F.appFlavor.enableLogging) {
  // Log something
}
```

### 3. Initialize Firebase Early

```dart
// In bootstrap.dart
await FirebaseConfig.setup();
```

### 4. Use Feature Flags

```dart
// Good
if (AppConfig.instance.enableAnalytics) {
  // Track analytics
}

// Bad
if (F.appFlavor != Flavor.dev) {
  // Track analytics
}
```

## 🔧 Configuration

### Flavor Configuration

The app uses `flutter_flavorizr` for multi-flavor builds.

**Build Commands:**

```bash
# Development
flutter run --flavor=dev --dart-define=FLAVOR=dev

# Staging
flutter run --flavor=staging --dart-define=FLAVOR=staging

# Production
flutter run --flavor=prod --dart-define=FLAVOR=prod
```

**Build APK:**

```bash
# Development
flutter build apk --flavor=dev --dart-define=FLAVOR=dev

# Staging
flutter build apk --flavor=staging --dart-define=FLAVOR=staging

# Production
flutter build apk --flavor=prod --dart-define=FLAVOR=prod
```

**Build iOS:**

```bash
# Development
flutter build ios --flavor=dev --dart-define=FLAVOR=dev

# Staging
flutter build ios --flavor=staging --dart-define=FLAVOR=staging

# Production
flutter build ios --flavor=prod --dart-define=FLAVOR=prod
```

### Firebase Configuration

Generate Firebase options for each flavor:

```bash
# Development
flutterfire configure --project=fasttaxi-dev \
  --out=lib/config/firebase/firebase_options/firebase_options_dev.dart \
  --ios-bundle-id=com.fastgoldentaxi.dev \
  --android-app-id=com.fastgoldentaxi.dev

# Staging
flutterfire configure --project=fasttaxi-staging \
  --out=lib/config/firebase/firebase_options/firebase_options_staging.dart \
  --ios-bundle-id=com.fastgoldentaxi.staging \
  --android-app-id=com.fastgoldentaxi.staging

# Production
flutterfire configure --project=fasttaxi-prod \
  --out=lib/config/firebase/firebase_options/firebase_options_prod.dart \
  --ios-bundle-id=com.fastgoldentaxi \
  --android-app-id=com.fastgoldentaxi
```

### Flavorizr Configuration

`flavorizr.yaml`:

```yaml
flavors:
  dev:
    app:
      name: "Fast Golden Taxi Dev"
    android:
      applicationId: "com.fastgoldentaxi.dev"
    ios:
      bundleId: "com.fastgoldentaxi.dev"
  staging:
    app:
      name: "Fast Golden Taxi Staging"
    android:
      applicationId: "com.fastgoldentaxi.staging"
    ios:
      bundleId: "com.fastgoldentaxi.staging"
  prod:
    app:
      name: "Fast Golden Taxi"
    android:
      applicationId: "com.fastgoldentaxi"
    ios:
      bundleId: "com.fastgoldentaxi"
```

## 🧪 Testing

### Unit Tests

```dart
test('FlavorExtension should return correct values', () {
  expect(Flavor.dev.isDevelopment, true);
  expect(Flavor.dev.isProduction, false);
  expect(Flavor.dev.name, 'dev');
});

test('AppConfig should initialize correctly', () {
  final config = AppConfig.forFlavor(Flavor.dev);
  expect(config.flavor, Flavor.dev);
  expect(config.apiBaseUrl, 'https://fasttaxi.questifysolutions.com/api/v1');
});
```

### Widget Tests

```dart
testWidgets('Should show debug banner in dev', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        flavorProvider.overrideWith((ref) => Flavor.dev),
      ],
      child: const App(),
    ),
  );

  expect(find.byType(Banner), findsOneWidget);
});
```

## 📚 Additional Resources

- [Flutter Flavorizr](https://pub.dev/packages/flutter_flavorizr)
- [Firebase Flutter](https://firebase.flutter.dev)
- [Flutter Configuration](https://flutter.dev/docs/deployment/flavors)

## 🤝 Contributing

When adding new configuration:

1. Add to `FlavorExtension` if flavor-specific
2. Add to `AppConfig` if app-wide
3. Update documentation
4. Add tests

## 📄 License

This module is part of the Fast Golden Taxi project.