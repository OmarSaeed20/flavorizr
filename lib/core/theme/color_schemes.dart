// lib/core/theme/color_schemes.dart

/// Material 3 [ColorScheme] definitions for Fast Golden Taxi.
///
/// Both light and dark schemes are built directly from the Figma
/// palette defined in `app_colors.dart`.
///
/// The app uses a **fixed brand palette** – there is no
/// user-selectable color-scheme picker. The golden-yellow primary
/// stays consistent across both brightness modes.
library;

import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// LIGHT SCHEME
// ═══════════════════════════════════════════════════════════════════════════════

/// Light [ColorScheme] derived from the Figma design.
///
/// Surface hierarchy follows Material 3 conventions while every
/// brand-specific slot maps 1 : 1 to a Figma token.
const ColorScheme kLightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // ── Primary ───────────────────────────────────────────────────────────
  primary: kPrimary, // #FFBF00 – golden CTA
  onPrimary: kGray900, // black text on golden buttons
  primaryContainer: Color(0xFFFFF3CC), // 20 % tint of primary
  onPrimaryContainer: kGray800, // #212121
  // ── Secondary ─────────────────────────────────────────────────────────
  secondary: kGray700, // #353535 – dark gray
  onSecondary: kWhite,
  secondaryContainer: kGray100, // #F2F2F2
  onSecondaryContainer: kGray700, // #353535
  // ── Tertiary ──────────────────────────────────────────────────────────
  tertiary: kPrimaryVariant, // #F2C223 – warmer golden
  onTertiary: kGray900,
  tertiaryContainer: Color(0xFFFFF8E1),
  onTertiaryContainer: kGray800,

  // ── Error / Destructive ───────────────────────────────────────────────
  error: kDestructive, // #CC2B2B
  onError: kWhite,
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),

  // ── Surface ───────────────────────────────────────────────────────────
  surface: kWhite, // #FFFFFF
  onSurface: kGray900, // #000000
  onSurfaceVariant: kGray500, // #686868
  // ── Surface containers (Material 3 elevation tints) ───────────────────
  surfaceContainerLowest: kWhite,
  surfaceContainerLow: kGray50, // #FAFAFA
  surfaceContainer: kGray100, // #F2F2F2
  surfaceContainerHigh: kGray150, // #E4E4E4
  surfaceContainerHighest: kGray200, // #D1D1D1
  // ── Outline ───────────────────────────────────────────────────────────
  outline: kGray300, // #B6B6B6
  outlineVariant: kGray200, // #D1D1D1
  // ── Inverse ───────────────────────────────────────────────────────────
  inverseSurface: kGray700, // #353535
  onInverseSurface: kWhite,
  inversePrimary: kPrimaryVariant, // #F2C223
  // ── Misc ──────────────────────────────────────────────────────────────
  shadow: kShadowLight,
  scrim: kGray900,
  surfaceTint: kPrimary,
);

// ═══════════════════════════════════════════════════════════════════════════════
// DARK SCHEME
// ═══════════════════════════════════════════════════════════════════════════════

/// Dark [ColorScheme] derived from the Figma design.
///
/// The dark palette uses a mid-gray surface (#4A4A4A) with a slightly
/// lighter scaffold (#636363) background, creating a layered depth effect.
/// The golden primary shifts to goldenrod (#DAA520) for optimal WCAG
/// contrast on dark surfaces.
///
/// ### Figma-to-Material 3 mapping
///
/// | Figma Element                | Material 3 Slot               | Hex       |
/// |------------------------------|-------------------------------|-----------|
/// | Scaffold / page bg           | `surface` (scaffold override) | #636363   |
/// | Card / app bar / container   | `surfaceContainer`            | #4A4A4A   |
/// | Primary CTA / labels         | `primary`                     | #DAA520   |
/// | Selected accent border       | `tertiary`                    | #F2C223   |
/// | Primary heading text         | `onSurface`                   | #FFFFFF   |
/// | Subtitle / data values       | `onSurfaceVariant`            | #D1D1D1   |
/// | Input hint / placeholder     | `outline`                     | #949494   |
/// | Card / input borders         | `outlineVariant`              | #636363   |
/// | Error / destructive          | `error`                       | #CC2B2B   |
const ColorScheme kDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // ── Primary ───────────────────────────────────────────────────────────
  primary: kDarkPrimary, // #DAA520 – goldenrod CTA
  onPrimary: kGray900, // black text on golden buttons
  primaryContainer: Color(0xFF5C4500), // darkened primary container
  onPrimaryContainer: Color(0xFFFFF3CC),

  // ── Secondary ─────────────────────────────────────────────────────────
  secondary: kDarkTextSecondary, // #D1D1D1 – secondary content
  onSecondary: kGray900,
  secondaryContainer: kDarkSurface, // #4A4A4A
  onSecondaryContainer: kDarkTextSecondary, // #D1D1D1
  // ── Tertiary ──────────────────────────────────────────────────────────
  tertiary: kDarkPrimaryVariant, // #F2C223 – active accent
  onTertiary: kGray900,
  tertiaryContainer: Color(0xFF5C4500),
  onTertiaryContainer: Color(0xFFFFF8E1),

  // ── Error / Destructive ───────────────────────────────────────────────
  error: kDestructive, // #CC2B2B – kept identical to Figma
  onError: kWhite,
  errorContainer: Color(0xFF5C1A1A),
  onErrorContainer: Color(0xFFF9DEDC),

  // ── Surface ───────────────────────────────────────────────────────────
  // Figma uses #636363 as the scaffold bg and #4A4A4A for cards.
  // Material 3's surface hierarchy is mapped accordingly.
  surface: kDarkBackground, // #636363 – scaffold background
  onSurface: kDarkOnSurface, // #FFFFFF – primary text
  onSurfaceVariant: kDarkTextSecondary, // #D1D1D1 – subtitles
  // ── Surface containers (Material 3 elevation tints) ───────────────────
  // Layered from darkest to lightest, matching Figma's card/container system.
  surfaceContainerLowest: kDarkSurfaceDeep, // #3A3A3A – deepest (drawers)
  surfaceContainerLow: kDarkSurface, // #4A4A4A – cards, app bar
  surfaceContainer: kDarkSurface, // #4A4A4A – main containers
  surfaceContainerHigh: kDarkSegmentBorder, // #4F4F4F – elevated
  surfaceContainerHighest: kDarkSurfaceVariant, // #636363 – highest
  // ── Outline ───────────────────────────────────────────────────────────
  outline: kDarkTextHint, // #949494 – prominent borders
  outlineVariant: kDarkSurfaceVariant, // #636363 – subtle borders
  // ── Inverse ───────────────────────────────────────────────────────────
  inverseSurface: kWhite,
  onInverseSurface: kDarkSurface, // #4A4A4A
  inversePrimary: Color(0xFFC49200), // darker golden
  // ── Misc ──────────────────────────────────────────────────────────────
  shadow: kDarkShadow, // #33000000
  scrim: kGray900,
  surfaceTint: kDarkPrimary,
);

