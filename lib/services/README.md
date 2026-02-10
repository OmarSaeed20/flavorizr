# Services Module

The services module provides application-level services including Firebase integration, analytics, and crashlytics for the Fast Golden Taxi application.

## 📁 Directory Structure

```
lib/services/
├── firebase_service.dart    # Firebase initialization and configuration
└── analytics/               # Analytics and crashlytics services
    ├── analytics_service.dart
    └── crashlytics_service.dart
```

## 🎯 Key Components

### 1. FirebaseService (`firebase_service.dart`)

Firebase initialization and configuration service.

**Features:**
- Firebase initialization
- Firebase options configuration
- Firebase auth setup
- Firebase analytics setup
- Firebase crashlytics setup
- Firebase messaging setup
- Firebase remote config setup

**Usage:**
```dart
// Initialize Firebase
await FirebaseService.initialize();

// Get Firebase app
final app = FirebaseService.app;

// Get Firebase auth
final auth = FirebaseService.auth;

// Get Firebase analytics
final analytics = FirebaseService.analytics;
```

**FirebaseService:**
```dart
class FirebaseService {
  static FirebaseApp? _app;
  static FirebaseAuth? _auth;
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebaseMessaging? _messaging;
  static FirebaseRemoteConfig? _remoteConfig;

  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      // Initialize Firebase app
      _app = await Firebase.initializeApp(
        options: _getFirebaseOptions(),
      );

      // Initialize Firebase auth
      _auth = FirebaseAuth.instanceFor(app: _app!);

      // Initialize Firebase analytics
      _analytics = FirebaseAnalytics.instanceFor(app: _app!);

      // Initialize Firebase crashlytics
      _crashlytics = FirebaseCrashlytics.instanceFor(app: _app!);

      // Initialize Firebase messaging
      _messaging = FirebaseMessaging.instanceFor(app: _app!);

      // Initialize Firebase remote config
      _remoteConfig = FirebaseRemoteConfig.instanceFor(app: _app!);

      // Configure crashlytics
      await _configureCrashlytics();

      // Configure messaging
      await _configureMessaging();

      // Configure remote config
      await _configureRemoteConfig();

      // Log app open
      await _analytics?.logAppOpen();
    } catch (e) {
      throw Exception('Failed to initialize Firebase: $e');
    }
  }

  // Get Firebase options based on flavor
  static FirebaseOptions _getFirebaseOptions() {
    final flavor = AppConfig.instance.flavor;

    switch (flavor) {
      case Flavor.dev:
        return const FirebaseOptions(
          apiKey: 'dev-api-key',
          appId: 'dev-app-id',
          messagingSenderId: 'dev-sender-id',
          projectId: 'dev-project-id',
        );
      case Flavor.staging:
        return const FirebaseOptions(
          apiKey: 'staging-api-key',
          appId: 'staging-app-id',
          messagingSenderId: 'staging-sender-id',
          projectId: 'staging-project-id',
        );
      case Flavor.prod:
        return const FirebaseOptions(
          apiKey: 'prod-api-key',
          appId: 'prod-app-id',
          messagingSenderId: 'prod-sender-id',
          projectId: 'prod-project-id',
        );
    }
  }

  // Configure crashlytics
  static Future<void> _configureCrashlytics() async {
    await _crashlytics?.setCrashlyticsCollectionEnabled(true);
    await _crashlytics?.setUserIdentifier('user-id');
  }

  // Configure messaging
  static Future<void> _configureMessaging() async {
    await _messaging?.requestPermission();
    await _messaging?.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Configure remote config
  static Future<void> _configureRemoteConfig() async {
    await _remoteConfig?.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _remoteConfig?.fetchAndActivate();
  }

  // Getters
  static FirebaseApp get app => _app!;
  static FirebaseAuth get auth => _auth!;
  static FirebaseAnalytics get analytics => _analytics!;
  static FirebaseCrashlytics get crashlytics => _crashlytics!;
  static FirebaseMessaging get messaging => _messaging!;
  static FirebaseRemoteConfig get remoteConfig => _remoteConfig!;
}
```

