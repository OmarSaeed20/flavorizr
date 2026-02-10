// lib/core/theme/color_schemes.dart
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// Pre-defined color schemes available in the app.
///
/// Users can select from these schemes in settings,
/// or the app can use dynamic colors from the system.
class AppColorSchemes {
  const AppColorSchemes._();

  /// List of available color schemes with their display names.
  static final List<({String name, FlexScheme scheme, IconData icon})> schemes = [
    (name: 'Material Blue', scheme: FlexScheme.material, icon: Icons.water_drop),
    (name: 'Material High Contrast', scheme: FlexScheme.materialHc, icon: Icons.contrast),
    (name: 'Brand Blue', scheme: FlexScheme.brandBlue, icon: Icons.sailing),
    (name: 'Indigo', scheme: FlexScheme.indigoM3, icon: Icons.nights_stay),
    (name: 'Hippie Blue', scheme: FlexScheme.hippieBlue, icon: Icons.waves),
    (name: 'Aqua Blue', scheme: FlexScheme.aquaBlue, icon: Icons.pool),
    (name: 'Teal', scheme: FlexScheme.tealM3, icon: Icons.eco),
    (name: 'Green Forest', scheme: FlexScheme.greenM3, icon: Icons.forest),
    (name: 'Verdun Green', scheme: FlexScheme.verdunHemlock, icon: Icons.grass),
    (name: 'Dell Genoa Green', scheme: FlexScheme.dellGenoa, icon: Icons.park),
    (name: 'Lime', scheme: FlexScheme.limeM3, icon: Icons.local_florist),
    (name: 'Gold Sunset', scheme: FlexScheme.gold, icon: Icons.wb_sunny),
    (name: 'Mango', scheme: FlexScheme.mango, icon: Icons.emoji_food_beverage),
    (name: 'Amber', scheme: FlexScheme.amber, icon: Icons.light_mode),
    (name: 'Orange', scheme: FlexScheme.orangeM3, icon: Icons.brightness_5),
    (name: 'Deep Orange', scheme: FlexScheme.deepOrangeM3, icon: Icons.local_fire_department),
    (name: 'Red Wine', scheme: FlexScheme.redWine, icon: Icons.wine_bar),
    (name: 'Red', scheme: FlexScheme.redM3, icon: Icons.favorite),
    (name: 'Pink', scheme: FlexScheme.pinkM3, icon: Icons.favorite_border),
    (name: 'Sakura', scheme: FlexScheme.sakura, icon: Icons.spa),
    (name: 'Purple', scheme: FlexScheme.purpleM3, icon: Icons.auto_awesome),
    (name: 'Deep Purple', scheme: FlexScheme.deepPurple, icon: Icons.diamond),
    (name: 'Violet', scheme: FlexScheme.blumineBlue, icon: Icons.brush),
    (name: 'Barossa', scheme: FlexScheme.barossa, icon: Icons.celebration),
    (name: 'Shark', scheme: FlexScheme.shark, icon: Icons.dark_mode),
    (name: 'Grey Law', scheme: FlexScheme.greyLaw, icon: Icons.gavel),
    (name: 'Sepia', scheme: FlexScheme.sepia, icon: Icons.photo_album),
  ];

  /// Gets the [FlexScheme] at the specified [index].
  /// Returns [FlexScheme.material] if index is out of bounds.
  static FlexScheme getScheme(int index) {
    if (index < 0 || index >= schemes.length) {
      return FlexScheme.material;
    }
    return schemes[index].scheme;
  }

  /// Gets the display name for the scheme at [index].
  static String getSchemeName(int index) {
    if (index < 0 || index >= schemes.length) {
      return 'Material Blue';
    }
    return schemes[index].name;
  }

  /// Gets the icon for the scheme at [index].
  static IconData getSchemeIcon(int index) {
    if (index < 0 || index >= schemes.length) {
      return Icons.water_drop;
    }
    return schemes[index].icon;
  }

  /// Gets the total count of available schemes.
  static int get schemeCount => schemes.length;
}

/// Semantic colors for specific UI states.
///
/// These colors are used consistently throughout the app
/// for success, warning, error, and info states.
class SemanticColors {
  SemanticColors._();

  // Success colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  // Warning colors
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  // Error colors
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  // Info colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Neutral colors
  static const Color neutral = Color(0xFF9E9E9E);
  static const Color neutralLight = Color(0xFFE0E0E0);
  static const Color neutralDark = Color(0xFF616161);

  /// Gets the semantic color for a given status.
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'active':
        return success;
      case 'warning':
      case 'pending':
      case 'processing':
        return warning;
      case 'error':
      case 'failed':
      case 'cancelled':
        return error;
      case 'info':
      case 'new':
        return info;
      default:
        return neutral;
    }
  }
}

/// Custom app-specific colors that don't change with theme.
class ConstantColors {
  const ConstantColors._();

  // Brand colors
  static const Color brandPrimary = Color(0xFF6750A4);
  static const Color brandSecondary = Color(0xFF625B71);
  static const Color brandAccent = Color(0xFF7D5260);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6750A4), Color(0xFF9A82DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF625B71), Color(0xFF958DA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF7D5260), Color(0xFFB58392)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Social colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color apple = Color(0xFF000000);
  static const Color github = Color(0xFF333333);

  // Shimmer colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF424242);
  static const Color shimmerHighlightDark = Color(0xFF616161);
}
