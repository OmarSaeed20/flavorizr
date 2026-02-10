// lib/core/theme/app_theme.dart

/// Material 3 theme builder for Fast Golden Taxi.
///
/// Assembles [ThemeData] from the Figma-derived palette
/// (`app_colors.dart`), color schemes (`color_schemes.dart`),
/// and typography (`typography.dart`).
///
/// No third-party theme packages (e.g. `flex_color_scheme`) are used –
/// everything maps directly to Flutter's Material 3 API.
library;

import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/color_schemes.dart';
import 'package:fast_golden_taxi/core/theme/theme_settings.dart';
import 'package:fast_golden_taxi/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// THEME BUILDER
// ═══════════════════════════════════════════════════════════════════════════════

/// Builds Material 3 [ThemeData] for the app.
///
/// Usage in `MaterialApp`:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light(settings: themeSettings),
///   darkTheme: AppTheme.dark(settings: themeSettings),
///   themeMode: themeSettings.themeMode,
/// );
/// ```
class AppTheme {
  const AppTheme._();

  // ─────────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a **light** [ThemeData].
  ///
  /// If [dynamicScheme] is non-null **and** the user opted in via
  /// [ThemeSettings.useDynamicColor], it replaces the Figma palette.
  static ThemeData light({
    required ThemeSettings settings,
    ColorScheme? dynamicScheme,
  }) {
    final colorScheme = (settings.useDynamicColor && dynamicScheme != null)
        ? dynamicScheme
        : kLightColorScheme;

    return _buildTheme(
      colorScheme: colorScheme,
      settings: settings,
      isDark: false,
    );
  }

  /// Creates a **dark** [ThemeData].
  ///
  /// Supports OLED true-black mode via [ThemeSettings.useOledBlack].
  static ThemeData dark({
    required ThemeSettings settings,
    ColorScheme? dynamicScheme,
  }) {
    final ColorScheme colorScheme;

    if (settings.useDynamicColor && dynamicScheme != null) {
      colorScheme = dynamicScheme;
    } else if (settings.useOledBlack) {
      colorScheme = kOledDarkColorScheme;
    } else {
      colorScheme = kDarkColorScheme;
    }

    return _buildTheme(
      colorScheme: colorScheme,
      settings: settings,
      isDark: true,
    );
  }

