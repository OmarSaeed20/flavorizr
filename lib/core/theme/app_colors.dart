// lib/core/theme/app_colors.dart

/// Figma-accurate color palette for Fast Golden Taxi.
///
/// Every hex value is extracted directly from the Figma design file.
/// The naming follows a **semantic + scale** convention so designers
/// and engineers share the same vocabulary.
///
/// ## Light Mode Palette
///
/// | Token              | Hex        | Figma Usage                                    |
/// |--------------------|------------|------------------------------------------------|
/// | `primary`          | #FFBF00    | Confirm / Accept / Submit buttons, map markers |
/// | `primaryVariant`   | #F2C223    | Selected chip border, date-picker accent       |
/// | `destructive`      | #CC2B2B    | Cancel button text, error states               |
/// | `gray900`          | #000000    | Pure black text, status-bar icons              |
/// | `gray800`          | #212121    | Date/time display text                         |
/// | `gray700`          | #353535    | Headings, selected date-picker bg              |
/// | `gray600`          | #3C3C3C    | Car marker circle border                       |
/// | `gray500`          | #686868    | Address text, subtitle text                    |
/// | `gray400`          | #949494    | Placeholder / hint text, disabled bg           |
/// | `gray300`          | #B6B6B6    | Toggle border                                  |
/// | `gray250`          | #B0B0B0    | Far-date text (date-picker)                    |
/// | `gray200`          | #D1D1D1    | Input field borders                            |
/// | `gray150`          | #E4E4E4    | Keyboard keys, card/chip borders               |
/// | `gray100`          | #F2F2F2    | Input field backgrounds, dividers              |
/// | `gray50`           | #FAFAFA    | Avatar borders, icon-button bg                 |
/// | `white`            | #FFFFFF    | Backgrounds, cards, bottom sheets              |
///
/// ## Dark Mode Palette (Figma-accurate)
///
/// | Token                     | Hex        | Figma Usage                                         |
/// |---------------------------|------------|-----------------------------------------------------|
/// | `darkPrimary`             | #DAA520    | Goldenrod – titles, labels, accents, primary CTAs   |
/// | `darkPrimaryVariant`      | #F2C223    | Selected tab/chip border, active accent             |
/// | `darkBackground`          | #636363    | Scaffold / page background                         |
/// | `darkSurface`             | #4A4A4A    | Cards, app bar, containers, inputs, bottom sheets   |
/// | `darkSurfaceVariant`      | #636363    | Card borders, input borders, dividers               |
/// | `darkSegmentBorder`       | #4F4F4F    | Segmented control border                           |
/// | `darkOnSurface`           | #FFFFFF    | Primary text – headings, names, body on dark        |
/// | `darkTextSecondary`       | #D1D1D1    | Status bar, subtitles, data values                  |
/// | `darkTextTertiary`        | #B5B5B5    | Body text, descriptions, help text                  |
/// | `darkTextHint`            | #949494    | Input hints, labels, secondary info                 |
/// | `darkTextMuted`           | #6C6C6C    | Currency suffix in inputs                           |
/// | `darkOverlay`             | #B3000000  | Modal backdrop (70% black)                          |
/// | `darkBadge`               | #26F1C630  | Badge/tag background (15% opacity gold)             |
/// | `darkChartAccent`         | #FFDB58    | Pie chart accent                                    |
/// | `darkChatBubbleSent`      | #B6B6B6    | Sent message bubble                                 |
/// | `darkSelectedTabText`     | #4A4A4A    | Inverted text on selected gold tab                  |
/// | `darkShadow`              | #33000000  | Drop shadow (20% black)                             |
/// | `darkShadowSubtle`        | #14000000  | Subtle elevation shadow (8% black)                  |
/// | `darkShadowCard`          | #28E1E1E1  | Card shadow on dark                                 |
/// | `darkShadowSheet`         | #3F000000  | Bottom-sheet shadow (25% black)                     |
///
/// **Shadows** are also defined here so widgets reference a single
/// source of truth instead of scattering opacity math.
library;

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// BRAND / PRIMARY
// ═══════════════════════════════════════════════════════════════════════════════

/// The signature golden-yellow of Fast Golden Taxi (light mode).
///
/// Used on primary CTA buttons (Confirm, Accept, Submit) and as the
/// accent ring on map markers.
const Color kPrimary = Color(0xFFFFBF00);

/// A slightly warmer golden shade used for selected-state accents
/// (e.g. selected chip border, date-picker ring).
const Color kPrimaryVariant = Color(0xFFF2C223);

// ── Dark-mode brand overrides (from Figma) ──────────────────────────────