### 2. AnalyticsService (`analytics/analytics_service.dart`)

Analytics service for tracking user behavior and app events.

**Features:**
- Event tracking
- User properties
- Screen tracking
- Conversion tracking
- Custom events

**Usage:**
```dart
// Track event
await analyticsService.logEvent('button_clicked', {
  'button_name': 'submit',
});

// Set user property
await analyticsService.setUserProperty('user_type', 'premium');

// Track screen view
await analyticsService.logScreenView('HomeScreen');
```

**AnalyticsService:**
```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  // Log event
  Future<void> logEvent(
    String name, {
    Map<String, Object?>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Set user property
  Future<void> setUserProperty(
    String name,
    String? value,
  ) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // Set user ID
  Future<void> setUserId(String? id) async {
    await _analytics.setUserId(id);
  }

  // Log screen view
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  // Log app open
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  // Log login
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // Log sign up
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // Log purchase
  Future<void> logPurchase({
    required String itemId,
    required double price,
    required int quantity,
    String? currency,
  }) async {
    await _analytics.logEcommercePurchase(
      value: price * quantity,
      currency: currency ?? 'USD',
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          price: price,
          quantity: quantity,
        ),
      ],
    );
  }

  // Log search
  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  // Log share
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method,
    );
  }
}
```

### 3. CrashlyticsService (`analytics/crashlytics_service.dart`)

Crashlytics service for error reporting and crash tracking.

**Features:**
- Crash reporting
- Error logging
- Custom keys
- User identifiers
- Non-fatal errors

**Usage:**
```dart
// Log error
await crashlyticsService.logError(error, stackTrace);

// Set user identifier
await crashlyticsService.setUserId('user-id');

// Set custom key
await crashlyticsService.setCustomKey('key', 'value');
```

**CrashlyticsService:**
```dart
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService(this._crashlytics);

  // Record error
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
    bool isUnhandled = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      fatal: fatal,
      isUnhandled: isUnhandled,
    );
  }

  // Log error
  Future<void> logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? message,
    Map<String, dynamic>? context,
  }) async {
    if (message != null) {
      await _crashlytics.log(message);
    }

    if (context != null) {
      for (final entry in context.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value.toString());
      }
    }

    await _crashlytics.recordError(
      error,
      stackTrace,
      fatal: false,
    );
  }

  // Set user identifier
  Future<void> setUserId(String? identifier) async {
    await _crashlytics.setUserId(identifier);
  }

  // Set custom key
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  // Log message
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  // Check if crashlytics is enabled
  Future<bool> isEnabled() async {
    return await _crashlytics.isCrashlyticsCollectionEnabled();
  }

  // Enable/disable crashlytics
  Future<void> setEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  // Send uncaught errors
  Future<void> sendUncaughtError(
    dynamic error,
    StackTrace stack,
  ) async {
    await _crashlytics.recordError(
      error,
      stack,
      fatal: true,
      isUnhandled: true,
    );
  }
}
```

## 🏗️ Architecture

### Firebase Initialization Flow

```
1. App starts
2. Bootstrap initializes Firebase
3. Firebase app created
4. Firebase services initialized
5. Firebase configured
6. Firebase ready for use
```

### Analytics Flow

```
1. User action occurs
2. Analytics service called
3. Event logged
4. Event sent to Firebase
5. Analytics dashboard updated
```

### Crashlytics Flow

```
1. Error occurs
2. Error caught
3. Error logged to crashlytics
4. Error sent to Firebase
5. Crashlytics dashboard updated
```

## 📝 Best Practices

### 1. Initialize Firebase Early

```dart
// Good
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}

// Bad
void main() {
  runApp(MyApp());
  // Firebase initialized later
}
```

### 2. Track Important Events

```dart
// Good
await analyticsService.logEvent('purchase_completed', {
  'item_id': itemId,
  'price': price,
});

// Bad
// Don't track events
```

