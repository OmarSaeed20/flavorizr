# Fast Golden Taxi - Application Source Code

This directory contains the complete source code for the Fast Golden Taxi Flutter application, organized in a clean, modular architecture following industry best practices.

## 📁 Directory Structure

```
lib/
├── main.dart                 # Application entry point
├── app.dart                  # Root app widget with router and theme
├── bootstrap.dart            # 17-step initialization sequence
├── observers.dart            # App observers (navigation, lifecycle)
├── config/                   # Configuration and flavors
├── core/                     # Core functionality and utilities
├── features/                 # Feature modules
├── shared/                   # Shared utilities and widgets
├── services/                 # Application-level services
├── pages/                    # Router layouts and screens
└── l10n/                     # Internationalization and localization
```

## 🚀 Quick Start

### Entry Point

The application starts in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Detect flavor from platform
  final flavor = Flavor.values.firstWhere(
    (f) => f.name == appFlavor,
    orElse: () => Flavor.dev,
  );

  // Bootstrap the application
  await bootstrap(flavor);

  runApp(const App());
}
```

### Bootstrap Process

`bootstrap.dart` initializes the application in 17 steps:

1. Initialize Flutter bindings
2. Set flavor
3. Configure HTTP overrides
4. Initialize Firebase
5. Set up FCM background handler
6. Initialize AppConfig
7. Initialize AppLogger
8. Initialize ErrorHandler
9. Initialize NotificationService
10. Set preferred orientations
11. Initialize ThemeSettings
12. Initialize LocaleController
13. Initialize Router
14. Initialize Analytics
15. Initialize Crashlytics
16. Initialize Remote Config
17. Register observers

### Root App Widget

`app.dart` configures the MaterialApp.router:

```dart
class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: F.title,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(settings: themeSettings),
      darkTheme: AppTheme.dark(settings: themeSettings),
      themeMode: themeSettings.themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.instance.router,
    );
  }
}
```

## 📦 Module Overview

### 1. Config Module (`config/`)

Configuration and flavor management.

**Key Files:**
- `flavors.dart` - Flavor definitions (dev/staging/prod)
- `app_config.dart` - Per-flavor configuration
- `firebase_config.dart` - Firebase configuration

**Features:**
- Multi-flavor support (dev/staging/prod)
- Environment-specific configurations
- Firebase configuration per flavor
- Feature flags

**Documentation:** [config/README.md](config/README.md)

### 2. Core Module (`core/`)

Core functionality and utilities.

**Sub-modules:**
- `di/` - Dependency injection with Riverpod
- `error/` - Error handling and error boundaries
- `network/` - HTTP client and interceptors
- `theme/` - Theme system with 28+ color schemes
- `localization/` - Localization service
- `logger/` - Advanced logging with Talker
- `accessibility/` - Accessibility helpers
- `performance/` - Performance monitoring
- `services/` - Core services (notification, auth, storage, analytics)
- `router/` - GoRouter configuration with 80+ routes
- `platform/` - Platform-specific utilities
- `ui/` - Responsive UI framework

**Documentation:** [core/README.md](core/README.md)

### 3. Features Module (`features/`)

Feature modules following clean architecture.

**Structure:**
```
features/
├── feature_name/
│   ├── data/          # Data layer (repositories, data sources)
│   ├── domain/        # Domain layer (entities, use cases)
│   └── presentation/  # Presentation layer (pages, widgets)
```

**Features:**
- Authentication
- Booking
- Profile
- Settings
- And more...

**Documentation:** [features/README.md](features/README.md)

### 4. Shared Module (`shared/`)

Shared utilities and widgets.

**Contents:**
- Use cases (BaseUseCase, StreamUseCase)
- Domain entities
- Value objects
- Utilities
- Shared widgets
- Constants
- Extensions

**Documentation:** [shared/README.md](shared/README.md)

### 5. Services Module (`services/`)

Application-level services.

**Services:**
- Firebase initialization
- Analytics service
- Crashlytics service

**Documentation:** [services/README.md](services/README.md)

### 6. Pages Module (`pages/`)

Router layouts and screens.

**Contents:**
- Router layouts and screens configuration
- Supporting services for router

**Documentation:** [pages/README.md](pages/README.md)

### 7. L10n Module (`l10n/`)

Internationalization and localization.

**Supported Languages:**
- English (en)
- Arabic (ar)

**Contents:**
- ARB translation files
- Generated localizations classes

**Documentation:** [l10n/README.md](l10n/README.md)

## 🏗️ Architecture

### Layered Architecture

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Pages, Widgets, Controllers)      │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│          Domain Layer               │
│  (Use Cases, Entities, Value Objects)│
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│           Data Layer                │
│  (Repositories, Data Sources)       │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│          Core Layer                 │
│  (Network, Storage, Services)       │
└─────────────────────────────────────┘
```

### Dependency Flow

```
Presentation → Domain → Data → Core
```

