// lib/core/theme/app_theme.dart
import 'package:flavorizr/core/theme/color_schemes.dart';
import 'package:flavorizr/core/theme/theme_settings.dart';
import 'package:flavorizr/core/theme/typography.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builds Material 3 themes using flex_color_scheme.
///
/// This class handles:
/// - Light and dark theme generation
/// - Dynamic color integration (Android 12+)
/// - OLED true black mode
/// - Custom typography
/// - Component-specific theming
class AppTheme {
  AppTheme._();

  /// Creates a light theme based on the provided [settings].
  ///
  /// If [dynamicScheme] is provided and [settings./useDynamicColor] is true,
  /// it will be used instead of the selected color scheme.
  static ThemeData light({required ThemeSettings settings, ColorScheme? dynamicScheme}) {
    final useDynamic = settings.useDynamicColor && dynamicScheme != null;
    final scheme = AppColorSchemes.getScheme(settings.colorSchemeIndex);

    final flexTheme = FlexThemeData.light(
      scheme: useDynamic ? null : scheme,
      colorScheme: useDynamic ? dynamicScheme : null,
      useMaterial3: settings.useMaterial3,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: _getSubThemesData(settings),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3ErrorColors: true,
      fontFamily: AppTypography.fontFamily,
    );

    return _applyCustomizations(flexTheme, settings: settings, isDark: false);
  }

  /// Creates a dark theme based on the provided [settings].
  ///
  /// If [dynamicScheme] is provided and [settings./useDynamicColor] is true,
  /// it will be used instead of the selected color scheme.
  ///
  /// If [settings./useOledBlack] is true, surfaces will use true black.
  static ThemeData dark({required ThemeSettings settings, ColorScheme? dynamicScheme}) {
    final useDynamic = settings.useDynamicColor && dynamicScheme != null;
    final scheme = AppColorSchemes.getScheme(settings.colorSchemeIndex);

    final flexTheme = FlexThemeData.dark(
      scheme: useDynamic ? null : scheme,
      colorScheme: useDynamic ? dynamicScheme : null,
      useMaterial3: settings.useMaterial3,
      surfaceMode: settings.useOledBlack
          ? FlexSurfaceMode.highScaffoldLevelSurface
          : FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: settings.useOledBlack ? 0 : 13,
      darkIsTrueBlack: settings.useOledBlack,
      subThemesData: _getSubThemesData(settings),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3ErrorColors: true,
      fontFamily: AppTypography.fontFamily,
    );

    return _applyCustomizations(flexTheme, settings: settings, isDark: true);
  }

