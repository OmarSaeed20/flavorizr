// lib/core/router/route_guards.dart
import 'dart:async';

import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Base class for route guards.
///
/// Route guards control access to specific routes based on various conditions.
abstract class RouteGuard {
  const RouteGuard();

  /// Checks if navigation to the route should be allowed.
  ///
  /// Returns `true` if navigation is allowed, `false` otherwise.
  FutureOr<bool> canActivate(BuildContext context, GoRouterState state);

  /// Gets the redirect path if navigation is denied.
  ///
  /// Returns `null` if no redirect should occur (will show error instead).
  FutureOr<String?> getRedirectPath(BuildContext context, GoRouterState state);
}

/// Guard that checks if user is authenticated.
class AuthGuard extends RouteGuard {
  const AuthGuard({required this.isAuthenticated, this.redirectPath = Routes.login});
  final Future<bool> Function() isAuthenticated;
  final String redirectPath;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async => isAuthenticated();

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) {
    // Store the intended destination for redirect after login
    final redirectUri = Uri(
      path: redirectPath,
      queryParameters: {'redirect': state.matchedLocation},
    );
    return redirectUri.toString();
  }
}

/// Guard that checks if user is NOT authenticated.
///
/// Used to prevent authenticated users from accessing login/register pages.
class GuestGuard extends RouteGuard {
  const GuestGuard({required this.isAuthenticated, this.redirectPath = Routes.home});
  final Future<bool> Function() isAuthenticated;
  final String redirectPath;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async =>
      !(await isAuthenticated());

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) => redirectPath;
}

/// Guard that checks user roles/permissions.
class RoleGuard extends RouteGuard {
  const RoleGuard({
    required this.getUserRoles,
    required this.requiredRoles,
    this.requireAll = false,
    this.redirectPath = Routes.home,
  });
  final Future<List<String>> Function() getUserRoles;
  final List<String> requiredRoles;
  final bool requireAll;
  final String redirectPath;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    final userRoles = await getUserRoles();

    if (requireAll) {
      return requiredRoles.every(userRoles.contains);
    } else {
      return requiredRoles.any(userRoles.contains);
    }
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) => redirectPath;
}

/// Guard that checks if onboarding is completed.
class OnboardingGuard extends RouteGuard {
  const OnboardingGuard({required this.isOnboardingCompleted});
  final Future<bool> Function() isOnboardingCompleted;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async =>
      isOnboardingCompleted();

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) => Routes.onboarding;
}

/// Guard that checks if email is verified.
class EmailVerificationGuard extends RouteGuard {
  const EmailVerificationGuard({required this.isEmailVerified});
  final Future<bool> Function() isEmailVerified;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async => isEmailVerified();

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) => Routes.verifyEmail;
}

/// Guard that checks a feature flag.
class FeatureFlagGuard extends RouteGuard {
  const FeatureFlagGuard({
    required this.isFeatureEnabled,
    required this.featureName,
    this.redirectPath = Routes.home,
  });
  final Future<bool> Function(String featureName) isFeatureEnabled;
  final String featureName;
  final String redirectPath;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async =>
      isFeatureEnabled(featureName);

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) => redirectPath;
}

/// Guard that combines multiple guards with AND logic.
///
/// All guards must pass for navigation to be allowed.
class CompositeAndGuard extends RouteGuard {
  const CompositeAndGuard(this.guards);
  final List<RouteGuard> guards;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    for (final guard in guards) {
      if (!(await guard.canActivate(context, state))) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<String?> getRedirectPath(BuildContext context, GoRouterState state) async {
    // Return the first guard's redirect path that would deny access
    for (final guard in guards) {
      return await guard.getRedirectPath(context, state);
    }
    return null;
  }
}

/// Guard that combines multiple guards with OR logic.
///
/// Any guard passing allows navigation.
class CompositeOrGuard extends RouteGuard {
  const CompositeOrGuard(this.guards, {this.defaultRedirectPath = Routes.home});
  final List<RouteGuard> guards;
  final String defaultRedirectPath;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    for (final guard in guards) {
      if (await guard.canActivate(context, state)) {
        return true;
      }
    }
    return false;
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) => defaultRedirectPath;
}

/// Utility class for managing multiple route guards.
class RouteGuardManager {
  final Map<String, List<RouteGuard>> _routeGuards = {};
  final List<RouteGuard> _globalGuards = [];

  /// Adds a guard for a specific route.
  void addGuardForRoute(String route, RouteGuard guard) {
    _routeGuards.putIfAbsent(route, () => []).add(guard);
  }

  /// Adds guards for multiple routes.
  void addGuardForRoutes(List<String> routes, RouteGuard guard) {
    for (final route in routes) {
      addGuardForRoute(route, guard);
    }
  }

  /// Adds a global guard that applies to all routes.
  void addGlobalGuard(RouteGuard guard) {
    _globalGuards.add(guard);
  }

  /// Removes all guards for a route.
  void removeGuardsForRoute(String route) {
    _routeGuards.remove(route);
  }

  /// Clears all guards.
  void clearAll() {
    _routeGuards.clear();
    _globalGuards.clear();
  }

  /// Checks all guards for a route.
  ///
  /// Returns the redirect path if any guard fails, null if all pass.
  Future<String?> checkGuards(BuildContext context, GoRouterState state) async {
    // Check global guards first
    for (final guard in _globalGuards) {
      if (!(await guard.canActivate(context, state))) {
        return await guard.getRedirectPath(context, state);
      }
    }

    // Check route-specific guards
    final routeGuards = _routeGuards[state.matchedLocation];
    if (routeGuards != null) {
      for (final guard in routeGuards) {
        if (!(await guard.canActivate(context, state))) {
          return await guard.getRedirectPath(context, state);
        }
      }
    }

    return null;
  }

  /// Gets all guards for a route (including global guards).
  List<RouteGuard> getGuardsForRoute(String route) => [
    ..._globalGuards,
    ...(_routeGuards[route] ?? []),
  ];
}