// ═══════════════════════════════════════════════════════════════════════════════
// OLED TRUE-BLACK VARIANT
// ═══════════════════════════════════════════════════════════════════════════════

/// Returns a dark [ColorScheme] with pure-black surfaces for OLED screens.
///
/// All surface-level slots shift darker from the Figma palette,
/// saving battery on OLED panels while retaining the golden brand.
ColorScheme get kOledDarkColorScheme => kDarkColorScheme.copyWith(
  surface: kGray900, // pure black scaffold
  surfaceContainerLowest: kGray900,
  surfaceContainerLow: const Color(0xFF1A1A1A),
  surfaceContainer: const Color(0xFF212121),
  surfaceContainerHigh: const Color(0xFF2C2C2C),
  surfaceContainerHighest: const Color(0xFF353535),
);

// ═══════════════════════════════════════════════════════════════════════════════
// SEMANTIC STATUS COLORS (theme-independent)
// ═══════════════════════════════════════════════════════════════════════════════

/// Semantic status colors used consistently across the entire app.
///
/// These intentionally do **not** change with the theme – a green
/// success badge should always look the same in both light and dark mode.
class SemanticColors {
  const SemanticColors._();

  // ── Success ─────────────────────────────────────────────────────────────
  static const Color success = kSuccess;
  static const Color successLight = kSuccessLight;
  static const Color successDark = kSuccessDark;

  // ── Warning ─────────────────────────────────────────────────────────────
  static const Color warning = kWarning;
  static const Color warningLight = kWarningLight;
  static const Color warningDark = kWarningDark;

  // ── Error ───────────────────────────────────────────────────────────────
  static const Color error = kDestructive;
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  // ── Info ────────────────────────────────────────────────────────────────
  static const Color info = kInfo;
  static const Color infoLight = kInfoLight;
  static const Color infoDark = kInfoDark;

  // ── Neutral ─────────────────────────────────────────────────────────────
  static const Color neutral = kGray400;
  static const Color neutralLight = kGray150;
  static const Color neutralDark = kGray500;

  /// Convenience lookup by status string.
  static Color getStatusColor(String status) => switch (status.toLowerCase()) {
    'success' || 'completed' || 'active' => success,
    'warning' || 'pending' || 'processing' => warning,
    'error' || 'failed' || 'cancelled' => error,
    'info' || 'new' => info,
    _ => neutral,
  };
}

/// App-specific constants that are **not** part of [ColorScheme].
///
/// Use these for social-login buttons, shimmer placeholders, and gradients
/// that must remain visually identical regardless of the active theme.
class ConstantColors {
  const ConstantColors._();

  // Brand
  static const Color brandPrimary = kPrimary;
  static const Color brandPrimaryDark = kDarkPrimary;
  static const Color brandSecondary = kGray700;
  static const Color brandAccent = kPrimaryVariant;

  // Dark-mode special elements
  static const Color darkBadge = kDarkBadge;
  static const Color darkChatBubbleSent = kDarkChatBubbleSent;
  static const Color darkChartAccent = kDarkChartAccent;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [kPrimary, kPrimaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkWalletGradient = kDarkWalletGradient;

  // Social
  static const Color facebook = kFacebook;
  static const Color google = kGoogle;
  static const Color twitter = kTwitter;
  static const Color apple = kApple;

  // Shimmer
  static const Color shimmerBase = kShimmerBase;
  static const Color shimmerHighlight = kShimmerHighlight;
  static const Color shimmerBaseDark = kShimmerBaseDark;
  static const Color shimmerHighlightDark = kShimmerHighlightDark;
}
