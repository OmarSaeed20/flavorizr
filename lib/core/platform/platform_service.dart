// lib/core/platform/platform_service.dart
/// Platform service for platform detection and adaptation.
///
/// Provides utilities for detecting the current platform and adapting
/// the app's behavior accordingly.
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enumeration of supported platforms.
enum AppPlatform { ios, android, web, macos, windows, linux }

/// Service for platform detection and adaptation.
class PlatformService {
  static AppPlatform get current {
    if (kIsWeb) return AppPlatform.web;
    if (Platform.isIOS) return AppPlatform.ios;
    if (Platform.isAndroid) return AppPlatform.android;
    if (Platform.isMacOS) return AppPlatform.macos;
    if (Platform.isWindows) return AppPlatform.windows;
    if (Platform.isLinux) return AppPlatform.linux;
    return AppPlatform.android; // Fallback
  }

  /// Returns true if running on iOS.
  static bool get isIOS => current == AppPlatform.ios;

  /// Returns true if running on Android.
  static bool get isAndroid => current == AppPlatform.android;

  /// Returns true if running on web.
  static bool get isWeb => current == AppPlatform.web;

  /// Returns true if running on desktop (macOS, Windows, Linux).
  static bool get isDesktop =>
      current == AppPlatform.macos ||
      current == AppPlatform.windows ||
      current == AppPlatform.linux;

  /// Returns true if running on mobile (iOS, Android).
  static bool get isMobile => isIOS || isAndroid;

  /// Returns true if the platform has a notch/dynamic island.
  static bool get hasNotch => isIOS; // Simplified, should check device

  /// Returns true if the platform uses Cupertino design.
  static bool get usesCupertinoDesign => isIOS || current == AppPlatform.macos;

  /// Returns true if the platform uses Material design.
  static bool get usesMaterialDesign => !usesCupertinoDesign;

  /// Returns the platform-specific back button behavior.
  static bool get hasPhysicalBackButton => isAndroid;

  /// Returns the platform name as a string.
  static String get platformName => current.name;

  /// Returns true if the platform supports haptic feedback.
  static bool get supportsHaptics => isMobile;

  /// Returns true if the platform supports biometric authentication.
  static bool get supportsBiometrics => isMobile;

  /// Returns true if the platform supports push notifications.
  static bool get supportsPushNotifications => isMobile;

  /// Returns true if the platform supports in-app purchases.
  static bool get supportsInAppPurchases => isMobile;

  /// Returns true if the platform supports deep linking.
  static bool get supportsDeepLinking => true;

  /// Returns true if the platform supports sharing.
  static bool get supportsSharing => true;

  /// Returns true if the platform supports file picking.
  static bool get supportsFilePicking => !isWeb;

  /// Returns true if the platform supports camera.
  static bool get supportsCamera => !isWeb;

  /// Returns true if the platform supports microphone.
  static bool get supportsMicrophone => !isWeb;

  /// Returns true if the platform supports location services.
  static bool get supportsLocation => true;

  /// Returns true if the platform supports Bluetooth.
  static bool get supportsBluetooth => isMobile;

  /// Returns the appropriate haptic feedback for the platform.
  static void lightHaptic() {
    // TODO: Implement haptic feedback using flutter_local_notifications or similar
  }

  /// Returns the appropriate heavy haptic feedback.
  static void heavyHaptic() {
    // TODO: Implement haptic feedback using flutter_local_notifications or similar
  }

  /// Returns the appropriate selection haptic feedback.
  static void selectionHaptic() {
    // TODO: Implement haptic feedback
  }

  /// Returns the appropriate notification haptic feedback.
  static void notificationHaptic() {
    // TODO: Implement haptic feedback
  }

  /// Returns the appropriate success haptic feedback.
  static void successHaptic() {
    // TODO: Implement haptic feedback
  }

  /// Returns the appropriate warning haptic feedback.
  static void warningHaptic() {
    // TODO: Implement haptic feedback
  }

  /// Returns the appropriate error haptic feedback.
  static void errorHaptic() {
    // TODO: Implement haptic feedback
  }

  /// Returns the platform-specific safe area padding.
  static EdgeInsets get safeAreaPadding {
    if (isIOS) {
      return const EdgeInsets.only(
        top: 44, // Status bar + notch
        bottom: 34, // Home indicator
      );
    }
    if (isAndroid) {
      return const EdgeInsets.only(
        top: 24, // Status bar
      );
    }
    return EdgeInsets.zero;
  }

  /// Returns the platform-specific bottom sheet border radius.
  static double get bottomSheetBorderRadius {
    if (isIOS) return 20;
    return 16;
  }

  /// Returns the platform-specific card border radius.
  static double get cardBorderRadius {
    if (isIOS) return 12;
    return 12;
  }

  /// Returns the platform-specific button border radius.
  static double get buttonBorderRadius {
    if (isIOS) return 8;
    return 20;
  }

