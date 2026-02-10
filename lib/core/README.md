# Core Module

The `core` module contains the foundational infrastructure and shared utilities for the Fast Golden Taxi application. This module is independent of any specific feature and provides the building blocks for the entire application.

## 📁 Directory Structure

```
lib/core/
├── accessibility/          # Accessibility utilities and semantic widgets
├── di/                     # Dependency Injection providers
├── error/                  # Error handling framework
├── localization/           # Localization and internationalization
├── logger/                 # Logging infrastructure
├── network/                # Network layer (API, WebSocket, interceptors)
├── performance/            # Performance monitoring and optimization
├── platform/               # Platform-specific utilities
├── router/                 # Navigation and routing
├── services/               # Core services (notifications, etc.)
├── theme/                  # Theming and styling
└── ui/responsive/          # Responsive UI framework
```

## 🎯 Key Components

### 1. Accessibility (`accessibility/`)

Provides accessibility support for screen readers and assistive technologies.

**Key Files:**
- `accessibility.dart` - Main accessibility utilities
- `accessibility_service.dart` - Accessibility service for managing settings
- `focus_helpers.dart` - Focus management helpers
- `semantic_widgets.dart` - Semantic widgets with proper labels

**Usage:**
```dart
// Use semantic button for proper accessibility
SemanticButton(
  label: 'Submit',
  hint: 'Submit the form',
  onPressed: () => _submit(),
  child: const Icon(Icons.send),
)
```

### 2. Dependency Injection (`di/`)

Centralized dependency injection using Riverpod providers.

**Key Files:**
- `providers.dart` - All Riverpod providers for core services

**Usage:**
```dart
// Access API client through provider
final apiClient = ref.watch(apiClientProvider);
```

### 3. Error Handling (`error/`)

Comprehensive error handling framework with typed failures and error boundaries.

**Key Files:**
- `error.dart` - Base error types and exceptions
- `error_handler.dart` - Global error handler
- `error_boundary.dart` - Error boundary widget for catching widget errors

**Features:**
- Typed network exceptions
- Global error catching
- Crash reporting integration
- User-friendly error messages

**Usage:**
```dart
// Wrap widgets with error boundary
ErrorBoundary(
  onError: (error, stackTrace) {
    // Handle error
  },
  child: MyWidget(),
)
```

### 4. Localization (`localization/`)

Internationalization support with runtime locale switching.

**Key Files:**
- `locale_controller.dart` - Locale state management
- `localization_service.dart` - Localization utilities

**Supported Languages:**
- English (en)
- Arabic (ar)

**Usage:**
```dart
// Get localized string
final text = LocalizationService.of(context).welcomeMessage;

// Format date according to locale
final formattedDate = LocalizationService.formatDate(context, DateTime.now());

// Check RTL
final isRTL = LocalizationService.isRTL(context);
```

### 5. Logger (`logger/`)

Advanced logging infrastructure with Talker integration.

**Key Files:**
- `advanced_app_logger.dart` - Main logger implementation
- `app_logger.dart` - Simple logger interface
- `logger_integration_helpers.dart` - Integration helpers
- `logger_ui_components.dart` - UI components for viewing logs

**Log Levels:**
- `debug` - Detailed debugging information
- `info` - General informational messages
- `warning` - Warning messages
- `error` - Error messages
- `critical` - Critical errors

**Log Categories:**
- `network` - Network-related logs
- `ui` - UI-related logs
- `business` - Business logic logs
- `performance` - Performance metrics
- `security` - Security-related logs
- `crash` - Crash reports

**Usage:**
```dart
// Log messages
await AppLogger.instance.logInfo('User logged in');
await AppLogger.instance.logError('Failed to load data', error, stackTrace);

// Log with category
await AppLogger.instance.logInfo(
  'API request completed',
  category: LogCategory.network,
  data: {'endpoint': '/api/users', 'duration': 250},
);
```

### 6. Network (`network/`)

Complete network layer with Dio HTTP client and WebSocket support.

**Key Files:**
- `api_client.dart` - Main API client
- `api_endpoints.dart` - API endpoint constants
- `api_response.dart` - API response models
- `base/` - Base classes for data sources and repositories
- `exception/` - Network exception types
- `interceptors/` - HTTP interceptors
- `websocket/` - WebSocket client and manager
- `results/` - Result types (ApiResult)