  /// Gets the sub-themes configuration.
  static FlexSubThemesData _getSubThemesData(ThemeSettings settings) => const FlexSubThemesData(
    // Overall settings
    interactionEffects: true,
    tintedDisabledControls: true,
    splashType: FlexSplashType.inkSparkle,

    // Blend levels
    blendOnLevel: 10,

    // Text field
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: 20,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorRadius: 12,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,

    // Buttons
    filledButtonRadius: 20,
    elevatedButtonRadius: 20,
    outlinedButtonRadius: 20,
    textButtonRadius: 20,
    elevatedButtonSchemeColor: SchemeColor.primary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,

    // Toggle buttons
    toggleButtonsRadius: 20,
    segmentedButtonRadius: 20,
    segmentedButtonSchemeColor: SchemeColor.primary,

    // FAB
    fabSchemeColor: SchemeColor.primaryContainer,
    fabRadius: 16,
    fabUseShape: true,

    // Chip
    chipRadius: 8,
    chipSchemeColor: SchemeColor.primary,

    // Card
    cardRadius: 16,
    cardElevation: 1,

    // Dialogs
    dialogRadius: 28,
    dialogElevation: 6,
    datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
    timePickerDialogRadius: 28,

    // Bottom sheet
    bottomSheetRadius: 28,
    bottomSheetElevation: 4,
    bottomSheetModalElevation: 8,

    // Snackbar
    snackBarRadius: 8,
    snackBarElevation: 4,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,

    // Navigation bar
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
    bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    bottomNavigationBarBackgroundSchemeColor: SchemeColor.surface,
    bottomNavigationBarElevation: 3,
    bottomNavigationBarType: BottomNavigationBarType.fixed,

    // Navigation rail
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailSelectedIconSchemeColor: SchemeColor.primary,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailIndicatorSchemeColor: SchemeColor.primaryContainer,
    navigationRailIndicatorOpacity: 1,
    navigationRailBackgroundSchemeColor: SchemeColor.surface,
    navigationRailLabelType: NavigationRailLabelType.all,

    // Drawer
    drawerRadius: 16,
    drawerElevation: 1,
    drawerBackgroundSchemeColor: SchemeColor.surface,
    drawerWidth: 304,

    // AppBar
    appBarCenterTitle: true,
    appBarScrolledUnderElevation: 4,

    // TabBar
    tabBarIndicatorSchemeColor: SchemeColor.primary,
    tabBarItemSchemeColor: SchemeColor.primary,
    tabBarUnselectedItemSchemeColor: SchemeColor.onSurface,
    tabBarDividerColor: Colors.transparent,

    // PopupMenu
    popupMenuRadius: 8,
    popupMenuElevation: 4,

    // Menu
    menuRadius: 8,
    menuElevation: 4,
    menuBarRadius: 0,
    menuBarElevation: 1,

    // Tooltip
    tooltipRadius: 4,
  );

  /// Applies custom theme modifications.
  static ThemeData _applyCustomizations(
    ThemeData theme, {
    required ThemeSettings settings,
    required bool isDark,
  }) {
    final colorScheme = theme.colorScheme;

    return theme.copyWith(
      // Text theme with scale factor
      textTheme: AppTypography.createTextTheme(
        displayColor: colorScheme.onSurface,
        bodyColor: colorScheme.onSurface,
        scaleFactor: settings.textScaleFactor,
      ),

      // Primary text theme
      primaryTextTheme: AppTypography.createTextTheme(
        displayColor: colorScheme.onPrimary,
        bodyColor: colorScheme.onPrimary,
        scaleFactor: settings.textScaleFactor,
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // Scrollbar theme
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

      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        horizontalTitleGap: 16,
        minVerticalPadding: 8,
        enableFeedback: true,
      ),

      // Expansion tile theme
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Badge theme
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        smallSize: 6,
        largeSize: 16,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: colorScheme.primaryContainer,
        valueIndicatorTextStyle: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Extensions
      extensions: [
        AppThemeExtension(
          success: SemanticColors.success,
          successContainer: isDark ? SemanticColors.successDark : SemanticColors.successLight,
          onSuccess: Colors.white,
          warning: SemanticColors.warning,
          warningContainer: isDark ? SemanticColors.warningDark : SemanticColors.warningLight,
          onWarning: Colors.black,
          info: SemanticColors.info,
          infoContainer: isDark ? SemanticColors.infoDark : SemanticColors.infoLight,
          onInfo: Colors.white,
          shimmerBase: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
          shimmerHighlight: isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight,
        ),
      ],
    );
  }

  /// Gets the system UI overlay style based on the theme.
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
    systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  );
}

/// Theme extension for app-specific colors.
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
  });
  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color warning;
  final Color warningContainer;
  final Color onWarning;
  final Color info;
  final Color infoContainer;
  final Color onInfo;
  final Color shimmerBase;
  final Color shimmerHighlight;

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
  );

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}

/// Extension to easily access custom theme colors.
extension AppThemeExtensions on ThemeData {
  AppThemeExtension get appColors => extension<AppThemeExtension>()!;
}

extension BuildContextThemeExtensions on BuildContext {
  /// Gets the current theme.
  ThemeData get theme => Theme.of(this);

  /// Gets the current color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Gets the current text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets the app-specific theme colors.
  AppThemeExtension get appColors => Theme.of(this).appColors;

  /// Whether dark mode is currently active.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
