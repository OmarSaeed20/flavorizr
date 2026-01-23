import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'device_info.dart';

/// Responsive data containing all responsive values
///
/// Provides consistent spacing, sizing, typography, and layout values
/// that scale appropriately based on the current device.
class ResponsiveData {
  /// The device info this data is based on
  final DeviceInfo device;

  /// Lazy-initialized responsive values
  ResponsivePadding? _padding;
  ResponsiveSpacing? _spacing;
  ResponsiveSizing? _sizing;
  ResponsiveRadius? _radius;
  ResponsiveFontSize? _fontSize;
  ResponsiveIconSize? _iconSize;

  ResponsiveData(this.device);

  /// Padding values
  ResponsivePadding get padding => _padding ??= ResponsivePadding(device);

  /// Spacing values (for gaps between elements)
  ResponsiveSpacing get spacing => _spacing ??= ResponsiveSpacing(device);

  /// Sizing values (for widths, heights)
  ResponsiveSizing get sizing => _sizing ??= ResponsiveSizing(device);

  /// Border radius values
  ResponsiveRadius get radius => _radius ??= ResponsiveRadius(device);

  /// Font size values
  ResponsiveFontSize get fontSize => _fontSize ??= ResponsiveFontSize(device);

  /// Icon size values
  ResponsiveIconSize get iconSize => _iconSize ??= ResponsiveIconSize(device);
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESPONSIVE PADDING
// ═══════════════════════════════════════════════════════════════════════════════

/// Responsive padding values
class ResponsivePadding {
  final DeviceInfo device;

  const ResponsivePadding(this.device);

  /// Base scale factor for padding
  double get _scale => device.scaleFactor;

  /// None (0)
  double get none => 0;

  /// Extra extra small (2)
  double get xxs => (2 * _scale).r;

  /// Extra small (4)
  double get xs => (4 * _scale).r;

  /// Small (8)
  double get sm => (8 * _scale).r;

  /// Medium (12)
  double get md => (12 * _scale).r;

  /// Large (16)
  double get lg => (16 * _scale).r;

  /// Extra large (24)
  double get xl => (24 * _scale).r;

  /// Extra extra large (32)
  double get xxl => (32 * _scale).r;

  /// Screen horizontal padding
  double get screen => device.byDevice(
        mobile: 16.r,
        tablet: 24.r,
        // desktop: 32.r,
      );

  /// Card internal padding
  double get card => device.byDevice(
        mobile: 12.r,
        tablet: 16.r,
        desktop: 20.r,
      );

  /// Content area padding
  double get content => device.byDevice(
        mobile: 16.r,
        tablet: 20.r,
        desktop: 24.r,
      );

  /// Button internal padding
  double get button => device.byDevice(
        mobile: 12.r,
        tablet: 14.r,
        desktop: 16.r,
      );

  /// Input field padding
  double get input => device.byDevice(
        mobile: 12.r,
        tablet: 14.r,
        desktop: 16.r,
      );

  /// List item padding
  double get listItem => device.byDevice(
        mobile: 12.r,
        tablet: 16.r,
        desktop: 20.r,
      );

  /// Dialog padding
  double get dialog => device.byDevice(
        mobile: 20.r,
        tablet: 24.r,
        desktop: 32.r,
      );

  /// Bottom sheet padding
  double get bottomSheet => device.byDevice(
        mobile: 16.r,
        tablet: 24.r,
        desktop: 32.r,
      );