**Interceptors:**
1. `AuthInterceptor` - Attaches auth tokens and handles refresh
2. `LoggingInterceptor` - Logs all requests/responses
3. `RetryInterceptor` - Retries failed requests with exponential backoff
4. `AnalyticsInterceptor` - Tracks API calls for analytics
5. `PerformanceInterceptor` - Measures API response times

**Usage:**
```dart
// Make API request
final result = await apiClient.get<User>('/users/123');

// Use base data source
class UserRemoteDataSource with BaseRemoteDataSource {
  @override
  Dio get dio => ApiClient.instance.dio;

  Future<ApiResult<User>> getUser(String id) {
    return get<User>(path: '/users/$id');
  }
}
```

### 7. Performance (`performance/`)

Performance monitoring and optimization utilities.

**Key Files:**
- `image_cache_service.dart` - Image caching and preloading
- `lazy_loading_service.dart` - Lazy loading utilities
- `performance_monitor.dart` - Performance monitoring
- `performance_profiler.dart` - Performance profiling
- `widget_optimizer.dart` - Widget optimization helpers

**Usage:**
```dart
// Preload image
await ImageCacheService.instance.preloadImage(
  NetworkImage('https://example.com/image.jpg'),
);

// Profile widget performance
PerformanceProfiler.profileWidget(
  name: 'MyWidget',
  builder: () => MyWidget(),
);
```

### 8. Platform (`platform/`)

Platform-specific utilities and adaptive widgets.

**Key Files:**
- `adaptive_widgets.dart` - Adaptive widgets for different platforms
- `platform_detection.dart` - Platform detection utilities

**Usage:**
```dart
// Check platform
if (PlatformDetector.isIOS) {
  // iOS-specific code
}

// Use adaptive widget
AdaptiveButton(
  onPressed: () {},
  child: const Text('Submit'),
)
```

### 9. Router (`router/`)

Navigation and routing using GoRouter with role-based guards.

**Key Files:**
- `app_router.dart` - Main router configuration
- `routes.dart` - All route definitions (80+ routes)
- `route_guards.dart` - Navigation guards
- `role_based_guard.dart` - Role-based routing
- `route_transitions.dart` - Custom page transitions
- `router_observer.dart` - Router observer for analytics

**Route Structure:**
- `/` - Splash screen
- `/auth/*` - Authentication routes
- `/consumer/*` - Consumer routes (bottom nav shell)
- `/driver/*` - Driver routes (bottom nav shell)
- `/company/*` - Company routes (bottom nav shell)

**Guards:**
- `AuthGuard` - Validates authentication
- `OnboardingGuard` - Checks onboarding completion
- `UserRoleGuard` - Routes to correct role shell

**Usage:**
```dart
// Navigate to route
context.push(Routes.consumerHome);

// Navigate with parameters
context.push('${Routes.tripDetail}/123');

// Navigate with query parameters
context.push(Routes.tripHistory, queryParameters: {'page': '1'});
```

### 10. Services (`services/`)

Core services for notifications and other platform features.

**Key Files:**
- `notification_service.dart` - FCM and local notifications

**Features:**
- Firebase Cloud Messaging
- Local notifications
- Foreground/background/terminated handling
- Deep link handling
- Permission management

**Usage:**
```dart
// Initialize notification service
await NotificationService.instance.initialize();

// Listen to notifications
NotificationService.instance.onNotification.listen((payload) {
  // Handle notification
});

// Show local notification
await NotificationService.instance.showLocalNotification(
  title: 'New Message',
  body: 'You have a new message',
);
```

### 11. Theme (`theme/`)

Comprehensive theming system with Material 3 support.

**Key Files:**
- `app_theme.dart` - Theme generation
- `color_schemes.dart` - Color scheme definitions
- `typography.dart` - Typography configuration
- `theme_controller.dart` - Theme state management
- `theme_settings.dart` - Theme settings model

**Features:**
- Light/dark mode
- Dynamic colors (Android 12+)
- OLED true black mode
- 28+ color schemes
- Custom typography
- High contrast mode
- Text scale factor

**Usage:**
```dart
// Access theme controller
final themeController = ref.watch(themeControllerProvider);

// Update theme mode
ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.dark);

// Update color scheme
ref.read(themeControllerProvider.notifier).setColorScheme(5);
```

### 12. Responsive UI (`ui/responsive/`)

Responsive UI framework with breakpoints and adaptive widgets.

