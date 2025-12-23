// pubspec.yaml dependencies
/*
dependencies:
  flutter:
    sdk: flutter
  go_router: ^16.2.1
  flutter_riverpod: ^2.5.1
  shared_preferences: ^2.3.2
  flutter_secure_storage: ^9.2.2
  connectivity_plus: ^6.0.5
  path: ^1.9.1
  logger: ^2.4.0
  rxdart: ^0.28.0
*/

// lib/core/router/app_router.dart
import 'package:flavorizr/core/logger/logger_integration_helpers.dart' show LoggerNavigatorObserver;
import 'package:flavorizr/pages/router_supporting_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../auth/auth_service.dart';
// import '../navigation/navigation_service.dart';
// import '../analytics/route_analytics.dart';
// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../features/auth/presentation/screens/register_screen.dart';
// import '../../features/home/presentation/screens/home_screen.dart';
// import '../../features/profile/presentation/screens/profile_screen.dart';
// import '../../features/settings/presentation/screens/settings_screen.dart';
// import '../../features/shop/presentation/screens/shop_screen.dart';
// import '../../features/shop/presentation/screens/product_details_screen.dart';
// import '../../features/cart/presentation/screens/cart_screen.dart';
// import '../../features/checkout/presentation/screens/checkout_screen.dart';
// import '../../features/orders/presentation/screens/orders_screen.dart';
// import '../../shared/presentation/screens/splash_screen.dart';
// import '../../shared/presentation/screens/error_screen.dart';
// import '../../shared/presentation/screens/not_found_screen.dart';
// import '../../shared/presentation/layouts/main_layout.dart';
// import '../../shared/presentation/layouts/auth_layout.dart';
import 'router_layouts_screens.dart';

// Route Names Constants
class AppRoutes {
  // Root routes
  static const String splash = '/';
  static const String home = '/home';

  // Auth routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Main app routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String notifications = '/settings/notifications';
  static const String privacy = '/settings/privacy';
  static const String security = '/settings/security';

  // Shop routes
  static const String shop = '/shop';
  static const String shopCategory = '/shop/category/:categoryId';
  static const String product = '/shop/product/:productId';
  static const String productReviews = '/shop/product/:productId/reviews';

  // Cart and Checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String checkoutPayment = '/checkout/payment';
  static const String checkoutConfirm = '/checkout/confirm';

  // Orders
  static const String orders = '/orders';
  static const String orderDetails = '/orders/:orderId';

  // Admin routes (if user is admin)
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';

  // Deep link routes
  static const String deepLink = '/deep/:type/:id';
  static const String share = '/share/:type/:id';

  // Error routes
  static const String error = '/error';
  static const String notFound = '/404';
}

// Route Configuration
class RouteConfig {
  final String name;
  final String path;
  final bool requiresAuth;
  final List<UserRole> allowedRoles;
  final bool trackAnalytics;
  final Duration? cacheDuration;
  final Map<String, dynamic>? metadata;

  const RouteConfig({
    required this.name,
    required this.path,
    this.requiresAuth = false,
    this.allowedRoles = const [],
    this.trackAnalytics = true,
    this.cacheDuration,
    this.metadata,
  });
}

// Navigation State
class NavigationState {
  final String currentRoute;
  final Map<String, dynamic> routeData;
  final List<String> routeHistory;
  final bool canGoBack;
  final bool isLoading;

  const NavigationState({
    required this.currentRoute,
    this.routeData = const {},
    this.routeHistory = const [],
    this.canGoBack = false,
    this.isLoading = false,
  });

  NavigationState copyWith({
    String? currentRoute,
    Map<String, dynamic>? routeData,
    List<String>? routeHistory,
    bool? canGoBack,
    bool? isLoading,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      routeData: routeData ?? this.routeData,
      routeHistory: routeHistory ?? this.routeHistory,
      canGoBack: canGoBack ?? this.canGoBack,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Route Guard
abstract class RouteGuard {
  Future<bool> canActivate(BuildContext context, GoRouterState state);

  String? getRedirectPath(BuildContext context, GoRouterState state);
}

// Auth Guard
class AuthGuard implements RouteGuard {
  final AuthService _authService;

  AuthGuard(this._authService);

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    return await _authService.isAuthenticated();
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) {
    return AppRoutes.login;
  }
}

// Role Guard
class RoleGuard implements RouteGuard {
  final AuthService _authService;
  final List<UserRole> requiredRoles;

  RoleGuard(this._authService, this.requiredRoles);

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    if (!await _authService.isAuthenticated()) return false;

    final user = await _authService.getCurrentUser();
    return user != null && requiredRoles.contains(user.role);
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) {
    return AppRoutes.home;
  }
}

// Advanced App Router
class AppRouter {
  static AppRouter? _instance;
  static AppRouter get instance => _instance ??= AppRouter._internal();