### Clean Architecture Principles

1. **Dependency Rule:** Dependencies point inward
2. **Separation of Concerns:** Each layer has a single responsibility
3. **Testability:** Each layer can be tested independently
4. **Scalability:** Easy to add new features
5. **Maintainability:** Clear structure and organization

## 🔧 Key Technologies

### State Management
- **Riverpod** - Type-safe state management with code generation
- **Providers** - Singleton, state, future, and stream providers

### Networking
- **Dio** - HTTP client with interceptors
- **WebSocket** - Real-time communication
- **Connectivity** - Network status monitoring

### Storage
- **Secure Storage** - Encrypted key-value storage
- **Shared Preferences** - Simple key-value storage

### Navigation
- **GoRouter** - Declarative routing with guards
- **Deep Linking** - URL-based navigation

### Theming
- **Flex Color Scheme** - 28+ Material 3 color schemes
- **Dynamic Colors** - Android 12+ dynamic theming
- **Dark Mode** - Full dark mode support

### Localization
- **ARB Files** - Translation resource bundles
- **RTL Support** - Right-to-left language support

### Firebase
- **Auth** - Authentication
- **Analytics** - User analytics
- **Crashlytics** - Crash reporting
- **Messaging** - Push notifications
- **Remote Config** - Remote configuration

### Logging
- **Talker** - Advanced logging with UI viewer
- **Log Levels** - Debug, info, warning, error, critical
- **Categories** - Organized log categories

### Performance
- **Image Cache** - Optimized image caching
- **Lazy Loading** - On-demand content loading
- **Performance Profiler** - Performance monitoring

### Accessibility
- **Semantic Widgets** - Screen reader support
- **Focus Helpers** - Keyboard navigation
- **High Contrast** - Accessibility support

### Responsive Design
- **Breakpoints** - Material 3 responsive breakpoints
- **Adaptive Widgets** - Platform-specific widgets
- **Spacing System** - Consistent spacing

## 📝 Best Practices

### 1. Follow Clean Architecture

```dart
// Good - Use use cases
class GetUserUseCase extends BaseUseCase<User, String> {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(String userId) async {
    return await repository.getUser(userId);
  }
}

// Bad - Call repository directly
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userRepositoryProvider).getUser('1');
    return Text(user.name);
  }
}
```

### 2. Use Dependency Injection

```dart
// Good - Use providers
@Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
});

// Bad - Create instances directly
final repository = UserRepository(apiClient);
```

### 3. Handle Errors Properly

```dart
// Good - Use error handler
try {
  await riskyOperation();
} catch (e, stack) {
  errorHandler.handleError(e, stack);
}

// Bad - Don't handle errors
await riskyOperation();
```

### 4. Use Type Safety

```dart
// Good - Use freezed
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = _User;
}

// Bad - Use plain classes
class User {
  final String id;
  final String name;
  final String email;

  User(this.id, this.name, this.email);
}
```

### 5. Write Tests

```dart
// Good - Write tests
test('GetUserUseCase should return user', () async {
  final mockRepository = MockUserRepository();
  final useCase = GetUserUseCase(mockRepository);

  when(mockRepository.getUser('1')).thenAnswer((_) async => User(id: '1', name: 'John'));

  final result = await useCase('1');

  expect(result.isRight(), true);
});

// Bad - Don't write tests
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/user_test.dart
```

### Test Structure

```
test/
├── core/           # Core module tests
├── features/       # Feature module tests
├── shared/         # Shared module tests
└── helpers/        # Test helpers and mocks
```

## 📚 Documentation

- [Phase 0 Foundations](../../docs/phases/phase_0_foundations.md)
- [API Documentation](../../docs/API_DOCUMENTATION.md)
- [Config Module](config/README.md)
- [Core Module](core/README.md)
- [Features Module](features/README.md)
- [Shared Module](shared/README.md)
- [Services Module](services/README.md)
- [Pages Module](pages/README.md)
- [L10n Module](l10n/README.md)

## 🚀 Building

### Build APK

```bash
# Dev flavor
flutter build apk --flavor=dev --dart-define=FLAVOR=dev

# Staging flavor
flutter build apk --flavor=staging --dart-define=FLAVOR=staging

# Prod flavor
flutter build apk --flavor=prod --dart-define=FLAVOR=prod
```

### Build iOS

```bash
# Dev flavor
flutter build ios --flavor=dev --dart-define=FLAVOR=dev

# Staging flavor
flutter build ios --flavor=staging --dart-define=FLAVOR=staging

# Prod flavor
flutter build ios --flavor=prod --dart-define=FLAVOR=prod
```

## 🤝 Contributing

When contributing to the codebase:

1. Follow the existing architecture
2. Write tests for new features
3. Update documentation
4. Follow code style guidelines
5. Run code generation
6. Run tests before committing

## 📄 License

This project is part of the Fast Golden Taxi application.

---

**Built with ❤️ using Flutter and Clean Architecture**