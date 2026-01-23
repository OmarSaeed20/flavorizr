// lib/core/router/navigation_state.dart
import 'package:flutter/foundation.dart';

/// Navigation state for tracking current route.
@immutable
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationState &&
          runtimeType == other.runtimeType &&
          currentRoute == other.currentRoute &&
          canGoBack == other.canGoBack &&
          isLoading == other.isLoading;

  @override
  int get hashCode => Object.hash(currentRoute, canGoBack, isLoading);

  @override
  String toString() =>
      'NavigationState(currentRoute: $currentRoute, canGoBack: $canGoBack, isLoading: $isLoading)';
}
