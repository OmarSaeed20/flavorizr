// lib/shared/presentation/widgets/auth/auth_design_constants.dart
import 'package:flutter/material.dart';

/// Figma-accurate design constants for the entire auth flow.
///
/// Every token is extracted from the Figma design file to ensure
/// pixel-perfect implementation across all auth screens.
abstract final class AuthDesignConstants {
  const AuthDesignConstants._();

  // ═══════════════════════════════════════════════════════════════
  // COLORS
  // ═══════════════════════════════════════════════════════════════

  /// Primary brand gold — buttons, active indicators, links.
  static const Color primary = Color(0xFFFFBF00);

  /// Primary variant — selected card borders.
  static const Color primaryVariant = Color(0xFFF2C223);

  /// Screen background for most auth pages.
  static const Color background = Color(0xFFF2F2F2);

  /// Alternative background for user create-account.
  static const Color backgroundAlt = Color(0xFFF2F5F4);

  /// Company auth background.
  static const Color companyBackground = Color(0xFF646464);

  /// Company form card / app bar background.
  static const Color companyCardBackground = Color(0xFF4A4A4A);

  /// Company accent gold.
  static const Color companyGold = Color(0xFFDAA520);

  /// Text — headings.
  static const Color textPrimary = Color(0xFF131313);

  /// Text — body, app bar titles.
  static const Color textSecondary = Color(0xFF353535);

  /// Text — subtitles, labels, placeholders.
  static const Color textTertiary = Color(0xFF686868);

  /// Text — disabled state.
  static const Color textDisabled = Color(0xFF949494);

  /// Error / destructive — error text, OTP timer.
  static const Color error = Color(0xFFCC2B2B);

  /// Success state.
  static const Color success = Color(0xFF4CAF50);

  /// Inactive border — unselected card borders, inactive dots.
  static const Color inactiveBorder = Color(0xFFE4E4E4);

  /// Input border / fill.
  static const Color inputBorder = Color(0xFFF2F2F2);

  /// Outline border for secondary buttons.
  static const Color outlineBorder = Color(0xFFB6B6B6);

  // ═══════════════════════════════════════════════════════════════
  // TYPOGRAPHY
  // ═══════════════════════════════════════════════════════════════

  static const String fontHeadings = 'Inter';
  static const String fontBody = 'Poppins';

  // ═══════════════════════════════════════════════════════════════
  // DIMENSIONS
  // ═══════════════════════════════════════════════════════════════

  static const double inputBorderRadius = 8.0;
  static const double buttonHeight = 48.0;
  static const double buttonBorderRadius = 8.0;
  static const double bottomSheetRadius = 24.0;
  static const double cardBorderRadius = 24.0;
  static const double roleCardBorderRadius = 24.0;

  // ═══════════════════════════════════════════════════════════════
  // SHADOWS
  // ═══════════════════════════════════════════════════════════════

  static const BoxShadow bottomSheetShadow = BoxShadow(
    color: Color(0x3F000000),
    blurRadius: 14,
    offset: Offset(0, 4),
  );

  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 10,
    offset: Offset(0, 5),
  );

  static const BoxShadow languageCardShadow = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 10,
    offset: Offset(0, 3),
  );

  // ═══════════════════════════════════════════════════════════════
  // OTP
  // ═══════════════════════════════════════════════════════════════

  static const int otpCellCount = 6;
  static const double otpCellWidth = 41.0;
  static const double otpCellHeight = 49.0;
  static const int otpResendTimerSeconds = 60;

  // ═══════════════════════════════════════════════════════════════
  // PADDING
  // ═══════════════════════════════════════════════════════════════

  static const EdgeInsets sheetPadding = EdgeInsets.fromLTRB(20, 24, 20, 32);
  static const EdgeInsets sheetPaddingExtended = EdgeInsets.fromLTRB(20, 32, 20, 56);

  // ═══════════════════════════════════════════════════════════════
  // TEXT STYLES (Figma-accurate)
  // ═══════════════════════════════════════════════════════════════

  /// Screen title — 24px Inter Medium
  static const TextStyle screenTitle = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontFamily: fontHeadings,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  /// Screen subtitle — 14px Poppins Regular
  static const TextStyle screenSubtitle = TextStyle(
    color: textTertiary,
    fontSize: 14,
    fontFamily: fontBody,
    fontWeight: FontWeight.w400,
  );

  /// App bar title — 18px Inter SemiBold
  static const TextStyle appBarTitle = TextStyle(
    color: textSecondary,
    fontSize: 18,
    fontFamily: fontHeadings,
    fontWeight: FontWeight.w600,
    height: 1.56,
  );

  /// Field label — 12px Poppins Regular
  static const TextStyle fieldLabel = TextStyle(
    color: textTertiary,
    fontSize: 12,
    fontFamily: fontBody,
    fontWeight: FontWeight.w400,
    height: 1.25,
  );

  /// Field hint — 11px Poppins Regular
  static const TextStyle fieldHint = TextStyle(
    color: textTertiary,
    fontSize: 11,
    fontFamily: fontBody,
    fontWeight: FontWeight.w400,
    height: 1.25,
  );

  /// Button text — 14px Poppins SemiBold
  static const TextStyle buttonText = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: fontBody,
    fontWeight: FontWeight.w600,
  );

  /// Logo title — 24px Poppins Bold
  static const TextStyle logoTitle = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontFamily: fontBody,
    fontWeight: FontWeight.w700,
  );

  /// Language option — 14px Poppins Medium
  static const TextStyle languageOption = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: fontBody,
    fontWeight: FontWeight.w500,
    height: 1.29,
  );

  /// Role card label — 16px Poppins Medium
  static const TextStyle roleLabel = TextStyle(
    color: textTertiary,
    fontSize: 16,
    fontFamily: fontBody,
    fontWeight: FontWeight.w500,
  );

  /// Link text — 16px Poppins Regular
  static const TextStyle linkText = TextStyle(
    color: textTertiary,
    fontSize: 16,
    fontFamily: fontBody,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Link text accent — 16px Poppins SemiBold, primary color
  static const TextStyle linkTextAccent = TextStyle(
    color: primary,
    fontSize: 16,
    fontFamily: fontBody,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// Country code — 11px Poppins Medium
  static const TextStyle countryCode = TextStyle(
    color: textSecondary,
    fontSize: 11,
    fontFamily: fontBody,
    fontWeight: FontWeight.w500,
  );
}
