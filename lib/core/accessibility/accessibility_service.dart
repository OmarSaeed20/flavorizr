// lib/core/accessibility/accessibility_service.dart
/// Accessibility service for managing accessibility features across the app.
///
/// Provides:
/// - Screen reader announcements
/// - Focus management
/// - Accessibility preferences
library;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Service for managing accessibility features across the app.
///
/// Provides:
/// - Screen reader announcements
/// - Focus management
/// - Accessibility preferences
class AccessibilityService {
  static AccessibilityService? _instance;

  AccessibilityService._();

  /// Gets the singleton instance.
  static AccessibilityService get instance {
    _instance ??= AccessibilityService._();
    return _instance!;
  }

  /// Announces a message to screen readers.
  ///
  /// [message] - The text to announce.
  /// [assertiveness] - How urgently the announcement should be made.
  void announce(
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announces a route change to screen readers.
  void announceRouteChange(String routeName) {
    announce('Navigated to $routeName');
  }

  /// Announces an error to screen readers (assertive).
  void announceError(String error) {
    announce('Error: $error', assertiveness: Assertiveness.assertive);
  }

  /// Announces a success message.
  void announceSuccess(String message) {
    announce(message);
  }

  /// Announces loading state.
  void announceLoading() {
    announce('Loading, please wait');
  }

  /// Announces completion of loading.
  void announceLoaded() {
    announce('Content loaded');
  }

  /// Announces a form validation error.
  void announceValidationError(String field, String error) {
    announceError('$field: $error');
  }

  /// Announces a notification.
  void announceNotification(String title, String? body) {
    final message = body != null ? '$title. $body' : title;
    announce(message);
  }

  /// Announces a state change.
  void announceStateChange(String item, String state) {
    announce('$item is now $state');
  }

  /// Announces a list item count.
  void announceListCount(int count, String itemType) {
    announce('$count $itemType${count == 1 ? '' : 's'} available');
  }
}

/// Assertiveness levels for screen reader announcements.
enum Assertiveness {
  /// Low priority, can be interrupted.
  polite,

  /// High priority, interrupts other announcements.
  assertive,
}

/// Extension methods for accessibility on BuildContext.
extension AccessibilityExtensions on BuildContext {
  /// Returns true if screen reader is enabled.
  bool get isScreenReaderEnabled {
    return MediaQuery.of(this).accessibleNavigation;
  }

  /// Returns true if reduce motion is enabled.
  bool get reduceMotion {
    return MediaQuery.of(this).disableAnimations;
  }

  /// Returns true if bold text is enabled.
  bool get boldText {
    return MediaQuery.of(this).boldText;
  }

  /// Returns true if high contrast is enabled.
  bool get highContrast {
    return MediaQuery.of(this).highContrast;
  }

  /// Returns the current text scale factor.
  double get textScaleFactor {
    return MediaQuery.textScalerOf(this).scale(1.0);
  }

  /// Returns true if large text is enabled (scale > 1.3).
  bool get largeText {
    return textScaleFactor > 1.3;
  }

  /// Returns true if invert colors is enabled.
  bool get invertColors {
    return MediaQuery.of(this).invertColors;
  }

  /// Returns the current platform brightness.
  Brightness get platformBrightness {
    return MediaQuery.of(this).platformBrightness;
  }

  /// Returns true if the platform is in dark mode.
  bool get isDarkMode {
    return platformBrightness == Brightness.dark;
  }

  /// Returns the padding for safe areas.
  EdgeInsets get safePadding {
    return MediaQuery.of(this).padding;
  }

  /// Returns the view insets (keyboard, etc.).
  EdgeInsets get viewInsets {
    return MediaQuery.of(this).viewInsets;
  }

  /// Returns the view padding (notches, etc.).
  EdgeInsets get viewPadding {
    return MediaQuery.of(this).viewPadding;
  }
}
