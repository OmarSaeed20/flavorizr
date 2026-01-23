import 'package:flutter/material.dart';

import 'device_info.dart';
import 'responsive_context.dart';

/// A responsive value that changes based on device type or screen size
///
/// Usage:
/// ```dart
/// final padding = ResponsiveValue<double>(
///   mobile: 16,
///   tablet: 24,
///   desktop: 32,
/// ).resolve(context);
/// ```
class ResponsiveValue<T> {
  /// Value for mobile devices
  final T mobile;

  /// Value for tablet devices (falls back to mobile if null)
  final T? tablet;

  /// Value for desktop devices (falls back to tablet, then mobile if null)
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Resolve the value based on the current context
  T resolve(BuildContext context) {
    final responsive = ResponsiveContext(context);
    return responsive.byDevice(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Resolve using DeviceInfo directly
  T resolveWithInfo(DeviceInfo info) {
    return info.byDevice(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// A responsive value based on window size class
class WindowResponsiveValue<T> {
  final T compact;
  final T? medium;
  final T? expanded;
  final T? large;
  final T? extraLarge;

  const WindowResponsiveValue({
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  });

  /// Resolve the value based on the current context
  T resolve(BuildContext context) {
    final responsive = ResponsiveContext(context);
    return responsive.byWindowSize(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// Resolve using DeviceInfo directly
  T resolveWithInfo(DeviceInfo info) {
    return info.byWindowSize(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }
}

/// A responsive value based on orientation
class OrientationResponsiveValue<T> {
  final T portrait;
  final T landscape;

  const OrientationResponsiveValue({
    required this.portrait,
    required this.landscape,
  });

  /// Resolve the value based on the current context
  T resolve(BuildContext context) {
    final responsive = ResponsiveContext(context);
    return responsive.byOrientation(
      portrait: portrait,
      landscape: landscape,
    );
  }

  /// Resolve using DeviceInfo directly
  T resolveWithInfo(DeviceInfo info) {
    return info.byOrientation(
      portrait: portrait,
      landscape: landscape,
    );
  }
}

/// A responsive value based on platform
class PlatformResponsiveValue<T> {
  final T defaultValue;
  final T? ios;
  final T? android;
  final T? web;
  final T? macos;
  final T? windows;
  final T? linux;

  const PlatformResponsiveValue({
    required this.defaultValue,
    this.ios,
    this.android,
    this.web,
    this.macos,
    this.windows,
    this.linux,
  });

  /// Resolve the value based on the current context
  T resolve(BuildContext context) {
    final responsive = ResponsiveContext(context);
    return responsive.byPlatform(
      defaultValue: defaultValue,
      ios: ios,
      android: android,
      web: web,
      macos: macos,
      windows: windows,
      linux: linux,
    );
  }

  /// Resolve using DeviceInfo directly
  T resolveWithInfo(DeviceInfo info) {
    return info.byPlatform(
      defaultValue: defaultValue,
      ios: ios,
      android: android,
      web: web,
      macos: macos,
      windows: windows,
      linux: linux,
    );
  }
}

/// Extension to easily create responsive values
extension ResponsiveValueExtension<T> on T {
  /// Create a responsive value with this as the mobile value
  ResponsiveValue<T> responsive({T? tablet, T? desktop}) {
    return ResponsiveValue<T>(
      mobile: this,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Create a window responsive value with this as the compact value
  WindowResponsiveValue<T> windowResponsive({
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return WindowResponsiveValue<T>(
      compact: this,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }
}
