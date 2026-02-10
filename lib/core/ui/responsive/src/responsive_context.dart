import 'package:fast_golden_taxi/core/ui/responsive/src/breakpoints.dart';
import 'package:fast_golden_taxi/core/ui/responsive/src/device_info.dart';
import 'package:fast_golden_taxi/core/ui/responsive/src/responsive_data.dart';
import 'package:flutter/material.dart';

/// Responsive context that provides access to all responsive utilities
///
/// This is the main entry point for responsive design utilities.
/// Access via the `context.responsive` extension.
class ResponsiveContext {
  /// The build context
  final BuildContext context;

  /// Cached device info
  DeviceInfo? _deviceInfo;

  /// Cached responsive data
  ResponsiveData? _responsiveData;

  ResponsiveContext(this.context);

  // ═══════════════════════════════════════════════════════════════════════════
  // DEVICE INFO
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get device information
  DeviceInfo get device => _deviceInfo ??= DeviceInfo.fromContext(context);

  /// Alias for device info
  DeviceInfo get info => device;

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE DATA
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get responsive data (spacing, sizing, etc.)
  ResponsiveData get data => _responsiveData ??= ResponsiveData(device);

  /// Shorthand for padding values
  ResponsivePadding get padding => data.padding;

  /// Shorthand for spacing values
  ResponsiveSpacing get spacing => data.spacing;

  /// Shorthand for sizing values
  ResponsiveSizing get sizing => data.sizing;

  /// Shorthand for radius values
  ResponsiveRadius get radius => data.radius;

  /// Shorthand for font sizes
  ResponsiveFontSize get fontSize => data.fontSize;

  /// Shorthand for icon sizes
  ResponsiveIconSize get iconSize => data.iconSize;

  // ═══════════════════════════════════════════════════════════════════════════
  // QUICK ACCESS PROPERTIES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Screen width
  double get width => device.screenWidth;

  /// Screen height
  double get height => device.screenHeight;

  /// Device type
  DeviceType get deviceType => device.deviceType;

  /// Window size class
  WindowSizeClass get windowSize => device.windowSizeClass;

  /// Is mobile device
  bool get isMobile => device.isMobile;

  /// Is tablet device
  bool get isTablet => device.isTablet;

  /// Is desktop device
  bool get isDesktop => device.isDesktop;

  /// Is in portrait orientation
  bool get isPortrait => device.isPortrait;

  /// Is in landscape orientation
  bool get isLandscape => device.isLandscape;

  /// Is running on web
  bool get isWeb => device.isWeb;

  /// Is dark mode enabled
  bool get isDarkMode => device.isDarkMode;

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE VALUE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns value based on device type
  T byDevice<T>({required T mobile, T? tablet, T? desktop}) {
    return device.byDevice(mobile: mobile, tablet: tablet, desktop: desktop);
  }

  /// Returns value based on window size class
  T byWindowSize<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return device.byWindowSize(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// Returns value based on orientation
  T byOrientation<T>({required T portrait, required T landscape}) {
    return device.byOrientation(portrait: portrait, landscape: landscape);
  }

  /// Returns value based on platform
  T byPlatform<T>({
    required T defaultValue,
    T? ios,
    T? android,
    T? web,
    T? macos,
    T? windows,
    T? linux,
  }) {
    return device.byPlatform(
      defaultValue: defaultValue,
      ios: ios,
      android: android,
      web: web,
      macos: macos,
      windows: windows,
      linux: linux,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LAYOUT HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Maximum content width for centered layouts
  double get maxContentWidth => device.maxContentWidth;

  /// Number of columns for grid layouts
  int get gridColumns => device.gridColumns;

  /// Whether to use drawer navigation
  bool get useDrawerNavigation => device.useDrawerNavigation;

  /// Whether to use bottom navigation
  bool get useBottomNavigation => device.useBottomNavigation;

  /// Whether to use rail navigation
  bool get useRailNavigation => device.useRailNavigation;

  /// Whether to use permanent navigation drawer
  bool get usePermanentNavigation => device.usePermanentNavigation;

  // ═══════════════════════════════════════════════════════════════════════════
  // GAP WIDGETS (Convenience)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Extra small gap (4)
  SizedBox get gapXs => SizedBox.square(dimension: spacing.xs);

  /// Small gap (8)
  SizedBox get gapSm => SizedBox.square(dimension: spacing.sm);

  /// Medium gap (16)
  SizedBox get gapMd => SizedBox.square(dimension: spacing.md);

  /// Large gap (24)
  SizedBox get gapLg => SizedBox.square(dimension: spacing.lg);

  /// Extra large gap (32)
  SizedBox get gapXl => SizedBox.square(dimension: spacing.xl);

  // ═══════════════════════════════════════════════════════════════════════════
  // PADDING HELPERS (Convenience)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Screen padding (horizontal padding for content)
  EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: padding.screen);

  /// Card padding
  EdgeInsets get cardPadding => EdgeInsets.all(padding.card);

  /// Content padding
  EdgeInsets get contentPadding => EdgeInsets.all(padding.content);
}
