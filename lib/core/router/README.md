# Router Module

The router module provides comprehensive navigation and routing infrastructure using GoRouter with role-based guards, custom transitions, and deep linking support.

## 📁 Directory Structure

```
lib/core/router/
├── app_router.dart           # Main router configuration
├── navigation_state.dart     # Navigation state management
├── role_based_guard.dart     # Role-based routing guard
├── route_config.dart         # Route configuration
├── route_guards.dart         # Navigation guards
├── route_transitions.dart    # Custom page transitions
├── router.dart               # Router utilities
├── router_observer.dart      # Router observer for analytics
├── routes.dart               # All route definitions (80+ routes)
└── widgets/                  # Router-related widgets
    └── widgets.dart          # Reusable router widgets
```

## 🎯 Key Components

### 1. AppRouter (`app_router.dart`)

Main router configuration with singleton pattern.

**Features:**
- Singleton instance for consistent configuration
- Role-based routing (Consumer, Driver, Company)
- Navigation guards (Auth, Onboarding, Role)
- Custom page transitions
- Deep linking support
- Navigation state tracking
- Route history management

**Usage:**
```dart
// Initialize router
await AppRouter.instance.initialize(
  isAuthenticated: () => authService.isLoggedIn,
  isOnboardingCompleted: () => onboardingService.isCompleted,
  getUserRole: () => authService.getUserRole,
  initialLocation: Routes.splash,
);

// Access router
final router = AppRouter.instance.router;

// Navigate programmatically
context.push(Routes.consumerHome);
context.go(Routes.login);
```

### 2. Routes (`routes.dart`)

All route definitions organized by user role.

**Route Structure:**

#### Root Routes
- `/` - Splash screen
- `/home` - Main home (redirects based on role)
- `/error` - Error page
- `/404` - Not found page

#### Auth Routes (`/auth/*`)
- `/auth/login` - Login page
- `/auth/register` - Registration page
- `/auth/forgot-password` - Forgot password
- `/auth/reset-password` - Reset password (with token)
- `/auth/verify-email` - Email verification
- `/auth/role-selection` - Role selection (Consumer/Driver/Company)

#### Consumer Routes (`/consumer/*`)
**Home & Booking:**
- `/consumer/home` - Consumer home with map view
- `/consumer/location-search` - Location search for pickup/dropoff
- `/consumer/ride-options` - Ride options and pricing
- `/consumer/ride-confirmation` - Ride confirmation
- `/consumer/direct-booking` - Direct booking
- `/consumer/tracking` - Driver tracking
- `/consumer/trip-rating` - Trip rating

**Trip Management:**
- `/consumer/trips/history` - Trip history
- `/consumer/trips/:id` - Trip detail
- `/consumer/trips/:id/cancel` - Cancel trip
- `/consumer/trips/:id/share` - Share trip
- `/consumer/emergency` - Emergency contact

**Schedule Trip:**
- `/consumer/schedule-trip` - Schedule a future trip
- `/consumer/scheduled-trips` - Scheduled trips list

**Payment & Wallet:**
- `/consumer/payment-methods` - Payment methods
- `/consumer/payment-methods/add` - Add payment method
- `/consumer/wallet` - Wallet
- `/consumer/wallet/add` - Add money to wallet
- `/consumer/promocodes` - Promocodes
- `/consumer/receipts` - Receipts
- `/consumer/receipts/:id` - Receipt detail

**Saved Places:**
- `/consumer/saved-places` - Saved places
- `/consumer/saved-places/add` - Add saved place
- `/consumer/saved-places/:id/edit` - Edit saved place

**Profile & Settings:**
- `/consumer/profile` - Profile
- `/consumer/profile/edit` - Edit profile
- `/consumer/settings` - Settings
- `/consumer/settings/appearance` - Appearance settings
- `/consumer/settings/language` - Language settings
- `/consumer/settings/notifications` - Notification settings
- `/consumer/settings/privacy` - Privacy settings
- `/consumer/settings/help` - Help & support

**Chat & Support:**
- `/consumer/chat` - Chat list
- `/consumer/chat/:id` - Conversation
- `/consumer/support` - Support
- `/consumer/support/tickets` - Support tickets
- `/consumer/support/tickets/:id` - Ticket detail

**Notifications:**
- `/consumer/notifications` - Notifications

#### Driver Routes (`/driver/*`)
**Home & Earnings:**
- `/driver/home` - Driver home
- `/driver/earnings` - Earnings
- `/driver/earnings/withdraw` - Withdraw earnings

**Trips:**
- `/driver/trips` - Trips list
- `/driver/trips/active` - Active trip
- `/driver/trips/history` - Trip history
- `/driver/trips/:id` - Trip detail

