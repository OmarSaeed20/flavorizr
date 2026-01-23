import 'package:flavorizr/core/ui/responsive/src/breakpoints.dart';
import 'package:flutter/material.dart';

/// Comprehensive device information for responsive layouts
///
/// Contains all relevant information about the current device,
/// screen, and environment for making responsive decisions.
@immutable
class DeviceInfo {
  /// The device type (mobile, tablet, desktop)
  final DeviceType deviceType;

  /// The window size class based on Material Design 3
  final WindowSizeClass windowSizeClass;

  /// The current orientation
  final OrientationType orientation;

  /// The platform type
  final PlatformType platform;

  /// Screen width in logical pixels
  final double screenWidth;

  /// Screen height in logical pixels
  final double screenHeight;

  /// Device pixel ratio
  final double pixelRatio;

  /// Safe area padding (notches, status bars, etc.)
  final EdgeInsets safeArea;

  /// View padding (keyboard, etc.)
  final EdgeInsets viewPadding;

  /// Text scale factor from system settings
  final double textScaleFactor;

  /// Whether dark mode is enabled
  final bool isDarkMode;

  /// Whether high contrast mode is enabled
  final bool isHighContrast;

  /// Whether reduced motion is preferred
  final bool reduceMotion;

  /// Whether bold text is enabled
  final bool boldText;

  const DeviceInfo({
    required this.deviceType,
    required this.windowSizeClass,
    required this.orientation,
    required this.platform,
    required this.screenWidth,
    required this.screenHeight,
    required this.pixelRatio,
    required this.safeArea,
    required this.viewPadding,
    required this.textScaleFactor,
    required this.isDarkMode,
    required this.isHighContrast,
    required this.reduceMotion,
    required this.boldText,
  });

