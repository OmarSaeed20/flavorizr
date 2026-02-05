// lib/core/router/route_config.dart
import 'package:flutter/foundation.dart';

/// Route configuration for analytics, guards, and metadata.
///
/// Use this to define additional configuration for routes
/// such as authentication requirements, allowed roles, and analytics tracking.
@immutable
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

  /// The unique name identifier for this route.
  final String name;

  /// The URL path for this route.
  final String path;

  /// Whether this route requires authentication.
  final bool requiresAuth;

  /// List of roles that can access this route.
  /// Empty list means any authenticated user can access.
  final List<String> allowedRoles;

  /// Whether to track this route in analytics.
  final bool trackAnalytics;

  /// Optional cache duration for this route's data.
  final Duration? cacheDuration;

  /// Additional metadata for this route.
  final Map<String, dynamic>? metadata;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteConfig &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          path == other.path;

  @override
  int get hashCode => Object.hash(name, path);

  @override
  String toString() =>
      'RouteConfig(name: $name, path: $path, requiresAuth: $requiresAuth)';
}
