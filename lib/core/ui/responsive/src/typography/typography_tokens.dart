import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Typography tokens for consistent text sizing
///
/// Based on Material Design 3 type scale with responsive adjustments.
abstract class TypographyTokens {
  TypographyTokens._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES (Large decorative text)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Display Large - 57sp (Hero text, major headlines)
  static double get displayLg => 57.sp;

  /// Display Medium - 45sp (Section heroes)
  static double get displayMd => 45.sp;

  /// Display Small - 36sp (Card heroes)
  static double get displaySm => 36.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE STYLES (Section headers)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Headline Large - 32sp (Page titles)
  static double get headlineLg => 32.sp;

  /// Headline Medium - 28sp (Section titles)
  static double get headlineMd => 28.sp;

  /// Headline Small - 24sp (Subsection titles)
  static double get headlineSm => 24.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES (Component titles)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Title Large - 22sp (Card titles, Dialog titles)
  static double get titleLg => 22.sp;

  /// Title Medium - 16sp (List tiles, Navigation items)
  static double get titleMd => 16.sp;

  /// Title Small - 14sp (Tabs, Chips)
  static double get titleSm => 14.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES (Main content text)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Body Large - 16sp (Long-form text)
  static double get bodyLg => 16.sp;

  /// Body Medium - 14sp (Default body text)
  static double get bodyMd => 14.sp;

  /// Body Small - 12sp (Supporting text)
  static double get bodySm => 12.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES (UI labels)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Label Large - 14sp (Buttons, Menu items)
  static double get labelLg => 14.sp;

  /// Label Medium - 12sp (Labels, Badges)
  static double get labelMd => 12.sp;

  /// Label Small - 11sp (Captions, Timestamps)
  static double get labelSm => 11.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC ALIASES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Page title size
  static double get pageTitle => headlineMd;

  /// Section title size
  static double get sectionTitle => titleLg;

  /// Card title size
  static double get cardTitle => titleMd;

  /// Card subtitle size
  static double get cardSubtitle => bodyMd;

  /// Default body text size
  static double get body => bodyMd;

  /// Caption text size
  static double get caption => bodySm;

  /// Button text size
  static double get button => labelLg;

  /// Input text size
  static double get input => bodyLg;

  /// Input label size
  static double get inputLabel => labelMd;

  /// Input hint size
  static double get inputHint => bodySm;

  /// App bar title size
  static double get appBarTitle => titleLg;

  /// Tab label size
  static double get tab => titleSm;

  /// Chip label size
  static double get chip => labelMd;

  /// Badge text size
  static double get badge => labelSm;

  /// Overline text size
  static double get overline => labelSm;
}

/// Shorthand for TypographyTokens
typedef FontSizes = TypographyTokens;
