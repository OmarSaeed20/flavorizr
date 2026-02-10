# Services Module

The services module provides core services for the Fast Golden Taxi application, including notification service, authentication service, and other platform-specific services.

## 📁 Directory Structure

```
lib/core/services/
├── notification_service.dart  # FCM and local notifications
├── auth_service.dart          # Authentication service
├── storage_service.dart       # Storage service
└── analytics_service.dart     # Analytics service
```

## 🎯 Key Components

### 1. NotificationService (`notification_service.dart`)

FCM and local notifications service with comprehensive notification handling.

**Features:**
- Firebase Cloud Messaging (FCM)
- Local notifications
- Foreground/background/terminated handling
- Deep links
- Permission management
- Notification channels
- Notification scheduling

**Usage:**
```dart
// Get service instance
final notificationService = NotificationService.instance;

// Initialize service
await notificationService.initialize();

// Request permissions
final granted = await notificationService.requestPermissions();

// Show local notification
await notificationService.showNotification(
  id: 1,
  title: 'New Message',
  body: 'You have a new message',
  payload: 'message_id',
);

// Schedule notification
await notificationService.scheduleNotification(
  id: 2,
  title: 'Reminder',
  body: 'Don\'t forget to check your ride',
  scheduledDate: DateTime.now().add(const Duration(hours: 1)),
);

// Cancel notification
await notificationService.cancelNotification(1);

// Cancel all notifications
await notificationService.cancelAllNotifications();
```

**NotificationService:**
```dart
class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService._internal();
    return _instance!;
  }

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<RemoteMessage> _messageController =
      StreamController.broadcast();

  Stream<RemoteMessage> get onMessage => _messageController.stream;

  NotificationService._internal();

  Future<void> initialize() async {
    // Request permissions
    await requestPermissions();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Configure FCM
    await _configureFCM();

    // Get initial message
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Listen for messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<bool> requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> _configureFCM() async {
    // Get FCM token
    final token = await _messaging.getToken();
    AppLogger.instance.info('FCM Token: $token', category: 'notification');

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((token) {
      AppLogger.instance.info('FCM Token refreshed: $token', category: 'notification');
      // Send token to server
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.instance.info('Foreground message: ${message.notification?.title}', category: 'notification');
    _messageController.add(message);

    // Show local notification
    showNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  void _handleMessage(RemoteMessage message) {
    AppLogger.instance.info('Message opened: ${message.notification?.title}', category: 'notification');
    // Handle deep link
  }

  void _onNotificationTap(NotificationResponse response) {
    AppLogger.instance.info('Notification tapped: ${response.payload}', category: 'notification');
    // Handle notification tap
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Channel',
      channelDescription: 'Scheduled notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<String?> getFCMToken() async {
    return await _messaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
```

### 2. AuthService (`auth_service.dart`)

Authentication service for managing user authentication.

**Features:**
- Email/password authentication
- Google sign-in
- Apple sign-in
- Phone authentication
- Token management
- Session management

**Usage:**
```dart
// Get service instance
final authService = AuthService.instance;

// Sign in with email/password
final user = await authService.signInWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password',
);

// Sign in with Google
final user = await authService.signInWithGoogle();

// Sign in with Apple
final user = await authService.signInWithApple();

// Sign out
await authService.signOut();

// Get current user
final user = authService.currentUser;
```

**AuthService:**
```dart
class AuthService {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._internal();
    return _instance!;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final StreamController<User?> _userController = StreamController.broadcast();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  AuthService._internal() {
    _auth.authStateChanges().listen(_userController.add);
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await _auth.signInWithCredential(oauthCredential);
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }
}
```

### 3. StorageService (`storage_service.dart`)

Storage service for managing app data persistence.

**Features:**
- Secure storage
- Shared preferences
- File storage
- Cache management
- Data encryption

**Usage:**
```dart
// Get service instance
final storageService = StorageService.instance;

// Store data
await storageService.setString('key', 'value');
await storageService.setInt('key', 123);
await storageService.setBool('key', true);
await storageService.setDouble('key', 3.14);
await storageService.setStringList('key', ['a', 'b', 'c']);

// Retrieve data
final value = await storageService.getString('key');
final value = await storageService.getInt('key');
final value = await storageService.getBool('key');
final value = await storageService.getDouble('key');
final value = await storageService.getStringList('key');

// Remove data
await storageService.remove('key');

// Clear all data
await storageService.clear();
```

**StorageService:**
```dart
class StorageService {
  static StorageService? _instance;
  static StorageService get instance {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SharedPreferences _prefs = SharedPreferences.getInstance() as SharedPreferences;

  StorageService._internal();

  // Secure storage methods
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }

  // Shared preferences methods
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
```

### 4. AnalyticsService (`analytics_service.dart`)

Analytics service for tracking user behavior and app performance.

**Features:**
- Event tracking
- User properties
- Screen tracking
- Conversion tracking
- Custom dimensions

**Usage:**
```dart
// Get service instance
final analyticsService = AnalyticsService.instance;

// Initialize service
await analyticsService.initialize();

// Track event
await analyticsService.logEvent(
  name: 'button_clicked',
  parameters: {
    'button_name': 'submit',
    'screen': 'login',
  },
);

// Set user property
await analyticsService.setUserProperty('user_type', 'consumer');

// Set user ID
await analyticsService.setUserId('user123');

// Track screen view
await analyticsService.logScreenView(screenName: 'home');
```