  /// Create DeviceInfo from BuildContext
  factory DeviceInfo.fromContext(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final width = size.width;
    final height = size.height;

    final windowSizeClass = WindowSizeClass.fromWidth(width);
    final deviceType = DeviceType.fromWindowSizeClass(windowSizeClass);
    final orientation = OrientationType.fromDimensions(width, height);

    return DeviceInfo(
      deviceType: deviceType,
      windowSizeClass: windowSizeClass,
      orientation: orientation,
      platform: PlatformType.current,
      screenWidth: width,
      screenHeight: height,
      pixelRatio: mediaQuery.devicePixelRatio,
      safeArea: mediaQuery.padding,
      viewPadding: mediaQuery.viewPadding,
      textScaleFactor: mediaQuery.textScaler.scale(1.0),
      isDarkMode: Theme.of(context).brightness == Brightness.dark,
      isHighContrast: mediaQuery.highContrast,
      reduceMotion: mediaQuery.disableAnimations,
      boldText: mediaQuery.boldText,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPUTED PROPERTIES
  // ═══════════════════════════════════════════════════════════════════════════

  /// The device type (legacy alias)
  /// @deprecated Use deviceType instead
  DeviceType get type => deviceType;

  /// The shortest side of the screen
  double get shortestSide =>
      screenWidth < screenHeight ? screenWidth : screenHeight;

  /// The longest side of the screen
  double get longestSide =>
      screenWidth > screenHeight ? screenWidth : screenHeight;

  /// Aspect ratio of the screen
  double get aspectRatio => screenWidth / screenHeight;

  /// Whether the device is in portrait mode
  bool get isPortrait => orientation.isPortrait;

  /// Whether the device is in landscape mode
  bool get isLandscape => orientation.isLandscape;

  /// Whether the device is a mobile phone
  bool get isMobile => deviceType.isMobile;

  /// Whether the device is a tablet
  bool get isTablet => deviceType.isTablet;

  /// Whether the device is a desktop
  bool get isDesktop => deviceType.isDesktop;

  /// Whether running on web
  bool get isWeb => platform.isWebPlatform;

  /// Whether running on iOS
  bool get isIOS => platform == PlatformType.ios;

  /// Whether running on Android
  bool get isAndroid => platform == PlatformType.android;

  /// Whether running on macOS
  bool get isMacOS => platform == PlatformType.macos;

  /// Whether running on Windows
  bool get isWindows => platform == PlatformType.windows;

  /// Whether running on Linux
  bool get isLinux => platform == PlatformType.linux;

  /// Whether running on a mobile platform (iOS or Android)
  bool get isMobilePlatform => platform.isMobilePlatform;

  /// Whether running on a desktop platform
  bool get isDesktopPlatform => platform.isDesktopPlatform;

  /// Whether running on an Apple platform
  bool get isApplePlatform => platform.isApplePlatform;

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE VALUE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns a value based on device type
  T byDevice<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return deviceType.when(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Returns a value based on window size class
  T byWindowSize<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return windowSizeClass.when(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// Returns a value based on orientation
  T byOrientation<T>({
    required T portrait,
    required T landscape,
  }) {
    return orientation.isPortrait ? portrait : landscape;
  }

  /// Returns a value based on platform
  T byPlatform<T>({
    required T defaultValue,
    T? ios,
    T? android,
    T? web,
    T? macos,
    T? windows,
    T? linux,
  }) {
    return switch (platform) {
      PlatformType.ios => ios ?? defaultValue,
      PlatformType.android => android ?? defaultValue,
      PlatformType.web => web ?? defaultValue,
      PlatformType.macos => macos ?? defaultValue,
      PlatformType.windows => windows ?? defaultValue,
      PlatformType.linux => linux ?? defaultValue,
      PlatformType.unknown => defaultValue,
    };
  }

  /// Returns mobile or web value
  T mobileOrWeb<T>({required T mobile, required T web}) {
    return isWeb ? web : mobile;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCALING HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Base scale factor for the current device
  double get scaleFactor {
    return byDevice(
      mobile: 1.0,
      tablet: 1.15,
      desktop: 1.25,
    );
  }

  /// Icon scale factor
  double get iconScaleFactor {
    return byDevice(
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
  }

  /// Font scale factor (respects system text scale)
  double get fontScaleFactor {
    final baseScale = byDevice(
      mobile: 1.0,
      tablet: 1.05,
      desktop: 1.1,
    );
    return baseScale * textScaleFactor.clamp(0.8, 1.4);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LAYOUT HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Maximum content width for centered layouts
  double get maxContentWidth {
    return byWindowSize(
      compact: screenWidth,
      medium: 720.0,
      expanded: 840.0,
      large: 1200.0,
      extraLarge: 1440.0,
    );
  }

  /// Number of columns for grid layouts
  int get gridColumns {
    return byWindowSize(
      compact: 1,
      medium: 2,
      expanded: 2,
      large: 3,
      extraLarge: 4,
    );
  }

  /// Whether to use drawer navigation (vs rail/permanent)
  bool get useDrawerNavigation => windowSizeClass.isCompact;

  /// Whether to use bottom navigation
  bool get useBottomNavigation => windowSizeClass.isCompact;

  /// Whether to use rail navigation
  bool get useRailNavigation =>
      windowSizeClass.isMedium || windowSizeClass.isExpanded;

  /// Whether to use permanent navigation drawer
  bool get usePermanentNavigation =>
      windowSizeClass.isLarge || windowSizeClass.isExtraLarge;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfo &&
          runtimeType == other.runtimeType &&
          deviceType == other.deviceType &&
          windowSizeClass == other.windowSizeClass &&
          orientation == other.orientation &&
          platform == other.platform &&
          screenWidth == other.screenWidth &&
          screenHeight == other.screenHeight &&
          pixelRatio == other.pixelRatio &&
          isDarkMode == other.isDarkMode;

  @override
  int get hashCode => Object.hash(
        deviceType,
        windowSizeClass,
        orientation,
        platform,
        screenWidth,
        screenHeight,
        pixelRatio,
        isDarkMode,
      );

  @override
  String toString() {
    return 'DeviceInfo('
        'device: $deviceType, '
        'window: $windowSizeClass, '
        'orientation: $orientation, '
        'platform: $platform, '
        'size: ${screenWidth.toStringAsFixed(0)}x${screenHeight.toStringAsFixed(0)}'
        ')';
  }
}
