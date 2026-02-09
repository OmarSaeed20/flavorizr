// lib/core/router/role_based_guard.dart
import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/router/route_guards.dart';
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Guard that checks user role matches route requirements
class UserRoleGuard extends RouteGuard {
  const UserRoleGuard({required this.getUserRole});

  /// Function that returns the current user's role ('consumer', 'driver', 'company', or null)
  final Future<String?> Function() getUserRole;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    final userRole = await getUserRole();
    final location = state.matchedLocation;

    // Allow access to public routes (auth, splash, onboarding, etc.)
    if (!Routes.requiresAuth(location)) {
      return true;
    }

    // If user has no role, deny access (should redirect to role selection)
    if (userRole == null || userRole.isEmpty) {
      AppLogger.instance.logInfo('Access denied: No role assigned', data: {'route': location});
      return false;
    }

    // Check if route matches user's role
    if (Routes.isConsumerRoute(location)) {
      final hasAccess = userRole == 'consumer';
      if (!hasAccess) {
        AppLogger.instance.logInfo(
          'Access denied: Consumer route requires consumer role',
          data: {'route': location, 'userRole': userRole},
        );
      }
      return hasAccess;
    }

    if (Routes.isDriverRoute(location)) {
      final hasAccess = userRole == 'driver';
      if (!hasAccess) {
        AppLogger.instance.logInfo(
          'Access denied: Driver route requires driver role',
          data: {'route': location, 'userRole': userRole},
        );
      }
      return hasAccess;
    }

    if (Routes.isCompanyRoute(location)) {
      final hasAccess = userRole == 'company';
      if (!hasAccess) {
        AppLogger.instance.logInfo(
          'Access denied: Company route requires company role',
          data: {'route': location, 'userRole': userRole},
        );
      }
      return hasAccess;
    }

    // Allow access for shared/general routes that don't have role restrictions
    return true;
  }

  @override
  Future<String?> getRedirectPath(BuildContext context, GoRouterState state) async {
    final userRole = await getUserRole();

    // If no role, redirect to role selection
    if (userRole == null || userRole.isEmpty) {
      return Routes.roleSelection;
    }

    // Redirect to appropriate home based on user's role
    return switch (userRole) {
      'consumer' => Routes.consumerHome,
      'driver' => Routes.driverHome,
      'company' => Routes.companyDashboard,
      _ => Routes.roleSelection,
    };
  }
}

/// Guard that ensures user has selected a role before accessing protected routes
class RoleSelectionGuard extends RouteGuard {
  const RoleSelectionGuard({required this.getUserRole, this.redirectPath = Routes.roleSelection});

  final Future<String?> Function() getUserRole;
  final String redirectPath;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;

    // Allow access to public routes
    if (!Routes.requiresAuth(location)) {
      return true;
    }

    // Allow access to role selection page itself
    if (location == Routes.roleSelection) {
      return true;
    }

    final userRole = await getUserRole();

    // Check if user has a role
    if (userRole == null || userRole.isEmpty) {
      AppLogger.instance.logInfo('Role selection required', data: {'route': location});
      return false;
    }

    return true;
  }

  @override
  String? getRedirectPath(BuildContext context, GoRouterState state) {
    return redirectPath;
  }
}

/// Combined guard for checking both authentication and role
class AuthAndRoleGuard extends RouteGuard {
  const AuthAndRoleGuard({required this.isAuthenticated, required this.getUserRole});

  final Future<bool> Function() isAuthenticated;
  final Future<String?> Function() getUserRole;

  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;

    // Allow public routes
    if (!Routes.requiresAuth(location)) {
      return true;
    }

    // Check authentication first
    final authenticated = await isAuthenticated();
    if (!authenticated) {
      AppLogger.instance.logInfo('Access denied: Not authenticated', data: {'route': location});
      return false;
    }

    // Then check role
    final userRole = await getUserRole();
    if (userRole == null || userRole.isEmpty) {
      AppLogger.instance.logInfo('Access denied: No role selected', data: {'route': location});
      return false;
    }

    // Finally check role matches route
    if (Routes.isConsumerRoute(location) && userRole != 'consumer') {
      return false;
    }
    if (Routes.isDriverRoute(location) && userRole != 'driver') {
      return false;
    }
    if (Routes.isCompanyRoute(location) && userRole != 'company') {
      return false;
    }

    return true;
  }

  @override
  Future<String?> getRedirectPath(BuildContext context, GoRouterState state) async {
    final authenticated = await isAuthenticated();

    if (!authenticated) {
      // Not logged in -> go to login
      return Routes.login;
    }

    final userRole = await getUserRole();
    if (userRole == null || userRole.isEmpty) {
      // Logged in but no role -> go to role selection
      return Routes.roleSelection;
    }

    // Logged in with role but wrong route -> go to their home
    return switch (userRole) {
      'consumer' => Routes.consumerHome,
      'driver' => Routes.driverHome,
      'company' => Routes.companyDashboard,
      _ => Routes.roleSelection,
    };
  }
}
