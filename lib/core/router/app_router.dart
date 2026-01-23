// lib/core/router/app_router.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/router/route_guards.dart';
import 'package:flavorizr/core/router/routes.dart';

/// Provider for the GoRouter instance.
///
/// Usage:
/// ```dart
/// final router = ref.watch(routerProvider);
/// ```
final routerProvider = Provider<GoRouter>((ref) => AppRouter.instance.router);

/// Navigation key for accessing navigator without context.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Shell navigator key for bottom navigation.
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Route configuration for analytics and guards.
class RouteConfig {
  const RouteConfig({
    required this.name,
    required this.path,
    this.requiresAuth = false,
    this.allowedRoles = const [],
    this.trackAnalytics = true,
    this.cacheDuration,
    this.metadata,
  });
  final String name;
  final String path;
  final bool requiresAuth;
  final List<String> allowedRoles;
  final bool trackAnalytics;
  final Duration? cacheDuration;
  final Map<String, dynamic>? metadata;
}

/// Navigation state for tracking current route.
class NavigationState {
  const NavigationState({
    required this.currentRoute,
    this.routeData = const {},
    this.routeHistory = const [],
    this.canGoBack = false,
    this.isLoading = false,
  });
  final String currentRoute;
  final Map<String, dynamic> routeData;
  final List<String> routeHistory;
  final bool canGoBack;
  final bool isLoading;

  NavigationState copyWith({
    String? currentRoute,
    Map<String, dynamic>? routeData,
    List<String>? routeHistory,
    bool? canGoBack,
    bool? isLoading,
  }) => NavigationState(
    currentRoute: currentRoute ?? this.currentRoute,
    routeData: routeData ?? this.routeData,
    routeHistory: routeHistory ?? this.routeHistory,
    canGoBack: canGoBack ?? this.canGoBack,
    isLoading: isLoading ?? this.isLoading,
  );
}

/// Creates and configures the app router.
///
/// The router is structured with:
/// - Global routes (splash, auth, error)
/// - Shell route (main app with bottom navigation)
/// - Feature-specific sub-routes
class AppRouter {
  AppRouter._internal();

  static AppRouter? _instance;
  static AppRouter get instance => _instance ??= AppRouter._internal();

  late GoRouter _router;
  final RouteGuardManager _guardManager = RouteGuardManager();
  final List<String> _routeHistory = [];
  NavigationState _navigationState = const NavigationState(currentRoute: '/');

  bool _isInitialized = false;

  GoRouter get router {
    if (!_isInitialized) {
      throw StateError('AppRouter not initialized. Call initialize() first.');
    }
    return _router;
  }

  NavigationState get navigationState => _navigationState;
  List<String> get routeHistory => List.unmodifiable(_routeHistory);

  /// Initializes the router with configuration.
  Future<void> initialize({
    Future<bool> Function()? isAuthenticated,
    Future<bool> Function()? isOnboardingCompleted,
    String initialLocation = Routes.splash,
    List<RouteBase>? additionalRoutes,
  }) async {
    if (_isInitialized) return;

    // Setup guards if auth check is provided
    if (isAuthenticated != null) {
      _guardManager.addGlobalGuard(AuthGuard(isAuthenticated: isAuthenticated));
    }

    if (isOnboardingCompleted != null) {
      _guardManager.addGlobalGuard(OnboardingGuard(isOnboardingCompleted: isOnboardingCompleted));
    }

    _router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: kDebugMode,
      observers: [_RouterObserver(onRouteChange: _handleRouteChange)],
      redirect: _handleRedirect,
      routes: [..._buildRoutes(), ...(additionalRoutes ?? [])],
      errorBuilder: _errorBuilder,
      onException: _handleException,
    );