/// Goldenrod primary for dark mode – lower saturation for WCAG contrast.
///
/// Figma: titles, labels, accent badges, primary CTA buttons on dark bg.
const Color kDarkPrimary = Color(0xFFDAA520);

/// Dark-mode primary variant – selected tab/chip border, active accent.
const Color kDarkPrimaryVariant = Color(0xFFF2C223);

/// Bright golden used in pie charts and accent highlights on dark mode.
const Color kDarkChartAccent = Color(0xFFFFDB58);

/// Wallet card gradient end color (dark mode).
const Color kDarkGradientGold = Color(0xFFF7CF4D);

// ═══════════════════════════════════════════════════════════════════════════════
// DESTRUCTIVE / ERROR
// ═══════════════════════════════════════════════════════════════════════════════

/// Red used for cancel-button text and error / destructive actions.
const Color kDestructive = Color(0xFFCC2B2B);

// ═══════════════════════════════════════════════════════════════════════════════
// NEUTRAL / GRAYSCALE – LIGHT (dark → light)
// ═══════════════════════════════════════════════════════════════════════════════

/// Pure black – status-bar icons, primary heading text.
const Color kGray900 = Color(0xFF000000);

/// Very dark gray – date/time display text.
const Color kGray800 = Color(0xFF212121);

/// Dark gray – headings, selected date-picker background.
const Color kGray700 = Color(0xFF353535);

/// Dark gray – car marker circle border.
const Color kGray600 = Color(0xFF3C3C3C);

/// Medium gray – address text, subtitle text.
const Color kGray500 = Color(0xFF686868);

/// Adjacent-date text in the date-picker.
const Color kGray475 = Color(0xFF676363);

/// Medium-light gray – placeholder / hint text, disabled button bg.
const Color kGray400 = Color(0xFF949494);

/// Light gray – toggle border.
const Color kGray300 = Color(0xFFB6B6B6);

/// Far-date text in the date-picker.
const Color kGray250 = Color(0xFFB0B0B0);

/// Light gray – input field borders, "Current Balance" label.
const Color kGray200 = Color(0xFFD1D1D1);

/// Very light gray – keyboard keys, card / chip / toggle-track borders.
const Color kGray150 = Color(0xFFE4E4E4);

/// Off-white – input-field backgrounds, keyboard special keys, dividers.
const Color kGray100 = Color(0xFFF2F2F2);

/// Near-white – avatar borders, icon-button backgrounds, chip bg.
const Color kGray50 = Color(0xFFFAFAFA);

/// Pure white – card backgrounds, bottom sheets, scaffold.
const Color kWhite = Color(0xFFFFFFFF);

// ═══════════════════════════════════════════════════════════════════════════════
// DARK-MODE SURFACE & BACKGROUND (from Figma)
// ═══════════════════════════════════════════════════════════════════════════════

/// Dark-mode scaffold / page background.
///
/// Figma: main page background behind cards & app bar.
const Color kDarkBackground = Color(0xFF636363);

/// Dark-mode card / container / app-bar / input-field / bottom-sheet surface.
///
/// Figma: all elevated surfaces sit on this color.
const Color kDarkSurface = Color(0xFF4A4A4A);

/// Dark-mode card borders, input borders, dividers.
///
/// Matches the background so borders are subtle (1:1.2 contrast ratio).
const Color kDarkSurfaceVariant = Color(0xFF636363);

/// Dark-mode segmented control border.
const Color kDarkSegmentBorder = Color(0xFF4F4F4F);

/// Deep surface for drawers, menus, OLED override layer.
const Color kDarkSurfaceDeep = Color(0xFF3A3A3A);

// ═══════════════════════════════════════════════════════════════════════════════
// DARK-MODE TEXT HIERARCHY (from Figma)
// ═══════════════════════════════════════════════════════════════════════════════

/// Primary text on dark – headings, names, body text.
const Color kDarkOnSurface = Color(0xFFFFFFFF);

/// Secondary text on dark – status bar, subtitles, data values.
const Color kDarkTextSecondary = Color(0xFFD1D1D1);

/// Tertiary text on dark – body text, descriptions, help text.
const Color kDarkTextTertiary = Color(0xFFB5B5B5);

/// Hint / placeholder text on dark – input hints, labels, secondary info.
const Color kDarkTextHint = Color(0xFF949494);

/// Muted text on dark – currency suffix in inputs.
const Color kDarkTextMuted = Color(0xFF6C6C6C);

// ═══════════════════════════════════════════════════════════════════════════════
// DARK-MODE SPECIAL ELEMENTS (from Figma)
// ═══════════════════════════════════════════════════════════════════════════════

/// Badge / tag background on dark – 15% opacity gold.
const Color kDarkBadge = Color(0x26F1C630);

/// Sent chat bubble color on dark.
const Color kDarkChatBubbleSent = Color(0xFFB6B6B6);

