// lib/core/router/routes.dart
/// Defines all route paths used in the application.
///
/// Using constants for route paths prevents typos and enables
/// easy refactoring. All paths should be defined here.
///
/// Naming convention:
/// - Use lowercase with hyphens for paths
/// - Use descriptive names that match the page purpose
abstract class Routes {
  Routes._();

  // ==================== Root Routes ====================

  /// Splash/loading screen shown during app initialization.
  static const String splash = '/';

  /// Main home screen after authentication.
  static const String home = '/home';

  /// Error page for generic errors.
  static const String error = '/error';

  /// 404 Not found page.
  static const String notFound = '/404';

  // ==================== Auth Routes ====================

  /// Login page.
  static const String login = '/auth/login';

  /// Registration page.
  static const String register = '/auth/register';

  /// Forgot password page.
  static const String forgotPassword = '/auth/forgot-password';

  /// Reset password page (with token).
  static const String resetPassword = '/auth/reset-password';

  /// Email verification page.
  static const String verifyEmail = '/auth/verify-email';

  /// Onboarding flow.
  static const String onboarding = '/onboarding';

  // ==================== Profile Routes ====================

  /// User profile page.
  static const String profile = '/profile';

  /// Edit profile page.
  static const String editProfile = '/profile/edit';

  /// Profile settings page.
  static const String profileSettings = '/profile/settings';

  // ==================== Settings Routes ====================

  /// Main settings page.
  static const String settings = '/settings';

  /// Notification settings.
  static const String notificationSettings = '/settings/notifications';

  /// Privacy settings.
  static const String privacySettings = '/settings/privacy';

  /// Security settings.
  static const String securitySettings = '/settings/security';

  /// Appearance/Theme settings.
  static const String appearanceSettings = '/settings/appearance';

  /// Language settings.
  static const String languageSettings = '/settings/language';

  /// About page.
  static const String about = '/settings/about';

  // ==================== Feature Routes ====================

  /// Search page.
  static const String search = '/search';

  /// Notifications list.
  static const String notifications = '/notifications';

  /// Help/Support page.
  static const String help = '/help';

  /// Feedback page.
  static const String feedback = '/feedback';

  // ==================== Deep Link Routes ====================

  /// Generic deep link handler.
  /// Pattern: /link/:type/:id
  static const String deepLink = '/link/:type/:id';

  /// Share link handler.
  /// Pattern: /share/:type/:id
  static const String share = '/share/:type/:id';

  // ==================== Helper Methods ====================

  /// Creates a profile route with user ID.
  static String userProfile(String userId) => '/user/$userId';

  /// Creates an item detail route.
  static String itemDetail(String itemId) => '/item/$itemId';

  /// Creates a deep link route.
  static String createDeepLink(String type, String id) => '/link/$type/$id';

  /// Creates a share link route.
  static String createShareLink(String type, String id) => '/share/$type/$id';

  /// Parses a route to extract parameters.
  static Map<String, String> parseRoute(String route) {
    final uri = Uri.parse(route);
    return {'path': uri.path, ...uri.queryParameters};
  }

  /// Checks if a route requires authentication.
  static bool requiresAuth(String route) {
    const publicRoutes = {
      splash,
      login,
      register,
      forgotPassword,
      resetPassword,
      onboarding,
      notFound,
    };
    return !publicRoutes.contains(route);
  }

  /// Gets a user-friendly name for a route.
  static String getRouteName(String route) => switch (route) {
    splash => 'Splash',
    home => 'Home',
    login => 'Login',
    register => 'Register',
    forgotPassword => 'Forgot Password',
    resetPassword => 'Reset Password',
    verifyEmail => 'Verify Email',
    onboarding => 'Onboarding',
    profile => 'Profile',
    editProfile => 'Edit Profile',
    settings => 'Settings',
    notificationSettings => 'Notification Settings',
    privacySettings => 'Privacy Settings',
    securitySettings => 'Security Settings',
    appearanceSettings => 'Appearance',
    languageSettings => 'Language',
    about => 'About',
    search => 'Search',
    notifications => 'Notifications',
    help => 'Help',
    feedback => 'Feedback',
    error => 'Error',
    notFound => 'Not Found',
    _ => route.split('/').last.replaceAll('-', ' ').toTitleCase(),
  };
}

/// Extension to convert string to title case.
extension StringExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) =>
              word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