  /// Section padding
  double get section => device.byDevice(
        mobile: 16.r,
        tablet: 20.r,
        desktop: 24.r,
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESPONSIVE SPACING
// ═══════════════════════════════════════════════════════════════════════════════

/// Responsive spacing values (for gaps between elements)
class ResponsiveSpacing {
  final DeviceInfo device;

  const ResponsiveSpacing(this.device);

  /// Base scale factor
  double get _scale => device.scaleFactor;

  /// None (0)
  double get none => 0;

  /// Extra extra small (2)
  double get xxs => (2 * _scale).r;

  /// Extra small (4)
  double get xs => (4 * _scale).r;

  /// Small (8)
  double get sm => (8 * _scale).r;

  /// Medium (16)
  double get md => (16 * _scale).r;

  /// Large (24)
  double get lg => (24 * _scale).r;

  /// Extra large (32)
  double get xl => (32 * _scale).r;

  /// Extra extra large (48)
  double get xxl => (48 * _scale).r;

  /// Section spacing (vertical space between sections)
  double get section => device.byDevice(
        mobile: 24.r,
        tablet: 32.r,
        desktop: 48.r,
      );

  /// Grid spacing (gap in grid layouts)
  double get grid => device.byDevice(
        mobile: 12.r,
        tablet: 16.r,
        desktop: 20.r,
      );

  /// List spacing (gap between list items)
  double get list => device.byDevice(
        mobile: 8.r,
        tablet: 12.r,
        desktop: 16.r,
      );

  /// Card spacing (gap between cards)
  double get card => device.byDevice(
        mobile: 12.r,
        tablet: 16.r,
        desktop: 20.r,
      );

  /// Form field spacing
  double get formField => device.byDevice(
        mobile: 16.r,
        tablet: 20.r,
        desktop: 24.r,
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESPONSIVE SIZING
// ═══════════════════════════════════════════════════════════════════════════════

/// Responsive sizing values (for widths, heights)
class ResponsiveSizing {
  final DeviceInfo device;

  const ResponsiveSizing(this.device);

  /// Base scale factor
  double get _scale => device.scaleFactor;

  /// Touch target minimum (48 for accessibility)
  double get touchTarget => 48.r;

  /// Small touch target (40)
  double get touchTargetSm => 40.r;

  /// Large touch target (56)
  double get touchTargetLg => 56.r;

  /// App bar height
  double get appBarHeight => device.byDevice(
        mobile: 56.r,
        tablet: 64.r,
        desktop: 64.r,
      );

  /// Bottom navigation bar height
  double get bottomNavHeight => 56.r;

  /// Navigation rail width (collapsed)
  double get railWidth => (80 * _scale).r;

  /// Navigation rail width (extended)
  double get railWidthExtended => device.byDevice(
        mobile: 256.r,
        tablet: 280.r,
        desktop: 320.r,
      );

  /// Drawer width
  double get drawerWidth => device.byDevice(
        mobile: 280.r,
        tablet: 320.r,
        desktop: 360.r,
      );

  /// Dialog width
  double get dialogWidth => device.byDevice(
        mobile: device.screenWidth * 0.9,
        tablet: 480.r,
        desktop: 560.r,
      );

  /// Dialog max width
  double get dialogMaxWidth => 560.r;

  /// Bottom sheet max width
  double get bottomSheetMaxWidth => device.byDevice(
        mobile: device.screenWidth,
        tablet: 560.r,
        desktop: 640.r,
      );

  /// Card min height
  double get cardMinHeight => device.byDevice(
        mobile: 80.r,
        tablet: 100.r,
        desktop: 120.r,
      );

  /// Avatar small (32)
  double get avatarSm => (32 * _scale).r;

  /// Avatar medium (40)
  double get avatarMd => (40 * _scale).r;

  /// Avatar large (56)
  double get avatarLg => (56 * _scale).r;

  /// Avatar extra large (72)
  double get avatarXl => (72 * _scale).r;

  /// Button height
  double get buttonHeight => device.byDevice(
        mobile: 44.r,
        tablet: 48.r,
        desktop: 48.r,
      );

  /// Button height small
  double get buttonHeightSm => device.byDevice(
        mobile: 36.r,
        tablet: 40.r,
        desktop: 40.r,
      );

  /// Button height large
  double get buttonHeightLg => device.byDevice(
        mobile: 52.r,
        tablet: 56.r,
        desktop: 56.r,
      );

  /// Input field height
  double get inputHeight => device.byDevice(
        mobile: 48.r,
        tablet: 52.r,
        desktop: 52.r,
      );

  /// Chip height
  double get chipHeight => device.byDevice(
        mobile: 32.r,
        tablet: 36.r,
        desktop: 36.r,
      );

  /// List tile height
  double get listTileHeight => device.byDevice(
        mobile: 56.r,
        tablet: 64.r,
        desktop: 72.r,
      );

  /// Divider thickness
  double get dividerThickness => 1.r;

  /// Border width thin
  double get borderThin => 1.r;

  /// Border width medium
  double get borderMd => 1.5.r;

  /// Border width thick
  double get borderThick => 2.r;
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESPONSIVE RADIUS
// ═══════════════════════════════════════════════════════════════════════════════

/// Responsive border radius values
class ResponsiveRadius {
  final DeviceInfo device;

  const ResponsiveRadius(this.device);

  /// Base scale factor
  double get _scale => device.scaleFactor;

  /// None (0)
  double get none => 0;

  /// Extra small (4)
  double get xs => (4 * _scale).r;

  /// Small (6)
  double get s => (6 * _scale).r;

  /// Small (8)
  double get sm => (8 * _scale).r;

  /// Default (10)
  double get def => (10 * _scale).r;

  /// Medium (12)
  double get md => (12 * _scale).r;

  /// Large (16)
  double get lg => (16 * _scale).r;

  /// Extra large (24)
  double get xl => (24 * _scale).r;

  /// Extra extra large (32)
  double get xxl => (32 * _scale).r;

  /// Circular (very large for pills)
  double get circular => 999.r;

  /// Card radius
  double get card => device.byDevice(
        mobile: 12.r,
        tablet: 14.r,
        desktop: 16.r,
      );

  /// Button radius
  double get button => device.byDevice(
        mobile: 8.r,
        tablet: 10.r,
        desktop: 12.r,
      );

  /// Input radius
  double get input => device.byDevice(
        mobile: 8.r,
        tablet: 10.r,
        desktop: 12.r,
      );

  /// Dialog radius
  double get dialog => device.byDevice(
        mobile: 16.r,
        tablet: 20.r,
        desktop: 24.r,
      );

  /// Bottom sheet radius
  double get bottomSheet => device.byDevice(
        mobile: 20.r,
        tablet: 24.r,
        desktop: 28.r,
      );

  /// Chip radius
  double get chip => 999.r;

  /// Avatar radius (circular)
  double get avatar => 999.r;

  /// BorderRadius helpers
  BorderRadius get cardBorderRadius => BorderRadius.circular(card);
  BorderRadius get buttonBorderRadius => BorderRadius.circular(button);
  BorderRadius get inputBorderRadius => BorderRadius.circular(input);
  BorderRadius get dialogBorderRadius => BorderRadius.circular(dialog);
  BorderRadius get bottomSheetBorderRadius => BorderRadius.only(
        topLeft: Radius.circular(bottomSheet),
        topRight: Radius.circular(bottomSheet),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESPONSIVE FONT SIZE
// ═══════════════════════════════════════════════════════════════════════════════

/// Responsive font size values
class ResponsiveFontSize {
  final DeviceInfo device;

  const ResponsiveFontSize(this.device);

  /// Base scale factor
  double get _scale => device.fontScaleFactor;

  // Display sizes
  double get displayLg => (57 * _scale).sp;
  double get displayMd => (45 * _scale).sp;
  double get displaySm => (36 * _scale).sp;

  // Headline sizes
  double get headlineLg => (32 * _scale).sp;
  double get headlineMd => (28 * _scale).sp;
  double get headlineSm => (24 * _scale).sp;

  // Title sizes
  double get titleLg => (22 * _scale).sp;
  double get titleMd => (16 * _scale).sp;
  double get titleSm => (14 * _scale).sp;

  // Body sizes
  double get bodyLg => (16 * _scale).sp;
  double get bodyMd => (14 * _scale).sp;
  double get bodySm => (12 * _scale).sp;

  // Label sizes
  double get labelLg => (14 * _scale).sp;
  double get labelMd => (12 * _scale).sp;
  double get labelSm => (11 * _scale).sp;

  // Semantic sizes
  double get h1 => headlineLg;
  double get h2 => headlineMd;
  double get h3 => headlineSm;
  double get h4 => titleLg;
  double get h5 => titleMd;
  double get h6 => titleSm;

  double get body => bodyMd;
  double get caption => bodySm;
  double get button => labelLg;
  double get overline => labelSm;

  // App-specific sizes
  double get appBarTitle => device.byDevice(
        mobile: 18.sp,
        tablet: 20.sp,
        desktop: 22.sp,
      );

  double get cardTitle => device.byDevice(
        mobile: 16.sp,
        tablet: 18.sp,
        desktop: 20.sp,
      );

  double get cardSubtitle => device.byDevice(
        mobile: 14.sp,
        tablet: 15.sp,
        desktop: 16.sp,
      );

  double get inputText => device.byDevice(
        mobile: 16.sp,
        tablet: 16.sp,
        desktop: 16.sp,
      );

  double get inputLabel => device.byDevice(
        mobile: 14.sp,
        tablet: 14.sp,
        desktop: 14.sp,
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESPONSIVE ICON SIZE
// ═══════════════════════════════════════════════════════════════════════════════

/// Responsive icon size values
class ResponsiveIconSize {
  final DeviceInfo device;

  const ResponsiveIconSize(this.device);

  /// Base scale factor
  double get _scale => device.iconScaleFactor;

  /// Extra small (12)
  double get xs => (12 * _scale).r;

  /// Small (16)
  double get sm => (16 * _scale).r;

  /// Regular (18)
  double get rg => (18 * _scale).r;

  /// Medium (20)
  double get md => (20 * _scale).r;

  /// Large (24) - Default icon size
  double get lg => (24 * _scale).r;

  /// Extra large (32)
  double get xl => (32 * _scale).r;

  /// Extra extra large (48)
  double get xxl => (48 * _scale).r;

  // Semantic sizes
  double get button => md;
  double get navigation => lg;
  double get appBar => lg;
  double get listTile => lg;
  double get fab => lg;
  double get empty => (64 * _scale).r;
  double get feature => (48 * _scale).r;
}
