import 'package:flavorizr/core/ui/responsive/src/breakpoints.dart';
import 'package:flavorizr/core/ui/responsive/src/device_info.dart';
import 'package:flutter/material.dart';

/// A builder widget that rebuilds based on device type
///
/// Usage:
/// ```dart
/// ResponsiveBuilder(
///   mobile: (context, info) => MobileLayout(),
///   tablet: (context, info) => TabletLayout(),
///   desktop: (context, info) => DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Builder for mobile devices
  final Widget Function(BuildContext context, DeviceInfo info)? mobile;

  /// Builder for tablet devices
  final Widget Function(BuildContext context, DeviceInfo info)? tablet;

  /// Builder for desktop devices
  final Widget Function(BuildContext context, DeviceInfo info)? desktop;

  /// Default builder (used as fallback)
  final Widget Function(BuildContext context, DeviceInfo info)? builder;

  const ResponsiveBuilder({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.builder,
  }) : assert(
          mobile != null ||
              tablet != null ||
              desktop != null ||
              builder != null,
          'At least one builder must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);

    // Select the appropriate builder based on device type
    final selectedBuilder = switch (info.deviceType) {
      DeviceType.mobile => mobile ?? tablet ?? desktop ?? builder,
      DeviceType.tablet => tablet ?? mobile ?? desktop ?? builder,
      DeviceType.desktop => desktop ?? tablet ?? mobile ?? builder,
    };

    if (selectedBuilder == null) {
      return const SizedBox.shrink();
    }

    return selectedBuilder(context, info);
  }
}

/// A builder widget that rebuilds based on window size class
///
/// Usage:
/// ```dart
/// WindowSizeBuilder(
///   compact: (context, info) => CompactLayout(),
///   medium: (context, info) => MediumLayout(),
///   expanded: (context, info) => ExpandedLayout(),
/// )
/// ```
class WindowSizeBuilder extends StatelessWidget {
  /// Builder for compact size (< 600dp)
  final Widget Function(BuildContext context, DeviceInfo info)? compact;

  /// Builder for medium size (600-839dp)
  final Widget Function(BuildContext context, DeviceInfo info)? medium;

  /// Builder for expanded size (840-1199dp)
  final Widget Function(BuildContext context, DeviceInfo info)? expanded;

  /// Builder for large size (1200-1599dp)
  final Widget Function(BuildContext context, DeviceInfo info)? large;

  /// Builder for extra large size (>= 1600dp)
  final Widget Function(BuildContext context, DeviceInfo info)? extraLarge;

  const WindowSizeBuilder({
    super.key,
    this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);

    final selectedBuilder = switch (info.windowSizeClass) {
      WindowSizeClass.compact =>
        compact ?? medium ?? expanded ?? large ?? extraLarge,
      WindowSizeClass.medium =>
        medium ?? compact ?? expanded ?? large ?? extraLarge,
      WindowSizeClass.expanded =>
        expanded ?? medium ?? large ?? compact ?? extraLarge,
      WindowSizeClass.large =>
        large ?? expanded ?? extraLarge ?? medium ?? compact,
      WindowSizeClass.extraLarge =>
        extraLarge ?? large ?? expanded ?? medium ?? compact,
    };

    if (selectedBuilder == null) {
      return const SizedBox.shrink();
    }

    return selectedBuilder(context, info);
  }
}

/// A builder widget that rebuilds based on orientation
class OrientationBuilder extends StatelessWidget {
  /// Builder for portrait orientation
  final Widget Function(BuildContext context, DeviceInfo info) portrait;

  /// Builder for landscape orientation
  final Widget Function(BuildContext context, DeviceInfo info) landscape;

  const OrientationBuilder({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);

    return info.isPortrait ? portrait(context, info) : landscape(context, info);
  }
}

/// A builder widget that rebuilds when device info changes
///
/// Provides full DeviceInfo for more complex responsive logic
class DeviceInfoBuilder extends StatelessWidget {
  /// Builder with full device info
  final Widget Function(BuildContext context, DeviceInfo info) builder;

  const DeviceInfoBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    return builder(context, info);
  }
}

/// A builder that provides responsive values
///
/// Usage:
/// ```dart
/// ResponsiveValueBuilder<double>(
///   mobile: 16,
///   tablet: 24,
///   desktop: 32,
///   builder: (context, value) => Padding(
///     padding: EdgeInsets.all(value),
///     child: child,
///   ),
/// )
/// ```
class ResponsiveValueBuilder<T> extends StatelessWidget {
  /// Value for mobile devices
  final T mobile;

  /// Value for tablet devices
  final T? tablet;

  /// Value for desktop devices
  final T? desktop;

  /// Builder that receives the resolved value
  final Widget Function(BuildContext context, T value) builder;

  const ResponsiveValueBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfo.fromContext(context);
    final value = info.byDevice(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return builder(context, value);
  }
}

/// Platform-specific builder
class PlatformBuilder extends StatelessWidget {
  /// Default builder
  final Widget Function(BuildContext context) defaultBuilder;

  /// iOS builder
  final Widget Function(BuildContext context)? ios;

  /// Android builder
  final Widget Function(BuildContext context)? android;

  /// Web builder
  final Widget Function(BuildContext context)? web;

  /// macOS builder
  final Widget Function(BuildContext context)? macos;

  /// Windows builder
  final Widget Function(BuildContext context)? windows;

  /// Linux builder
  final Widget Function(BuildContext context)? linux;

  const PlatformBuilder({
    super.key,
    required this.defaultBuilder,
    this.ios,
    this.android,
    this.web,
    this.macos,
    this.windows,
    this.linux,
  });

  @override
  Widget build(BuildContext context) {
    final platform = PlatformType.current;

    final selectedBuilder = switch (platform) {
      PlatformType.ios => ios ?? defaultBuilder,
      PlatformType.android => android ?? defaultBuilder,
      PlatformType.web => web ?? defaultBuilder,
      PlatformType.macos => macos ?? defaultBuilder,
      PlatformType.windows => windows ?? defaultBuilder,
      PlatformType.linux => linux ?? defaultBuilder,
      PlatformType.unknown => defaultBuilder,
    };

    return selectedBuilder(context);
  }
}
