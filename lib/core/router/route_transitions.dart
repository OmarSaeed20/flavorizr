// lib/core/router/route_transitions.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for different navigation patterns.
///
/// These transitions enhance the UX by providing visual feedback
/// about the navigation hierarchy and direction.
class RouteTransitions {
  RouteTransitions._();

  /// Default transition duration.
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Fast transition duration.
  static const Duration fastDuration = Duration(milliseconds: 200);

  /// Slow transition duration.
  static const Duration slowDuration = Duration(milliseconds: 400);

  // ==================== Fade Transitions ====================

  /// Creates a fade transition page.
  static CustomTransitionPage<T> fade<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeInOut,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        ),
  );

  // ==================== Slide Transitions ====================

  /// Creates a slide from right transition (standard forward navigation).
  static CustomTransitionPage<T> slideFromRight<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );

  /// Creates a slide from left transition (back navigation style).
  static CustomTransitionPage<T> slideFromLeft<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );

  /// Creates a slide from bottom transition (modal style).
  static CustomTransitionPage<T> slideFromBottom<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );

  /// Creates a slide from top transition.
  static CustomTransitionPage<T> slideFromTop<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );

  // ==================== Scale Transitions ====================

  /// Creates a scale transition (zoom in).
  static CustomTransitionPage<T> scale<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
    Alignment alignment = Alignment.center,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).chain(CurveTween(curve: curve));

      return ScaleTransition(
        scale: animation.drive(tween),
        alignment: alignment,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );

  // ==================== Combined Transitions ====================

  /// Creates a fade + slide from right transition.
  static CustomTransitionPage<T> fadeSlideFromRight<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: curve),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );

  /// Creates a fade + slide from bottom transition.
  static CustomTransitionPage<T> fadeSlideFromBottom<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = Curves.easeOutCubic,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: curve),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );

  /// Creates a shared axis horizontal transition (Material Design).
  static CustomTransitionPage<T> sharedAxisHorizontal<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Entering page
      final fadeIn = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.3, 1, curve: Curves.easeOut),
      );
      final slideIn = Tween(
        begin: const Offset(30, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      // Exiting page (secondary animation is for the page being replaced)
      final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0, 0.3, curve: Curves.easeIn),
        ),
      );
      final slideOut = Tween(begin: Offset.zero, end: const Offset(-30, 0))
          .animate(
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInCubic,
            ),
          );

      return FadeTransition(
        opacity: fadeOut,
        child: Transform.translate(
          offset: slideOut.value,
          child: FadeTransition(
            opacity: fadeIn,
            child: Transform.translate(offset: slideIn.value, child: child),
          ),
        ),
      );
    },
  );

  /// Creates a shared axis vertical transition (Material Design).
  static CustomTransitionPage<T> sharedAxisVertical<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeIn = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.3, 1, curve: Curves.easeOut),
      );
      final slideIn = Tween(
        begin: const Offset(0, 30),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: fadeIn,
        child: Transform.translate(offset: slideIn.value, child: child),
      );
    },
  );

  // ==================== No Transition ====================

  /// Creates a page with no transition (instant).
  static CustomTransitionPage<T> none<T>({
    required LocalKey key,
    required Widget child,
  }) => CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        child,
  );

  // ==================== Platform Adaptive ====================

  /// Creates a platform-adaptive transition.
  ///
  /// - iOS/macOS: Cupertino slide transition
  /// - Android/others: Material fade through transition
  static CustomTransitionPage<T> adaptive<T>({
    required LocalKey key,
    required Widget child,
    required BuildContext context,
    Duration duration = defaultDuration,
  }) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return slideFromRight<T>(
        key: key,
        child: child,
        duration: duration,
        curve: Curves.easeInOut,
      );
    }

    return fadeSlideFromRight<T>(key: key, child: child, duration: duration);
  }
}

/// Extension to easily apply transitions to GoRoute.
extension GoRouteTransitionExtension on GoRoute {
  /// Creates a copy of this route with a custom page builder using fade transition.
  GoRoute withFadeTransition() => GoRoute(
    path: path,
    name: name,
    redirect: redirect,
    routes: routes,
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder: (context, state) {
      final childWidget = builder?.call(context, state) ?? const SizedBox();
      return RouteTransitions.fade(key: state.pageKey, child: childWidget);
    },
  );

  /// Creates a copy of this route with slide from bottom transition.
  GoRoute withSlideFromBottomTransition() => GoRoute(
    path: path,
    name: name,
    redirect: redirect,
    routes: routes,
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder: (context, state) {
      final childWidget = builder?.call(context, state) ?? const SizedBox();
      return RouteTransitions.slideFromBottom(
        key: state.pageKey,
        child: childWidget,
      );
    },
  );
}
