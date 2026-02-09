// lib/core/router/widgets/main_shell.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main shell with bottom navigation.
///
/// This widget wraps the main app content with a bottom navigation bar
/// for switching between primary app sections.
///
/// Supports three user types:
/// - Consumer: Home, Trips, Wallet, Notifications, Profile
/// - Driver: Home, Trips, Earnings, Notifications, Profile
/// - Company: Dashboard, Fleet, Drivers, Analytics, Settings
class MainShell extends StatelessWidget {
  const MainShell({
    required this.currentRoute,
    required this.child,
    this.isDriver = false,
    this.isCompany = false,
    super.key,
  });

  final String currentRoute;
  final Widget child;
  final bool isDriver;
  final bool isCompany;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: child,
    bottomNavigationBar: NavigationBar(
      selectedIndex: _getSelectedIndex(),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: _getDestinations(),
    ),
  );

  List<NavigationDestination> _getDestinations() {
    if (isCompany) {
      return const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.directions_car_outlined),
          selectedIcon: Icon(Icons.directions_car),
          label: 'Fleet',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: 'Drivers',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    }

    if (isDriver) {
      return const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Trips',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: 'Earnings',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }

    // Consumer (default)
    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: 'Trips',
      ),
      NavigationDestination(
        icon: Icon(Icons.account_balance_wallet_outlined),
        selectedIcon: Icon(Icons.account_balance_wallet),
        label: 'Wallet',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  int _getSelectedIndex() {
    if (isCompany) {
      // Company navigation
      if (_isCompanyDashboard()) return 0;
      if (_isCompanyFleet()) return 1;
      if (_isCompanyDrivers()) return 2;
      if (_isCompanyAnalytics()) return 3;
      if (_isCompanySettings()) return 4;
      return 0;
    }

    if (isDriver) {
      // Driver navigation
      if (_isDriverHome()) return 0;
      if (_isDriverTrips()) return 1;
      if (_isDriverEarnings()) return 2;
      if (_isDriverNotifications()) return 3;
      if (_isDriverProfile()) return 4;
      return 0;
    }

    // Consumer navigation (default)
    if (_isConsumerHome()) return 0;
    if (_isConsumerTrips()) return 1;
    if (_isConsumerWallet()) return 2;
    if (_isConsumerNotifications()) return 3;
    if (_isConsumerProfile()) return 4;
    return 0;
  }

  // ==================== Company Route Checks ====================

  bool _isCompanyDashboard() => currentRoute == Routes.companyDashboard;

  bool _isCompanyFleet() =>
      currentRoute.startsWith('/company/fleet') ||
      currentRoute == Routes.fleetOverview ||
      currentRoute == Routes.vehicleList ||
      currentRoute == Routes.addVehicle ||
      currentRoute == Routes.maintenanceSchedule ||
      currentRoute.contains('/fleet/vehicles/');

  bool _isCompanyDrivers() =>
      currentRoute.startsWith('/company/drivers') ||
      currentRoute == Routes.companyDrivers ||
      currentRoute == Routes.addCompanyDriver;

  bool _isCompanyAnalytics() =>
      currentRoute == Routes.companyAnalytics ||
      currentRoute == Routes.revenueReports ||
      currentRoute == Routes.tripReports ||
      currentRoute == Routes.companyEarnings;

  bool _isCompanySettings() =>
      currentRoute == Routes.companySettings ||
      currentRoute == Routes.companyProfile ||
      currentRoute == Routes.zoneManagement ||
      currentRoute == Routes.businessSettings ||
      currentRoute == Routes.pricingSettings ||
      currentRoute == Routes.adminUsers;

  // ==================== Driver Route Checks ====================

  bool _isDriverHome() =>
      currentRoute == Routes.driverHome ||
      currentRoute == Routes.performanceStats ||
      currentRoute == Routes.heatMap;

  bool _isDriverTrips() =>
      currentRoute == Routes.driverTrips ||
      currentRoute.startsWith('/driver/trip-request/') ||
      currentRoute.startsWith('/driver/navigate/') ||
      currentRoute.contains('/driver/trip/') ||
      currentRoute == Routes.scheduleManagement;

  bool _isDriverEarnings() =>
      currentRoute == Routes.driverEarnings ||
      currentRoute == Routes.weeklyEarnings ||
      currentRoute == Routes.dailyEarnings ||
      currentRoute == Routes.withdrawal ||
      currentRoute == Routes.paymentHistory ||
      currentRoute == Routes.taxDocuments;

  bool _isDriverNotifications() => currentRoute == Routes.driverNotifications;

  bool _isDriverProfile() =>
      currentRoute == Routes.driverProfile ||
      currentRoute == Routes.editDriverProfile ||
      currentRoute == Routes.driverVerification ||
      currentRoute == Routes.uploadDocuments ||
      currentRoute == Routes.vehicleRegistration ||
      currentRoute == Routes.insuranceDocuments ||
      currentRoute == Routes.licenseVerification ||
      currentRoute == Routes.driverSettings ||
      currentRoute == Routes.driverReviews ||
      currentRoute == Routes.preferredZones ||
      currentRoute == Routes.driverTraining ||
      currentRoute == Routes.driverSupport;

  // ==================== Consumer Route Checks ====================

  bool _isConsumerHome() =>
      currentRoute == Routes.consumerHome ||
      currentRoute == Routes.locationSearch ||
      currentRoute == Routes.rideOptions ||
      currentRoute == Routes.rideConfirmation ||
      currentRoute == Routes.driverTracking ||
      currentRoute == Routes.tripRating ||
      currentRoute == Routes.emergencyContact;

  bool _isConsumerTrips() =>
      currentRoute == Routes.tripHistory ||
      currentRoute.startsWith('/consumer/trips/') ||
      currentRoute == Routes.scheduleTrip ||
      currentRoute == Routes.scheduledTrips;

  bool _isConsumerWallet() =>
      currentRoute == Routes.wallet ||
      currentRoute == Routes.addMoney ||
      currentRoute == Routes.paymentMethods ||
      currentRoute == Routes.addPaymentMethod ||
      currentRoute == Routes.promocodes ||
      currentRoute == Routes.receipts ||
      currentRoute.startsWith('/consumer/receipts/');

  bool _isConsumerNotifications() =>
      currentRoute == Routes.notifications ||
      currentRoute == Routes.chatList ||
      currentRoute.startsWith('/consumer/chat/');

  bool _isConsumerProfile() =>
      currentRoute == Routes.profile ||
      currentRoute == Routes.editProfile ||
      currentRoute == Routes.profileSettings ||
      currentRoute == Routes.accountVerification ||
      currentRoute == Routes.referral ||
      currentRoute == Routes.ridePreferences ||
      currentRoute == Routes.savedPlaces ||
      currentRoute == Routes.addSavedPlace ||
      currentRoute == Routes.settings ||
      currentRoute == Routes.notificationSettings ||
      currentRoute == Routes.privacySettings ||
      currentRoute == Routes.securitySettings ||
      currentRoute == Routes.appearanceSettings ||
      currentRoute == Routes.languageSettings ||
      currentRoute == Routes.about ||
      currentRoute == Routes.help ||
      currentRoute == Routes.feedback ||
      currentRoute == Routes.complaint;

  // ==================== Navigation Handler ====================

  void _onDestinationSelected(BuildContext context, int index) {
    final routes = _getRoutesForRole();

    if (index >= 0 && index < routes.length) {
      context.go(routes[index]);
    }
  }

  List<String> _getRoutesForRole() {
    if (isCompany) {
      return [
        Routes.companyDashboard,
        Routes.fleetOverview,
        Routes.companyDrivers,
        Routes.companyAnalytics,
        Routes.companySettings,
      ];
    }

    if (isDriver) {
      return [
        Routes.driverHome,
        Routes.driverTrips,
        Routes.driverEarnings,
        Routes.driverNotifications,
        Routes.driverProfile,
      ];
    }

    // Consumer (default)
    return [
      Routes.consumerHome,
      Routes.tripHistory,
      Routes.wallet,
      Routes.notifications,
      Routes.profile,
    ];
  }
}
