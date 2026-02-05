import 'package:flutter/foundation.dart';

/// Material Design 3 Responsive Breakpoints
///
/// Based on Material Design guidelines with additional breakpoints
/// for finer control over responsive layouts.
///
/// Reference: https://m3.material.io/foundations/layout/applying-layout/window-size-classes
class Breakpoints {
  const Breakpoints._();

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPACT (Mobile) - Width < 600dp
  // ═══════════════════════════════════════════════════════════════════════════

  /// Extra small mobile devices (width < 360)
  static const double xs = 0;

  /// Small mobile devices (width >= 360)
  static const double sm = 360;

  /// Standard mobile devices (width >= 480)
  static const double md = 480;

  // ═══════════════════════════════════════════════════════════════════════════
  // MEDIUM (Tablet) - Width 600-839dp
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small tablets / Large phones in landscape (width >= 600)
  static const double compact = 600;

  /// Standard tablets (width >= 720)
  static const double tablet = 720;

  // ═══════════════════════════════════════════════════════════════════════════
  // EXPANDED (Desktop/Large Tablet) - Width 840-1199dp
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large tablets / Small laptops (width >= 840)
  static const double medium = 840;

  /// Standard desktops (width >= 1024)
  static const double desktop = 1024;

  // ═══════════════════════════════════════════════════════════════════════════
  // LARGE (Large Desktop) - Width 1200-1599dp
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large desktops (width >= 1200)
  static const double expanded = 1200;

  /// Wide screens (width >= 1440)
  static const double wide = 1440;

  // ═══════════════════════════════════════════════════════════════════════════
  // EXTRA LARGE - Width >= 1600dp
  // ═══════════════════════════════════════════════════════════════════════════

  /// Extra large screens (width >= 1600)
  static const double xl = 1600;

  /// Ultra-wide screens (width >= 1920)
  static const double xxl = 1920;

  // ═══════════════════════════════════════════════════════════════════════════
  // WINDOW SIZE CLASSES (Material Design 3)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Maximum width for mobile layouts
  static const double mobileMax = compact - 1; // 599

  /// Maximum width for tablet layouts
  static const double tabletMax = medium - 1; // 839

  /// Maximum width for desktop layouts
  static const double desktopMax = expanded - 1; // 1199
}

/// Window size class based on Material Design 3
enum WindowSizeClass {
  /// Compact: width < 600dp (phones in portrait)
  compact,

  /// Medium: width 600-839dp (tablets, foldables, phones in landscape)
  medium,

  /// Expanded: width 840-1199dp (tablets, small laptops)
  expanded,

  /// Large: width 1200-1599dp (desktops)
  large,

  /// ExtraLarge: width >= 1600dp (large desktops, TVs)
  extraLarge;

  /// Check if this is a compact size (mobile)
  bool get isCompact => this == WindowSizeClass.compact;

  /// Check if this is a medium size (tablet)
  bool get isMedium => this == WindowSizeClass.medium;

  /// Check if this is an expanded size (small desktop)
  bool get isExpanded => this == WindowSizeClass.expanded;

  /// Check if this is a large size (desktop)
  bool get isLarge => this == WindowSizeClass.large;

  /// Check if this is an extra large size (large desktop)
  bool get isExtraLarge => this == WindowSizeClass.extraLarge;

  /// Check if this is mobile-like (compact)
  bool get isMobile => isCompact;

  /// Check if this is tablet-like (medium or expanded)
  bool get isTablet => isMedium || isExpanded;

  /// Check if this is desktop-like (large or extra large)
  bool get isDesktop => isLarge || isExtraLarge;

  /// Check if this is at least medium size
  bool get isAtLeastMedium => index >= WindowSizeClass.medium.index;

  /// Check if this is at least expanded size
  bool get isAtLeastExpanded => index >= WindowSizeClass.expanded.index;

  /// Check if this is at least large size
  bool get isAtLeastLarge => index >= WindowSizeClass.large.index;

  /// Get window size class from width
  static WindowSizeClass fromWidth(double width) {
    if (width >= Breakpoints.xl) return WindowSizeClass.extraLarge;
    if (width >= Breakpoints.expanded) return WindowSizeClass.large;
    if (width >= Breakpoints.medium) return WindowSizeClass.expanded;
    if (width >= Breakpoints.compact) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }

