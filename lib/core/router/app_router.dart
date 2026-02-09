// lib/core/router/app_router.dart
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/router/navigation_state.dart';
import 'package:flavorizr/core/router/role_based_guard.dart';
import 'package:flavorizr/core/router/route_guards.dart';
import 'package:flavorizr/core/router/router_observer.dart';
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/core/router/widgets/widgets.dart';
import 'package:flavorizr/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flavorizr/features/splash/presentation/pages/splash_page.dart';
import 'package:flavorizr/features/user/auth/presentation/pages/forgot_password_page.dart';
import 'package:flavorizr/features/user/auth/presentation/pages/login_page.dart';
import 'package:flavorizr/features/user/auth/presentation/pages/register_page.dart';
import 'package:flavorizr/features/user/auth/presentation/pages/reset_password_page.dart';
import 'package:flavorizr/features/user/auth/presentation/pages/verify_email_page.dart';
import 'package:flavorizr/features/user/profile/presentation/pages/edit_profile_page.dart';
import 'package:flavorizr/features/user/profile/presentation/pages/profile_page.dart';
import 'package:flavorizr/features/user/profile/presentation/pages/profile_settings_page.dart';
import 'package:flavorizr/features/user/settings/presentation/pages/appearance_settings_page.dart';
import 'package:flavorizr/features/user/settings/presentation/pages/language_settings_page.dart';
import 'package:flavorizr/features/user/settings/presentation/pages/notification_settings_page.dart';
import 'package:flavorizr/features/user/settings/presentation/pages/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import driver pages (when available)
// import 'package:flavorizr/features/driver/driver_auth/presentation/pages/driver_login_page.dart';
// import 'package:flavorizr/features/driver/driver_home/presentation/pages/driver_home_page.dart';
// ... etc

// ==================== Providers ====================

/// Provider for the GoRouter instance.
///
/// Usage:
/// ```dart
/// final router = ref.watch(routerProvider);
/// ```
final routerProvider = Provider<GoRouter>((ref) => AppRouter.instance.router);

// ==================== Navigator Keys ====================

/// Navigation key for accessing navigator without context.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Shell navigator key for consumer bottom navigation.
final consumerShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'consumerShell');

/// Shell navigator key for driver bottom navigation.
final driverShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'driverShell');

/// Shell navigator key for company navigation.
final companyShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'companyShell');

// ==================== App Router ====================

/// Creates and configures the app router.
///
/// The router is structured with:
/// - Global routes (splash, auth, error)
/// - Consumer routes (user booking rides)
/// - Driver routes (drivers providing services)
/// - Company routes (fleet management)
///
/// Example:
/// ```dart
/// await AppRouter.instance.initialize(
///   isAuthenticated: () => authService.isLoggedIn,
///   getUserRole: () => authService.getUserRole,
/// );
/// ```
class AppRouter {
  AppRouter._internal();

  static AppRouter? _instance;

  /// Singleton instance of the app router.
  static AppRouter get instance => _instance ??= AppRouter._internal();

  late GoRouter _router;
  final RouteGuardManager _guardManager = RouteGuardManager();
  final List<String> _routeHistory = [];
  NavigationState _navigationState = const NavigationState(currentRoute: '/');

  bool _isInitialized = false;

  /// The configured GoRouter instance.
  ///
  /// Throws [StateError] if accessed before initialization.
  GoRouter get router {
    if (!_isInitialized) {
      throw StateError('AppRouter not initialized. Call initialize() first.');
    }
    return _router;
  }

  /// Current navigation state.
  NavigationState get navigationState => _navigationState;

  /// Unmodifiable list of route history.
  List<String> get routeHistory => List.unmodifiable(_routeHistory);

  /// Whether the router has been initialized.
  bool get isInitialized => _isInitialized;

  // ==================== Initialization ====================