/// Selected tab fill on dark (text uses [kDarkSelectedTabText]).
const Color kDarkSelectedTabFill = Color(0xFFDAA520);

/// Selected tab text on dark – inverted to dark gray for contrast.
const Color kDarkSelectedTabText = Color(0xFF4A4A4A);

/// Modal backdrop overlay – 70% opacity black.
const Color kDarkOverlay = Color(0xB3000000);

/// Home indicator bar on dark.
const Color kDarkHomeIndicator = Color(0xFFFFFFFF);

// ═══════════════════════════════════════════════════════════════════════════════
// SHADOWS (pre-computed Color values for BoxShadow / Material)
// ═══════════════════════════════════════════════════════════════════════════════

/// Light shadow – 8 % opacity black.
const Color kShadowLight = Color(0x14000000);

/// Card shadow – ~25 % opacity #E1E1E1.
const Color kShadowCard = Color(0x3FE1E1E1);

/// Bottom-sheet shadow – 25 % opacity black.
const Color kShadowSheet = Color(0x3F000000);

/// Keyboard-key shadow – 30 % opacity black.
const Color kShadowKey = Color(0x4C000000);

// ── Dark-mode shadows (from Figma) ──────────────────────────────────────

/// Dark-mode drop shadow – 20% opacity black.
const Color kDarkShadow = Color(0x33000000);

/// Dark-mode subtle elevation shadow – 8% opacity black.
const Color kDarkShadowSubtle = Color(0x14000000);

/// Dark-mode card shadow – ~16% opacity #E1E1E1.
const Color kDarkShadowCard = Color(0x28E1E1E1);

// ═══════════════════════════════════════════════════════════════════════════════
// OVERLAY & MISCELLANEOUS
// ═══════════════════════════════════════════════════════════════════════════════

/// Map marker overlay – 80 % opacity black.
const Color kOverlayDark = Color(0xCC000000);

/// Rating-star background – 91 % opacity #F4F4F4.
const Color kRatingStarBg = Color(0xE8F4F4F4);

// ═══════════════════════════════════════════════════════════════════════════════
// DARK-MODE GRADIENTS
// ═══════════════════════════════════════════════════════════════════════════════

