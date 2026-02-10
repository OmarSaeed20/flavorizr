# Dependency Injection Module

The dependency injection module provides a centralized dependency management system using Riverpod providers for the Fast Golden Taxi application.

## 📁 Directory Structure

```
lib/core/di/
└── providers.dart          # Global Riverpod providers
```

## 🎯 Key Components

### 1. Providers (`providers.dart`)

Centralized Riverpod providers for all application dependencies.

**Features:**
- Singleton services
- State management providers
- Configuration providers
- Feature-specific providers
- Lazy initialization

**Usage:**
```dart
// Watch a provider
final config = ref.watch(appConfigProvider);

// Read a provider
final logger = ref.read(appLoggerProvider);

// Override a provider for testing
ProviderScope(
  overrides: [
    appConfigProvider.overrideWithValue(mockConfig),
  ],
  child: MyApp(),
);
```

## 🏗️ Architecture

### Provider Categories

```
1. Core Providers
   - appConfigProvider
   - appLoggerProvider
   - errorHandlerProvider

2. Network Providers
   - apiClientProvider
   - webSocketClientProvider

3. Storage Providers
   - secureStorageProvider
   - sharedPreferencesProvider

4. Service Providers
   - notificationServiceProvider
   - authServiceProvider
   - analyticsServiceProvider

5. Feature Providers
   - themeSettingsProvider
   - localeProvider
   - routerProvider
```

### Provider Lifecycle

```
1. Provider defined
2. Provider accessed (watch/read)
3. Provider initialized (lazy)
4. Provider cached
5. Provider disposed
```

## 📝 Best Practices

### 1. Use Appropriate Provider Types

```dart
// Good - Use Provider for immutable values
@Provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.forFlavor(Flavor.dev);
});

// Good - Use StateProvider for simple state
@StateProvider
final counterProvider = StateProvider<int>((ref) => 0);

// Good - Use StateNotifierProvider for complex state
@StateNotifierProvider
final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, ThemeSettings>((ref) {
  return ThemeSettingsNotifier();
});

// Good - Use FutureProvider for async values
@FutureProvider
final configProvider = FutureProvider<AppConfig>((ref) async {
  return await loadConfig();
});

// Good - Use StreamProvider for streams
@StreamProvider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
```

### 2. Use Family Providers for Parameterized Values

```dart
// Good - Use family for parameterized providers
final userProvider = Provider.family<User, String>((ref, userId) {
  return ref.watch(userRepositoryProvider).getUser(userId);
});

// Usage
final user = ref.watch(userProvider('user123'));
```

### 3. Dispose Resources Properly

```dart
// Good - Dispose resources in onDispose
@Provider
final webSocketProvider = Provider<WebSocketClient>((ref) {
  final client = WebSocketClient();
  ref.onDispose(() {
    client.dispose();
  });
  return client;
});
```

### 4. Use KeepAlive for Long-Lived Providers

```dart
// Good - Use keepAlive for providers that should stay alive
@Provider
final loggerProvider = Provider<AppLogger>((ref) {
  return AppLogger();
}, dependencies: [], keepAlive: true);
```

### 5. Test with Overrides

```dart
// Good - Override providers for testing
testWidgets('MyWidget should show loading', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        configProvider.overrideWith((ref) => AsyncValue.data(mockConfig)),
      ],
      child: MyApp(),
    ),
  );

  expect(find.text('Loading'), findsOneWidget);
});
```

## 🔧 Usage Examples

### Creating a Provider

```dart
// Simple provider
@Provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.forFlavor(Flavor.dev);
});

// Provider with dependencies
@Provider
final apiClientProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  return ApiClient(
    baseUrl: config.apiBaseUrl,
    logger: logger,
  );
});

// StateNotifier provider
@StateNotifierProvider
final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, ThemeSettings>((ref) {
  return ThemeSettingsNotifier();
});

// Future provider
@FutureProvider
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final userId = ref.watch(authStateProvider).userId;
  if (userId == null) throw Exception('Not authenticated');
  return ref.watch(userRepositoryProvider).getUserProfile(userId);
});

// Stream provider
@StreamProvider
final locationStreamProvider = StreamProvider<Location>((ref) {
  return ref.watch(locationServiceProvider).locationStream;
});
```