**Key Files:**
- `breakpoints.dart` - Breakpoint definitions
- `responsive_context.dart` - Responsive context
- `responsive_extensions.dart` - BuildContext extensions
- `spacing/` - Spacing system
- `widgets/` - Adaptive widgets

**Breakpoints:**
- `compact` (< 600dp) - Mobile
- `medium` (600-839dp) - Tablet
- `expanded` (840-1199dp) - Large tablet/small laptop
- `large` (1200-1599dp) - Desktop
- `extraLarge` (>= 1600dp) - Large desktop

**Usage:**
```dart
// Check device type
if (context.isTablet) {
  // Tablet-specific layout
}

// Get responsive value
final padding = context.responsive.byDevice(
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

// Use adaptive scaffold
AdaptiveScaffold(
  body: MyContent(),
)
```

## 🏗️ Architecture Principles

### Clean Architecture

The core module follows Clean Architecture principles:

1. **Dependency Rule** - Dependencies point inward
2. **Separation of Concerns** - Each module has a single responsibility
3. **Testability** - All components are easily testable
4. **Scalability** - Easy to extend without modifying existing code

### SOLID Principles

- **S**ingle Responsibility - Each class has one reason to change
- **O**pen/Closed - Open for extension, closed for modification
- **L**iskov Substitution - Subtypes are substitutable for base types
- **I**nterface Segregation - Clients don't depend on unused interfaces
- **D**ependency Inversion - Depend on abstractions, not concretions

## 📝 Best Practices

### Error Handling

Always use `ApiResult` for network operations:

```dart
final result = await repository.getUser(id);
result.when(
  success: (user) => _displayUser(user),
  exception: (error) => _showError(error.message),
);
```

### Logging

Use appropriate log levels and categories:

```dart
// Debug information
await AppLogger.instance.logDebug('Variable value: $value');

// Important events
await AppLogger.instance.logInfo('User action completed');

// Warnings
await AppLogger.instance.logWarning('Deprecated API used');

// Errors
await AppLogger.instance.logError('Operation failed', error, stackTrace);
```

### Localization

Always use localized strings:

```dart
// Good
Text(LocalizationService.of(context).welcomeMessage)

// Bad
Text('Welcome')
```

### Responsive Design

Always design for multiple screen sizes:

```dart
// Use responsive values
SizedBox(
  height: context.responsive.byDevice(
    mobile: 16,
    tablet: 24,
    desktop: 32,
  ),
)

// Use adaptive widgets
AdaptiveButton(
  onPressed: () {},
  child: const Text('Submit'),
)
```

## 🔧 Configuration

### Logger Configuration

Configure the logger in `bootstrap.dart`:

```dart
await AppLogger.instance.initialize(
  config: flavor.isProduction
    ? const AppLoggerConfig.production()
    : const AppLoggerConfig(),
);
```

### Theme Configuration

Theme settings are persisted in SharedPreferences:

```dart
// Default settings
const ThemeSettings defaults = ThemeSettings(
  themeMode: ThemeMode.system,
  colorSchemeIndex: 0,
  useDynamicColor: true,
  useOledBlack: false,
  textScaleFactor: 1.0,
);
```

### Network Configuration

API client is configured per flavor:

```dart
// Development
baseUrl: 'https://fasttaxi.questifysolutions.com/api/v1'

// Staging
baseUrl: 'https://fasttaxi.questifysolutions.com/api/v1'

// Production
baseUrl: 'https://fasttaxi.questifysolutions.com/api/v1'
```

## 🧪 Testing

### Unit Tests

Test core components in isolation:

```dart
test('ApiResult should handle success', () {
  final result = ApiResult.success('data');
  expect(result.isSuccess, true);
  expect(result.data, 'data');
});
```

### Widget Tests

Test widgets with mock providers:

```dart
testWidgets('ErrorBoundary should catch errors', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        themeControllerProvider.overrideWith((ref) => MockThemeController()),
      ],
      child: const MaterialApp(
        home: ErrorBoundary(child: MyWidget()),
      ),
    ),
  );
});
```

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://gorouter.dev)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Flex Color Scheme](https://pub.dev/packages/flex_color_scheme)

## 🤝 Contributing

When adding new features to the core module:

1. Follow the existing directory structure
2. Add comprehensive documentation
3. Write unit tests
4. Update this README
5. Follow SOLID principles
6. Ensure backward compatibility

## 📄 License

This module is part of the Fast Golden Taxi project.