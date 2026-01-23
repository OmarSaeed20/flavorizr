// lib/services/analytics/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Abstract interface for analytics tracking.
///
/// This allows for multiple analytics providers and easy mocking in tests.
abstract class AnalyticsProvider {
  Future<void> logEvent({required String name, Map<String, Object?>? parameters});

  Future<void> setUserId(String? userId);
  Future<void> setUserProperty({required String name, required String? value});
  Future<void> logScreenView({required String screenName, String? screenClass});
}

/// Analytics service that wraps Firebase Analytics.
///
/// Provides a clean API for tracking user actions, screen views,
/// and custom events throughout the app.
///
/// Usage:
/// ```dart
/// final analytics = AnalyticsService.instance;
/// await analytics.logEvent('button_clicked', {'button_name': 'submit'});
/// ```
class AnalyticsService implements AnalyticsProvider {
  AnalyticsService._();

  static AnalyticsService? _instance;
  static AnalyticsService get instance => _instance ??= AnalyticsService._();

  /// The Firebase Analytics instance.
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Whether analytics is enabled.
  bool _isEnabled = true;

  /// Enables or disables analytics collection.
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Returns the FirebaseAnalyticsObserver for GoRouter.
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  // ==================== User Properties ====================

  @override
  Future<void> setUserId(String? userId) async {
    if (!_isEnabled) return;
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {
    if (!_isEnabled) return;
    await _analytics.setUserProperty(name: name, value: value);
  }

  /// Sets multiple user properties at once.
  Future<void> setUserProperties(Map<String, String?> properties) async {
    for (final entry in properties.entries) {
      await setUserProperty(name: entry.key, value: entry.value);
    }
  }

  // ==================== Screen Tracking ====================

  @override
  Future<void> logScreenView({required String screenName, String? screenClass}) async {
    if (!_isEnabled) return;
    await _analytics.logScreenView(screenName: screenName, screenClass: screenClass);
    if (kDebugMode) {
      debugPrint('📊 Screen: $screenName');
    }
  }

  // ==================== Event Tracking ====================

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) async {
    if (!_isEnabled) return;
    // Filter out null values for Firebase Analytics
    Map<String, Object>? cleanParams;
    if (parameters != null) {
      cleanParams = <String, Object>{};
      for (final entry in parameters.entries) {
        if (entry.value != null) {
          cleanParams[entry.key] = entry.value!;
        }
      }
    }
    await _analytics.logEvent(name: name, parameters: cleanParams);
    if (kDebugMode) {
      debugPrint('📊 Event: $name ${parameters ?? ''}');
    }
  }

  // ==================== Authentication Events ====================

  /// Logs a login event.
  Future<void> logLogin({required String method}) async {
    await logEvent(name: 'login', parameters: {'method': method});
  }

  /// Logs a sign up event.
  Future<void> logSignUp({required String method}) async {
    await logEvent(name: 'sign_up', parameters: {'method': method});
  }

  /// Logs a logout event.
  Future<void> logLogout() async {
    await logEvent(name: 'logout');
  }

  /// Logs a password reset request.
  Future<void> logPasswordReset() async {
    await logEvent(name: 'password_reset_requested');
  }

  // ==================== Content Events ====================

  /// Logs when a post is created.
  Future<void> logPostCreated({String? postId, bool hasImages = false, int tagsCount = 0}) async {
    await logEvent(
      name: 'post_created',
      parameters: {
        if (postId != null) 'post_id': postId,
        'has_images': hasImages,
        'tags_count': tagsCount,
      },
    );
  }

  /// Logs when a post is viewed.
  Future<void> logPostViewed({required String postId}) async {
    await logEvent(name: 'post_viewed', parameters: {'post_id': postId});
  }

  /// Logs when a reaction is added.
  Future<void> logReactionAdded({required String postId, required String reactionType}) async {
    await logEvent(
      name: 'reaction_added',
      parameters: {'post_id': postId, 'reaction_type': reactionType},
    );
  }

  /// Logs when content is shared.
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: itemId,
      method: method ?? 'unknown',
    );
  }

  // ==================== Search Events ====================

  /// Logs a search event.
  Future<void> logSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  // ==================== Navigation Events ====================

  /// Logs when a user views a profile.
  Future<void> logProfileViewed({required String profileId}) async {
    await logEvent(name: 'profile_viewed', parameters: {'profile_id': profileId});
  }

  /// Logs when a user follows another user.
  Future<void> logFollow({required String followedUserId}) async {
    await logEvent(name: 'follow', parameters: {'followed_user_id': followedUserId});
  }

  /// Logs when a user unfollows another user.
  Future<void> logUnfollow({required String unfollowedUserId}) async {
    await logEvent(name: 'unfollow', parameters: {'unfollowed_user_id': unfollowedUserId});
  }

  // ==================== Error Events ====================

  /// Logs an error event (non-fatal).
  Future<void> logError({
    required String errorType,
    String? errorMessage,
    String? screenName,
  }) async {
    await logEvent(
      name: 'error_occurred',
      parameters: {
        'error_type': errorType,
        if (errorMessage != null) 'error_message': errorMessage.take(100),
        if (screenName != null) 'screen_name': screenName,
      },
    );
  }

  // ==================== App Lifecycle Events ====================

  /// Logs app open event.
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  /// Logs when user accepts terms.
  Future<void> logTermsAccepted() async {
    await logEvent(name: 'terms_accepted');
  }

  /// Logs when user completes onboarding.
  Future<void> logOnboardingComplete() async {
    await logEvent(name: 'onboarding_complete');
  }

  // ==================== Performance Events ====================

  /// Logs a timing event for performance tracking.
  Future<void> logTiming({
    required String category,
    required String variable,
    required int timeMs,
    String? label,
  }) async {
    await logEvent(
      name: 'timing',
      parameters: {
        'category': category,
        'variable': variable,
        'time_ms': timeMs,
        if (label != null) 'label': label,
      },
    );
  }

  /// Logs API response time.
  Future<void> logApiResponseTime({
    required String endpoint,
    required int durationMs,
    required int statusCode,
  }) async {
    await logEvent(
      name: 'api_response',
      parameters: {'endpoint': endpoint, 'duration_ms': durationMs, 'status_code': statusCode},
    );
  }

  // ==================== Custom Dimensions ====================

  /// Sets the user's subscription tier.
  Future<void> setSubscriptionTier(String? tier) async {
    await setUserProperty(name: 'subscription_tier', value: tier);
  }

  /// Sets whether user has enabled notifications.
  Future<void> setNotificationsEnabled(bool enabled) async {
    await setUserProperty(name: 'notifications_enabled', value: enabled.toString());
  }

  /// Sets the user's preferred theme.
  Future<void> setThemePreference(String theme) async {
    await setUserProperty(name: 'theme_preference', value: theme);
  }
}

extension on String {
  /// Takes the first n characters of a string.
  String take(int n) => length <= n ? this : substring(0, n);
}
