import 'package:fast_golden_taxi/core/ui/responsive/src/spacing/spacing_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// GAP WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

/// Pre-defined gap widgets for consistent spacing
///
/// Usage:
/// ```dart
/// Column(
///   children: [
///     Text('Hello'),
///     Gap.sm,  // 8dp gap
///     Text('World'),
///   ],
/// )
/// ```
abstract class Gap {
  Gap._();

  // ═══════════════════════════════════════════════════════════════════════════
  // SQUARE GAPS (same width and height)
  // ═══════════════════════════════════════════════════════════════════════════

  /// No gap (0)
  static SizedBox get none => const SizedBox.shrink();

  /// 2dp gap
  static SizedBox get xxs => SizedBox.square(dimension: Spacing.xxs);

  /// 4dp gap
  static SizedBox get xs => SizedBox.square(dimension: Spacing.xs);

  /// 8dp gap
  static SizedBox get sm => SizedBox.square(dimension: Spacing.sm);

  /// 12dp gap
  static SizedBox get smd => SizedBox.square(dimension: Spacing.smd);

  /// 16dp gap (default)
  static SizedBox get md => SizedBox.square(dimension: Spacing.md);

  /// 20dp gap
  static SizedBox get mdl => SizedBox.square(dimension: Spacing.mdl);

  /// 24dp gap
  static SizedBox get lg => SizedBox.square(dimension: Spacing.lg);

  /// 32dp gap
  static SizedBox get xl => SizedBox.square(dimension: Spacing.xl);

  /// 40dp gap
  static SizedBox get xxl => SizedBox.square(dimension: Spacing.xxl);

  /// 48dp gap
  static SizedBox get xxxl => SizedBox.square(dimension: Spacing.xxxl);

  /// 64dp gap
  static SizedBox get huge => SizedBox.square(dimension: Spacing.huge);

  /// Custom gap with responsive scaling
  static SizedBox custom(double size) => SizedBox.square(dimension: size.r);
}

/// Horizontal gap widgets (width only)
abstract class HGap {
  HGap._();

  /// No gap
  static SizedBox get none => const SizedBox.shrink();

  /// 2dp horizontal gap
  static SizedBox get xxs => SizedBox(width: Spacing.xxs);

  /// 4dp horizontal gap
  static SizedBox get xs => SizedBox(width: Spacing.xs);

  /// 8dp horizontal gap
  static SizedBox get sm => SizedBox(width: Spacing.sm);

  /// 12dp horizontal gap
  static SizedBox get smd => SizedBox(width: Spacing.smd);

  /// 16dp horizontal gap
  static SizedBox get md => SizedBox(width: Spacing.md);

  /// 20dp horizontal gap
  static SizedBox get mdl => SizedBox(width: Spacing.mdl);

  /// 24dp horizontal gap
  static SizedBox get lg => SizedBox(width: Spacing.lg);

  /// 32dp horizontal gap
  static SizedBox get xl => SizedBox(width: Spacing.xl);

  /// 40dp horizontal gap
  static SizedBox get xxl => SizedBox(width: Spacing.xxl);

  /// 48dp horizontal gap
  static SizedBox get xxxl => SizedBox(width: Spacing.xxxl);

  /// 64dp horizontal gap
  static SizedBox get huge => SizedBox(width: Spacing.huge);

  /// Custom horizontal gap with responsive scaling
  static SizedBox custom(double width) => SizedBox(width: width.r);
}

/// Vertical gap widgets (height only)
abstract class VGap {
  VGap._();

  /// No gap
  static SizedBox get none => const SizedBox.shrink();

  /// 2dp vertical gap
  static SizedBox get xxs => SizedBox(height: Spacing.xxs);

  /// 4dp vertical gap
  static SizedBox get xs => SizedBox(height: Spacing.xs);

  /// 8dp vertical gap
  static SizedBox get sm => SizedBox(height: Spacing.sm);

  /// 12dp vertical gap
  static SizedBox get smd => SizedBox(height: Spacing.smd);

  /// 16dp vertical gap
  static SizedBox get md => SizedBox(height: Spacing.md);

  /// 20dp vertical gap
  static SizedBox get mdl => SizedBox(height: Spacing.mdl);

  /// 24dp vertical gap
  static SizedBox get lg => SizedBox(height: Spacing.lg);

  /// 32dp vertical gap
  static SizedBox get xl => SizedBox(height: Spacing.xl);

  /// 40dp vertical gap
  static SizedBox get xxl => SizedBox(height: Spacing.xxl);

  /// 48dp vertical gap
  static SizedBox get xxxl => SizedBox(height: Spacing.xxxl);

  /// 64dp vertical gap
  static SizedBox get huge => SizedBox(height: Spacing.huge);

  /// Custom vertical gap with responsive scaling
  static SizedBox custom(double height) => SizedBox(height: height.r);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SLIVER GAPS
// ═══════════════════════════════════════════════════════════════════════════════

/// Sliver gap widgets for use in CustomScrollView
abstract class SliverGap {
  SliverGap._();

  /// No gap
  static SliverToBoxAdapter get none => const SliverToBoxAdapter(child: SizedBox.shrink());

  /// 4dp sliver gap
  static SliverToBoxAdapter get xs => SliverToBoxAdapter(child: SizedBox(height: Spacing.xs));

  /// 8dp sliver gap
  static SliverToBoxAdapter get sm => SliverToBoxAdapter(child: SizedBox(height: Spacing.sm));

  /// 16dp sliver gap
  static SliverToBoxAdapter get md => SliverToBoxAdapter(child: SizedBox(height: Spacing.md));

