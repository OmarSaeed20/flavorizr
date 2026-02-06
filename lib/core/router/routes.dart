// lib/core/router/routes.dart
/// Defines all route paths and names used in the application.
///
/// Using constants for route paths prevents typos and enables
/// easy refactoring. All paths should be defined here.
///
/// Naming convention:
/// - Use lowercase with hyphens for paths
/// - Use descriptive names that match the page purpose
/// - Names should be camelCase and match the route identifier
abstract class Routes {
  const Routes._();

  // ==================== Root Routes ====================

  /// Splash/loading screen shown during app initialization.
  static const String splash = '/';
  static const String splashName = 'splash';

  /// Main home screen after authentication.
  static const String home = '/home';
  static const String homeName = 'home';

  /// Error page for generic errors.
  static const String error = '/error';
  static const String errorName = 'error';

  /// 404 Not found page.
  static const String notFound = '/404';
  static const String notFoundName = 'notFound';

  // ==================== Auth Routes ====================

  /// Login page.
  static const String login = '/auth/login';
  static const String loginName = 'login';

  /// Registration page.
  static const String register = '/auth/register';
  static const String registerName = 'register';

  /// Forgot password page.
  static const String forgotPassword = '/auth/forgot-password';
  static const String forgotPasswordName = 'forgotPassword';

  /// Reset password page (with token).
  static const String resetPassword = '/auth/reset-password';
  static const String resetPasswordName = 'resetPassword';

  /// Email verification page.
  static const String verifyEmail = '/auth/verify-email';
  static const String verifyEmailName = 'verifyEmail';

  /// Onboarding flow.
  static const String onboarding = '/onboarding';
  static const String onboardingName = 'onboarding';

  // ==================== Profile Routes ====================

  /// User profile page.
  static const String profile = '/profile';
  static const String profileName = 'profile';

  /// Edit profile page (relative path for nested route).
  static const String editProfile = '/profile/edit';
  static const String editProfilePath = 'edit';
  static const String editProfileName = 'editProfile';

  /// Profile settings page (relative path for nested route).
  static const String profileSettings = '/profile/settings';
  static const String profileSettingsPath = 'settings';
  static const String profileSettingsName = 'profileSettings';

  // ==================== Settings Routes ====================

  /// Main settings page.
  static const String settings = '/settings';
  static const String settingsName = 'settings';

  /// Notification settings (relative path for nested route).
  static const String notificationSettings = '/settings/notifications';
  static const String notificationSettingsPath = 'notifications';
  static const String notificationSettingsName = 'notificationSettings';

  /// Privacy settings (relative path for nested route).
  static const String privacySettings = '/settings/privacy';
  static const String privacySettingsPath = 'privacy';
  static const String privacySettingsName = 'privacySettings';

  /// Security settings (relative path for nested route).
  static const String securitySettings = '/settings/security';
  static const String securitySettingsPath = 'security';
  static const String securitySettingsName = 'securitySettings';

  /// Appearance/Theme settings (relative path for nested route).
  static const String appearanceSettings = '/settings/appearance';
  static const String appearanceSettingsPath = 'appearance';
  static const String appearanceSettingsName = 'appearanceSettings';

  /// Language settings (relative path for nested route).
  static const String languageSettings = '/settings/language';
  static const String languageSettingsPath = 'language';
  static const String languageSettingsName = 'languageSettings';

  /// About page (relative path for nested route).
  static const String about = '/settings/about';
  static const String aboutPath = 'about';
  static const String aboutName = 'about';

  // ==================== Feature Routes ====================

  /// Search page.
  static const String search = '/search';
  static const String searchName = 'search';

  /// Notifications list.
  static const String notifications = '/notifications';
  static const String notificationsName = 'notifications';

  /// Help/Support page.
  static const String help = '/help';
  static const String helpName = 'help';

  /// Feedback page.
  static const String feedback = '/feedback';
  static const String feedbackName = 'feedback';

  // ==================== Trip Routes ====================

  /// Main trip booking page.
  static const String trip = '/trip';
  static const String tripName = 'trip';

  /// Trip history page.
  static const String tripHistory = '/trip/history';
  static const String tripHistoryName = 'tripHistory';

  /// Trip orders page.
  static const String tripOrders = '/trip/orders';
  static const String tripOrdersName = 'tripOrders';

  /// Trip detail page.
  static const String tripDetail = '/trip/detail';
  static const String tripDetailName = 'tripDetail';

  /// Trip booking page.
  static const String tripBooking = '/trip/booking';
  static const String tripBookingName = 'tripBooking';

  // ==================== Deep Link Routes ====================

  /// Generic deep link handler.
  /// Pattern: /link/:type/:id
  static const String deepLink = '/link/:type/:id';
  static const String deepLinkName = 'deepLink';

  /// Share link handler.
  /// Pattern: /share/:type/:id
  static const String share = '/share/:type/:id';
  static const String shareName = 'share';

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
    trip => 'Trip',
    tripHistory => 'Trip History',
    tripOrders => 'Trip Orders',
    tripDetail => 'Trip Detail',
    tripBooking => 'Trip Booking',
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