**Profile & Documents:**
- `/driver/profile` - Profile
- `/driver/profile/edit` - Edit profile
- `/driver/documents` - Documents
- `/driver/documents/:id/upload` - Upload document

**Vehicle:**
- `/driver/vehicle` - Vehicle
- `/driver/vehicle/edit` - Edit vehicle

**Reviews:**
- `/driver/reviews` - Reviews

**Schedule:**
- `/driver/schedule` - Schedule

**Settings:**
- `/driver/settings` - Settings

#### Company Routes (`/company/*`)
**Dashboard & Analytics:**
- `/company/dashboard` - Dashboard
- `/company/analytics` - Analytics

**Fleet Management:**
- `/company/fleet` - Fleet
- `/company/fleet/add` - Add vehicle
- `/company/fleet/:id` - Vehicle detail
- `/company/fleet/:id/edit` - Edit vehicle

**Drivers:**
- `/company/drivers` - Drivers
- `/company/drivers/add` - Add driver
- `/company/drivers/:id` - Driver detail
- `/company/drivers/:id/edit` - Edit driver

**Trips:**
- `/company/trips` - Trips
- `/company/trips/active` - Active trips
- `/company/trips/history` - Trip history
- `/company/trips/:id` - Trip detail

**Earnings:**
- `/company/earnings` - Earnings
- `/company/earnings/withdraw` - Withdraw earnings

**Settings:**
- `/company/settings` - Settings
- `/company/settings/zones` - Zones
- `/company/settings/zones/add` - Add zone
- `/company/settings/zones/:id/edit` - Edit zone

**Usage:**
```dart
// Navigate to route
context.push(Routes.consumerHome);

// Navigate with parameters
context.push('${Routes.tripDetail}/123');

// Navigate with query parameters
context.push(Routes.tripHistory, queryParameters: {'page': '1', 'limit': '20'});

// Navigate and replace
context.go(Routes.login);

// Navigate back
context.pop();

// Navigate to named route
context.goNamed(Routes.consumerHomeName);
```

### 3. Route Guards (`route_guards.dart`)

Navigation guards for protecting routes.

**Guard Types:**

#### AuthGuard
Validates authentication before allowing access.

```dart
class AuthGuard extends RouteGuard {
  final Future<bool> Function() isAuthenticated;

  @override
  Future<bool> canAccess(String location) async {
    return await isAuthenticated();
  }

  @override
  String get redirectLocation => Routes.login;
}
```

#### OnboardingGuard
Checks if onboarding is completed.

```dart
class OnboardingGuard extends RouteGuard {
  final Future<bool> Function() isOnboardingCompleted;

  @override
  Future<bool> canAccess(String location) async {
    return await isOnboardingCompleted();
  }

  @override
  String get redirectLocation => Routes.onboarding;
}
```

#### UserRoleGuard
Routes to correct role shell based on user role.

```dart
class UserRoleGuard extends RouteGuard {
  final Future<String> Function() getUserRole;

  @override
  Future<bool> canAccess(String location) async {
    final role = await getUserRole();
    return _isRouteAccessibleForRole(location, role);
  }

  @override
  String get redirectLocation {
    // Redirect to appropriate role shell
    return Routes.consumerHome; // or driverHome, companyDashboard
  }
}
```

**Usage:**
```dart
// Add guard to router
await AppRouter.instance.initialize(
  isAuthenticated: () => authService.isLoggedIn,
  isOnboardingCompleted: () => onboardingService.isCompleted,
  getUserRole: () => authService.getUserRole,
);
```

### 4. Route Transitions (`route_transitions.dart`)

Custom page transitions for different route types.

**Transition Types:**
- `fade` - Fade transition
- `slide` - Slide transition
- `scale` - Scale transition
- `rotation` - Rotation transition
- `size` - Size transition

**Usage:**
```dart
// Use custom transition
GoRoute(
  path: Routes.consumerHome,
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const ConsumerHomePage(),
    transitionsBuilder: RouteTransitions.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ),
)
```

### 5. Navigation State (`navigation_state.dart`)

Tracks navigation state and history.

**Features:**
- Current route tracking
- Route history
- Navigation parameters
- Query parameters

**Usage:**
```dart
// Get navigation state
final state = AppRouter.instance.navigationState;
print('Current route: ${state.currentRoute}');
print('Route history: ${state.routeHistory}');

// Listen to navigation changes
AppRouter.instance.navigationStateChanges.listen((state) {
  print('Navigated to: ${state.currentRoute}');
});
```

### 6. Router Observer (`router_observer.dart`)

Observer for tracking navigation events.

