// lib/features/onboarding/data/datasources/onboarding_local_datasource.dart
import 'package:fast_golden_taxi/features/onboarding/data/models/onboarding_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for onboarding operations.
abstract class OnboardingLocalDataSource {
  /// Gets the list of onboarding pages.
  List<OnboardingPageModel> getOnboardingPages();

  /// Checks if onboarding has been completed.
  Future<bool> isOnboardingCompleted();

  /// Marks onboarding as completed.
  Future<void> completeOnboarding();

  /// Resets onboarding status.
  Future<void> resetOnboarding();
}

/// Implementation of [OnboardingLocalDataSource].
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  const OnboardingLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _onboardingCompletedKey = 'onboarding_completed';

  @override
  List<OnboardingPageModel> getOnboardingPages() {
    // Return hardcoded onboarding pages
    // These can be loaded from remote config in production
    return const [
      OnboardingPageModel(
        id: 'welcome',
        title: 'Welcome to Fast Taxi',
        description:
            "Your go-to app for fast, reliable rides. Whether you're heading to work, the airport, or out for a night on the town, we've got you covered",
        imagePath: 'assets/images/onboarding/welcome.png',
      ),
      OnboardingPageModel(
        id: 'trip_booking',
        title: 'Seamless Trip Booking',
        description:
            'Plan and book your trips effortlessly. Choose your destination, select travel dates, and confirm your booking with just a few taps',
        imagePath: 'assets/images/onboarding/trip_booking.png',
      ),
      OnboardingPageModel(
        id: 'vehicle_rentals',
        title: 'Flexible Vehicle Rentals',
        description:
            'Rent the perfect vehicle for your needs. From Bikes to private cars, find and book a rental car that suits your trip and budget',
        imagePath: 'assets/images/onboarding/vehicle_rentals.png',
      ),
      OnboardingPageModel(
        id: 'advertisements',
        title: 'Add and View Advertisements',
        description:
            'Promote your services or browse for deals. Easily add your own advertisements or explore a range of ads to find what interests you',
        imagePath: 'assets/images/onboarding/advertisements.png',
      ),
    ];
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingCompletedKey, true);
  }

  @override
  Future<void> resetOnboarding() async {
    await _prefs.remove(_onboardingCompletedKey);
  }
}