  /// Returns the platform-specific input field border radius.
  static double get inputBorderRadius {
    if (isIOS) return 10;
    return 8;
  }

  /// Returns the platform-specific default font family.
  static String? get defaultFontFamily {
    if (isIOS) return '.SF Pro Text';
    if (isAndroid) return 'Roboto';
    return null;
  }

  /// Returns the platform-specific animation duration.
  static Duration get defaultAnimationDuration {
    if (isIOS) return const Duration(milliseconds: 350);
    return const Duration(milliseconds: 200);
  }

  /// Returns the platform-specific animation curve.
  static Curve get defaultAnimationCurve {
    if (isIOS) return Curves.easeInOut;
    return Curves.fastOutSlowIn;
  }

  /// Returns the platform-specific scroll physics.
  static ScrollPhysics get scrollPhysics {
    if (isIOS) return const BouncingScrollPhysics();
    return const ClampingScrollPhysics();
  }

  /// Returns the platform-specific page transition.
  static PageTransitionsTheme get pageTransitionsTheme {
    if (isIOS) {
      return const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      );
    }
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      },
    );
  }

  /// Returns the platform-specific dialog theme.
  static DialogTheme get dialogTheme {
    if (isIOS) {
      return DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)));
    }
    return DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)));
  }

  /// Returns the platform-specific bottom sheet theme.
  static BottomSheetThemeData get bottomSheetTheme {
    if (isIOS) {
      return BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(bottomSheetBorderRadius)),
        ),
        backgroundColor: Colors.white,
      );
    }
    return BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(bottomSheetBorderRadius)),
      ),
    );
  }

  /// Returns the platform-specific app bar theme.
  static AppBarTheme get appBarTheme {
    if (isIOS) {
      return const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      );
    }
    return const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  /// Returns the platform-specific floating action button theme.
  static FloatingActionButtonThemeData get floatingActionButtonTheme {
    if (isIOS) {
      return FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }
    return const FloatingActionButtonThemeData(shape: CircleBorder());
  }

  /// Returns the platform-specific card theme.
  static CardTheme get cardTheme {
    return CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius)),
      elevation: isIOS ? 0 : 1,
    );
  }

  /// Returns the platform-specific input decoration theme.
  static InputDecorationTheme get inputDecorationTheme {
    if (isIOS) {
      return InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(inputBorderRadius)),
        filled: true,
        fillColor: Colors.grey[100],
      );
    }
    return InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(inputBorderRadius)),
      filled: false,
    );
  }

  /// Returns the platform-specific text button theme.
  static TextButtonThemeData get textButtonTheme {
    if (isIOS) {
      return TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Returns the platform-specific elevated button theme.
  static ElevatedButtonThemeData get elevatedButtonTheme {
    if (isIOS) {
      return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    }
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  /// Returns the platform-specific outlined button theme.
  static OutlinedButtonThemeData get outlinedButtonTheme {
    if (isIOS) {
      return OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius)),
          side: BorderSide(color: Colors.blue.withValues(alpha:0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    }
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonBorderRadius)),
        side: BorderSide(color: Colors.blue.withValues(alpha:0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  /// Returns the platform-specific switch theme.
  static SwitchThemeData get switchTheme {
    if (isIOS) {
      return SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.grey[400];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.green;
          }
          return Colors.grey[300];
        }),
      );
    }
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue;
        }
        return Colors.grey[400];
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue.withValues(alpha:0.5);
        }
        return Colors.grey[300];
      }),
    );
  }

  /// Returns the platform-specific checkbox theme.
  static CheckboxThemeData get checkboxTheme {
    if (isIOS) {
      return CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      );
    }
    return const CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
    );
  }

  /// Returns the platform-specific radio theme.
  static RadioThemeData get radioTheme {
    if (isIOS) {
      return RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.blue;
          }
          return Colors.grey[400];
        }),
      );
    }
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue;
        }
        return Colors.grey[400];
      }),
    );
  }

  /// Returns the platform-specific slider theme.
  static SliderThemeData get sliderTheme {
    if (isIOS) {
      return const SliderThemeData(
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
      );
    }
    return const SliderThemeData(
      trackHeight: 2,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
    );
  }

  /// Returns the platform-specific progress indicator theme.
  static ProgressIndicatorThemeData get progressIndicatorTheme {
    if (isIOS) {
      return const ProgressIndicatorThemeData(linearTrackColor: Colors.grey, color: Colors.blue);
    }
    return const ProgressIndicatorThemeData(linearTrackColor: Colors.grey, color: Colors.blue);
  }

  /// Returns the platform-specific divider theme.
  static DividerThemeData get dividerTheme {
    if (isIOS) {
      return DividerThemeData(color: Colors.grey[300], thickness: 0.5, space: 1);
    }
    return DividerThemeData(color: Colors.grey[400], thickness: 1, space: 16);
  }

  /// Returns the platform-specific list tile theme.
  static ListTileThemeData get listTileTheme {
    if (isIOS) {
      return const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 40,
      );
    }
    return const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minLeadingWidth: 56,
    );
  }

  /// Returns the platform-specific chip theme.
  static ChipThemeData get chipTheme {
    if (isIOS) {
      return ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: const TextStyle(fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    }
    return ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: const TextStyle(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  /// Returns the platform-specific snackbar theme.
  static SnackBarThemeData get snackBarTheme {
    if (isIOS) {
      return SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      );
    }
    return SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    );
  }

  /// Returns the platform-specific bottom navigation bar theme.
  static BottomNavigationBarThemeData get bottomNavigationBarTheme {
    if (isIOS) {
      return const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      );
    }
    return const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    );
  }

  /// Returns the platform-specific tab bar theme.
  static TabBarTheme get tabBarTheme {
    if (isIOS) {
      return const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      );
    }
    return const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    );
  }

  /// Returns the platform-specific tooltip theme.
  static TooltipThemeData get tooltipTheme {
    if (isIOS) {
      return TooltipThemeData(
        decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    }
    return TooltipThemeData(
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(4)),
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Returns the platform-specific badge theme.
  static BadgeThemeData get badgeTheme {
    if (isIOS) {
      return const BadgeThemeData(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        smallSize: 8,
        largeSize: 16,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      );
    }
    return const BadgeThemeData(
      backgroundColor: Colors.red,
      textColor: Colors.white,
      smallSize: 6,
      largeSize: 18,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  /// Returns the platform-specific navigation bar theme.
  static NavigationBarThemeData get navigationBarTheme {
    if (isIOS) {
      return NavigationBarThemeData(
        height: 80,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 10, fontWeight: FontWeight.w600);
          }
          return const TextStyle(fontSize: 10);
        }),
      );
    }
    return NavigationBarThemeData(
      height: 80,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
        }
        return const TextStyle(fontSize: 12);
      }),
    );
  }

  /// Returns the platform-specific navigation rail theme.
  static NavigationRailThemeData get navigationRailTheme {
    if (isIOS) {
      return const NavigationRailThemeData(
        minWidth: 56,
        selectedLabelTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelTextStyle: TextStyle(fontSize: 12),
      );
    }
    return const NavigationRailThemeData(
      minWidth: 80,
      selectedLabelTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelTextStyle: TextStyle(fontSize: 12),
    );
  }

  /// Returns the platform-specific drawer theme.
  static DrawerThemeData get drawerTheme {
    if (isIOS) {
      return const DrawerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        elevation: 16,
      );
    }
    return const DrawerThemeData(elevation: 16);
  }

  /// Returns the platform-specific time picker theme.
  static TimePickerThemeData get timePickerTheme {
    if (isIOS) {
      return TimePickerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      );
    }
    return TimePickerThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    );
  }

  /// Returns the platform-specific date picker theme.
  static DatePickerThemeData get datePickerTheme {
    if (isIOS) {
      return DatePickerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      );
    }
    return DatePickerThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    );
  }

  /// Returns the platform-specific color scheme.
  static ColorScheme getColorScheme(Brightness brightness) {
    if (isIOS) {
      return brightness == Brightness.light
          ? const ColorScheme.light(
              primary: Color(0xFF007AFF),
              secondary: Color(0xFF5856D6),
              surface: Color(0xFFF2F2F7),
              error: Color(0xFFFF3B30),
            )
          : const ColorScheme.dark(
              primary: Color(0xFF0A84FF),
              secondary: Color(0xFF5E5CE6),
              surface: Color(0xFF1C1C1E),
              error: Color(0xFFFF453A),
            );
    }
    return brightness == Brightness.light ? const ColorScheme.light() : const ColorScheme.dark();
  }
}

/// Extension for platform-specific widget building.
extension PlatformWidgets on BuildContext {
  /// Returns the current platform.
  AppPlatform get platform => PlatformService.current;

  /// Returns true if on iOS.
  bool get isIOS => PlatformService.isIOS;

  /// Returns true if on Android.
  bool get isAndroid => PlatformService.isAndroid;

  /// Returns true if on web.
  bool get isWeb => PlatformService.isWeb;

  /// Returns true if on desktop.
  bool get isDesktop => PlatformService.isDesktop;

  /// Returns true if on mobile.
  bool get isMobile => PlatformService.isMobile;

  /// Returns the platform-specific safe area padding.
  EdgeInsets get safeAreaPadding => PlatformService.safeAreaPadding;

  /// Returns the platform-specific scroll physics.
  ScrollPhysics get scrollPhysics => PlatformService.scrollPhysics;

  /// Returns the platform-specific animation duration.
  Duration get animationDuration => PlatformService.defaultAnimationDuration;

  /// Returns the platform-specific animation curve.
  Curve get animationCurve => PlatformService.defaultAnimationCurve;
}
