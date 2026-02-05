import 'package:flavorizr/core/ui/responsive/src/device_info.dart';
import 'package:flutter/material.dart';

/// Text scale utilities for responsive typography
class TextScale {
  final DeviceInfo device;

  const TextScale(this.device);

  /// Get scaled font size based on device type
  ///
  /// Applies a scale factor for larger screens while respecting
  /// the user's text scale preference.
  double scale(double size) {
    final baseScale = device.fontScaleFactor;
    return size * baseScale;
  }

  /// Get constrained font size (min and max bounds)
  ///
  /// Ensures text doesn't get too small or too large
  double constrained(double size, {double? min, double? max}) {
    double scaled = scale(size);
    if (min != null && scaled < min) scaled = min;
    if (max != null && scaled > max) scaled = max;
    return scaled;
  }

  /// Check if the user has increased text scale
  bool get isLargeText => device.textScaleFactor > 1.2;

  /// Check if the user has decreased text scale
  bool get isSmallText => device.textScaleFactor < 0.9;

  /// Get line height multiplier based on device
  double get lineHeightMultiplier =>
      device.byDevice(mobile: 1.4, tablet: 1.5, desktop: 1.5);

  /// Get letter spacing adjustment based on device
  double get letterSpacingAdjustment =>
      device.byDevice(mobile: 0, tablet: 0.15, desktop: 0.25);
}

/// Extension on TextStyle for responsive adjustments
extension ResponsiveTextStyleExtension on TextStyle {
  /// Apply responsive scaling to font size
  TextStyle responsive(BuildContext context) {
    final device = DeviceInfo.fromContext(context);
    final textScale = TextScale(device);

    return copyWith(
      fontSize: fontSize != null ? textScale.scale(fontSize!) : null,
      height: textScale.lineHeightMultiplier,
      letterSpacing: letterSpacing != null
          ? letterSpacing! + textScale.letterSpacingAdjustment
          : null,
    );
  }

  /// Constrain font size within bounds
  TextStyle constrained({double? minSize, double? maxSize}) {
    if (fontSize == null) return this;

    double newSize = fontSize!;
    if (minSize != null && newSize < minSize) newSize = minSize;
    if (maxSize != null && newSize > maxSize) newSize = maxSize;

    return copyWith(fontSize: newSize);
  }

  /// Apply device-specific font size
  TextStyle deviceFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final device = DeviceInfo.fromContext(context);
    final size = device.byDevice(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return copyWith(fontSize: size);
  }
}

/// Line height presets
abstract class LineHeights {
  LineHeights._();

  /// Tight line height (1.2)
  static const double tight = 1.2;

  /// Normal line height (1.4)
  static const double normal = 1.4;

  /// Relaxed line height (1.5)
  static const double relaxed = 1.5;

  /// Loose line height (1.6)
  static const double loose = 1.6;

  /// Extra loose line height (1.8)
  static const double extraLoose = 1.8;
}

/// Letter spacing presets
abstract class LetterSpacings {
  LetterSpacings._();

  /// Tight letter spacing (-0.5)
  static const double tight = -0.5;

  /// Normal letter spacing (0)
  static const double normal = 0;

  /// Wide letter spacing (0.5)
  static const double wide = 0.5;

  /// Extra wide letter spacing (1.0)
  static const double extraWide = 1.0;

  /// Tracking letter spacing (1.5 - for all caps)
  static const double tracking = 1.5;
}

/// Font weight presets
abstract class FontWeights {
  FontWeights._();

  /// Thin (100)
  static const FontWeight thin = FontWeight.w100;

  /// Extra Light (200)
  static const FontWeight extraLight = FontWeight.w200;

  /// Light (300)
  static const FontWeight light = FontWeight.w300;

  /// Regular (400)
  static const FontWeight regular = FontWeight.w400;

  /// Medium (500)
  static const FontWeight medium = FontWeight.w500;

  /// Semi Bold (600)
  static const FontWeight semiBold = FontWeight.w600;

  /// Bold (700)
  static const FontWeight bold = FontWeight.w700;

  /// Extra Bold (800)
  static const FontWeight extraBold = FontWeight.w800;

  /// Black (900)
  static const FontWeight black = FontWeight.w900;
}