  /// Returns a value based on the window size class
  T when<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return switch (this) {
      WindowSizeClass.compact => compact,
      WindowSizeClass.medium => medium ?? compact,
      WindowSizeClass.expanded => expanded ?? medium ?? compact,
      WindowSizeClass.large => large ?? expanded ?? medium ?? compact,
      WindowSizeClass.extraLarge =>
        extraLarge ?? large ?? expanded ?? medium ?? compact,
    };
  }

  /// Returns a value for mobile, tablet, or desktop
  T maybeWhen<T>({required T orElse, T? mobile, T? tablet, T? desktop}) {
    if (isMobile && mobile != null) return mobile;
    if (isTablet && tablet != null) return tablet;
    if (isDesktop && desktop != null) return desktop;
    return orElse;
  }
}

/// Device type classification
enum DeviceType {
  /// Mobile phone
  mobile,

  /// Tablet device
  tablet,

  /// Desktop/laptop computer
  desktop;

  /// Check if mobile
  bool get isMobile => this == DeviceType.mobile;

  /// Check if tablet
  bool get isTablet => this == DeviceType.tablet;

  /// Check if desktop
  bool get isDesktop => this == DeviceType.desktop;

  /// Returns a value based on device type
  T when<T>({required T mobile, T? tablet, T? desktop}) {
    return switch (this) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
    };
  }

  /// Returns a value based on device type (legacy alias)
  /// @deprecated Use when instead
  T valueWhen<T>({required T mobile, T? tablet, T? desktop}) {
    return when(mobile: mobile, tablet: tablet, desktop: desktop);
  }

  /// Get device type from window size class
  static DeviceType fromWindowSizeClass(WindowSizeClass sizeClass) {
    return switch (sizeClass) {
      WindowSizeClass.compact => DeviceType.mobile,
      WindowSizeClass.medium => DeviceType.tablet,
      WindowSizeClass.expanded => DeviceType.tablet,
      WindowSizeClass.large => DeviceType.desktop,
      WindowSizeClass.extraLarge => DeviceType.desktop,
    };
  }

  /// Get device type from screen width
  static DeviceType fromWidth(double width) {
    return fromWindowSizeClass(WindowSizeClass.fromWidth(width));
  }
}

/// Orientation type
enum OrientationType {
  /// Portrait orientation (height > width)
  portrait,

  /// Landscape orientation (width > height)
  landscape;

  /// Check if portrait
  bool get isPortrait => this == OrientationType.portrait;

  /// Check if landscape
  bool get isLandscape => this == OrientationType.landscape;

  /// Get orientation from dimensions
  static OrientationType fromDimensions(double width, double height) {
    return width > height
        ? OrientationType.landscape
        : OrientationType.portrait;
  }
}

/// Platform type for platform-specific adjustments
enum PlatformType {
  /// iOS platform
  ios,

  /// Android platform
  android,

  /// Web platform
  web,

  /// macOS platform
  macos,

  /// Windows platform
  windows,

  /// Linux platform
  linux,

  /// Unknown platform
  unknown;

  /// Check if mobile platform (iOS or Android)
  bool get isMobilePlatform =>
      this == PlatformType.ios || this == PlatformType.android;

  /// Check if desktop platform (macOS, Windows, Linux)
  bool get isDesktopPlatform =>
      this == PlatformType.macos ||
      this == PlatformType.windows ||
      this == PlatformType.linux;

  /// Check if web platform
  bool get isWebPlatform => this == PlatformType.web;

  /// Check if Apple platform (iOS or macOS)
  bool get isApplePlatform =>
      this == PlatformType.ios || this == PlatformType.macos;

  /// Get current platform
  static PlatformType get current {
    if (kIsWeb) return PlatformType.web;

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => PlatformType.ios,
      TargetPlatform.android => PlatformType.android,
      TargetPlatform.macOS => PlatformType.macos,
      TargetPlatform.windows => PlatformType.windows,
      TargetPlatform.linux => PlatformType.linux,
      _ => PlatformType.unknown,
    };
  }
}