    _isInitialized = true;
    AppLogger.instance.logInfo('AppRouter initialized');
  }

  /// Handles global redirect logic.
  Future<String?> _handleRedirect(BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;

    // Skip redirect for error and splash routes
    if (location == Routes.error || location == Routes.notFound || location == Routes.splash) {
      return null;
    }

    // Check route guards
    final redirectPath = await _guardManager.checkGuards(context, state);
    if (redirectPath != null) {
      AppLogger.instance.logInfo(
        'Route guard redirect',
        data: {'from': location, 'to': redirectPath},
      );
      return redirectPath;
    }

    return null;
  }

  /// Handles route changes for analytics and history.
  void _handleRouteChange(String route, Map<String, dynamic>? params) {
    _routeHistory.add(route);

    // Keep history limited
    if (_routeHistory.length > 50) {
      _routeHistory.removeAt(0);
    }

    _navigationState = _navigationState.copyWith(
      currentRoute: route,
      routeData: params ?? {},
      routeHistory: List.from(_routeHistory),
      canGoBack: _routeHistory.length > 1,
    );

    AppLogger.instance.logInfo('Route changed: $route', category: LogCategory.ui, data: params);
  }

  /// Builds the main route tree.
  List<RouteBase> _buildRoutes() => [
    // Splash Route
    GoRoute(
      path: Routes.splash,
      name: 'splash',
      builder: (context, state) => const _PlaceholderScreen(title: 'Splash', message: 'Loading...'),
    ),

    // Error Route
    GoRoute(
      path: Routes.error,
      name: 'error',
      builder: (context, state) {
        final error = state.extra as String?;
        return _ErrorScreen(error: error);
      },
    ),

    // Not Found Route
    GoRoute(
      path: Routes.notFound,
      name: 'notFound',
      builder: (context, state) => const _NotFoundScreen(),
    ),

    // Auth Routes
    GoRoute(
      path: Routes.login,
      name: 'login',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Login', message: 'Login screen placeholder'),
    ),
    GoRoute(
      path: Routes.register,
      name: 'register',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Register', message: 'Register screen placeholder'),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Forgot Password',
        message: 'Forgot password screen placeholder',
      ),
    ),
    GoRoute(
      path: Routes.onboarding,
      name: 'onboarding',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Onboarding', message: 'Onboarding screen placeholder'),
    ),

    // Main App Shell
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) =>
          _MainShell(currentRoute: state.matchedLocation, child: child),
      routes: [
        // Home
        GoRoute(
          path: Routes.home,
          name: 'home',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Home', message: 'Home screen placeholder'),
        ),

        // Profile
        GoRoute(
          path: Routes.profile,
          name: 'profile',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Profile', message: 'Profile screen placeholder'),
          routes: [
            GoRoute(
              path: 'edit',
              name: 'editProfile',
              builder: (context, state) => const _PlaceholderScreen(
                title: 'Edit Profile',
                message: 'Edit profile screen placeholder',
              ),
            ),
          ],
        ),

        // Settings
        GoRoute(
          path: Routes.settings,
          name: 'settings',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Settings', message: 'Settings screen placeholder'),
          routes: [
            GoRoute(
              path: 'appearance',
              name: 'appearanceSettings',
              builder: (context, state) => const _PlaceholderScreen(
                title: 'Appearance',
                message: 'Appearance settings placeholder',
              ),
            ),
            GoRoute(
              path: 'notifications',
              name: 'notificationSettings',
              builder: (context, state) => const _PlaceholderScreen(
                title: 'Notifications',
                message: 'Notification settings placeholder',
              ),
            ),
          ],
        ),

        // Search
        GoRoute(
          path: Routes.search,
          name: 'search',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Search', message: 'Search screen placeholder'),
        ),

        // Notifications
        GoRoute(
          path: Routes.notifications,
          name: 'notifications',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Notifications',
            message: 'Notifications screen placeholder',
          ),
        ),
      ],
    ),
  ];

  /// Error page builder.
  Widget _errorBuilder(BuildContext context, GoRouterState state) {
    AppLogger.instance.logError('Router error: ${state.error}', category: LogCategory.ui);
    return _ErrorScreen(error: state.error?.toString());
  }

  /// Exception handler.
  void _handleException(BuildContext context, GoRouterState state, GoRouter router) {
    AppLogger.instance.logError(
      'Router exception',
      category: LogCategory.ui,
      data: {'location': state.matchedLocation, 'error': state.error?.toString()},
    );

    // Navigate to error page
    router.go(Routes.error, extra: state.error?.toString());
  }

  // ==================== Navigation Methods ====================

  /// Navigates to a route.
  void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  /// Pushes a route onto the stack.
  Future<T?> push<T extends Object?>(String location, {Object? extra}) =>
      _router.push<T>(location, extra: extra);

  /// Replaces the current route.
  void replace<T extends Object?>(String location, {Object? extra}) {
    _router.replace<T>(location, extra: extra);
  }

  /// Pops the current route.
  void pop<T extends Object?>([T? result]) {
    _router.pop(result);
  }

  /// Checks if can pop.
  bool canPop() => _router.canPop();

  /// Gets the current location.
  String get currentLocation => _router.routeInformationProvider.value.uri.toString();

  /// Refreshes the current route (re-triggers redirect).
  void refresh() {
    _router.refresh();
  }

  /// Clears history and navigates to route.
  void clearAndGo(String location, {Object? extra}) {
    _routeHistory.clear();
    _router.go(location, extra: extra);
  }
}

/// Router observer for tracking navigation.
class _RouterObserver extends NavigatorObserver {
  _RouterObserver({required this.onRouteChange});
  final void Function(String route, Map<String, dynamic>? params) onRouteChange;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _notifyRouteChange(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _notifyRouteChange(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _notifyRouteChange(newRoute);
    }
  }

  void _notifyRouteChange(Route<dynamic> route) {
    final settings = route.settings;
    onRouteChange(settings.name ?? 'unknown', null);
  }
}

// ==================== Placeholder Screens ====================

/// Placeholder screen for routes not yet implemented.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_rounded, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    ),
  );
}

/// Error screen.
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});
  final String? error;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: Theme.of(context).textTheme.titleLarge),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: () => context.go(Routes.home), child: const Text('Go Home')),
          ],
        ),
      ),
    ),
  );
}

/// Not found (404) screen.
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Not Found')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Theme.of(context).colorScheme.tertiary),
          const SizedBox(height: 16),
          Text('Page Not Found', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            "The page you are looking for doesn't exist.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: () => context.go(Routes.home), child: const Text('Go Home')),
        ],
      ),
    ),
  );
}

/// Main shell with bottom navigation.
class _MainShell extends StatelessWidget {
  const _MainShell({required this.currentRoute, required this.child});
  final String currentRoute;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: child,
    bottomNavigationBar: NavigationBar(
      selectedIndex: _getSelectedIndex(),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );

  int _getSelectedIndex() {
    if (currentRoute.startsWith(Routes.home)) return 0;
    if (currentRoute.startsWith(Routes.search)) return 1;
    if (currentRoute.startsWith(Routes.notifications)) return 2;
    if (currentRoute.startsWith(Routes.profile)) return 3;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;
      case 1:
        context.go(Routes.search);
        break;
      case 2:
        context.go(Routes.notifications);
        break;
      case 3:
        context.go(Routes.profile);
        break;
    }
  }
}