  /// Initializes the router with configuration.
  Future<void> initialize({
    Future<bool> Function()? isAuthenticated,
    Future<bool> Function()? isOnboardingCompleted,
    Future<String> Function()? getUserRole, // 'consumer', 'driver', 'company'
    String initialLocation = Routes.splash,
    List<RouteBase>? additionalRoutes,
  }) async {
    if (_isInitialized) return;

    if (isAuthenticated != null) {
      _guardManager.addGlobalGuard(AuthGuard(isAuthenticated: isAuthenticated));
    }

    if (isOnboardingCompleted != null) {
      _guardManager.addGlobalGuard(OnboardingGuard(isOnboardingCompleted: isOnboardingCompleted));
    }

    // Add role-based guard for consumer, driver, and company routes
    if (getUserRole != null) {
      _guardManager.addGlobalGuard(
        UserRoleGuard(
          getUserRole: () async {
            return getUserRole();
          },
        ),
      );
    }

    _router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: kDebugMode,
      observers: [RouterObserver(onRouteChange: _handleRouteChange)],
      redirect: _handleRedirect,
      routes: [
        ..._buildGlobalRoutes(),
        ..._buildAuthRoutes(),
        ..._buildConsumerRoutes(),
        ..._buildDriverRoutes(),
        ..._buildCompanyRoutes(),
        ...(additionalRoutes ?? []),
      ],
      onException: _handleException,
    );