**AnalyticsService:**
```dart
class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance {
    _instance ??= AnalyticsService._internal();
    return _instance!;
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  AnalyticsService._internal();

  Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> setUserId(String? id) async {
    await _analytics.setUserId(id: id);
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> logScreenView({required String screenName}) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logLogin({String? loginMethod}) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future<void> logSignUp({String? signUpMethod}) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future<void> logPurchase({
    required String itemId,
    required double price,
    String? currency,
  }) async {
    await _analytics.logPurchase(
      itemId: itemId,
      price: price,
      currency: currency,
    );
  }

  Future<void> logSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
```

## 🏗️ Architecture

### Service Initialization Flow

```
1. App starts
2. Initialize services in bootstrap
3. Configure services
4. Services ready for use
5. App uses services throughout lifecycle
```

### Notification Flow

```
1. Server sends FCM message
2. FCM receives message
3. App receives message (foreground/background/terminated)
4. NotificationService handles message
5. Show local notification
6. User taps notification
7. Handle deep link
```

## 📝 Best Practices

### 1. Initialize Services Early

```dart
// Good
// In bootstrap.dart
await NotificationService.instance.initialize();
await AuthService.instance.initialize();
await AnalyticsService.instance.initialize();

// Bad
// Initialize services late
```

### 2. Handle Errors Gracefully

```dart
// Good
try {
  await notificationService.showNotification(
    id: 1,
    title: 'Test',
    body: 'Test notification',
  );
} catch (e) {
  AppLogger.instance.error('Failed to show notification', error: e);
}

// Bad
// Don't handle errors
await notificationService.showNotification(
  id: 1,
  title: 'Test',
  body: 'Test notification',
);
```

### 3. Use Secure Storage for Sensitive Data

```dart
// Good
await storageService.setSecureString('auth_token', token);

// Bad
await storageService.setString('auth_token', token);
```

### 4. Track Important Events

```dart
// Good
await analyticsService.logEvent(
  name: 'booking_completed',
  parameters: {
    'booking_id': booking.id,
    'amount': booking.amount,
    'payment_method': booking.paymentMethod,
  },
);

// Bad
// Don't track events
```

### 5. Request Permissions Properly

```dart
// Good
final granted = await notificationService.requestPermissions();
if (!granted) {
  // Handle permission denied
}

// Bad
// Don't check permissions
await notificationService.showNotification(
  id: 1,
  title: 'Test',
  body: 'Test notification',
);
```

## 🔧 Usage Examples

### Complete Notification Flow

```dart
class NotificationHandler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = NotificationService.instance;

    useEffect(() {
      // Initialize notification service
      notificationService.initialize();

      // Listen for messages
      final subscription = notificationService.onMessage.listen((message) {
        // Handle message
        _handleMessage(message);
      });

      return subscription.cancel;
    }, []);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Show notification
            await notificationService.showNotification(
              id: 1,
              title: 'Test Notification',
              body: 'This is a test notification',
            );
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }

  void _handleMessage(RemoteMessage message) {
    // Handle incoming message
    AppLogger.instance.info('Received message: ${message.notification?.title}');
  }
}
```

### Authentication Flow

```dart
class AuthHandler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService.instance;
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: authState.when(
        initial: () => LoginButton(
          onLogin: () async {
            try {
              await authService.signInWithGoogle();
            } catch (e) {
              AppLogger.instance.error('Login failed', error: e);
            }
          },
        ),
        authenticated: (user) => HomePage(user: user),
        unauthenticated: () => LoginButton(
          onLogin: () async {
            try {
              await authService.signInWithGoogle();
            } catch (e) {
              AppLogger.instance.error('Login failed', error: e);
            }
          },
        ),
      ),
    );
  }
}
```

### Storage Usage

```dart
class StorageHandler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageService = StorageService.instance;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Store data
            await storageService.setString('user_name', 'John Doe');
            await storageService.setInt('user_age', 30);

            // Retrieve data
            final name = await storageService.getString('user_name');
            final age = await storageService.getInt('user_age');

            print('Name: $name, Age: $age');
          },
          child: const Text('Store Data'),
        ),
      ),
    );
  }
}
```

### Analytics Tracking

```dart
class AnalyticsHandler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsService = AnalyticsService.instance;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Track event
            await analyticsService.logEvent(
              name: 'button_clicked',
              parameters: {
                'button_name': 'submit',
                'screen': 'home',
              },
            );
          },
          child: const Text('Track Event'),
        ),
      ),
    );
  }
}
```

## 🧪 Testing

### Unit Tests

```dart
test('StorageService should store and retrieve data', () async {
  final storageService = StorageService.instance;

  await storageService.setString('key', 'value');
  final value = await storageService.getString('key');

  expect(value, 'value');
});
```

### Integration Tests

```dart
testWidgets('AuthService should sign in user', (tester) async {
  final authService = AuthService.instance;

  final result = await authService.signInWithEmailAndPassword(
    email: 'test@example.com',
    password: 'password',
  );

  expect(result.user, isNotNull);
});
```

## 📚 Additional Resources

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Firebase Analytics](https://firebase.google.com/docs/analytics)

## 🤝 Contributing

When adding new services:

1. Follow existing patterns
2. Handle errors properly
3. Add comprehensive logging
4. Write tests
5. Update documentation

## 📄 License

This module is part of the Fast Golden Taxi project.