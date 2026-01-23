// lib/core/router/router_observer.dart
import 'package:flutter/material.dart';

/// Router observer for tracking navigation changes.
///
/// Used internally by `AppRouter` to track route changes
/// for analytics and history management.
class RouterObserver extends NavigatorObserver {
  RouterObserver({required this.onRouteChange});

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

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _notifyRouteChange(previousRoute);
    }
  }

  void _notifyRouteChange(Route<dynamic> route) {
    final settings = route.settings;
    final arguments = settings.arguments;
    final params = arguments is Map<String, dynamic> ? arguments : null;
    onRouteChange(settings.name ?? 'unknown', params);
  }
}
