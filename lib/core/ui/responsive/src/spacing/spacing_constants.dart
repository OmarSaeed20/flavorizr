import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing constants for consistent layout throughout the app
///
/// Based on a 4dp baseline grid (Material Design recommendation)
abstract class SpacingConstants {
  SpacingConstants._();

  // ═══════════════════════════════════════════════════════════════════════════
  // BASE SPACING SCALE (4dp baseline)
  // ═══════════════════════════════════════════════════════════════════════════

  /// No spacing (0)
  static double get none => 0;

  /// 2dp - Micro spacing
  static double get xxs => 2.r;

  /// 4dp - Extra small spacing
  static double get xs => 4.r;

  /// 8dp - Small spacing
  static double get sm => 8.r;

  /// 12dp - Small-medium spacing
  static double get smd => 12.r;

  /// 16dp - Medium spacing (default)
  static double get md => 16.r;

  /// 20dp - Medium-large spacing
  static double get mdl => 20.r;

  /// 24dp - Large spacing
  static double get lg => 24.r;

  /// 32dp - Extra large spacing
  static double get xl => 32.r;

  /// 40dp - Extra extra large spacing
  static double get xxl => 40.r;

  /// 48dp - Triple extra large spacing
  static double get xxxl => 48.r;

  /// 64dp - Huge spacing
  static double get huge => 64.r;

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC SPACING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Spacing between related elements (4)
  static double get related => xs;

  /// Spacing between grouped elements (8)
  static double get grouped => sm;

  /// Spacing between sections (16)
  static double get section => md;

  /// Spacing for page content (24)
  static double get page => lg;

  /// Spacing for major sections (32)
  static double get major => xl;

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPONENT SPACING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Icon to text spacing (8)
  static double get iconText => sm;

  /// Button content spacing (12)
  static double get buttonContent => smd;

  /// Card internal spacing (16)
  static double get cardInternal => md;

  /// List item spacing (8)
  static double get listItem => sm;

  /// Form field spacing (16)
  static double get formField => md;

  /// Input helper text spacing (4)
  static double get inputHelper => xs;

  /// Chip spacing (8)
  static double get chip => sm;

  /// Dialog content spacing (24)
  static double get dialogContent => lg;

  /// Bottom sheet header spacing (16)
  static double get bottomSheetHeader => md;

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN PADDING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Horizontal screen padding (16)
  static double get screenHorizontal => md;

  /// Vertical screen padding (16)
  static double get screenVertical => md;

  /// Screen edge padding (16)
  static double get screenEdge => md;
}

/// Shorthand for SpacingConstants
typedef Spacing = SpacingConstants;