  /// 24dp sliver gap
  static SliverToBoxAdapter get lg => SliverToBoxAdapter(child: SizedBox(height: Spacing.lg));

  /// 32dp sliver gap
  static SliverToBoxAdapter get xl => SliverToBoxAdapter(child: SizedBox(height: Spacing.xl));

  /// Custom sliver gap with responsive scaling
  static SliverToBoxAdapter custom(double height) =>
      SliverToBoxAdapter(child: SizedBox(height: height.r));
}

// ═══════════════════════════════════════════════════════════════════════════════
// PADDING PRESETS
// ═══════════════════════════════════════════════════════════════════════════════

/// Pre-defined EdgeInsets for consistent padding
abstract class Insets {
  Insets._();

  // ═══════════════════════════════════════════════════════════════════════════
  // ALL SIDES
  // ═══════════════════════════════════════════════════════════════════════════

  /// No padding
  static EdgeInsets get none => EdgeInsets.zero;

  /// 4dp all sides
  static EdgeInsets get allXs => EdgeInsets.all(Spacing.xs);

  /// 8dp all sides
  static EdgeInsets get allSm => EdgeInsets.all(Spacing.sm);

  /// 12dp all sides
  static EdgeInsets get allSmd => EdgeInsets.all(Spacing.smd);

  /// 16dp all sides
  static EdgeInsets get allMd => EdgeInsets.all(Spacing.md);

  /// 20dp all sides
  static EdgeInsets get allMdl => EdgeInsets.all(Spacing.mdl);

  /// 24dp all sides
  static EdgeInsets get allLg => EdgeInsets.all(Spacing.lg);

  /// 32dp all sides
  static EdgeInsets get allXl => EdgeInsets.all(Spacing.xl);

  // ═══════════════════════════════════════════════════════════════════════════
  // HORIZONTAL ONLY
  // ═══════════════════════════════════════════════════════════════════════════

  /// 4dp horizontal
  static EdgeInsets get horizontalXs => EdgeInsets.symmetric(horizontal: Spacing.xs);

  /// 8dp horizontal
  static EdgeInsets get horizontalSm => EdgeInsets.symmetric(horizontal: Spacing.sm);

  /// 12dp horizontal
  static EdgeInsets get horizontalSmd => EdgeInsets.symmetric(horizontal: Spacing.smd);

  /// 16dp horizontal
  static EdgeInsets get horizontalMd => EdgeInsets.symmetric(horizontal: Spacing.md);

  /// 24dp horizontal
  static EdgeInsets get horizontalLg => EdgeInsets.symmetric(horizontal: Spacing.lg);

  /// 32dp horizontal
  static EdgeInsets get horizontalXl => EdgeInsets.symmetric(horizontal: Spacing.xl);

  // ═══════════════════════════════════════════════════════════════════════════
  // VERTICAL ONLY
  // ═══════════════════════════════════════════════════════════════════════════

  /// 4dp vertical
  static EdgeInsets get verticalXs => EdgeInsets.symmetric(vertical: Spacing.xs);

  /// 8dp vertical
  static EdgeInsets get verticalSm => EdgeInsets.symmetric(vertical: Spacing.sm);

  /// 12dp vertical
  static EdgeInsets get verticalSmd => EdgeInsets.symmetric(vertical: Spacing.smd);

  /// 16dp vertical
  static EdgeInsets get verticalMd => EdgeInsets.symmetric(vertical: Spacing.md);

  /// 24dp vertical
  static EdgeInsets get verticalLg => EdgeInsets.symmetric(vertical: Spacing.lg);

  /// 32dp vertical
  static EdgeInsets get verticalXl => EdgeInsets.symmetric(vertical: Spacing.xl);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC PRESETS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Screen content padding (16 horizontal)
  static EdgeInsets get screen => EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal);

  /// Screen content padding with top (16 horizontal, 16 top)
  static EdgeInsets get screenWithTop => EdgeInsets.only(
    left: Spacing.screenHorizontal,
    right: Spacing.screenHorizontal,
    top: Spacing.screenVertical,
  );

  /// Screen content padding all (16 all sides)
  static EdgeInsets get screenAll => EdgeInsets.all(Spacing.screenEdge);

  /// Card padding (16 all sides)
  static EdgeInsets get card => EdgeInsets.all(Spacing.cardInternal);

  /// Button content padding (12 horizontal, 8 vertical)
  static EdgeInsets get button =>
      EdgeInsets.symmetric(horizontal: Spacing.buttonContent, vertical: Spacing.sm);

  /// Input field padding (16 horizontal, 12 vertical)
  static EdgeInsets get input =>
      EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.smd);

  /// List tile padding (16 horizontal, 8 vertical)
  static EdgeInsets get listTile =>
      EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm);

  /// Dialog padding (24 all sides)
  static EdgeInsets get dialog => EdgeInsets.all(Spacing.dialogContent);

  /// Bottom sheet padding (16 horizontal, 24 top, 16 bottom)
  static EdgeInsets get bottomSheet =>
      EdgeInsets.only(left: Spacing.md, right: Spacing.md, top: Spacing.lg, bottom: Spacing.md);

  /// Custom padding with responsive scaling
  static EdgeInsets all(double value) => EdgeInsets.all(value.r);

  /// Custom symmetric padding with responsive scaling
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal.r, vertical: vertical.r);

  /// Custom only padding with responsive scaling
  static EdgeInsets only({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      EdgeInsets.only(left: left.r, top: top.r, right: right.r, bottom: bottom.r);
}