  /// Returns a [SystemUiOverlayStyle] matching the current theme.
  static SystemUiOverlayStyle getSystemUiOverlayStyle({
    required ThemeData theme,
    required bool isDark,
    Color? statusBarColor,
    Color? navigationBarColor,
  }) => SystemUiOverlayStyle(
    statusBarColor: statusBarColor ?? Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: navigationBarColor ?? theme.colorScheme.surface,
    systemNavigationBarIconBrightness: isDark
        ? Brightness.light
        : Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Internal – Theme assembly
  // ─────────────────────────────────────────────────────────────────────────

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required ThemeSettings settings,
    required bool isDark,
  }) {
    // Text themes
    final textTheme = AppTypography.createTextTheme(
      displayColor: colorScheme.onSurface,
      bodyColor: colorScheme.onSurface,
      scaleFactor: settings.textScaleFactor,
    );

    final primaryTextTheme = AppTypography.createTextTheme(
      displayColor: colorScheme.onPrimary,
      bodyColor: colorScheme.onPrimary,
      scaleFactor: settings.textScaleFactor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      // Figma dark: scaffold bg = #636363, light: #FFFFFF
      scaffoldBackgroundColor: isDark ? kDarkBackground : colorScheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // ── AppBar ──────────────────────────────────────────────────────────
      // Figma dark: app bar = #4A4A4A (card surface), title = white
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: isDark ? 0 : 4,
        backgroundColor: isDark ? kDarkSurface : colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),

      // ── Elevated Button ─────────────────────────────────────────────────
      // Figma dark: golden fill (#DAA520), border #F2C223, black text
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isDark
                ? const BorderSide(color: kDarkPrimaryVariant)
                : BorderSide.none,
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.displayFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Filled Button ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isDark
                ? const BorderSide(color: kDarkPrimaryVariant)
                : BorderSide.none,
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.displayFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      // Figma dark: outline uses surface variant border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(
            color: isDark ? kDarkSurfaceVariant : colorScheme.outline,
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.displayFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ─────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.displayFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ── Input Decoration ────────────────────────────────────────────────
      // Figma dark: fill = #4A4A4A, border = #636363, hint = #949494
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? kDarkSurface : kGray100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? kDarkSurfaceVariant : kGray200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? kDarkSurfaceVariant : kGray200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: TextStyle(
          fontFamily: AppTypography.bodyFontFamily,
          color: isDark ? kDarkTextHint : kGray400,
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          fontFamily: AppTypography.bodyFontFamily,
          color: isDark ? kDarkTextHint : colorScheme.onSurfaceVariant,
        ),
        prefixIconColor: colorScheme.primary,
      ),

      // ── Card ────────────────────────────────────────────────────────────
      // Figma dark: card = #4A4A4A, border = #636363
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDark
              ? const BorderSide(color: kDarkSurfaceVariant)
              : BorderSide.none,
        ),
        color: isDark ? kDarkSurface : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark ? kDarkShadowCard : kShadowCard,
        margin: EdgeInsets.zero,
      ),

      // ── Chip ────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? kDarkSurface : kGray50,
        selectedColor: isDark ? kDarkBadge : colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isDark ? kDarkSurfaceVariant : kGray150),
        ),
        labelStyle: const TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      // Figma dark: dialog bg = #4A4A4A
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: isDark ? 0 : 6,
        backgroundColor: isDark ? kDarkSurface : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Bottom Sheet ────────────────────────────────────────────────────
      // Figma dark: bottom sheet = #4A4A4A, drag handle = white
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        elevation: isDark ? 0 : 8,
        backgroundColor: isDark ? kDarkSurface : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark ? kDarkShadow : kShadowSheet,
        showDragHandle: true,
        dragHandleColor: isDark ? kDarkTextSecondary : kGray300,
        dragHandleSize: const Size(32, 4),
      ),

      // ── Snackbar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          fontFamily: AppTypography.bodyFontFamily,
          color: colorScheme.onInverseSurface,
        ),
      ),

      // ── Bottom Navigation Bar ───────────────────────────────────────────
      // Figma dark: nav bar bg = #4A4A4A
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: isDark ? 0 : 3,
        backgroundColor: isDark ? kDarkSurface : colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isDark ? kDarkTextHint : colorScheme.onSurface,
        selectedLabelStyle: const TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Navigation Bar (Material 3) ─────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        elevation: isDark ? 0 : 3,
        backgroundColor: isDark ? kDarkSurface : colorScheme.surface,
        indicatorColor: isDark ? kDarkBadge : colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: AppTypography.displayFontFamily,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          );
        }),
      ),

      // ── Floating Action Button ──────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      // Figma dark: divider = #636363
      dividerTheme: DividerThemeData(
        color: isDark ? kDarkSurfaceVariant : kGray150,
        thickness: 1,
        space: 1,
      ),

      // ── ListTile ────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        horizontalTitleGap: 16,
        minVerticalPadding: 8,
        enableFeedback: true,
      ),

      // ── Expansion Tile ──────────────────────────────────────────────────
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ── TabBar ──────────────────────────────────────────────────────────
      // Figma dark: selected tab fill = #DAA520, selected text = #4A4A4A,
      //             unselected text = white
      tabBarTheme: TabBarThemeData(
        indicatorColor: colorScheme.primary,
        labelColor: isDark ? kDarkSelectedTabText : colorScheme.primary,
        unselectedLabelColor: isDark ? kDarkOnSurface : colorScheme.onSurface,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Badge ───────────────────────────────────────────────────────────
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        smallSize: 6,
        largeSize: 16,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),

      // ── Progress Indicator ──────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // ── Slider ──────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: colorScheme.primaryContainer,
        valueIndicatorTextStyle: TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ── Scrollbar ───────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(false),
        thickness: WidgetStateProperty.all(8),
        radius: const Radius.circular(8),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return colorScheme.primary.withValues(alpha: 0.9);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.7);
          }
          return colorScheme.onSurface.withValues(alpha: 0.3);
        }),
      ),

      // ── Drawer ──────────────────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
        ),
        elevation: isDark ? 0 : 1,
        backgroundColor: isDark ? kDarkSurface : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        width: 304,
      ),

      // ── PopupMenu ───────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: isDark ? 0 : 4,
        color: isDark ? kDarkSurface : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Tooltip ─────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: TextStyle(
          fontFamily: AppTypography.bodyFontFamily,
          fontSize: 12,
          color: colorScheme.onInverseSurface,
        ),
      ),

      // ── Date Picker ─────────────────────────────────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor: isDark ? kDarkSurface : colorScheme.surface,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
        dayStyle: const TextStyle(
          fontFamily: AppTypography.displayFontFamily,
          fontWeight: FontWeight.w500,
        ),
        todayBorder: BorderSide(color: colorScheme.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        surfaceTintColor: Colors.transparent,
      ),

      // ── Segmented Button ────────────────────────────────────────────────
      // Figma dark: segment border = #4F4F4F, selected fill = #DAA520
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          side: isDark
              ? WidgetStateProperty.all(
                  const BorderSide(color: kDarkSegmentBorder),
                )
              : null,
          backgroundColor: isDark
              ? WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return kDarkSelectedTabFill;
                  }
                  return kDarkSurface;
                })
              : null,
          foregroundColor: isDark
              ? WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return kDarkSelectedTabText;
                  }
                  return kDarkOnSurface;
                })
              : null,
        ),
      ),

      // ── Page Transitions ────────────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // ── Extensions ──────────────────────────────────────────────────────
      extensions: [
        AppThemeExtension(
          success: SemanticColors.success,
          successContainer: isDark
              ? SemanticColors.successDark
              : SemanticColors.successLight,
          onSuccess: kWhite,
          warning: SemanticColors.warning,
          warningContainer: isDark
              ? SemanticColors.warningDark
              : SemanticColors.warningLight,
          onWarning: kGray900,
          info: SemanticColors.info,
          infoContainer: isDark
              ? SemanticColors.infoDark
              : SemanticColors.infoLight,
          onInfo: kWhite,
          shimmerBase: isDark ? kShimmerBaseDark : kShimmerBase,
          shimmerHighlight: isDark ? kShimmerHighlightDark : kShimmerHighlight,
          // Dark-mode specific semantic tokens
          overlay: isDark ? kDarkOverlay : kOverlayDark,
          badge: isDark ? kDarkBadge : const Color(0x26FFBF00),
          chatBubbleSent: isDark ? kDarkChatBubbleSent : kGray100,
          chartAccent: isDark ? kDarkChartAccent : kPrimaryVariant,
          textTertiary: isDark ? kDarkTextTertiary : kGray500,
          textMuted: isDark ? kDarkTextMuted : kGray300,
          cardSurface: isDark ? kDarkSurface : kWhite,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// THEME EXTENSION – app-specific semantic colors
// ═══════════════════════════════════════════════════════════════════════════════

/// Extra color slots that Material 3's [ColorScheme] doesn't cover.
///
/// Access via `Theme.of(context).appColors` or `context.appColors`.
///
/// Includes both universal semantic colors (success, warning, info) and
/// dark-mode specific Figma tokens (overlay, badge, chat, chart, etc.).
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.success,
    required this.successContainer,
    required this.onSuccess,
    required this.warning,
    required this.warningContainer,
    required this.onWarning,
    required this.info,
    required this.infoContainer,
    required this.onInfo,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.overlay,
    required this.badge,
    required this.chatBubbleSent,
    required this.chartAccent,
    required this.textTertiary,
    required this.textMuted,
    required this.cardSurface,
  });

  // ── Semantic status ─────────────────────────────────────────────────────
  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color warning;
  final Color warningContainer;
  final Color onWarning;
  final Color info;
  final Color infoContainer;
  final Color onInfo;

  // ── Shimmer / skeleton ──────────────────────────────────────────────────
  final Color shimmerBase;
  final Color shimmerHighlight;

  // ── Dark-mode Figma tokens ──────────────────────────────────────────────

  /// Modal backdrop overlay color (70% black on dark, 80% on light).
  final Color overlay;

  /// Badge / tag background (15% gold on dark, 15% gold on light).
  final Color badge;

  /// Sent chat message bubble color.
  final Color chatBubbleSent;

  /// Chart accent color (pie charts, data vis).
  final Color chartAccent;

  /// Tertiary text – descriptions, help text (#B5B5B5 dark, #686868 light).
  final Color textTertiary;

  /// Muted text – currency suffix, disabled labels (#6C6C6C dark).
  final Color textMuted;

  /// Explicit card surface – for widgets needing card bg independent of
  /// `ColorScheme.surface` (#4A4A4A dark, #FFFFFF light).
  final Color cardSurface;

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccess,
    Color? warning,
    Color? warningContainer,
    Color? onWarning,
    Color? info,
    Color? infoContainer,
    Color? onInfo,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? overlay,
    Color? badge,
    Color? chatBubbleSent,
    Color? chartAccent,
    Color? textTertiary,
    Color? textMuted,
    Color? cardSurface,
  }) => AppThemeExtension(
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    onSuccess: onSuccess ?? this.onSuccess,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarning: onWarning ?? this.onWarning,
    info: info ?? this.info,
    infoContainer: infoContainer ?? this.infoContainer,
    onInfo: onInfo ?? this.onInfo,
    shimmerBase: shimmerBase ?? this.shimmerBase,
    shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    overlay: overlay ?? this.overlay,
    badge: badge ?? this.badge,
    chatBubbleSent: chatBubbleSent ?? this.chatBubbleSent,
    chartAccent: chartAccent ?? this.chartAccent,
    textTertiary: textTertiary ?? this.textTertiary,
    textMuted: textMuted ?? this.textMuted,
    cardSurface: cardSurface ?? this.cardSurface,
  );

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      badge: Color.lerp(badge, other.badge, t)!,
      chatBubbleSent: Color.lerp(chatBubbleSent, other.chatBubbleSent, t)!,
      chartAccent: Color.lerp(chartAccent, other.chartAccent, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONVENIENCE EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════

/// Quick access to [AppThemeExtension] from [ThemeData].
extension AppThemeExtensions on ThemeData {
  /// App-specific semantic colors (success, warning, info, shimmer).
  AppThemeExtension get appColors => extension<AppThemeExtension>()!;
}

/// Quick access to theme properties from [BuildContext].
extension BuildContextThemeExtensions on BuildContext {
  /// The current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// The current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// The current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// App-specific semantic colors (success, warning, info, shimmer).
  AppThemeExtension get appColors => Theme.of(this).appColors;

  /// Whether dark mode is currently active.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
