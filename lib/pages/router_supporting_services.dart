/* // lib/core/navigation/navigation_service.dart
import 'dart:convert';

import 'package:flavorizr/core/router/app_router.dart';
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/pages/advanced_app_router.dart';
import 'package:flavorizr/pages/router_layouts_screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance => _instance ??= NavigationService._internal();

  late GoRouter _router;
  final BehaviorSubject<NavigationState> _navigationState = BehaviorSubject.seeded(
    const NavigationState(currentRoute: '/'),
  );
  final List<String> _routeHistory = [];

  NavigationService._internal();

  Stream<NavigationState> get navigationState => _navigationState.stream;
  NavigationState get currentState => _navigationState.value;

  Future<void> initialize(GoRouter router) async {
    _router = router;
    await _loadNavigationHistory();
  }

  Future<void> _loadNavigationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('navigation_history') ?? [];
      _routeHistory.addAll(history.take(20)); // Keep last 20 routes
    } catch (e) {
      debugPrint('Failed to load navigation history: $e');
    }
  }

  Future<void> _saveNavigationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('navigation_history', _routeHistory);
    } catch (e) {
      debugPrint('Failed to save navigation history: $e');
    }
  }

  void updateNavigationState(String route, {Map<String, dynamic>? data}) {
    // Add to history
    if (_routeHistory.isEmpty || _routeHistory.last != route) {
      _routeHistory.add(route);
      if (_routeHistory.length > 50) {
        _routeHistory.removeAt(0);
      }
      _saveNavigationHistory();
    }

    // Update state
    final newState = NavigationState(
      currentRoute: route,
      routeData: data ?? {},
      routeHistory: List.from(_routeHistory),
      canGoBack: _router.canPop(),
    );

    _navigationState.add(newState);
  }

  void setLoading(bool loading) {
    final newState = currentState.copyWith(isLoading: loading);
    _navigationState.add(newState);
  }

  List<String> getRecentRoutes({int limit = 10}) {
    return _routeHistory.reversed.take(limit).toList();
  }

  void clearHistory() {
    _routeHistory.clear();
    _saveNavigationHistory();
  }

  void dispose() {
    _navigationState.close();
  }
}

// lib/core/analytics/route_analytics.dart
class RouteAnalyticsEvent {
  final String route;
  final String action;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;
  final Duration? duration;

  RouteAnalyticsEvent({
    required this.route,
    required this.action,
    this.parameters = const {},
    DateTime? timestamp,
    this.duration,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'route': route,
    'action': action,
    'parameters': parameters,
    'timestamp': timestamp.toIso8601String(),
    'duration': duration?.inMilliseconds,
  };
}

class RouteAnalytics {
  RouteAnalytics._internal();
  static RouteAnalytics? _instance;
  static RouteAnalytics get instance => _instance ??= RouteAnalytics._internal();

  final List<RouteAnalyticsEvent> _events = [];
  final Map<String, DateTime> _routeStartTimes = {};
  final Map<String, int> _routeVisitCounts = {};

  Future<void> initialize() async {
    await _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countsJson = prefs.getString('route_visit_counts');
      if (countsJson != null) {
        // Load visit counts
      }
    } catch (e) {
      debugPrint('Failed to load analytics data: $e');
    }
  }

  Future<void> trackNavigation(String route, String action, [Map<String, dynamic>? params]) async {
    // Track visit count
    _routeVisitCounts[route] = (_routeVisitCounts[route] ?? 0) + 1;

    // Calculate duration if coming from another route
    Duration? duration;
    if (_routeStartTimes.isNotEmpty) {
      final lastRoute = _routeStartTimes.keys.last;
      final startTime = _routeStartTimes[lastRoute];
      if (startTime != null) {
        duration = DateTime.now().difference(startTime);
      }
    }

    // Record start time for this route
    _routeStartTimes.clear();
    _routeStartTimes[route] = DateTime.now();

    // Create event
    final event = RouteAnalyticsEvent(
      route: route,
      action: action,
      parameters: params ?? {},
      duration: duration,
    );

    _events.add(event);

    // Keep only last 1000 events
    if (_events.length > 1000) {
      _events.removeAt(0);
    }

    // Log in debug mode
    if (kDebugMode) {
      debugPrint('Route Analytics: $route ($action) ${duration?.inMilliseconds ?? 0}ms');
    }

    await _saveAnalyticsData();
  }

  Future<void> trackDeepLink(String url) async {
    await trackNavigation('deep_link', 'open', {'url': url});
  }

  Future<void> _saveAnalyticsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Save visit counts
      await prefs.setString('route_visit_counts', jsonEncode(_routeVisitCounts));
    } catch (e) {
      debugPrint('Failed to save analytics data: $e');
    }
  }

  List<RouteAnalyticsEvent> getEvents({String? route, int? limit}) {
    var events = _events.where((e) => route == null || e.route == route).toList();
    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && events.length > limit) {
      events = events.take(limit).toList();
    }

    return events;
  }

  Map<String, int> getRouteVisitCounts() => Map.from(_routeVisitCounts);

  Map<String, dynamic> getAnalyticsSummary() {
    final totalEvents = _events.length;
    final totalRoutes = _routeVisitCounts.keys.length;
    final mostVisitedRoute = _routeVisitCounts.isNotEmpty
        ? _routeVisitCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'None';

    final avgDuration =
        _events
            .where((e) => e.duration != null)
            .map((e) => e.duration!.inMilliseconds)
            .fold<int>(0, (sum, duration) => sum + duration) /
        (_events.where((e) => e.duration != null).length);

    return {
      'totalEvents': totalEvents,
      'totalRoutes': totalRoutes,
      'mostVisitedRoute': mostVisitedRoute,
      'avgDurationMs': avgDuration.isNaN ? 0 : avgDuration.round(),
      'recentEvents': getEvents(limit: 10).map((e) => e.toJson()).toList(),
    };
  }

  void dispose() {
    _events.clear();
    _routeStartTimes.clear();
    _routeVisitCounts.clear();
  }
}

// lib/core/router/router_observers.dart
class RouterObserver extends NavigatorObserver {
  final NavigationService _navigationService = NavigationService.instance;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRouteChange(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _handleRouteChange(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _handleRouteChange(newRoute);
    }
  }

  void _handleRouteChange(Route<dynamic> route) {
    final routeName = route.settings.name ?? 'unknown';
    final routeData = {
      'arguments': route.settings.arguments?.toString(),
      'isActive': route.isActive,
      'isCurrent': route.isCurrent,
    };

    _navigationService.updateNavigationState(routeName, data: routeData);
  }
}

class AnalyticsObserver extends NavigatorObserver {
  final RouteAnalytics _analytics;

  AnalyticsObserver(this._analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackNavigation(route, 'push');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _trackNavigation(previousRoute, 'pop');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _trackNavigation(newRoute, 'replace');
    }
  }

  void _trackNavigation(Route<dynamic> route, String action) {
    final routeName = route.settings.name ?? 'unknown';
    _analytics.trackNavigation(routeName, action, {
      'arguments': route.settings.arguments?.toString(),
    });
  }
}

// lib/core/auth/auth_service.dart
enum UserRole { guest, user, admin, moderator }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool isVerified;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.isVerified = false,
    this.lastLogin,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role.name,
    'isVerified': isVerified,
    'lastLogin': lastLogin?.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    role: UserRole.values.byName(json['role']),
    isVerified: json['isVerified'] ?? false,
    lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
  );
}

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._internal();

  final BehaviorSubject<User?> _userSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> _isLoadingSubject = BehaviorSubject.seeded(false);

  AuthService._internal();

  Stream<User?> get userStream => _userSubject.stream;
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  User? get currentUser => _userSubject.value;
  bool get isLoading => _isLoadingSubject.value;

  Future<void> initialize() async {
    _isLoadingSubject.add(true);
    try {
      await _loadStoredUser();
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  Future<void> _loadStoredUser() async {
    try {
      const storage = FlutterSecureStorage();
      final userJson = await storage.read(key: 'user_data');

      if (userJson != null) {
        final user = User.fromJson(jsonDecode(userJson));
        _userSubject.add(user);
      }
    } catch (e) {
      debugPrint('Failed to load stored user: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    return currentUser != null;
  }

  Future<User?> getCurrentUser() async {
    return currentUser;
  }

  Future<bool> login(String email, String password) async {
    _isLoadingSubject.add(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock user creation
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@')[0],
        role: email.contains('admin') ? UserRole.admin : UserRole.user,
        isVerified: true,
        lastLogin: DateTime.now(),
      );

      await _storeUser(user);
      _userSubject.add(user);
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoadingSubject.add(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: UserRole.user,
      );

      await _storeUser(user);
      _userSubject.add(user);
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  Future<void> _storeUser(User user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'user_data', value: jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Failed to store user: $e');
    }
  }

  Future<void> logout() async {
    _isLoadingSubject.add(true);
    try {
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'user_data');
      _userSubject.add(null);
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  void dispose() {
    _userSubject.close();
    _isLoadingSubject.close();
  }
}

// lib/core/router/route_transitions.dart
class RouteTransitions {
  static CustomTransitionPage slideTransition({
    required Widget child,
    required GoRouterState state,
    Axis direction = Axis.horizontal,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = direction == Axis.horizontal
            ? const Offset(1.0, 0.0)
            : const Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static CustomTransitionPage fadeTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage scaleTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage customTransition({
    required Widget child,
    required GoRouterState state,
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    )
    transitionsBuilder,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: transitionsBuilder,
    );
  }
}

// lib/core/router/route_middleware.dart
abstract class RouteMiddleware {
  Future<bool> canEnter(BuildContext context, GoRouterState state);
  Future<void> onEnter(BuildContext context, GoRouterState state);
  Future<void> onExit(BuildContext context, GoRouterState state);
}

class AuthMiddleware implements RouteMiddleware {
  final AuthService _authService;

  AuthMiddleware(this._authService);

  @override
  Future<bool> canEnter(BuildContext context, GoRouterState state) async {
    return _authService.isAuthenticated();
  }

  @override
  Future<void> onEnter(BuildContext context, GoRouterState state) async {
    // Log authentication check
    debugPrint('Auth middleware: User entering ${state.fullPath}');
  }

  @override
  Future<void> onExit(BuildContext context, GoRouterState state) async {
    // Cleanup if needed
  }
}

class LoadingMiddleware implements RouteMiddleware {
  @override
  Future<bool> canEnter(BuildContext context, GoRouterState state) async {
    // Show loading indicator
    context.setLoading(true);
    return true;
  }

  @override
  Future<void> onEnter(BuildContext context, GoRouterState state) async {
    // Hide loading indicator after a delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) context.setLoading(false);
  }

  @override
  Future<void> onExit(BuildContext context, GoRouterState state) async {
    context.setLoading(false);
  }
}

// lib/core/router/deep_link_handlers.dart
class DeepLinkHandler extends StatelessWidget {
  final String type;
  final String id;
  final Map<String, String> queryParams;

  const DeepLinkHandler({
    super.key,
    required this.type,
    required this.id,
    this.queryParams = const {},
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _handleDeepLink(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error.toString());
        }

        return snapshot.data ?? const NotFoundScreen();
      },
    );
  }

  Future<Widget> _handleDeepLink(BuildContext context) async {
    switch (type) {
      case 'product':
        // Navigate to product details
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/shop/product/$id', extra: queryParams);
        });
        return ProductDetailsScreen(productId: id);

      case 'user':
        // Navigate to user profile
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/profile/$id');
        });
        return ProfileScreen(userId: id);

      case 'order':
        // Navigate to order details
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/orders/$id');
        });
        return OrderDetailsScreen(orderId: id);

      default:
        return const NotFoundScreen();
    }
  }
}

class ShareHandler extends StatelessWidget {
  final String type;
  final String id;

  const ShareHandler({super.key, required this.type, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _handleShare(context),
      builder: (context, snapshot) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing share link...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      switch (type) {
        case 'product':
          context.go('/shop/product/$id');
          break;
        case 'user':
          context.go('/profile/$id');
          break;
        default:
          context.go('/home');
      }
    }
  }
}

// lib/core/router/route_provider.dart
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.instance.router;
});

final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService.instance;
});

final routeAnalyticsProvider = Provider<RouteAnalytics>((ref) {
  return RouteAnalytics.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

final currentRouteProvider = StreamProvider<String>((ref) {
  return NavigationService.instance.navigationState.map((state) => state.currentRoute);
});

final canGoBackProvider = StreamProvider<bool>((ref) {
  return NavigationService.instance.navigationState.map((state) => state.canGoBack);
});

final routeHistoryProvider = StreamProvider<List<String>>((ref) {
  return NavigationService.instance.navigationState.map((state) => state.routeHistory);
});

// Extension for easy routing
extension AppRouterExtension on BuildContext {
  bool get canGoBack => AppRouter.instance.canGoBack;
  String get currentRoute => AppRouter.instance.currentRoute;
  void goToHome() => go(Routes.home);
  void goToLogin() => go(Routes.login);
  void goToProfile() => go(Routes.profile);
  void goToSettings() => go(Routes.settings);
  void goToShop({String? category}) {
    final uri = Uri(
      path: Routes.shop,
      queryParameters: category != null ? {'category': category} : null,
    );
    go(uri.toString());
  }

  void goToProduct(String productId, {String? variant}) {
    final path = Routes.product.replaceAll(':productId', productId);
    final uri = Uri(path: path, queryParameters: variant != null ? {'variant': variant} : null);
    go(uri.toString());
  }
}

extension NavigationServiceExtension on BuildContext {
  void setLandingRoute() => NavigationService.instance.setLoading(true);
  void setLoading(bool loading) => NavigationService.instance.setLoading(loading);

  void clearNavigationHistory() => NavigationService.instance.clearHistory();

  List<String> getRecentRoutes({int limit = 10}) =>
      NavigationService.instance.getRecentRoutes(limit: limit);
}
 */
