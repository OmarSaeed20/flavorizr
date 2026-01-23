// lib/core/router/app_router.dart
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/router/navigation_state.dart';
import 'package:flavorizr/core/router/route_guards.dart';
import 'package:flavorizr/core/router/router_observer.dart';
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/core/router/widgets/widgets.dart';
import 'package:flavorizr/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flavorizr/features/auth/presentation/pages/login_page.dart';
import 'package:flavorizr/features/auth/presentation/pages/register_page.dart';
import 'package:flavorizr/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flavorizr/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ==================== Providers ====================

/// Provider for the GoRouter instance.
///
/// Usage:
/// ```dart
/// final router = ref.watch(routerProvider);
/// ```
final routerProvider = Provider<GoRouter>((ref) => AppRouter.instance.router);

// ==================== Navigator Keys ====================

/// Navigation key for accessing navigator without context.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Shell navigator key for bottom navigation.
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

// ==================== App Router ====================

/// Creates and configures the app router.
///
/// The router is structured with:
/// - Global routes (splash, auth, error)
/// - Shell route (main app with bottom navigation)
/// - Feature-specific sub-routes
///
/// Example:
/// ```dart
/// await AppRouter.instance.initialize(
///   isAuthenticated: () => authService.isLoggedIn,
/// );
/// ```
class AppRouter {
  AppRouter._internal();

  static AppRouter? _instance;

  /// Singleton instance of the app router.
  static AppRouter get instance => _instance ??= AppRouter._internal();

  late GoRouter _router;
  final RouteGuardManager _guardManager = RouteGuardManager();
  final List<String> _routeHistory = [];
  NavigationState _navigationState = const NavigationState(currentRoute: '/');

  bool _isInitialized = false;

  /// The configured GoRouter instance.
  ///
  /// Throws [StateError] if accessed before initialization.
  GoRouter get router {
    if (!_isInitialized) {
      throw StateError('AppRouter not initialized. Call initialize() first.');
    }
    return _router;
  }

  /// Current navigation state.
  NavigationState get navigationState => _navigationState;

  /// Unmodifiable list of route history.
  List<String> get routeHistory => List.unmodifiable(_routeHistory);

  /// Whether the router has been initialized.
  bool get isInitialized => _isInitialized;

  // ==================== Initialization ====================

  /// Initializes the router with configuration.
  Future<void> initialize({
    Future<bool> Function()? isAuthenticated,
    Future<bool> Function()? isOnboardingCompleted,
    String initialLocation = Routes.splash,
    List<RouteBase>? additionalRoutes,
  }) async {
    if (_isInitialized) return;

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
      observers: [RouterObserver(onRouteChange: _handleRouteChange)],
      redirect: _handleRedirect,
      routes: [..._buildRoutes(), ...(additionalRoutes ?? [])],
      onException: _handleException,
    );

    _isInitialized = true;
    AppLogger.instance.logInfo('AppRouter initialized');
  }

  // ==================== Route Handling ====================

  Future<String?> _handleRedirect(BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;

    if (location == Routes.error || location == Routes.notFound || location == Routes.splash) {
      return null;
    }

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

  void _handleRouteChange(String route, Map<String, dynamic>? params) {
    _routeHistory.add(route);

    if (_routeHistory.length > 50) {
      _routeHistory.removeAt(0);
    }

    _navigationState = _navigationState.copyWith(
      currentRoute: route,
      routeData: params ?? {},
      routeHistory: List.from(_routeHistory),
      canGoBack: _routeHistory.length > 1,
    );

    AppLogger.instance.logInfo(r'Route changed: $route', category: LogCategory.ui, data: params);
  }

  void _handleException(BuildContext context, GoRouterState state, GoRouter router) {
    AppLogger.instance.logError(
      'Router exception',
      category: LogCategory.ui,
      data: {'location': state.matchedLocation, 'error': state.error?.toString()},
    );
    router.go(Routes.error, extra: state.error?.toString());
  }

  // ==================== Route Building ====================

  List<RouteBase> _buildRoutes() => [
    ..._buildGlobalRoutes(),
    ..._buildAuthRoutes(),
    _buildShellRoute(),
  ];

  List<GoRoute> _buildGlobalRoutes() => [
    GoRoute(
      path: Routes.splash,
      name: Routes.splashName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.error,
      name: Routes.errorName,
      builder: (context, state) {
        final error = state.extra as String?;
        return ErrorScreen(error: error);
      },
    ),
    GoRoute(
      path: Routes.notFound,
      name: Routes.notFoundName,
      builder: (context, state) => const NotFoundScreen(),
    ),
  ];

  List<GoRoute> _buildAuthRoutes() => [
    GoRoute(
      path: Routes.login,
      name: Routes.loginName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.register,
      name: Routes.registerName,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      name: Routes.forgotPasswordName,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: Routes.onboarding,
      name: Routes.onboardingName,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ];

  ShellRoute _buildShellRoute() => ShellRoute(
    navigatorKey: shellNavigatorKey,
    builder: (context, state, child) =>
        MainShell(currentRoute: state.matchedLocation, child: child),
    routes: [
      GoRoute(
        path: Routes.home,
        name: Routes.homeName,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Home', message: 'Home screen placeholder'),
      ),
      GoRoute(
        path: Routes.profile,
        name: Routes.profileName,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Profile', message: 'Profile screen placeholder'),
        routes: [
          GoRoute(
            path: Routes.editProfilePath,
            name: Routes.editProfileName,
            builder: (context, state) => const PlaceholderScreen(
              title: 'Edit Profile',
              message: 'Edit profile screen placeholder',
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.settings,
        name: Routes.settingsName,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Settings', message: 'Settings screen placeholder'),
        routes: [
          GoRoute(
            path: Routes.appearanceSettingsPath,
            name: Routes.appearanceSettingsName,
            builder: (context, state) => const PlaceholderScreen(
              title: 'Appearance',
              message: 'Appearance settings placeholder',
            ),
          ),
          GoRoute(
            path: Routes.notificationSettingsPath,
            name: Routes.notificationSettingsName,
            builder: (context, state) => const PlaceholderScreen(
              title: 'Notifications',
              message: 'Notification settings placeholder',
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.search,
        name: Routes.searchName,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Search', message: 'Search screen placeholder'),
      ),
      GoRoute(
        path: Routes.notifications,
        name: Routes.notificationsName,
        builder: (context, state) => const PlaceholderScreen(
          title: 'Notifications',
          message: 'Notifications screen placeholder',
        ),
      ),
    ],
  );

  // ==================== Navigation Methods ====================

  void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  Future<T?> push<T extends Object?>(String location, {Object? extra}) =>
      _router.push<T>(location, extra: extra);

  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => _router.pushNamed<T>(
    name,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    extra: extra,
  );

  void replace<T extends Object?>(String location, {Object? extra}) {
    _router.replace<T>(location, extra: extra);
  }

  void replaceNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router.replaceNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void pop<T extends Object?>([T? result]) {
    _router.pop(result);
  }

  bool canPop() => _router.canPop();

  String get currentLocation => _router.routeInformationProvider.value.uri.toString();

  void refresh() {
    _router.refresh();
  }

  void clearAndGo(String location, {Object? extra}) {
    _routeHistory.clear();
    _router.go(location, extra: extra);
  }

  @visibleForTesting
  static void reset() {
    _instance?._isInitialized = false;
    _instance = null;
  }
}