  late GoRouter _router;
  final List<RouteGuard> _guards = [];
  final RouteAnalytics _analytics = RouteAnalytics.instance;
  final NavigationService _navigationService = NavigationService.instance;

  // Route configurations
  final Map<String, RouteConfig> _routeConfigs = {
    AppRoutes.splash: const RouteConfig(
      name: 'splash',
      path: AppRoutes.splash,
      trackAnalytics: false,
    ),
    AppRoutes.home: const RouteConfig(
      name: 'home',
      path: AppRoutes.home,
      requiresAuth: true,
    ),
    AppRoutes.login: const RouteConfig(name: 'login', path: AppRoutes.login),
    AppRoutes.register: const RouteConfig(
      name: 'register',
      path: AppRoutes.register,
    ),
    AppRoutes.profile: const RouteConfig(
      name: 'profile',
      path: AppRoutes.profile,
      requiresAuth: true,
    ),
    AppRoutes.shop: const RouteConfig(name: 'shop', path: AppRoutes.shop),
    AppRoutes.product: const RouteConfig(
      name: 'product',
      path: AppRoutes.product,
      cacheDuration: Duration(minutes: 10),
    ),
    AppRoutes.admin: const RouteConfig(
      name: 'admin',
      path: AppRoutes.admin,
      requiresAuth: true,
      allowedRoles: [UserRole.admin],
    ),
  };

  AppRouter._internal();

  GoRouter get router => _router;

  Future<void> initialize({
    required AuthService authService,
    bool enableAnalytics = true,
    bool enableLogging = true,
    bool enableDeepLinks = true,
  }) async {
    // Initialize guards
    _guards.addAll([
      AuthGuard(authService),
      RoleGuard(authService, [UserRole.admin]),
    ]);

    // Initialize router
    _router = GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: kDebugMode,
      observers: [
        RouterObserver(),
        if (enableAnalytics) AnalyticsObserver(_analytics),
        if (enableLogging) LoggerNavigatorObserver(),
      ],
      redirect: _handleRedirect,
      routes: _buildRoutes(),
      errorBuilder: _errorBuilder,
      onException: _handleException,
    );

    // Initialize navigation service
    await _navigationService.initialize(_router);

    // Initialize analytics
    if (enableAnalytics) {
      await _analytics.initialize();
    }
  }

