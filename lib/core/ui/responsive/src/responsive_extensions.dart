import 'package:flavorizr/core/ui/responsive/src/responsive_context.dart';
import 'package:flavorizr/core/ui/responsive/src/responsive_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extensions on BuildContext for responsive utilities
extension ResponsiveContextExtension on BuildContext {
  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE CONTEXT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get the responsive context with all utilities
  ResponsiveContext get responsive => ResponsiveContext(this);

  /// Shorthand for responsive data
  ResponsiveData get responsiveData => responsive.data;

  // ═══════════════════════════════════════════════════════════════════════════
  // DEVICE TYPE CHECKS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if device is tablet
  bool get isTablet => responsive.isTablet;

  /// Check if device is desktop or larger (large or extra large window size)
  bool get isDesktopOrLarger => responsive.isDesktop;

  /// Check if device is tablet or larger (medium, expanded, large, or extra large)
  bool get isTabletOrLarger => responsive.windowSize.isAtLeastMedium;

  /// Adaptive horizontal padding for small content areas
  double get adaptiveHorizontalPaddingSmall =>
      responsive.byDevice(mobile: 12.r, tablet: 16.r, desktop: 20.r);

  // ═══════════════════════════════════════════════════════════════════════════
  // PLATFORM CHECKS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if running on web
  bool get isWeb => responsive.device.isWeb;

  /// Check if running on iOS
  bool get isIOS => responsive.device.isIOS;

  /// Check if running on Android
  bool get isAndroid => responsive.device.isAndroid;

  /// Check if running on macOS
  bool get isMacOS => responsive.device.isMacOS;

  /// Check if running on Windows
  bool get isWindows => responsive.device.isWindows;

  /// Check if running on Linux
  bool get isLinux => responsive.device.isLinux;

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE VALUE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns value based on device type (mobile, tablet, desktop)
  T byDevice<T>({required T mobile, T? tablet, T? desktop}) {
    return responsive.byDevice(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Returns value based on window size class
  T byWindowSize<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return responsive.byWindowSize(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// Returns value based on orientation
  T byOrientation<T>({required T portrait, required T landscape}) {
    return responsive.byOrientation(portrait: portrait, landscape: landscape);
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

  // ═══════════════════════════════════════════════════════════════════════════
  // SPACING SHORTCUTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get responsive spacing
  ResponsiveSpacing get rSpacing => responsive.spacing;

  /// Get responsive padding
  ResponsivePadding get rPadding => responsive.padding;

  /// Get responsive sizing
  ResponsiveSizing get rSizing => responsive.sizing;

  /// Get responsive radius
  ResponsiveRadius get rRadius => responsive.radius;

  /// Get responsive font sizes
  ResponsiveFontSize get rFontSize => responsive.fontSize;

  /// Get responsive icon sizes
  ResponsiveIconSize get rIconSize => responsive.iconSize;
}

/// Extensions on num for responsive scaling
extension ResponsiveNumExtension on num {
  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE SCALING (using ScreenUtil from playx)
  // Note: .w, .h, .r, .sp are already provided by playx/ScreenUtil
  // These are semantic aliases for clarity
  // ═══════════════════════════════════════════════════════════════════════════

  /// Responsive width (based on design width) - alias for .w
  double get rw => w;

  /// Responsive height (based on design height) - alias for .h
  double get rh => h;

  /// Responsive size (based on shorter side) - alias for .r
  double get rs => r;

  /// Responsive font size (with text scale factor) - alias for .sp
  double get rsp => sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC SCALING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Scale for spacing - uses .r
  double get spaced => r;

  /// Scale for padded - uses .r
  double get padded => r;

  /// Scale for radiused - uses .r
  double get radiused => r;

  /// Scale for icons - uses .r
  double get iconed => r;

  /// Scale for font size - uses .sp
  double get fonted => sp;
}

/// Extensions for SizedBox gap creation
extension ResponsiveGapExtension on num {
  /// Creates a horizontal SizedBox with responsive width
  SizedBox get horizontalGap => SizedBox(width: r);

  /// Creates a vertical SizedBox with responsive height
  SizedBox get verticalGap => SizedBox(height: r);

  /// Creates a square SizedBox with responsive dimensions
  SizedBox get gap => SizedBox.square(dimension: r);
}

/// Extensions for EdgeInsets creation
extension ResponsiveEdgeInsetsExtension on num {
  /// Creates EdgeInsets.all with responsive value
  EdgeInsets get allPadding => EdgeInsets.all(r);

  /// Creates symmetric horizontal EdgeInsets
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: r);

  /// Creates symmetric vertical EdgeInsets
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: r);

  /// Creates only left EdgeInsets
  EdgeInsets get leftPadding => EdgeInsets.only(left: r);

  /// Creates only right EdgeInsets
  EdgeInsets get rightPadding => EdgeInsets.only(right: r);

  /// Creates only top EdgeInsets
  EdgeInsets get topPadding => EdgeInsets.only(top: r);

  /// Creates only bottom EdgeInsets
  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: r);
}

/// Extensions for BorderRadius creation
extension ResponsiveBorderRadiusExtension on num {
  /// Creates circular BorderRadius with responsive value
  BorderRadius get circularRadius => BorderRadius.circular(r);

  /// Creates only top BorderRadius
  BorderRadius get topRadius => BorderRadius.only(
    topLeft: Radius.circular(r),
    topRight: Radius.circular(r),
  );

  /// Creates only bottom BorderRadius
  BorderRadius get bottomRadius => BorderRadius.only(
    bottomLeft: Radius.circular(r),
    bottomRight: Radius.circular(r),
  );

  /// Creates only left BorderRadius
  BorderRadius get leftRadius => BorderRadius.only(
    topLeft: Radius.circular(r),
    bottomLeft: Radius.circular(r),
  );

  /// Creates only right BorderRadius
  BorderRadius get rightRadius => BorderRadius.only(
    topRight: Radius.circular(r),
    bottomRight: Radius.circular(r),
  );
}

/// Widget extension for responsive padding and margin
extension ResponsiveWidgetExtension on Widget {
  /// Add responsive padding all around
  Widget withPadding(double value) =>
      Padding(padding: EdgeInsets.all(value.r), child: this);

  /// Add responsive horizontal padding
  Widget withHorizontalPadding(double value) => Padding(
    padding: EdgeInsets.symmetric(horizontal: value.r),
    child: this,
  );

  /// Add responsive vertical padding
  Widget withVerticalPadding(double value) => Padding(
    padding: EdgeInsets.symmetric(vertical: value.r),
    child: this,
  );

  /// Add responsive symmetric padding
  Widget withSymmetricPadding({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal.r,
          vertical: vertical.r,
        ),
        child: this,
      );

  /// Add responsive edge insets padding
  Widget withEdgePadding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left.r,
      top: top.r,
      right: right.r,
      bottom: bottom.r,
    ),
    child: this,
  );

  /// Center the widget with maximum width constraint
  Widget centeredWithMaxWidth(double maxWidth) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth.r),
      child: this,
    ),
  );

  /// Add safe area
  Widget withSafeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) =>
      SafeArea(top: top, bottom: bottom, left: left, right: right, child: this);
}