**Features:**
- Route change tracking
- Navigation duration measurement
- Analytics integration

**Usage:**
```dart
// Add observer to router
final router = GoRouter(
  observers: [
    RouterObserver(),
  ],
  // ... other config
);
```

## 🏗️ Architecture

### Route Structure

```
┌─────────────────────────────────────┐
│         Root Routes                 │
│    (splash, error, 404)            │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       │               │
┌──────▼──────┐  ┌────▼─────┐
│ Auth Routes │  │ Onboarding│
└──────┬──────┘  └────┬─────┘
       │              │
       └──────┬───────┘
              │
       ┌──────▼──────────────────────┐
       │   Role-Based Routing        │
       │  (Consumer, Driver, Company)│
       └──────┬──────────────────────┘
              │
    ┌─────────┼─────────┐
    │         │         │
┌───▼───┐ ┌──▼───┐ ┌───▼────┐
│Consumer│ │Driver│ │Company │
│ Routes │ │Routes│ │ Routes │
└───────┘ └──────┘ └────────┘
```

### Navigation Flow

```
1. App starts → Splash screen
2. Check auth → Not authenticated → Login
3. Check auth → Authenticated → Check onboarding
4. Onboarding not complete → Onboarding flow
5. Onboarding complete → Check user role
6. Route to appropriate shell (Consumer/Driver/Company)
7. Navigate within role shell
8. Handle deep links
9. Track navigation events
```

## 📝 Best Practices

### 1. Use Named Routes

```dart
// Good
context.push(Routes.consumerHome);

// Bad
context.push('/consumer/home');
```

### 2. Use Route Parameters

```dart
// Good
context.push('${Routes.tripDetail}/123');

// Bad
context.push('/consumer/trips/123');
```

### 3. Use Query Parameters

```dart
// Good
context.push(Routes.tripHistory, queryParameters: {'page': '1', 'limit': '20'});

// Bad
context.push('/consumer/trips/history?page=1&limit=20');
```

### 4. Handle Route Parameters

```dart
// In page widget
class TripDetailPage extends StatelessWidget {
  const TripDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = GoRouterState.of(context).pathParameters['id'];
    // Use tripId
  }
}
```

### 5. Use Guards for Protected Routes

```dart
// Add guard to route
GoRoute(
  path: Routes.consumerHome,
  guards: [AuthGuard()],
  pageBuilder: (context, state) => MaterialPage(child: ConsumerHomePage()),
)
```

### 6. Handle Deep Links

```dart
// Configure deep links
final router = GoRouter(
  initialLocation: Routes.splash,
  routes: $appRoutes,
  // Deep linking is automatic with GoRouter
);
```

### 7. Use Custom Transitions

```dart
// Add custom transition
GoRoute(
  path: Routes.consumerHome,
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const ConsumerHomePage(),
    transitionsBuilder: RouteTransitions.slide,
    transitionDuration: const Duration(milliseconds: 300),
  ),
)
```

## 🧪 Testing

### Widget Tests

```dart
testWidgets('Should navigate to login when not authenticated', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        routerProvider.overrideWith((ref) => createTestRouter()),
      ],
      child: const App(),
    ),
  );

  // Verify navigation
  expect(find.text('Login'), findsOneWidget);
});
```

### Integration Tests

```dart
test('AuthGuard should redirect to login when not authenticated', () async {
  final guard = AuthGuard(isAuthenticated: () async => false);

  final canAccess = await guard.canAccess(Routes.consumerHome);

  expect(canAccess, false);
  expect(guard.redirectLocation, Routes.login);
});
```

## 🔧 Configuration

### Router Configuration

```dart
// Initialize router
await AppRouter.instance.initialize(
  isAuthenticated: () => authService.isLoggedIn,
  isOnboardingCompleted: () => onboardingService.isCompleted,
  getUserRole: () => authService.getUserRole,
  initialLocation: Routes.splash,
);
```

### Navigator Keys

```dart
// Root navigator
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// Shell navigators
final consumerShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'consumerShell');
final driverShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'driverShell');
final companyShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'companyShell');
```

## 📚 Additional Resources

- [GoRouter Documentation](https://gorouter.dev)
- [Flutter Navigation](https://flutter.dev/docs/development/ui/navigation)
- [Deep Linking](https://flutter.dev/docs/development/ui/navigation/deep-linking)

## 🤝 Contributing

When adding new routes:

1. Add route constant to `routes.dart`
2. Add route name constant
3. Create page widget
4. Add route to `app_router.dart`
5. Add guards if needed
6. Add tests
7. Update documentation

## 📄 License

This module is part of the Fast Golden Taxi project.