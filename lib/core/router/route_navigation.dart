import 'package:fast_golden_taxi/core/router/app_router.dart';
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/auth/otp/presentation/controllers/otp_controller.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centralized navigation helper for the entire application.
///
/// Provides static methods to navigate to every screen, grouping them by
/// feature area. Uses [AppRouter] internally so a valid [BuildContext] is
/// always available through the root navigator key.
///
/// Usage:
/// ```dart
/// RouteNavigation.navigateToLogin(UserRole.user);
/// RouteNavigation.navigateToConsumerHome();
/// RouteNavigation.goBack();
/// ```
class RouteNavigation {
  RouteNavigation._([this.context]);
  final BuildContext? context;
  static RouteNavigation? _instance;

  /// Gets the singleton instance (lazily resolved via the root navigator key).
  static RouteNavigation get instance {
    _instance ??= RouteNavigation._(
      AppRouter.instance.router.configuration.navigatorKey.currentContext,
    );
    return _instance!;
  }

  /// Shorthand for the current [BuildContext].
  static BuildContext? get _ctx => instance.context;

  /// Shorthand for the [AppRouter] singleton.
  static AppRouter get _router => AppRouter.instance;

  // ==================== Utility / Generic ====================

  /// Pop the current route (go back).
  static void goBack<T extends Object?>([T? result]) {
    if (_router.canPop()) {
      _router.pop(result);
    }
  }

  /// Whether we can pop the current route.
  static bool canGoBack() => _router.canPop();

  /// Navigate to a path, replacing the entire history.
  static void clearAndGo(String location, {Object? extra}) {
    _router.clearAndGo(location, extra: extra);
  }