### 3. Log All Errors

```dart
// Good
try {
  await riskyOperation();
} catch (e, stack) {
  await crashlyticsService.logError(e, stack);
}

// Bad
try {
  await riskyOperation();
} catch (e) {
  print(e);
}
```

### 4. Set User Identifiers

```dart
// Good
await analyticsService.setUserId(userId);
await crashlyticsService.setUserId(userId);

// Bad
// Don't set user identifiers
```

### 5. Use Remote Config

```dart
// Good
final featureEnabled = await FirebaseService.remoteConfig.getBool('feature_enabled');

// Bad
final featureEnabled = true; // Hardcoded
```

## 🔧 Usage Examples

### Firebase Initialization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.initialize();

  // Initialize other services
  await initializeServices();

  runApp(MyApp());
}
```

### Tracking User Events

```dart
class PurchaseButton extends ConsumerWidget {
  final String itemId;
  final double price;

  const PurchaseButton({
    super.key,
    required this.itemId,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsService = ref.watch(analyticsServiceProvider);

    return ElevatedButton(
      onPressed: () async {
        // Track purchase event
        await analyticsService.logPurchase(
          itemId: itemId,
          price: price,
          quantity: 1,
        );

        // Complete purchase
        await completePurchase(itemId);
      },
      child: const Text('Purchase'),
    );
  }
}
```

### Error Handling with Crashlytics

```dart
class DataRepository {
  final CrashlyticsService crashlyticsService;

  DataRepository(this.crashlyticsService);

  Future<Data> fetchData() async {
    try {
      final response = await apiClient.get('/data');
      return Data.fromJson(response.data);
    } catch (e, stack) {
      // Log error to crashlytics
      await crashlyticsService.logError(
        e,
        stack,
        message: 'Failed to fetch data',
        context: {
          'endpoint': '/data',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      rethrow;
    }
  }
}
```

### Screen Tracking

```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logScreenView('MyPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My Page'),
      ),
    );
  }
}
```

### User Properties

```dart
class UserProfilePage extends ConsumerWidget {
  final User user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsService = ref.watch(analyticsServiceProvider);

    useEffect(() {
      // Set user properties
      analyticsService.setUserProperty('user_type', user.type);
      analyticsService.setUserProperty('subscription', user.subscription);
      analyticsService.setUserId(user.id);
      return null;
    }, [user]);

    return Scaffold(
      body: Center(
        child: Text('User Profile'),
      ),
    );
  }
}
```

### Remote Config

```dart
class FeatureFlagService {
  final FirebaseRemoteConfig _remoteConfig;

  FeatureFlagService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.fetchAndActivate();
  }

  bool get isNewFeatureEnabled {
    return _remoteConfig.getBool('new_feature_enabled');
  }

  String get welcomeMessage {
    return _remoteConfig.getString('welcome_message');
  }

  int get maxItems {
    return _remoteConfig.getInt('max_items');
  }
}
```

## 🧪 Testing

### Mocking Firebase Services

```dart
class MockAnalyticsService extends Mock implements AnalyticsService {}

test('PurchaseButton should track purchase event', () async {
  final mockAnalyticsService = MockAnalyticsService();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
      ],
      child: MaterialApp(
        home: PurchaseButton(
          itemId: 'item1',
          price: 9.99,
        ),
      ),
    ),
  );

  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();

  verify(mockAnalyticsService.logPurchase(
    itemId: 'item1',
    price: 9.99,
    quantity: 1,
  )).called(1);
});
```

## 📚 Additional Resources

- [Firebase Flutter](https://firebase.flutter.dev/)
- [Firebase Analytics](https://firebase.google.com/docs/analytics)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)
- [Firebase Remote Config](https://firebase.google.com/docs/remote-config)

## 🤝 Contributing

When adding Firebase features:

1. Test on all platforms
2. Handle errors gracefully
3. Use appropriate Firebase services
4. Update documentation
5. Add tests

## 📄 License

This module is part of the Fast Golden Taxi project.