/// Wallet card gradient (dark mode) – black → golden.
///
/// Figma: wallet card background from `Colors.black` to `#F7CF4D`
/// with a 3% white overlay on top.
const LinearGradient kDarkWalletGradient = LinearGradient(
  colors: [kGray900, kDarkGradientGold],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Dark-mode wallet card overlay – 3% opacity white.
const Color kDarkWalletOverlay = Color(0x08FFFFFF);

// ═══════════════════════════════════════════════════════════════════════════════
// SEMANTIC STATUS COLORS
// ═══════════════════════════════════════════════════════════════════════════════

/// Success green.
const Color kSuccess = Color(0xFF4CAF50);

/// Success container (light theme).
const Color kSuccessLight = Color(0xFF81C784);

/// Success container (dark theme).
const Color kSuccessDark = Color(0xFF388E3C);

/// Warning orange.
const Color kWarning = Color(0xFFFF9800);

/// Warning container (light theme).
const Color kWarningLight = Color(0xFFFFB74D);

/// Warning container (dark theme).
const Color kWarningDark = Color(0xFFF57C00);

/// Info blue.
const Color kInfo = Color(0xFF2196F3);

/// Info container (light theme).
const Color kInfoLight = Color(0xFF64B5F6);

/// Info container (dark theme).
const Color kInfoDark = Color(0xFF1976D2);

// ═══════════════════════════════════════════════════════════════════════════════
// SOCIAL BRAND COLORS
// ═══════════════════════════════════════════════════════════════════════════════

/// Facebook brand blue.
const Color kFacebook = Color(0xFF1877F2);

/// Google brand red.
const Color kGoogle = Color(0xFFDB4437);

/// Twitter / X brand blue.
const Color kTwitter = Color(0xFF1DA1F2);

/// Apple brand black.
const Color kApple = Color(0xFF000000);

// ═══════════════════════════════════════════════════════════════════════════════
// SHIMMER / SKELETON LOADING
// ═══════════════════════════════════════════════════════════════════════════════

/// Shimmer base (light).
const Color kShimmerBase = Color(0xFFE0E0E0);

/// Shimmer highlight (light).
const Color kShimmerHighlight = Color(0xFFF5F5F5);

/// Shimmer base (dark).
const Color kShimmerBaseDark = Color(0xFF424242);

/// Shimmer highlight (dark).
const Color kShimmerHighlightDark = Color(0xFF616161);

// ═══════════════════════════════════════════════════════════════════════════════
// AppColors – context-aware accessor (backward-compatible API)
// ═══════════════════════════════════════════════════════════════════════════════

/// Provides **theme-aware** color access from a [BuildContext].
///
/// ```dart
/// final colors = AppColors.of(context);
/// Container(color: colors.primary);
/// ```
///
/// For raw palette tokens use the top-level `k*` constants directly.
class AppColors {
  const AppColors._({
    required this.primary,
    required this.primaryVariant,
    required this.destructive,
    required this.surface,
    required this.onSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textHint,
    required this.textMuted,
    required this.border,
    required this.inputBackground,
    required this.divider,
    required this.success,
    required this.warning,
    required this.info,
    required this.overlay,
    required this.badge,
    required this.chartAccent,
    required this.chatBubbleSent,
    required this.selectedTabFill,
    required this.selectedTabText,
    required this.shadow,
    required this.shadowCard,
  });

  /// Resolves an [AppColors] instance from the nearest [Theme].
  ///
  /// Automatically adapts all semantic tokens to the active brightness
  /// (light or dark) using the Figma-accurate palette.
  static AppColors of(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    return AppColors._(
      primary: cs.primary,
      primaryVariant: isDark ? kDarkPrimaryVariant : kPrimaryVariant,
      destructive: cs.error,
      surface: cs.surface,
      onSurface: cs.onSurface,
      textPrimary: cs.onSurface,
      textSecondary: isDark ? kDarkTextSecondary : cs.onSurfaceVariant,
      textTertiary: isDark ? kDarkTextTertiary : kGray500,
      textHint: isDark ? kDarkTextHint : kGray400,
      textMuted: isDark ? kDarkTextMuted : kGray300,
      border: isDark ? kDarkSurfaceVariant : kGray200,
      inputBackground: isDark ? kDarkSurface : kGray100,
      divider: isDark ? kDarkSurfaceVariant : kGray150,
      success: kSuccess,
      warning: kWarning,
      info: kInfo,
      overlay: isDark ? kDarkOverlay : kOverlayDark,
      badge: isDark ? kDarkBadge : const Color(0x26FFBF00),
      chartAccent: isDark ? kDarkChartAccent : kPrimaryVariant,
      chatBubbleSent: isDark ? kDarkChatBubbleSent : kGray100,
      selectedTabFill: isDark ? kDarkSelectedTabFill : kPrimary,
      selectedTabText: isDark ? kDarkSelectedTabText : kGray900,
      shadow: isDark ? kDarkShadow : kShadowLight,
      shadowCard: isDark ? kDarkShadowCard : kShadowCard,
    );
  }

  /// Golden primary CTA color.
  final Color primary;

  /// Warmer golden accent for selected states.
  final Color primaryVariant;

  /// Red for cancel / destructive actions.
  final Color destructive;

  /// Alias for [destructive] – backward-compatible with old `AppColors.error`.
  Color get error => destructive;

  /// Card / scaffold surface.
  final Color surface;

  /// Content color on surface.
  final Color onSurface;

  /// Primary text color (headings, body).
  final Color textPrimary;

  /// Secondary text color (subtitles, captions, data values).
  final Color textSecondary;

  /// Tertiary text color (descriptions, help text).
  final Color textTertiary;

  /// Hint / placeholder text color.
  final Color textHint;

  /// Muted text color (currency suffix, disabled labels).
  final Color textMuted;

  /// Input field border / card border color.
  final Color border;

  /// Input field background fill.
  final Color inputBackground;

  /// Divider / separator color.
  final Color divider;

  /// Success status color.
  final Color success;

  /// Warning status color.
  final Color warning;

  /// Info status color.
  final Color info;

  /// Modal backdrop / overlay color.
  final Color overlay;

  /// Badge / tag background color (partially transparent).
  final Color badge;

  /// Chart accent color (pie charts, data visualisation).
  final Color chartAccent;

  /// Sent chat message bubble color.
  final Color chatBubbleSent;

  /// Selected tab fill color.
  final Color selectedTabFill;

  /// Selected tab text color (inverted).
  final Color selectedTabText;

  /// Standard drop shadow color.
  final Color shadow;

  /// Card elevation shadow color.
  final Color shadowCard;

  // ── Static backward-compat aliases ──────────────────────────────────────

  /// Brand primary (static).
  static const Color brandPrimary = kPrimary;

  /// Brand secondary (static).
  static const Color brandSecondary = kGray700;

  /// Brand accent (static).
  static const Color brandAccent = kPrimaryVariant;

  /// Primary gradient (golden) – light mode.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [kPrimary, kPrimaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Wallet card gradient – dark mode.
  static const LinearGradient darkWalletGradient = kDarkWalletGradient;

  // Social colors
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