    _isInitialized = true;
    AppLogger.instance.logInfo('AppRouter initialized');
  }

  // ==================== Route Handling ====================

  Future<String?> _handleRedirect(BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;

    // Don't redirect on error, notFound, or splash routes
    if (location == Routes.error || location == Routes.notFound || location == Routes.splash) {
      return null;
    }

    // Check global guards
    final redirectPath = await _guardManager.checkGuards(context, state);
    if (redirectPath != null) {
      AppLogger.instance.logInfo(
        'Route guard redirect',
        data: {'from': location, 'to': redirectPath},
      );
      return redirectPath;
    }

    return null;
  }

  void _handleRouteChange(String route, Map<String, dynamic>? params) {
    _routeHistory.add(route);

    if (_routeHistory.length > 50) {
      _routeHistory.removeAt(0);
    }

    _navigationState = _navigationState.copyWith(
      currentRoute: route,
      routeData: params ?? {},
      routeHistory: List.from(_routeHistory),
      canGoBack: _routeHistory.length > 1,
    );

    AppLogger.instance.logInfo('Route changed: $route', category: LogCategory.ui, data: params);
  }

  void _handleException(BuildContext context, GoRouterState state, GoRouter router) {
    AppLogger.instance.logError(
      'Router exception',
      category: LogCategory.ui,
      data: {'location': state.matchedLocation, 'error': state.error?.toString()},
    );
    router.go(Routes.error, extra: state.error?.toString());
  }

  // ==================== Global Routes ====================

  List<GoRoute> _buildGlobalRoutes() => [
    GoRoute(
      path: Routes.splash,
      name: Routes.splashName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.error,
      name: Routes.errorName,
      builder: (context, state) {
        final error = state.extra as String?;
        return ErrorScreen(error: error);
      },
    ),
    GoRoute(
      path: Routes.notFound,
      name: Routes.notFoundName,
      builder: (context, state) => const NotFoundScreen(),
    ),
  ];

  // ==================== Auth Routes ====================

  List<GoRoute> _buildAuthRoutes() => [
    GoRoute(
      path: Routes.login,
      name: Routes.loginName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.register,
      name: Routes.registerName,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      name: Routes.forgotPasswordName,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: Routes.resetPassword,
      name: Routes.resetPasswordName,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? state.extra as String?;
        return ResetPasswordPage(token: token);
      },
    ),
    GoRoute(
      path: Routes.verifyEmail,
      name: Routes.verifyEmailName,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? state.extra as String?;
        return VerifyEmailPage(token: token);
      },
    ),
    GoRoute(
      path: Routes.onboarding,
      name: Routes.onboardingName,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: Routes.roleSelection,
      name: Routes.roleSelectionName,
      builder: (context, state) => const PlaceholderScreen(
        title: 'Select Role',
        message: 'Choose Consumer, Driver, or Company',
      ),
    ),
  ];

  // ==================== Consumer Routes ====================

  List<RouteBase> _buildConsumerRoutes() => [
    ShellRoute(
      navigatorKey: consumerShellNavigatorKey,
      builder: (context, state, child) =>
          MainShell(currentRoute: state.matchedLocation, child: child),
      routes: [
        // Consumer Home & Booking
        GoRoute(
          path: Routes.consumerHome,
          name: Routes.consumerHomeName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Consumer Home', message: 'Map view and ride booking'),
        ),
        GoRoute(
          path: Routes.locationSearch,
          name: Routes.locationSearchName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Search Location', message: 'Search pickup/dropoff'),
        ),
        GoRoute(
          path: Routes.rideOptions,
          name: Routes.rideOptionsName,
          builder: (context, state) => const PlaceholderScreen(
            title: 'Ride Options',
            message: 'Select vehicle type and view pricing',
          ),
        ),
        GoRoute(
          path: Routes.rideConfirmation,
          name: Routes.rideConfirmationName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Confirm Ride', message: 'Confirm booking details'),
        ),
        GoRoute(
          path: Routes.driverTracking,
          name: Routes.driverTrackingName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Track Driver', message: 'Real-time driver tracking'),
        ),
        GoRoute(
          path: Routes.tripRating,
          name: Routes.tripRatingName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Rate Trip', message: 'Rate and review your trip'),
        ),

        // Consumer Trip Management
        GoRoute(
          path: Routes.tripHistory,
          name: Routes.tripHistoryName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Trip History', message: 'Your past trips'),
        ),
        GoRoute(
          path: Routes.tripDetail,
          name: Routes.tripDetailName,
          builder: (context, state) {
            final tripId = state.pathParameters['id'] ?? '';
            return PlaceholderScreen(title: 'Trip Detail', message: 'Details for trip: $tripId');
          },
        ),
        GoRoute(
          path: Routes.scheduleTrip,
          name: Routes.scheduleTripName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Schedule Trip', message: 'Schedule a future ride'),
        ),
        GoRoute(
          path: Routes.scheduledTrips,
          name: Routes.scheduledTripsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Scheduled Trips', message: 'Your scheduled rides'),
        ),

        // Consumer Payment & Wallet
        GoRoute(
          path: Routes.paymentMethods,
          name: Routes.paymentMethodsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Payment Methods', message: 'Manage payment methods'),
        ),
        GoRoute(
          path: Routes.wallet,
          name: Routes.walletName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Wallet', message: 'Your wallet balance'),
        ),
        GoRoute(
          path: Routes.promocodes,
          name: Routes.promocodesName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Promo Codes', message: 'Available promo codes'),
        ),
        GoRoute(
          path: Routes.receipts,
          name: Routes.receiptsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Receipts', message: 'Trip receipts'),
        ),

        // Consumer Saved Places
        GoRoute(
          path: Routes.savedPlaces,
          name: Routes.savedPlacesName,
          builder: (context, state) => const PlaceholderScreen(
            title: 'Saved Places',
            message: 'Home, Work, and favorite locations',
          ),
        ),

        // Consumer Profile & Settings
        GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          builder: (context, state) => const ProfilePage(),
          routes: [
            GoRoute(
              path: Routes.editProfilePath,
              name: Routes.editProfileName,
              builder: (context, state) => const EditProfilePage(),
            ),
            GoRoute(
              path: Routes.profileSettingsPath,
              name: Routes.profileSettingsName,
              builder: (context, state) => const ProfileSettingsPage(),
            ),
          ],
        ),
        GoRoute(
          path: Routes.accountVerification,
          name: Routes.accountVerificationName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Verification', message: 'Verify your account'),
        ),
        GoRoute(
          path: Routes.referral,
          name: Routes.referralName,
          builder: (context, state) => const PlaceholderScreen(
            title: 'Referral Program',
            message: 'Invite friends and earn',
          ),
        ),

        // Consumer Settings
        GoRoute(
          path: Routes.settings,
          name: Routes.settingsName,
          builder: (context, state) => const SettingsPage(),
          routes: [
            GoRoute(
              path: Routes.appearanceSettingsPath,
              name: Routes.appearanceSettingsName,
              builder: (context, state) => const AppearanceSettingsPage(),
            ),
            GoRoute(
              path: Routes.notificationSettingsPath,
              name: Routes.notificationSettingsName,
              builder: (context, state) => const NotificationSettingsPage(),
            ),
            GoRoute(
              path: Routes.privacySettingsPath,
              name: Routes.privacySettingsName,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Privacy', message: 'Privacy settings'),
            ),
            GoRoute(
              path: Routes.securitySettingsPath,
              name: Routes.securitySettingsName,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Security', message: 'Security settings'),
            ),
            GoRoute(
              path: Routes.languageSettingsPath,
              name: Routes.languageSettingsName,
              builder: (context, state) => const LanguageSettingsPage(),
            ),
            GoRoute(
              path: Routes.aboutPath,
              name: Routes.aboutName,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'About', message: 'About this app'),
            ),
          ],
        ),

        // Consumer Support
        GoRoute(
          path: Routes.help,
          name: Routes.helpName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Help Center', message: 'Help and support'),
        ),
        GoRoute(
          path: Routes.feedback,
          name: Routes.feedbackName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Feedback', message: 'Send us your feedback'),
        ),
        GoRoute(
          path: Routes.complaint,
          name: Routes.complaintName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Submit Complaint', message: 'File a complaint'),
        ),

        // Consumer Notifications & Chat
        GoRoute(
          path: Routes.notifications,
          name: Routes.notificationsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Notifications', message: 'Your notifications'),
        ),
        GoRoute(
          path: Routes.chatList,
          name: Routes.chatListName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Messages', message: 'Your conversations'),
        ),
      ],
    ),
  ];

  // ==================== Driver Routes ====================

  List<RouteBase> _buildDriverRoutes() => [
    // Driver Auth (outside shell)
    GoRoute(
      path: Routes.driverLogin,
      name: Routes.driverLoginName,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Driver Login', message: 'Driver login page'),
      // Replace with: const DriverLoginPage(),
    ),
    GoRoute(
      path: Routes.driverRegister,
      name: Routes.driverRegisterName,
      builder: (context, state) => const PlaceholderScreen(
        title: 'Driver Registration',
        message: 'Driver registration page',
      ),
      // Replace with: const DriverRegisterPage(),
    ),
    GoRoute(
      path: Routes.driverResetPassword,
      name: Routes.driverResetPasswordName,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Reset Password', message: 'Driver password reset'),
    ),

    // Driver Shell Routes
    ShellRoute(
      navigatorKey: driverShellNavigatorKey,
      builder: (context, state, child) =>
          MainShell(currentRoute: state.matchedLocation, isDriver: true, child: child),
      routes: [
        // Driver Home & Dashboard
        GoRoute(
          path: Routes.driverHome,
          name: Routes.driverHomeName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Driver Home', message: 'Driver dashboard'),
          // Replace with: const DriverHomePage(),
        ),
        GoRoute(
          path: Routes.driverEarnings,
          name: Routes.driverEarningsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Earnings', message: 'Your earnings dashboard'),
        ),
        GoRoute(
          path: Routes.performanceStats,
          name: Routes.performanceStatsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Performance', message: 'Your performance stats'),
        ),
        GoRoute(
          path: Routes.heatMap,
          name: Routes.heatMapName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Heat Map', message: 'High-demand areas'),
        ),

        // Driver Trips
        GoRoute(
          path: Routes.driverTrips,
          name: Routes.driverTripsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'My Trips', message: 'Your trip history'),
        ),
        GoRoute(
          path: Routes.tripRequest,
          name: Routes.tripRequestName,
          builder: (context, state) {
            final tripId = state.pathParameters['id'] ?? '';
            return PlaceholderScreen(title: 'Trip Request', message: 'Trip request: $tripId');
          },
        ),

        // Driver Profile
        GoRoute(
          path: Routes.driverProfile,
          name: Routes.driverProfileName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Driver Profile', message: 'Your profile'),
        ),
        GoRoute(
          path: Routes.driverVerification,
          name: Routes.driverVerificationName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Verification', message: 'Document verification'),
        ),
        GoRoute(
          path: Routes.vehicleRegistration,
          name: Routes.vehicleRegistrationName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Vehicle', message: 'Vehicle registration'),
        ),

        // Driver Earnings & Payments
        GoRoute(
          path: Routes.withdrawal,
          name: Routes.withdrawalName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Withdraw', message: 'Cash out earnings'),
        ),
        GoRoute(
          path: Routes.paymentHistory,
          name: Routes.paymentHistoryName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Payment History', message: 'Your payment history'),
        ),

        // Driver Features
        GoRoute(
          path: Routes.driverReviews,
          name: Routes.driverReviewsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Reviews', message: 'Your ratings and reviews'),
        ),
        GoRoute(
          path: Routes.scheduleManagement,
          name: Routes.scheduleManagementName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Schedule', message: 'Manage your schedule'),
        ),
        GoRoute(
          path: Routes.driverTraining,
          name: Routes.driverTrainingName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Training', message: 'Training materials'),
        ),

        // Driver Settings
        GoRoute(
          path: Routes.driverSettings,
          name: Routes.driverSettingsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Settings', message: 'Driver settings'),
        ),
        GoRoute(
          path: Routes.driverNotifications,
          name: Routes.driverNotificationsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Notifications', message: 'Your notifications'),
        ),
      ],
    ),
  ];

  // ==================== Company Routes ====================

  List<RouteBase> _buildCompanyRoutes() => [
    // Company Auth (outside shell)
    GoRoute(
      path: Routes.companyLogin,
      name: Routes.companyLoginName,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Company Login', message: 'Company login page'),
    ),
    GoRoute(
      path: Routes.companyRegister,
      name: Routes.companyRegisterName,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Company Registration', message: 'Register your company'),
    ),

    // Company Shell Routes
    ShellRoute(
      navigatorKey: companyShellNavigatorKey,
      builder: (context, state, child) =>
          MainShell(currentRoute: state.matchedLocation, isCompany: true, child: child),
      routes: [
        // Company Dashboard
        GoRoute(
          path: Routes.companyDashboard,
          name: Routes.companyDashboardName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Dashboard', message: 'Company dashboard'),
        ),
        GoRoute(
          path: Routes.companyAnalytics,
          name: Routes.companyAnalyticsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Analytics', message: 'Business analytics'),
        ),
        GoRoute(
          path: Routes.revenueReports,
          name: Routes.revenueReportsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Revenue Reports', message: 'Financial reports'),
        ),

        // Fleet Management
        GoRoute(
          path: Routes.fleetOverview,
          name: Routes.fleetOverviewName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Fleet Overview', message: 'Your fleet'),
        ),
        GoRoute(
          path: Routes.vehicleList,
          name: Routes.vehicleListName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Vehicles', message: 'All vehicles'),
        ),
        GoRoute(
          path: Routes.addVehicle,
          name: Routes.addVehicleName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Add Vehicle', message: 'Register new vehicle'),
        ),
        GoRoute(
          path: Routes.maintenanceSchedule,
          name: Routes.maintenanceScheduleName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Maintenance', message: 'Maintenance schedule'),
        ),

        // Driver Management
        GoRoute(
          path: Routes.companyDrivers,
          name: Routes.companyDriversName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Drivers', message: 'Manage drivers'),
        ),
        GoRoute(
          path: Routes.addCompanyDriver,
          name: Routes.addCompanyDriverName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Add Driver', message: 'Register new driver'),
        ),

        // Company Trips & Earnings
        GoRoute(
          path: Routes.companyTrips,
          name: Routes.companyTripsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Trips', message: 'All company trips'),
        ),
        GoRoute(
          path: Routes.tripReports,
          name: Routes.tripReportsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Trip Reports', message: 'Trip analytics'),
        ),
        GoRoute(
          path: Routes.companyEarnings,
          name: Routes.companyEarningsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Earnings', message: 'Company earnings'),
        ),
        GoRoute(
          path: Routes.commissionSettings,
          name: Routes.commissionSettingsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Commission', message: 'Commission settings'),
        ),

        // Company Settings
        GoRoute(
          path: Routes.companyProfile,
          name: Routes.companyProfileName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Company Profile', message: 'Company information'),
        ),
        GoRoute(
          path: Routes.companySettings,
          name: Routes.companySettingsName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Settings', message: 'Company settings'),
        ),
        GoRoute(
          path: Routes.zoneManagement,
          name: Routes.zoneManagementName,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Zones', message: 'Operating zones'),
        ),
      ],
    ),
  ];

  // ==================== Navigation Methods ====================

  void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  Future<T?> push<T extends Object?>(String location, {Object? extra}) =>
      _router.push<T>(location, extra: extra);

  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => _router.pushNamed<T>(
    name,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    extra: extra,
  );

  void replace<T extends Object?>(String location, {Object? extra}) {
    _router.replace<T>(location, extra: extra);
  }

  void replaceNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router.replaceNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void pop<T extends Object?>([T? result]) {
    _router.pop(result);
  }

  bool canPop() => _router.canPop();

  String get currentLocation => _router.routeInformationProvider.value.uri.toString();

  void refresh() {
    _router.refresh();
  }

  void clearAndGo(String location, {Object? extra}) {
    _routeHistory.clear();
    _router.go(location, extra: extra);
  }

  @visibleForTesting
  static void reset() {
    _instance?._isInitialized = false;
    _instance = null;
  }
}
