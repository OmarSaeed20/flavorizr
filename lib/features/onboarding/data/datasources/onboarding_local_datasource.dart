// lib/features/onboarding/data/datasources/onboarding_local_datasource.dart
import 'package:flavorizr/features/onboarding/data/models/onboarding_page_model.dart';
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
        title: 'Welcome to Flavorizr',
        description:
            'Your all-in-one solution for building amazing Flutter apps with flavors and environment configurations.',
        imagePath: 'assets/images/onboarding/welcome.png',
      ),
      OnboardingPageModel(
        id: 'features',
        title: 'Powerful Features',
        description:
            'Multi-environment support, secure authentication, push notifications, and much more built right in.',
        imagePath: 'assets/images/onboarding/features.png',
      ),
      OnboardingPageModel(
        id: 'security',
        title: 'Secure & Reliable',
        description:
            'Built with security best practices including biometric authentication, encrypted storage, and secure API communication.',
        imagePath: 'assets/images/onboarding/security.png',
      ),
      OnboardingPageModel(
        id: 'ready',
        title: 'Ready to Start?',
        description: 'Create your account or sign in to get started on your journey.',
        imagePath: 'assets/images/onboarding/ready.png',
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