### Using Providers in Widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch a provider
    final config = ref.watch(appConfigProvider);
    final themeSettings = ref.watch(themeSettingsProvider);

    // Read a provider (no rebuild)
    final logger = ref.read(appLoggerProvider);

    return Scaffold(
      body: Column(
        children: [
          Text('Environment: ${config.flavor.name}'),
          Text('Theme: ${themeSettings.themeMode.name}'),
        ],
      ),
    );
  }
}
```

### Using Providers in Other Providers

```dart
@Provider
final apiClientProvider = Provider<Dio>((ref) {
  // Watch dependencies
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  // Create Dio instance
  final dio = Dio(BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.receiveTimeout,
  ));

  // Add interceptors
  dio.interceptors.addAll([
    AuthInterceptor(ref),
    LoggingInterceptor(logger),
    RetryInterceptor(ref),
  ]);

  return dio;
});
```

### Provider Families

```dart
// Define a family provider
final userProvider = Provider.family<User, String>((ref, userId) {
  return ref.watch(userRepositoryProvider).getUser(userId);
});

// Use in widget
class UserWidget extends ConsumerWidget {
  final String userId;

  const UserWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(userId));

    return user.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Async Providers

```dart
// FutureProvider
@FutureProvider
final configProvider = FutureProvider<AppConfig>((ref) async {
  final response = await http.get(Uri.parse('/config'));
  return AppConfig.fromJson(response.data);
});

// StreamProvider
@StreamProvider
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return ref.watch(chatServiceProvider).messagesStream;
});

// Usage
class ConfigWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);

    return config.when(
      data: (config) => Text('Environment: ${config.flavor}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### StateNotifier Providers

```dart
// Define StateNotifier
class ThemeSettingsNotifier extends StateNotifier<ThemeSettings> {
  ThemeSettingsNotifier() : super(ThemeSettings.initial());

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveToStorage();
  }

  void setColorScheme(String scheme) {
    state = state.copyWith(colorScheme: scheme);
    _saveToStorage();
  }

  void _saveToStorage() {
    // Save to storage
  }
}

// Create provider
@StateNotifierProvider
final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, ThemeSettings>((ref) {
  return ThemeSettingsNotifier();
});

// Use in widget
class ThemeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);

    return DropdownButton<ThemeMode>(
      value: themeSettings.themeMode,
      items: ThemeMode.values.map((mode) {
        return DropdownMenuItem(
          value: mode,
          child: Text(mode.name),
        );
      }).toList(),
      onChanged: (mode) {
        ref.read(themeSettingsProvider.notifier).setThemeMode(mode!);
      },
    );
  }
}
```

## 🧪 Testing

### Testing with Overrides

```dart
testWidgets('MyWidget should show user data', (tester) async {
  final mockUser = User(id: '1', name: 'John Doe');

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userProvider.overrideWith((ref) => AsyncValue.data(mockUser)),
      ],
      child: MaterialApp(
        home: MyWidget(),
      ),
    ),
  );

  expect(find.text('John Doe'), findsOneWidget);
});

test('userProvider should fetch user', () async {
  final container = ProviderContainer(
    overrides: [
      userRepositoryProvider.overrideWithValue(mockUserRepository),
    ],
  );

  final user = await container.read(userProvider('1').future);

  expect(user.id, equals('1'));
  expect(user.name, equals('John Doe'));
});
```

### Testing StateNotifier

```dart
test('ThemeSettingsNotifier should update theme mode', () {
  final container = ProviderContainer();
  final notifier = container.read(themeSettingsProvider.notifier);

  notifier.setThemeMode(ThemeMode.dark);

  expect(container.read(themeSettingsProvider).themeMode, equals(ThemeMode.dark));
});
```

## 📚 Additional Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Providers](https://riverpod.dev/docs/concepts/providers)
- [Riverpod Testing](https://riverpod.dev/docs/cookbooks/testing)

## 🤝 Contributing

When adding new providers:

1. Choose the appropriate provider type
2. Define dependencies clearly
3. Dispose resources properly
4. Add documentation
5. Write tests

## 📄 License

This module is part of the Fast Golden Taxi project.