  /// Navigate using a raw path.
  static void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  /// Push a raw path onto the navigation stack.
  static Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    return _router.push<T>(location, extra: extra);
  }

  /// Replace the current route with a new path (no back-stack entry).
  static void replace(String location, {Object? extra}) {
    _router.replace(location, extra: extra);
  }

  // ==================== Root / Global ====================

  /// Navigate to the splash screen.
  static void navigateToSplash() {
    _router.go(Routes.splash);
  }

  /// Navigate to the main home screen.
  static void navigateToHome() {
    _router.go(Routes.home);
  }

  /// Navigate to the error page.
  static void navigateToError({String? error}) {
    _router.go(Routes.error, extra: error);
  }

  /// Navigate to the 404 page.
  static void navigateToNotFound() {
    _router.go(Routes.notFound);
  }

  /// Navigate to the language selection screen.
  static void navigateToLanguageSelection() {
    _router.go(Routes.languageSelection);
  }

  /// Navigate to the onboarding flow.
  static void navigateToOnboarding() {
    _router.go(Routes.onboarding);
  }

  /// Navigate to the role selection screen.
  static void navigateToRoleSelection() {
    _ctx?.pushNamed(Routes.roleSelectionName);
  }

  /// Navigate to the select login/signup screen.
  static void navigateToSelectLoginSignup() {
    _ctx?.pushNamed(Routes.selectLoginSignupName);
  }

  // ==================== Auth (Role-aware) ====================

  /// Navigate to the login page for the given [role].
  static void navigateToLogin(String role) {
    final routeName = switch (UserRole.fromString(role) ?? UserRole.user) {
      UserRole.user => Routes.loginName,
      UserRole.driver => Routes.driverLoginName,
      UserRole.company => Routes.companyLoginName,
    };
    _ctx?.pushNamed(routeName, extra: role);
  }

  /// Navigate to the registration page for the given [role].
  static void navigateToRegister(String role) {
    final routeName = switch (UserRole.fromString(role) ?? UserRole.user) {
      UserRole.user => Routes.registerName,
      UserRole.driver => Routes.driverRegisterName,
      UserRole.company => Routes.companyRegisterName,
    };
    _ctx?.pushNamed(routeName, extra: role);
  }

  /// Navigate to the forgot-password page for the given [role].
  static void navigateToForgotPassword(String role) {
    final routeName = switch (UserRole.fromString(role) ?? UserRole.user) {
      UserRole.user => Routes.forgotPasswordName,
      UserRole.driver => Routes.driverForgotPasswordName,
      UserRole.company => Routes.companyForgotPasswordName,
    };
    _ctx?.pushNamed(routeName, extra: role);
  }

  /// Navigate to the reset-password page for the given [role].
  static void navigateToResetPassword(
    String role, {
    required String phone,
    required String otp,
    required OtpFlowContext flowContext,
  }) {
    final routeName = switch (UserRole.fromString(role) ?? UserRole.user) {
      UserRole.user => Routes.resetPasswordName,
      UserRole.driver => Routes.driverResetPasswordName,
      UserRole.company => Routes.companyResetPasswordName,
    };
    _ctx?.pushNamed(
      routeName,
      extra: {'phone': phone, 'role': role, 'flowContext': flowContext.value, 'otp': otp},
    );
  }

  /// Navigate to the verify-phone / OTP page for the given [role].
  static void navigateToVerifyPhone(
    String role, {
    required String phone,
    required OtpFlowContext flowContext,
  }) {
    final routeName = switch (UserRole.fromString(role) ?? UserRole.user) {
      UserRole.user => Routes.verifyPhoneName,
      UserRole.driver => Routes.driverVerifyPhoneName,
      UserRole.company => Routes.companyVerifyPhoneName,
    };
    _ctx?.pushNamed(
      routeName,
      extra: {'role': role, 'phone': phone, 'flowContext': flowContext.value},
    );
  }

  // ==================== Consumer – Home & Booking ====================

  /// Navigate to the consumer home page.
  static void navigateToConsumerHome() {
    _router.go(Routes.consumerHome);
  }

  /// Navigate to the location search page.
  static void navigateToLocationSearch() {
    _ctx?.pushNamed(Routes.locationSearchName);
  }

  /// Navigate to ride options / pricing.
  static void navigateToRideOptions({Object? extra}) {
    _ctx?.pushNamed(Routes.rideOptionsName, extra: extra);
  }

  /// Navigate to ride confirmation.
  static void navigateToRideConfirmation({Object? extra}) {
    _ctx?.pushNamed(Routes.rideConfirmationName, extra: extra);
  }

  /// Navigate to direct booking.
  static void navigateToDirectBooking() {
    _ctx?.pushNamed(Routes.directBookingName);
  }

  /// Navigate to the driver-tracking screen.
  static void navigateToDriverTracking({Object? extra}) {
    _ctx?.pushNamed(Routes.driverTrackingName, extra: extra);
  }

  /// Navigate to the trip-rating screen.
  static void navigateToTripRating({Object? extra}) {
    _ctx?.pushNamed(Routes.tripRatingName, extra: extra);
  }

  // ==================== Consumer – Trip Management ====================

  /// Navigate to the trip history page.
  static void navigateToTripHistory() {
    _ctx?.pushNamed(Routes.tripHistoryName);
  }

  /// Navigate to a specific trip detail.
  static void navigateToTripDetail(String tripId) {
    _ctx?.pushNamed(Routes.tripDetailName, pathParameters: {'id': tripId});
  }

  /// Navigate to the cancel-trip screen.
  static void navigateToCancelTrip(String tripId) {
    _ctx?.pushNamed(Routes.cancelTripName, pathParameters: {'id': tripId});
  }

  /// Navigate to the share-trip screen.
  static void navigateToShareTrip(String tripId) {
    _ctx?.pushNamed(Routes.shareTripName, pathParameters: {'id': tripId});
  }

  /// Navigate to the emergency-contact screen.
  static void navigateToEmergencyContact() {
    _ctx?.pushNamed(Routes.emergencyContactName);
  }

  // ==================== Consumer – Schedule Trip ====================

  /// Navigate to the schedule-trip page.
  static void navigateToScheduleTrip() {
    _ctx?.pushNamed(Routes.scheduleTripName);
  }

  /// Navigate to the list of scheduled trips.
  static void navigateToScheduledTrips() {
    _ctx?.pushNamed(Routes.scheduledTripsName);
  }

  // ==================== Consumer – Payment & Wallet ====================

  /// Navigate to payment methods.
  static void navigateToPaymentMethods() {
    _ctx?.pushNamed(Routes.paymentMethodsName);
  }

  /// Navigate to add-payment-method screen.
  static void navigateToAddPaymentMethod() {
    _ctx?.pushNamed(Routes.addPaymentMethodName);
  }

  /// Navigate to the wallet.
  static void navigateToWallet() {
    _ctx?.pushNamed(Routes.walletName);
  }

  /// Navigate to add-money screen.
  static void navigateToAddMoney() {
    _ctx?.pushNamed(Routes.addMoneyName);
  }

  /// Navigate to promo codes.
  static void navigateToPromocodes() {
    _ctx?.pushNamed(Routes.promocodesName);
  }

  /// Navigate to receipts.
  static void navigateToReceipts() {
    _ctx?.pushNamed(Routes.receiptsName);
  }

  /// Navigate to a specific receipt detail.
  static void navigateToReceiptDetail(String receiptId) {
    _ctx?.pushNamed(Routes.receiptDetailName, pathParameters: {'id': receiptId});
  }

  // ==================== Consumer – Saved Places ====================

  /// Navigate to saved places.
  static void navigateToSavedPlaces() {
    _ctx?.pushNamed(Routes.savedPlacesName);
  }

  /// Navigate to add-saved-place screen.
  static void navigateToAddSavedPlace() {
    _ctx?.pushNamed(Routes.addSavedPlaceName);
  }

  // ==================== Consumer – Profile & Settings ====================

  /// Navigate to the user profile page.
  static void navigateToProfile() {
    _ctx?.pushNamed(Routes.profileName);
  }

  /// Navigate to the edit-profile page.
  static void navigateToEditProfile() {
    _ctx?.pushNamed(Routes.editProfileName);
  }

  /// Navigate to profile settings.
  static void navigateToProfileSettings() {
    _ctx?.pushNamed(Routes.profileSettingsName);
  }

  /// Navigate to the account verification page.
  static void navigateToAccountVerification() {
    _ctx?.pushNamed(Routes.accountVerificationName);
  }

  /// Navigate to the referral program page.
  static void navigateToReferral() {
    _ctx?.pushNamed(Routes.referralName);
  }

  /// Navigate to ride preferences.
  static void navigateToRidePreferences() {
    _ctx?.pushNamed(Routes.ridePreferencesName);
  }

  // ==================== Consumer – Settings ====================

  /// Navigate to the main settings page.
  static void navigateToSettings() {
    _ctx?.pushNamed(Routes.settingsName);
  }

  /// Navigate to notification settings.
  static void navigateToNotificationSettings() {
    _ctx?.pushNamed(Routes.notificationSettingsName);
  }

  /// Navigate to privacy settings.
  static void navigateToPrivacySettings() {
    _ctx?.pushNamed(Routes.privacySettingsName);
  }

  /// Navigate to security settings.
  static void navigateToSecuritySettings() {
    _ctx?.pushNamed(Routes.securitySettingsName);
  }

  /// Navigate to appearance / theme settings.
  static void navigateToAppearanceSettings() {
    _ctx?.pushNamed(Routes.appearanceSettingsName);
  }

  /// Navigate to language settings.
  static void navigateToLanguageSettings() {
    _ctx?.pushNamed(Routes.languageSettingsName);
  }

  /// Navigate to the about page.
  static void navigateToAbout() {
    _ctx?.pushNamed(Routes.aboutName);
  }

  // ==================== Consumer – Support ====================

  /// Navigate to the help / support center.
  static void navigateToHelp() {
    _ctx?.pushNamed(Routes.helpName);
  }

  /// Navigate to the feedback page.
  static void navigateToFeedback() {
    _ctx?.pushNamed(Routes.feedbackName);
  }

  /// Navigate to the complaint submission page.
  static void navigateToComplaint() {
    _ctx?.pushNamed(Routes.complaintName);
  }

  // ==================== Consumer – Notifications & Chat ====================

  /// Navigate to the notifications list.
  static void navigateToNotifications() {
    _ctx?.pushNamed(Routes.notificationsName);
  }

  /// Navigate to the chat list.
  static void navigateToChatList() {
    _ctx?.pushNamed(Routes.chatListName);
  }

  /// Navigate to a conversation with a specific driver.
  static void navigateToChatWithDriver(String driverId, {String? title}) {
    _ctx?.pushNamed(
      Routes.chatWithDriverName,
      pathParameters: {'driverId': driverId},
      queryParameters: {if (title != null) 'title': title},
    );
  }

  // ==================== Driver – Auth ====================

  /// Navigate to driver login.
  static void navigateToDriverLogin() {
    _ctx?.pushNamed(Routes.driverLoginName);
  }

  /// Navigate to driver registration.
  static void navigateToDriverRegister() {
    _ctx?.pushNamed(Routes.driverRegisterName);
  }

  /// Navigate to driver forgot-password.
  static void navigateToDriverForgotPassword() {
    _ctx?.pushNamed(Routes.driverForgotPasswordName);
  }

  /// Navigate to driver reset-password.
  static void navigateToDriverResetPassword({Object? extra}) {
    _ctx?.pushNamed(Routes.driverResetPasswordName, extra: extra);
  }

  /// Navigate to driver verify-phone.
  static void navigateToDriverVerifyPhone({String? phone}) {
    _ctx?.pushNamed(Routes.driverVerifyPhoneName, extra: phone);
  }

  // ==================== Driver – Home & Dashboard ====================

  /// Navigate to the driver home / dashboard.
  static void navigateToDriverHome() {
    _router.go(Routes.driverHome);
  }

  /// Navigate to driver earnings.
  static void navigateToDriverEarnings() {
    _ctx?.pushNamed(Routes.driverEarningsName);
  }

  /// Navigate to weekly earnings.
  static void navigateToWeeklyEarnings() {
    _ctx?.pushNamed(Routes.weeklyEarningsName);
  }

  /// Navigate to daily earnings.
  static void navigateToDailyEarnings() {
    _ctx?.pushNamed(Routes.dailyEarningsName);
  }

  /// Navigate to performance stats.
  static void navigateToPerformanceStats() {
    _ctx?.pushNamed(Routes.performanceStatsName);
  }

  /// Navigate to the heat map.
  static void navigateToHeatMap() {
    _ctx?.pushNamed(Routes.heatMapName);
  }

  // ==================== Driver – Trip Management ====================

  /// Navigate to the driver trips list.
  static void navigateToDriverTrips() {
    _ctx?.pushNamed(Routes.driverTripsName);
  }

  /// Navigate to a specific trip request.
  static void navigateToTripRequest(String tripId) {
    _ctx?.pushNamed(Routes.tripRequestName, pathParameters: {'id': tripId});
  }

  /// Navigate to pickup navigation.
  static void navigateToPickup(String tripId) {
    _ctx?.pushNamed(Routes.navigateToPickupName, pathParameters: {'tripId': tripId});
  }

  /// Navigate to start-trip screen.
  static void navigateToStartTrip(String tripId) {
    _ctx?.pushNamed(Routes.startTripName, pathParameters: {'id': tripId});
  }

  /// Navigate to complete-trip screen.
  static void navigateToCompleteTrip(String tripId) {
    _ctx?.pushNamed(Routes.completeTripName, pathParameters: {'id': tripId});
  }

  /// Navigate to the trip summary.
  static void navigateToTripSummary(String tripId) {
    _ctx?.pushNamed(Routes.tripSummaryName, pathParameters: {'id': tripId});
  }

  // ==================== Driver – Profile & Documents ====================

  /// Navigate to the driver profile.
  static void navigateToDriverProfile() {
    _ctx?.pushNamed(Routes.driverProfileName);
  }

  /// Navigate to edit-driver-profile.
  static void navigateToEditDriverProfile() {
    _ctx?.pushNamed(Routes.editDriverProfileName);
  }

  /// Navigate to driver verification.
  static void navigateToDriverVerification() {
    _ctx?.pushNamed(Routes.driverVerificationName);
  }

  /// Navigate to upload documents.
  static void navigateToUploadDocuments() {
    _ctx?.pushNamed(Routes.uploadDocumentsName);
  }

  /// Navigate to vehicle registration.
  static void navigateToVehicleRegistration() {
    _ctx?.pushNamed(Routes.vehicleRegistrationName);
  }

  /// Navigate to insurance documents.
  static void navigateToInsuranceDocuments() {
    _ctx?.pushNamed(Routes.insuranceDocumentsName);
  }

  /// Navigate to license verification.
  static void navigateToLicenseVerification() {
    _ctx?.pushNamed(Routes.licenseVerificationName);
  }

  // ==================== Driver – Earnings & Payments ====================

  /// Navigate to the withdrawal / cash-out screen.
  static void navigateToWithdrawal() {
    _ctx?.pushNamed(Routes.withdrawalName);
  }

  /// Navigate to payment history.
  static void navigateToPaymentHistory() {
    _ctx?.pushNamed(Routes.paymentHistoryName);
  }

  /// Navigate to tax documents.
  static void navigateToTaxDocuments() {
    _ctx?.pushNamed(Routes.taxDocumentsName);
  }

  // ==================== Driver – Features ====================

  /// Navigate to driver reviews.
  static void navigateToDriverReviews({String? driverId}) {
    _ctx?.pushNamed(
      Routes.driverReviewsName,
      queryParameters: {if (driverId != null) 'driverId': driverId},
    );
  }

  /// Navigate to schedule management.
  static void navigateToScheduleManagement() {
    _ctx?.pushNamed(Routes.scheduleManagementName);
  }

  /// Navigate to preferred zones.
  static void navigateToPreferredZones() {
    _ctx?.pushNamed(Routes.preferredZonesName);
  }

  /// Navigate to driver training.
  static void navigateToDriverTraining() {
    _ctx?.pushNamed(Routes.driverTrainingName);
  }

  /// Navigate to driver support center.
  static void navigateToDriverSupport() {
    _ctx?.pushNamed(Routes.driverSupportName);
  }

  // ==================== Driver – Settings ====================

  /// Navigate to driver settings.
  static void navigateToDriverSettings() {
    _ctx?.pushNamed(Routes.driverSettingsName);
  }

  /// Navigate to driver notifications.
  static void navigateToDriverNotifications() {
    _ctx?.pushNamed(Routes.driverNotificationsName);
  }

  // ==================== Company – Auth ====================

  /// Navigate to company login.
  static void navigateToCompanyLogin() {
    _ctx?.pushNamed(Routes.companyLoginName);
  }

  /// Navigate to company registration.
  static void navigateToCompanyRegister() {
    _ctx?.pushNamed(Routes.companyRegisterName);
  }

  /// Navigate to company forgot-password.
  static void navigateToCompanyForgotPassword() {
    _ctx?.pushNamed(Routes.companyForgotPasswordName);
  }

  /// Navigate to company reset-password.
  static void navigateToCompanyResetPassword({Object? extra}) {
    _ctx?.pushNamed(Routes.companyResetPasswordName, extra: extra);
  }

  /// Navigate to company verify-phone.
  static void navigateToCompanyVerifyPhone({String? phone}) {
    _ctx?.pushNamed(Routes.companyVerifyPhoneName, extra: phone);
  }

  // ==================== Company – Dashboard ====================

  /// Navigate to the company dashboard.
  static void navigateToCompanyDashboard() {
    _router.go(Routes.companyDashboard);
  }

  /// Navigate to company analytics.
  static void navigateToCompanyAnalytics() {
    _ctx?.pushNamed(Routes.companyAnalyticsName);
  }

  /// Navigate to revenue reports.
  static void navigateToRevenueReports() {
    _ctx?.pushNamed(Routes.revenueReportsName);
  }

  // ==================== Company – Fleet Management ====================

  /// Navigate to fleet overview.
  static void navigateToFleetOverview() {
    _ctx?.pushNamed(Routes.fleetOverviewName);
  }

  /// Navigate to vehicle list.
  static void navigateToVehicleList() {
    _ctx?.pushNamed(Routes.vehicleListName);
  }

  /// Navigate to add-vehicle screen.
  static void navigateToAddVehicle() {
    _ctx?.pushNamed(Routes.addVehicleName);
  }

  /// Navigate to edit a vehicle.
  static void navigateToEditVehicle(String vehicleId) {
    _ctx?.pushNamed(Routes.editVehicleName, pathParameters: {'id': vehicleId});
  }

  /// Navigate to vehicle detail.
  static void navigateToVehicleDetail(String vehicleId) {
    _ctx?.pushNamed(Routes.vehicleDetailName, pathParameters: {'id': vehicleId});
  }

  /// Navigate to maintenance schedule.
  static void navigateToMaintenanceSchedule() {
    _ctx?.pushNamed(Routes.maintenanceScheduleName);
  }

  // ==================== Company – Driver Management ====================

  /// Navigate to company drivers list.
  static void navigateToCompanyDrivers() {
    _ctx?.pushNamed(Routes.companyDriversName);
  }

  /// Navigate to add-company-driver screen.
  static void navigateToAddCompanyDriver() {
    _ctx?.pushNamed(Routes.addCompanyDriverName);
  }

  /// Navigate to a company driver's detail.
  static void navigateToCompanyDriverDetail(String driverId) {
    _ctx?.pushNamed(Routes.companyDriverDetailName, pathParameters: {'id': driverId});
  }

  /// Navigate to a company driver's performance.
  static void navigateToCompanyDriverPerformance(String driverId) {
    _ctx?.pushNamed(Routes.companyDriverPerformanceName, pathParameters: {'id': driverId});
  }

  /// Navigate to a company driver's documents.
  static void navigateToCompanyDriverDocuments(String driverId) {
    _ctx?.pushNamed(Routes.companyDriverDocumentsName, pathParameters: {'id': driverId});
  }

  // ==================== Company – Trips & Earnings ====================

  /// Navigate to company trips.
  static void navigateToCompanyTrips() {
    _ctx?.pushNamed(Routes.companyTripsName);
  }

  /// Navigate to trip reports.
  static void navigateToTripReports() {
    _ctx?.pushNamed(Routes.tripReportsName);
  }

  /// Navigate to company earnings.
  static void navigateToCompanyEarnings() {
    _ctx?.pushNamed(Routes.companyEarningsName);
  }

  /// Navigate to commission settings.
  static void navigateToCommissionSettings() {
    _ctx?.pushNamed(Routes.commissionSettingsName);
  }

  /// Navigate to payment management.
  static void navigateToPaymentManagement() {
    _ctx?.pushNamed(Routes.paymentManagementName);
  }

  // ==================== Company – Settings ====================

  /// Navigate to company profile.
  static void navigateToCompanyProfile() {
    _ctx?.pushNamed(Routes.companyProfileName);
  }

  /// Navigate to edit company profile.
  static void navigateToCompanyEditProfile() {
    _ctx?.pushNamed('companyEditProfile');
  }

  /// Navigate to company settings.
  static void navigateToCompanySettings() {
    _ctx?.pushNamed(Routes.companySettingsName);
  }

  /// Navigate to company about page.
  static void navigateToCompanyAbout() {
    _ctx?.pushNamed('companyAbout');
  }

  /// Navigate to company FAQ page.
  static void navigateToCompanyFaq() {
    _ctx?.pushNamed('companyFaq');
  }

  /// Navigate to company privacy policy page.
  static void navigateToCompanyPrivacy() {
    _ctx?.pushNamed('companyPrivacy');
  }

  /// Navigate to company terms page.
  static void navigateToCompanyTerms() {
    _ctx?.pushNamed('companyTerms');
  }

  /// Navigate to business settings.
  static void navigateToBusinessSettings() {
    _ctx?.pushNamed(Routes.businessSettingsName);
  }

  /// Navigate to pricing settings.
  static void navigateToPricingSettings() {
    _ctx?.pushNamed(Routes.pricingSettingsName);
  }

  /// Navigate to zone management.
  static void navigateToZoneManagement() {
    _ctx?.pushNamed(Routes.zoneManagementName);
  }

  /// Navigate to admin users.
  static void navigateToAdminUsers() {
    _ctx?.pushNamed(Routes.adminUsersName);
  }

  // ==================== Shared / Legacy ====================

  /// Navigate to the legacy trip page.
  static void navigateToTrip() {
    _ctx?.pushNamed(Routes.tripName);
  }

  /// Navigate to the legacy trip orders page.
  static void navigateToTripOrders() {
    _ctx?.pushNamed(Routes.tripOrdersName);
  }

  /// Navigate to the search page.
  static void navigateToSearch() {
    _ctx?.pushNamed(Routes.searchName);
  }

  // ==================== Deep Links ====================

  /// Navigate via deep link.
  static void navigateToDeepLink(String type, String id) {
    _ctx?.pushNamed(Routes.deepLinkName, pathParameters: {'type': type, 'id': id});
  }

  /// Navigate via share link.
  static void navigateToShareLink(String type, String id) {
    _ctx?.pushNamed(Routes.shareName, pathParameters: {'type': type, 'id': id});
  }

  // ==================== Role-based Home ====================

  /// Navigate to the correct home screen based on [role], clearing history.
  static void navigateToRoleHome(String role) {
    final path = switch (UserRole.fromString(role) ?? UserRole.user) {
      UserRole.user => Routes.consumerHome,
      UserRole.driver => Routes.driverHome,
      UserRole.company => Routes.companyDashboard,
    };
    _router.clearAndGo(path);
  }

  /// After successful login, clear the stack and go to the role home.
  static void onLoginSuccess(String role) => navigateToRoleHome(role);

  /// After logout, clear the stack and return to the login/signup selector.
  static void onLogout() {
    _router.clearAndGo(Routes.selectLoginSignup);
  }
}
