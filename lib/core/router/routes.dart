// lib/core/router/routes.dart
/// Defines all route paths and names used in the application.
///
/// This file contains routes for three user types:
/// 1. Consumer (regular users booking rides)
/// 2. Driver (drivers providing ride services)
/// 3. Company (fleet management and admin)
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

  /// Onboarding flow.
  static const String onboarding = '/onboarding';
  static const String onboardingName = 'onboarding';

  /// Language selection page (first-launch gate).
  static const String languageSelection = '/language-selection';
  static const String languageSelectionName = 'languageSelection';

  /// Shared OTP / phone verification page (used by all roles).
  static const String verifyPhone = '/auth/verify-phone';
  static const String verifyPhoneName = 'verifyPhone';

  /// Select Login or Signup page (A.5)
  static const String selectLoginSignup = '/auth/select-login-signup';
  static const String selectLoginSignupName = 'selectLoginSignup';

  /// Role selection page (Consumer/Driver/Company)
  static const String roleSelection = '/auth/role-selection';
  static const String roleSelectionName = 'roleSelection';

  // ==================== Consumer Routes ====================

  // Consumer Home & Booking
  /// Consumer home with map view
  static const String consumerHome = '/consumer/home';
  static const String consumerHomeName = 'consumerHome';

  /// Location search for pickup/dropoff
  static const String locationSearch = '/consumer/location-search';
  static const String locationSearchName = 'locationSearch';

  /// Ride options and pricing
  static const String rideOptions = '/consumer/ride-options';
  static const String rideOptionsName = 'rideOptions';

  /// Ride confirmation
  static const String rideConfirmation = '/consumer/ride-confirmation';
  static const String rideConfirmationName = 'rideConfirmation';

  /// Direct booking
  static const String directBooking = '/consumer/direct-booking';
  static const String directBookingName = 'directBooking';

  /// Driver tracking
  static const String driverTracking = '/consumer/tracking';
  static const String driverTrackingName = 'driverTracking';

  /// Trip rating
  static const String tripRating = '/consumer/trip-rating';
  static const String tripRatingName = 'tripRating';

  // Consumer Trip Management
  /// Trip history
  static const String tripHistory = '/consumer/trips/history';
  static const String tripHistoryName = 'tripHistory';

  /// Trip detail
  static const String tripDetail = '/consumer/trips/:id';
  static const String tripDetailName = 'tripDetail';

  /// Cancel trip
  static const String cancelTrip = '/consumer/trips/:id/cancel';
  static const String cancelTripName = 'cancelTrip';

  /// Share trip
  static const String shareTrip = '/consumer/trips/:id/share';
  static const String shareTripName = 'shareTrip';

  /// Emergency contact during trip
  static const String emergencyContact = '/consumer/emergency';
  static const String emergencyContactName = 'emergencyContact';

  // Consumer Schedule Trip
  /// Schedule a future trip
  static const String scheduleTrip = '/consumer/schedule-trip';
  static const String scheduleTripName = 'scheduleTrip';

  /// Scheduled trips list
  static const String scheduledTrips = '/consumer/scheduled-trips';
  static const String scheduledTripsName = 'scheduledTrips';

  // Consumer Payment & Wallet
  /// Payment methods
  static const String paymentMethods = '/consumer/payment-methods';
  static const String paymentMethodsName = 'paymentMethods';

  /// Add payment method
  static const String addPaymentMethod = '/consumer/payment-methods/add';
  static const String addPaymentMethodName = 'addPaymentMethod';

  /// Wallet
  static const String wallet = '/consumer/wallet';
  static const String walletName = 'wallet';

  /// Add money to wallet
  static const String addMoney = '/consumer/wallet/add';
  static const String addMoneyName = 'addMoney';

  /// Promocodes
  static const String promocodes = '/consumer/promocodes';
  static const String promocodesName = 'promocodes';

  /// Receipts
  static const String receipts = '/consumer/receipts';
  static const String receiptsName = 'receipts';

  /// Receipt detail
  static const String receiptDetail = '/consumer/receipts/:id';
  static const String receiptDetailName = 'receiptDetail';

  // Consumer Saved Places
  /// Saved places (home, work, etc.)
  static const String savedPlaces = '/consumer/saved-places';
  static const String savedPlacesName = 'savedPlaces';

  /// Add saved place
  static const String addSavedPlace = '/consumer/saved-places/add';
  static const String addSavedPlaceName = 'addSavedPlace';

  // Consumer Profile & Settings
  /// User profile
  static const String profile = '/consumer/profile';
  static const String profileName = 'profile';

  /// Edit profile
  static const String editProfile = '/consumer/profile/edit';
  static const String editProfilePath = 'edit';
  static const String editProfileName = 'editProfile';

  /// Profile settings
  static const String profileSettings = '/consumer/profile/settings';
  static const String profileSettingsPath = 'settings';
  static const String profileSettingsName = 'profileSettings';

  /// Account verification
  static const String accountVerification = '/consumer/verification';
  static const String accountVerificationName = 'accountVerification';

  /// Referral program
  static const String referral = '/consumer/referral';
  static const String referralName = 'referral';

  /// Ride preferences
  static const String ridePreferences = '/consumer/preferences';
  static const String ridePreferencesName = 'ridePreferences';

  // Consumer Settings
  /// Main settings page
  static const String settings = '/consumer/settings';
  static const String settingsName = 'settings';

  /// Notification settings
  static const String notificationSettings = '/consumer/settings/notifications';
  static const String notificationSettingsPath = 'notifications';
  static const String notificationSettingsName = 'notificationSettings';

  /// Privacy settings
  static const String privacySettings = '/consumer/settings/privacy';
  static const String privacySettingsPath = 'privacy';
  static const String privacySettingsName = 'privacySettings';

  /// Security settings
  static const String securitySettings = '/consumer/settings/security';
  static const String securitySettingsPath = 'security';
  static const String securitySettingsName = 'securitySettings';

  /// Appearance/Theme settings
  static const String appearanceSettings = '/consumer/settings/appearance';
  static const String appearanceSettingsPath = 'appearance';
  static const String appearanceSettingsName = 'appearanceSettings';

  /// Language settings
  static const String languageSettings = '/consumer/settings/language';
  static const String languageSettingsPath = 'language';
  static const String languageSettingsName = 'languageSettings';

  /// About page
  static const String about = '/consumer/settings/about';
  static const String aboutPath = 'about';
  static const String aboutName = 'about';

  // Consumer Support
  /// Help/Support page
  static const String help = '/consumer/help';
  static const String helpName = 'help';

  /// Feedback page
  static const String feedback = '/consumer/feedback';
  static const String feedbackName = 'feedback';

  /// Submit complaint
  static const String complaint = '/consumer/complaint';
  static const String complaintName = 'complaint';

  // Consumer Notifications & Chat
  /// Notifications list
  static const String notifications = '/consumer/notifications';
  static const String notificationsName = 'notifications';

  /// Chat list
  static const String chatList = '/consumer/chat';
  static const String chatListName = 'chatList';

  /// Chat with driver
  static const String chatWithDriver = '/consumer/chat/:driverId';
  static const String chatWithDriverName = 'chatWithDriver';

  // ==================== Driver Routes ====================

  // Driver Auth
  /// Driver login
  static const String driverLogin = '/driver/auth/login';
  static const String driverLoginName = 'driverLogin';

  /// Driver registration
  static const String driverRegister = '/driver/auth/register';
  static const String driverRegisterName = 'driverRegister';

  /// Driver forgot password
  static const String driverForgotPassword = '/driver/auth/forgot-password';
  static const String driverForgotPasswordName = 'driverForgotPassword';

  /// Driver reset password
  static const String driverResetPassword = '/driver/auth/reset-password';
  static const String driverResetPasswordName = 'driverResetPassword';

  /// Driver verify phone
  static const String driverVerifyPhone = '/driver/auth/verify-phone';
  static const String driverVerifyPhoneName = 'driverVerifyPhone';

  // Driver Home & Dashboard
  /// Driver home/dashboard
  static const String driverHome = '/driver/home';
  static const String driverHomeName = 'driverHome';

  /// Earnings dashboard
  static const String driverEarnings = '/driver/earnings';
  static const String driverEarningsName = 'driverEarnings';

  /// Weekly earnings
  static const String weeklyEarnings = '/driver/earnings/weekly';
  static const String weeklyEarningsName = 'weeklyEarnings';

  /// Daily earnings
  static const String dailyEarnings = '/driver/earnings/daily';
  static const String dailyEarningsName = 'dailyEarnings';

  /// Performance stats
  static const String performanceStats = '/driver/performance';
  static const String performanceStatsName = 'performanceStats';

  /// Heat map
  static const String heatMap = '/driver/heat-map';
  static const String heatMapName = 'heatMap';

  // Driver Trip Management
  /// Driver trips list
  static const String driverTrips = '/driver/trips';
  static const String driverTripsName = 'driverTrips';

  /// Trip request
  static const String tripRequest = '/driver/trip-request/:id';
  static const String tripRequestName = 'tripRequest';

  /// Navigate to pickup
  static const String navigateToPickup = '/driver/navigate/:tripId';
  static const String navigateToPickupName = 'navigateToPickup';

  /// Start trip
  static const String startTrip = '/driver/trip/:id/start';
  static const String startTripName = 'startTrip';

  /// Complete trip
  static const String completeTrip = '/driver/trip/:id/complete';
  static const String completeTripName = 'completeTrip';

  /// Trip summary
  static const String tripSummary = '/driver/trip/:id/summary';
  static const String tripSummaryName = 'tripSummary';

  // Driver Profile & Documents
  /// Driver profile
  static const String driverProfile = '/driver/profile';
  static const String driverProfileName = 'driverProfile';

  /// Edit driver profile
  static const String editDriverProfile = '/driver/profile/edit';
  static const String editDriverProfileName = 'editDriverProfile';

  /// Driver verification
  static const String driverVerification = '/driver/verification';
  static const String driverVerificationName = 'driverVerification';

  /// Upload documents
  static const String uploadDocuments = '/driver/documents/upload';
  static const String uploadDocumentsName = 'uploadDocuments';

  /// Vehicle registration
  static const String vehicleRegistration = '/driver/vehicle';
  static const String vehicleRegistrationName = 'vehicleRegistration';

  /// Insurance documents
  static const String insuranceDocuments = '/driver/insurance';
  static const String insuranceDocumentsName = 'insuranceDocuments';

  /// License verification
  static const String licenseVerification = '/driver/license';
  static const String licenseVerificationName = 'licenseVerification';

  // Driver Earnings & Payments
  /// Withdrawal/Cash out
  static const String withdrawal = '/driver/withdrawal';
  static const String withdrawalName = 'withdrawal';

  /// Payment history
  static const String paymentHistory = '/driver/payment-history';
  static const String paymentHistoryName = 'paymentHistory';

  /// Tax documents
  static const String taxDocuments = '/driver/tax-documents';
  static const String taxDocumentsName = 'taxDocuments';

  // Driver Features
  /// Driver reviews
  static const String driverReviews = '/driver/reviews';
  static const String driverReviewsName = 'driverReviews';

  /// Schedule management
  static const String scheduleManagement = '/driver/schedule';
  static const String scheduleManagementName = 'scheduleManagement';

  /// Preferred zones/areas
  static const String preferredZones = '/driver/zones';
  static const String preferredZonesName = 'preferredZones';

  /// Driver training
  static const String driverTraining = '/driver/training';
  static const String driverTrainingName = 'driverTraining';

  /// Driver support center
  static const String driverSupport = '/driver/support';
  static const String driverSupportName = 'driverSupport';

  // Driver Settings
  /// Driver settings
  static const String driverSettings = '/driver/settings';
  static const String driverSettingsName = 'driverSettings';

  /// Driver notifications
  static const String driverNotifications = '/driver/notifications';
  static const String driverNotificationsName = 'driverNotifications';

  // ==================== Company Routes ====================

  // Company Auth
  /// Company login
  static const String companyLogin = '/company/auth/login';
  static const String companyLoginName = 'companyLogin';

  /// Company registration
  static const String companyRegister = '/company/auth/register';
  static const String companyRegisterName = 'companyRegister';

  /// Company forgot password
  static const String companyForgotPassword = '/company/auth/forgot-password';
  static const String companyForgotPasswordName = 'companyForgotPassword';

  /// Company reset password
  static const String companyResetPassword = '/company/auth/reset-password';
  static const String companyResetPasswordName = 'companyResetPassword';

  // Company Dashboard
  /// Company main dashboard
  static const String companyDashboard = '/company/dashboard';
  static const String companyDashboardName = 'companyDashboard';

  /// Analytics
  static const String companyAnalytics = '/company/analytics';
  static const String companyAnalyticsName = 'companyAnalytics';

  /// Revenue reports
  static const String revenueReports = '/company/revenue';
  static const String revenueReportsName = 'revenueReports';

  // Fleet Management
  /// Fleet overview
  static const String fleetOverview = '/company/fleet';
  static const String fleetOverviewName = 'fleetOverview';

  /// Vehicle list
  static const String vehicleList = '/company/fleet/vehicles';
  static const String vehicleListName = 'vehicleList';

  /// Add vehicle
  static const String addVehicle = '/company/fleet/vehicles/add';
  static const String addVehicleName = 'addVehicle';

  /// Edit vehicle
  static const String editVehicle = '/company/fleet/vehicles/:id/edit';
  static const String editVehicleName = 'editVehicle';

  /// Vehicle detail
  static const String vehicleDetail = '/company/fleet/vehicles/:id';
  static const String vehicleDetailName = 'vehicleDetail';

  /// Maintenance schedule
  static const String maintenanceSchedule = '/company/fleet/maintenance';
  static const String maintenanceScheduleName = 'maintenanceSchedule';

  // Driver Management (Company)
  /// Company driver management
  static const String companyDrivers = '/company/drivers';
  static const String companyDriversName = 'companyDrivers';

  /// Add company driver
  static const String addCompanyDriver = '/company/drivers/add';
  static const String addCompanyDriverName = 'addCompanyDriver';

  /// Company driver detail
  static const String companyDriverDetail = '/company/drivers/:id';
  static const String companyDriverDetailName = 'companyDriverDetail';

  /// Company driver performance
  static const String companyDriverPerformance = '/company/drivers/:id/performance';
  static const String companyDriverPerformanceName = 'companyDriverPerformance';

  /// Company driver documents
  static const String companyDriverDocuments = '/company/drivers/:id/documents';
  static const String companyDriverDocumentsName = 'companyDriverDocuments';

  // Company Trips & Earnings
  /// Company trips
  static const String companyTrips = '/company/trips';
  static const String companyTripsName = 'companyTrips';

  /// Trip reports
  static const String tripReports = '/company/trips/reports';
  static const String tripReportsName = 'tripReports';

  /// Company earnings summary
  static const String companyEarnings = '/company/earnings';
  static const String companyEarningsName = 'companyEarnings';

  /// Commission settings
  static const String commissionSettings = '/company/commission';
  static const String commissionSettingsName = 'commissionSettings';

  /// Payment management
  static const String paymentManagement = '/company/payments';
  static const String paymentManagementName = 'paymentManagement';

  // Company Settings
  /// Company profile
  static const String companyProfile = '/company/profile';
  static const String companyProfileName = 'companyProfile';

  /// Business settings
  static const String businessSettings = '/company/settings/business';
  static const String businessSettingsName = 'businessSettings';

  /// Pricing settings
  static const String pricingSettings = '/company/settings/pricing';
  static const String pricingSettingsName = 'pricingSettings';

  /// Zone management
  static const String zoneManagement = '/company/zones';
  static const String zoneManagementName = 'zoneManagement';

  /// Admin users
  static const String adminUsers = '/company/admin-users';
  static const String adminUsersName = 'adminUsers';

  /// Company settings
  static const String companySettings = '/company/settings';
  static const String companySettingsName = 'companySettings';

  // ==================== Shared/General Routes ====================

  /// Search page
  static const String search = '/search';
  static const String searchName = 'search';

  /// Main trip booking page (legacy - kept for compatibility)
  static const String trip = '/trip';
  static const String tripName = 'trip';

  /// Trip orders page (legacy - kept for compatibility)
  static const String tripOrders = '/trip/orders';
  static const String tripOrdersName = 'tripOrders';

  /// Trip booking page (legacy - kept for compatibility)
  static const String tripBooking = '/trip/booking';
  static const String tripBookingName = 'tripBooking';

  // ==================== Deep Link Routes ====================

  /// Generic deep link handler
  /// Pattern: /link/:type/:id
  static const String deepLink = '/link/:type/:id';
  static const String deepLinkName = 'deepLink';

  /// Share link handler
  /// Pattern: /share/:type/:id
  static const String share = '/share/:type/:id';
  static const String shareName = 'share';

  // ==================== Helper Methods ====================

  /// Creates a profile route with user ID
  static String userProfile(String userId) => '/user/$userId';

  /// Creates an item detail route
  static String itemDetail(String itemId) => '/item/$itemId';

  /// Creates a deep link route
  static String createDeepLink(String type, String id) => '/link/$type/$id';

  /// Creates a share link route
  static String createShareLink(String type, String id) => '/share/$type/$id';

  /// Creates a trip detail route with ID
  static String tripDetailById(String tripId) => '/consumer/trips/$tripId';

  /// Creates a driver trip request route
  static String driverTripRequest(String tripId) => '/driver/trip-request/$tripId';

  /// Creates a company driver detail route
  static String companyDriverById(String driverId) => '/company/drivers/$driverId';

  /// Creates a vehicle detail route
  static String vehicleById(String vehicleId) => '/company/fleet/vehicles/$vehicleId';

  /// Parses a route to extract parameters
  static Map<String, String> parseRoute(String route) {
    final uri = Uri.parse(route);
    return {'path': uri.path, ...uri.queryParameters};
  }

  /// Checks if a route requires authentication
  static bool requiresAuth(String route) {
    const publicRoutes = {
      splash,
      login,
      register,
      forgotPassword,
      resetPassword,
      onboarding,
      notFound,
      roleSelection,
      languageSelection,
      verifyPhone,
      selectLoginSignup,
      driverLogin,
      driverRegister,
      driverForgotPassword,
      driverResetPassword,
      companyLogin,
      companyRegister,
      companyForgotPassword,
      companyResetPassword,
    };
    return !publicRoutes.contains(route);
  }

  /// Gets user role from route
  static String? getUserRoleFromRoute(String route) {
    if (route.startsWith('/driver/')) return 'driver';
    if (route.startsWith('/company/')) return 'company';
    if (route.startsWith('/consumer/')) return 'consumer';
    return null;
  }

  /// Checks if route is for consumer
  static bool isConsumerRoute(String route) => route.startsWith('/consumer/') || route == home;

  /// Checks if route is for driver
  static bool isDriverRoute(String route) => route.startsWith('/driver/');

  /// Checks if route is for company
  static bool isCompanyRoute(String route) => route.startsWith('/company/');

  /// Gets a user-friendly name for a route
  static String getRouteName(String route) => switch (route) {
    // Root routes
    splash => 'Splash',
    home => 'Home',
    error => 'Error',
    notFound => 'Not Found',
    roleSelection => 'Select Role',

    // Auth routes
    login => 'Login',
    register => 'Register',
    forgotPassword => 'Forgot Password',
    resetPassword => 'Reset Password',
    verifyPhone => 'Verify Phone',
    selectLoginSignup => 'Get Started',
    languageSelection => 'Language Selection',
    onboarding => 'Onboarding',

    // Consumer routes
    consumerHome => 'Home',
    locationSearch => 'Search Location',
    rideOptions => 'Ride Options',
    rideConfirmation => 'Confirm Ride',
    driverTracking => 'Track Driver',
    tripRating => 'Rate Trip',
    tripHistory => 'Trip History',
    scheduleTrip => 'Schedule Trip',
    scheduledTrips => 'Scheduled Trips',
    paymentMethods => 'Payment Methods',
    wallet => 'Wallet',
    promocodes => 'Promo Codes',
    savedPlaces => 'Saved Places',
    profile => 'Profile',
    editProfile => 'Edit Profile',
    settings => 'Settings',
    notificationSettings => 'Notifications',
    privacySettings => 'Privacy',
    securitySettings => 'Security',
    appearanceSettings => 'Appearance',
    languageSettings => 'Language',
    about => 'About',
    help => 'Help',
    feedback => 'Feedback',
    notifications => 'Notifications',
    chatList => 'Messages',

    // Driver routes
    driverLogin => 'Driver Login',
    driverRegister => 'Driver Registration',
    driverForgotPassword => 'Driver Forgot Password',
    driverResetPassword => 'Driver Reset Password',
    driverHome => 'Driver Home',
    driverEarnings => 'Earnings',
    weeklyEarnings => 'Weekly Earnings',
    dailyEarnings => 'Daily Earnings',
    performanceStats => 'Performance',
    driverTrips => 'My Trips',
    driverProfile => 'Profile',
    driverVerification => 'Verification',
    vehicleRegistration => 'Vehicle Registration',
    withdrawal => 'Withdraw',
    paymentHistory => 'Payment History',
    driverReviews => 'Reviews',
    scheduleManagement => 'Schedule',
    driverSettings => 'Settings',

    // Company routes
    companyLogin => 'Company Login',
    companyRegister => 'Company Registration',
    companyForgotPassword => 'Company Forgot Password',
    companyResetPassword => 'Company Reset Password',
    companyDashboard => 'Dashboard',
    companyAnalytics => 'Analytics',
    fleetOverview => 'Fleet',
    vehicleList => 'Vehicles',
    companyDrivers => 'Drivers',
    companyTrips => 'Trips',
    tripReports => 'Reports',
    companyEarnings => 'Earnings',
    companyProfile => 'Company Profile',
    zoneManagement => 'Zones',

    _ => route.split('/').last.replaceAll('-', ' ').toTitleCase(),
  };
}

/// Extension to convert string to title case
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
