import 'package:flutter/material.dart';

import '../breakpoints.dart';
import '../device_info.dart';

/// Widget that shows/hides based on device type
///
/// Usage:
/// ```dart
/// ResponsiveVisibility(
///   visibleOn: {DeviceType.tablet, DeviceType.desktop},
///   child: SideNavigation(),
/// )
/// ```
class ResponsiveVisibility extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Device types where the child is visible
  final Set<DeviceType>? visibleOn;

  /// Device types where the child is hidden
  final Set<DeviceType>? hiddenOn;

  /// Replacement widget when hidden (defaults to SizedBox.shrink)
  final Widget? replacement;

  /// Whether to maintain size when hidden (uses Visibility widget)
  final bool maintainSize;

  /// Whether to maintain animation when hidden
  final bool maintainAnimation;

  /// Whether to maintain state when hidden
  final bool maintainState;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOn,
    this.hiddenOn,
    this.replacement,
    this.maintainSize = false,
    this.maintainAnimation = false,
    this.maintainState = false,
  }) : assert(
          visibleOn != null || hiddenOn != null,
          'Either visibleOn or hiddenOn must be specified',
        );

  /// Show only on mobile
  factory ResponsiveVisibility.mobileOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {DeviceType.mobile},
      replacement: replacement,
      child: child,
    );
  }

  /// Show only on tablet
  factory ResponsiveVisibility.tabletOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {DeviceType.tablet},
      replacement: replacement,
      child: child,
    );
  }

  /// Show only on desktop
  factory ResponsiveVisibility.desktopOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {DeviceType.desktop},
      replacement: replacement,
      child: child,
    );
  }

  /// Show on tablet and desktop
  factory ResponsiveVisibility.tabletUp({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {DeviceType.tablet, DeviceType.desktop},
      replacement: replacement,
      child: child,
    );
  }

  /// Show on mobile and tablet
  factory ResponsiveVisibility.tabletDown({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {DeviceType.mobile, DeviceType.tablet},
      replacement: replacement,
      child: child,
    );
  }

  /// Hide on mobile
  factory ResponsiveVisibility.hideMobile({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return ResponsiveVisibility(
      key: key,
      hiddenOn: const {DeviceType.mobile},
      replacement: replacement,
      child: child,
    );
  }

  /// Hide on desktop
  factory ResponsiveVisibility.hideDesktop({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return ResponsiveVisibility(
      key: key,
      hiddenOn: const {DeviceType.desktop},
      replacement: replacement,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final currentDevice = info.deviceType;

    bool isVisible;

    if (visibleOn != null) {
      isVisible = visibleOn!.contains(currentDevice);
    } else {
      isVisible = !hiddenOn!.contains(currentDevice);
    }

    if (maintainSize || maintainAnimation || maintainState) {
      return Visibility(
        visible: isVisible,
        maintainSize: maintainSize,
        maintainAnimation: maintainAnimation,
        maintainState: maintainState,
        replacement: replacement ?? const SizedBox.shrink(),
        child: child,
      );
    }

    return isVisible ? child : (replacement ?? const SizedBox.shrink());
  }
}

/// Widget that shows/hides based on window size class
class WindowSizeVisibility extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Window sizes where the child is visible
  final Set<WindowSizeClass>? visibleOn;

  /// Window sizes where the child is hidden
  final Set<WindowSizeClass>? hiddenOn;

  /// Replacement widget when hidden
  final Widget? replacement;

  const WindowSizeVisibility({
    super.key,
    required this.child,
    this.visibleOn,
    this.hiddenOn,
    this.replacement,
  }) : assert(
          visibleOn != null || hiddenOn != null,
          'Either visibleOn or hiddenOn must be specified',
        );

  /// Show only on compact screens
  factory WindowSizeVisibility.compactOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return WindowSizeVisibility(
      key: key,
      visibleOn: const {WindowSizeClass.compact},
      replacement: replacement,
      child: child,
    );
  }

  /// Show on medium and larger screens
  factory WindowSizeVisibility.mediumUp({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return WindowSizeVisibility(
      key: key,
      visibleOn: const {
        WindowSizeClass.medium,
        WindowSizeClass.expanded,
        WindowSizeClass.large,
        WindowSizeClass.extraLarge,
      },
      replacement: replacement,
      child: child,
    );
  }

  /// Show on expanded and larger screens
  factory WindowSizeVisibility.expandedUp({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return WindowSizeVisibility(
      key: key,
      visibleOn: const {
        WindowSizeClass.expanded,
        WindowSizeClass.large,
        WindowSizeClass.extraLarge,
      },
      replacement: replacement,
      child: child,
    );
  }

  /// Show on large and larger screens
  factory WindowSizeVisibility.largeUp({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return WindowSizeVisibility(
      key: key,
      visibleOn: const {
        WindowSizeClass.large,
        WindowSizeClass.extraLarge,
      },
      replacement: replacement,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final currentSize = info.windowSizeClass;

    bool isVisible;

    if (visibleOn != null) {
      isVisible = visibleOn!.contains(currentSize);
    } else {
      isVisible = !hiddenOn!.contains(currentSize);
    }

    return isVisible ? child : (replacement ?? const SizedBox.shrink());
  }
}

/// Widget that shows/hides based on orientation
class OrientationVisibility extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Show only in portrait
  final bool portraitOnly;

  /// Show only in landscape
  final bool landscapeOnly;

  /// Replacement widget when hidden
  final Widget? replacement;

  const OrientationVisibility({
    super.key,
    required this.child,
    this.portraitOnly = false,
    this.landscapeOnly = false,
    this.replacement,
  }) : assert(
          portraitOnly != landscapeOnly,
          'Either portraitOnly or landscapeOnly must be true, but not both',
        );

  /// Show only in portrait orientation
  factory OrientationVisibility.portrait({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return OrientationVisibility(
      key: key,
      portraitOnly: true,
      replacement: replacement,
      child: child,
    );
  }

  /// Show only in landscape orientation
  factory OrientationVisibility.landscape({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return OrientationVisibility(
      key: key,
      landscapeOnly: true,
      replacement: replacement,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);

    bool isVisible;

    if (portraitOnly) {
      isVisible = info.isPortrait;
    } else {
      isVisible = info.isLandscape;
    }

    return isVisible ? child : (replacement ?? const SizedBox.shrink());
  }
}

/// Widget that shows/hides based on platform
class PlatformVisibility extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Platforms where the child is visible
  final Set<PlatformType>? visibleOn;

  /// Platforms where the child is hidden
  final Set<PlatformType>? hiddenOn;

  /// Replacement widget when hidden
  final Widget? replacement;

  const PlatformVisibility({
    super.key,
    required this.child,
    this.visibleOn,
    this.hiddenOn,
    this.replacement,
  }) : assert(
          visibleOn != null || hiddenOn != null,
          'Either visibleOn or hiddenOn must be specified',
        );

  /// Show only on web
  factory PlatformVisibility.webOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return PlatformVisibility(
      key: key,
      visibleOn: const {PlatformType.web},
      replacement: replacement,
      child: child,
    );
  }

  /// Show only on mobile platforms (iOS, Android)
  factory PlatformVisibility.mobileOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return PlatformVisibility(
      key: key,
      visibleOn: const {PlatformType.ios, PlatformType.android},
      replacement: replacement,
      child: child,
    );
  }

  /// Show only on desktop platforms (macOS, Windows, Linux)
  factory PlatformVisibility.desktopOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return PlatformVisibility(
      key: key,
      visibleOn: const {
        PlatformType.macos,
        PlatformType.windows,
        PlatformType.linux,
      },
      replacement: replacement,
      child: child,
    );
  }

  /// Hide on web
  factory PlatformVisibility.hideWeb({
    Key? key,
    required Widget child,
    Widget? replacement,
  }) {
    return PlatformVisibility(
      key: key,
      hiddenOn: const {PlatformType.web},
      replacement: replacement,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPlatform = PlatformType.current;

    bool isVisible;

    if (visibleOn != null) {
      isVisible = visibleOn!.contains(currentPlatform);
    } else {
      isVisible = !hiddenOn!.contains(currentPlatform);
    }

    return isVisible ? child : (replacement ?? const SizedBox.shrink());
  }
}