  // Route Building
  List<RouteBase> _buildRoutes() {
    return [
      // Splash Route
      GoRoute(
        name: 'splash',
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Shell Route
      ShellRoute(
        builder: (context, state, child) => AuthLayout(child: child),
        routes: [
          GoRoute(
            name: 'login',
            path: AppRoutes.login,
            builder: (context, state) => const LoginScreen(),
            routes: [
              GoRoute(
                name: 'forgot-password',
                path: '/forgot-password',
                builder: (context, state) => const ForgotPasswordScreen(),
              ),
              GoRoute(
                name: 'reset-password',
                path: '/reset-password',
                builder: (context, state) => ResetPasswordScreen(
                  token: state.uri.queryParameters['token'],
                ),
              ),
            ],
          ),
          GoRoute(
            name: 'register',
            path: AppRoutes.register,
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
      ),

      // Main App Shell Route
      ShellRoute(
        builder: (context, state, child) =>
            MainLayout(currentRoute: state.fullPath ?? '', child: child),
        routes: [
          // Home Route
          GoRoute(
            name: 'home',
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),

          // Profile Routes
          GoRoute(
            name: 'profile',
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                name: 'edit-profile',
                path: '/edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),

          // Settings Routes
          GoRoute(
            name: 'settings',
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                name: 'notifications',
                path: '/notifications',
                builder: (context, state) => const NotificationSettingsScreen(),
              ),
              GoRoute(
                name: 'privacy',
                path: '/privacy',
                builder: (context, state) => const PrivacySettingsScreen(),
              ),
              GoRoute(
                name: 'security',
                path: '/security',
                builder: (context, state) => const SecuritySettingsScreen(),
              ),
            ],
          ),

          // Shop Routes
          GoRoute(
            name: 'shop',
            path: AppRoutes.shop,
            builder: (context, state) => ShopScreen(
              category: state.uri.queryParameters['category'],
              searchQuery: state.uri.queryParameters['search'],
            ),
            routes: [
              GoRoute(
                name: 'category',
                path: '/category/:categoryId',
                builder: (context, state) =>
                    ShopScreen(categoryId: state.pathParameters['categoryId']),
              ),
              GoRoute(
                name: 'product',
                path: '/product/:productId',
                builder: (context, state) => ProductDetailsScreen(
                  productId: state.pathParameters['productId']!,
                  variant: state.uri.queryParameters['variant'],
                ),
                routes: [
                  GoRoute(
                    name: 'product-reviews',
                    path: '/reviews',
                    builder: (context, state) => ProductReviewsScreen(
                      productId: state.pathParameters['productId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Cart Routes
          GoRoute(
            name: 'cart',
            path: AppRoutes.cart,
            builder: (context, state) => const CartScreen(),
          ),

          // Checkout Routes
          GoRoute(
            name: 'checkout',
            path: AppRoutes.checkout,
            builder: (context, state) => const CheckoutScreen(),
            routes: [
              GoRoute(
                name: 'payment',
                path: '/payment',
                builder: (context, state) => CheckoutPaymentScreen(
                  orderId: state.uri.queryParameters['orderId'],
                ),
              ),
              GoRoute(
                name: 'confirm',
                path: '/confirm',
                builder: (context, state) => CheckoutConfirmScreen(
                  orderId: state.pathParameters['orderId']!,
                ),
              ),
            ],
          ),

          // Orders Routes
          GoRoute(
            name: 'orders',
            path: AppRoutes.orders,
            builder: (context, state) => const OrdersScreen(),
            routes: [
              GoRoute(
                name: 'order-details',
                path: '/:orderId',
                builder: (context, state) => OrderDetailsScreen(
                  orderId: state.pathParameters['orderId']!,
                ),
              ),
            ],
          ),

          // Admin Routes
          GoRoute(
            name: 'admin',
            path: AppRoutes.admin,
            builder: (context, state) => const AdminDashboardScreen(),
            routes: [
              GoRoute(
                name: 'admin-users',
                path: '/users',
                builder: (context, state) => const AdminUsersScreen(),
              ),
              GoRoute(
                name: 'admin-products',
                path: '/products',
                builder: (context, state) => const AdminProductsScreen(),
              ),
              GoRoute(
                name: 'admin-orders',
                path: '/orders',
                builder: (context, state) => const AdminOrdersScreen(),
              ),
            ],
          ),
        ],
      ),

      // Deep Link Routes
      GoRoute(
        name: 'deep-link',
        path: AppRoutes.deepLink,
        builder: (context, state) => DeepLinkHandler(
          type: state.pathParameters['type']!,
          id: state.pathParameters['id']!,
          queryParams: state.uri.queryParameters,
        ),
      ),

      // Share Routes
      GoRoute(
        name: 'share',
        path: AppRoutes.share,
        builder: (context, state) => ShareHandler(
          type: state.pathParameters['type']!,
          id: state.pathParameters['id']!,
        ),
      ),

      // Error Routes
      GoRoute(
        name: 'error',
        path: AppRoutes.error,
        builder: (context, state) => ErrorScreen(error: state.extra as String?),
      ),
    ];
  }

  // Redirect Handler
  Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final location = state.fullPath;

    // Skip redirect for certain routes
    if (_shouldSkipRedirect(location)) {
      return null;
    }

    // Check route configuration
    final config = _getRouteConfig(location);
    if (config == null) return null;

    // Handle authentication redirect
    if (config.requiresAuth) {
      final authService = AuthService.instance;
      final isAuthenticated = await authService.isAuthenticated();

      if (!isAuthenticated) {
        // Save intended destination
        await _saveIntendedRoute(location);
        return AppRoutes.login;
      }

      // Check role-based access
      if (config.allowedRoles.isNotEmpty) {
        final user = await authService.getCurrentUser();
        if (user == null || !config.allowedRoles.contains(user.role)) {
          return AppRoutes.home;
        }
      }
    }

    // Handle onboarding redirect
    if (location == AppRoutes.home) {
      final shouldShowOnboarding = await _shouldShowOnboarding();
      if (shouldShowOnboarding) {
        return '/onboarding';
      }
    }

    return null;
  }

  bool _shouldSkipRedirect(String? location) {
    final skipRoutes = [
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.error,
      AppRoutes.notFound,
    ];

    return skipRoutes.any((route) => (location ?? "").startsWith(route));
  }

  RouteConfig? _getRouteConfig(String? location) {
    if (location == null) return null;
    // Try exact match first
    if (_routeConfigs.containsKey(location)) {
      return _routeConfigs[location];
    }

    // Try pattern matching
    for (final entry in _routeConfigs.entries) {
      if (_matchesPattern(entry.key, location)) {
        return entry.value;
      }
    }

    return null;
  }

  bool _matchesPattern(String pattern, String location) {
    // Simple pattern matching for routes with parameters
    final regexPattern = pattern.replaceAllMapped(
      RegExp(r':(\w+)'),
      (match) => r'([^/]+)',
    );

    final regex = RegExp('^$regexPattern\$');
    return regex.hasMatch(location);
  }

  Future<void> _saveIntendedRoute(String? route) async {
    if (route != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('intended_route', route);
    }
  }

  Future<String?> _getIntendedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final route = prefs.getString('intended_route');
    if (route != null) {
      await prefs.remove('intended_route');
    }
    return route;
  }

  Future<bool> _shouldShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('onboarding_completed');
    return value != null ? !value : true;
  }

  // Error Handling
  Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return ErrorScreen(
      error: state.error?.toString(),
      onRetry: () => context.go(AppRoutes.home),
    );
  }

  void _handleException(
    BuildContext context,
    GoRouterState state,
    GoRouter router,
  ) {
    // Log the exception
    debugPrint('Router Exception: ${state.error}');

    // Navigate to error screen
    router.go(AppRoutes.error, extra: state.error?.toString());
  }

  // Navigation Methods
  Future<void> navigateToHome() async {
    _router.go(AppRoutes.home);
    await _analytics.trackNavigation('home', 'direct');
  }

  Future<void> navigateToLogin({String? returnTo}) async {
    if (returnTo != null) {
      await _saveIntendedRoute(returnTo);
    }
    _router.go(AppRoutes.login);
    await _analytics.trackNavigation('login', 'redirect');
  }

  Future<void> navigateToProduct(String productId, {String? variant}) async {
    final uri = Uri(
      path: AppRoutes.product.replaceAll(':productId', productId),
      queryParameters: variant != null ? {'variant': variant} : null,
    );
    _router.go(uri.toString());
    await _analytics.trackNavigation('product', 'direct', {
      'productId': productId,
    });
  }

  Future<void> navigateAfterLogin() async {
    final intendedRoute = await _getIntendedRoute();
    _router.go(intendedRoute ?? AppRoutes.home);
    await _analytics.trackNavigation('post_login', 'redirect');
  }

  Future<void> logout() async {
    await AuthService.instance.logout();
    _router.go(AppRoutes.login);
    await _analytics.trackNavigation('logout', 'action');
  }

  // Deep Link Handling
  Future<void> handleDeepLink(String url) async {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;

      // Custom deep link handling logic
      if (path.startsWith('/product/')) {
        final productId = path.split('/')[2];
        await navigateToProduct(productId);
      } else if (path.startsWith('/share/')) {
        _router.go(path);
      } else {
        _router.go(path);
      }

      await _analytics.trackDeepLink(url);
    } catch (e) {
      debugPrint('Deep link handling error: $e');
      _router.go(AppRoutes.home);
    }
  }

  // Route Information
  String get currentRoute =>
      _router.routerDelegate.currentConfiguration.fullPath;

  bool get canGoBack => _router.canPop();

  Map<String, dynamic> get currentRouteData {
    final state = _router.routerDelegate.currentConfiguration;
    return {
      'path': state.fullPath,
      'pathParameters': state.pathParameters,
      'queryParameters': state.uri.queryParameters,
      'extra': state.extra,
    };
  }

  // Preloading
  Future<void> preloadRoute(String route) async {
    // Implement route preloading logic
    final config = _getRouteConfig(route);
    if (config?.cacheDuration != null) {
      // Cache route data
    }
  }

  // Cleanup
  void dispose() {
    _analytics.dispose();
    _navigationService.dispose();
  }
}
