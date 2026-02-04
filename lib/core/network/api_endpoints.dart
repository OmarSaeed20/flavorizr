// lib/core/network/api_endpoints.dart
/// Defines all API endpoints used in the application.
///
/// Using constants for endpoints prevents typos and enables
/// easy maintenance. All endpoints should be defined here.
abstract class ApiEndpoints {
  const ApiEndpoints._();

  // ==================== Auth Endpoints ====================

  /// Sign in with email and password.
  static const String signIn = '/auth/login';

  /// Sign up with email and password.
  static const String signUp = '/auth/register';

  /// Sign in with Google OAuth.
  static const String googleSignIn = '/auth/google';

  /// Sign in with Apple OAuth.
  static const String appleSignIn = '/auth/apple';

  /// Verify OTP code.
  static const String verifyOtp = '/auth/otp/verify';

  /// Send OTP to phone.
  static const String sendOtp = '/auth/otp/send';

  /// Send magic link email.
  static const String sendMagicLink = '/auth/magic-link/send';

  /// Verify magic link token.
  static const String verifyMagicLink = '/auth/magic-link/verify';

  /// Send password reset email.
  static const String forgotPassword = '/auth/password/forgot';

  /// Reset password with token.
  static const String resetPassword = '/auth/password/reset';

  /// Change password (authenticated).
  static const String changePassword = '/auth/password/change';

  /// Refresh access token.
  static const String refreshToken = '/auth/token/refresh';

  /// Sign out (invalidate refresh token).
  static const String signOut = '/auth/logout';

  /// Sign out from all devices.
  static const String signOutAll = '/auth/logout/all';

  /// Resend email verification.
  static const String resendVerification = '/auth/email/resend';

  /// Verify email with token.
  static const String verifyEmail = '/auth/email/verify';

  // ==================== User Endpoints ====================

  /// Get current user profile.
  static const String me = '/users/me';

  /// Update current user profile.
  static const String updateProfile = '/users/me';

  /// Upload profile photo.
  static const String uploadPhoto = '/users/me/photo';

  /// Delete profile photo.
  static const String deletePhoto = '/users/me/photo';

  /// Get user by ID.
  static String user(String id) => '/users/$id';

  /// Search users.
  static const String searchUsers = '/users/search';

  // ==================== Feed Endpoints ====================

  /// Get feed posts.
  static const String feed = '/feed';

  /// Get a single post.
  static String post(String id) => '/posts/$id';

  /// Create a new post.
  static const String createPost = '/posts';

  /// Update a post.
  static String updatePost(String id) => '/posts/$id';

  /// Delete a post.
  static String deletePost(String id) => '/posts/$id';

  /// Get post reactions.
  static String postReactions(String postId) => '/posts/$postId/reactions';

  /// React to a post.
  static String reactToPost(String postId) => '/posts/$postId/reactions';

  /// Get post comments.
  static String postComments(String postId) => '/posts/$postId/comments';

  /// Comment on a post.
  static String commentOnPost(String postId) => '/posts/$postId/comments';

  // ==================== Notification Endpoints ====================

  /// Get notifications.
  static const String notifications = '/notifications';

  /// Mark notification as read.
  static String markNotificationRead(String id) => '/notifications/$id/read';

  /// Mark all notifications as read.
  static const String markAllNotificationsRead = '/notifications/read/all';

  /// Register device for push notifications.
  static const String registerDevice = '/devices';

  /// Unregister device.
  static String unregisterDevice(String deviceId) => '/devices/$deviceId';

  // ==================== Settings Endpoints ====================

  /// Get user settings.
  static const String settings = '/settings';

  /// Update user settings.
  static const String updateSettings = '/settings';

  // ==================== Analytics Endpoints ====================

  /// Track event.
  static const String trackEvent = '/analytics/events';

  /// Track page view.
  static const String trackPageView = '/analytics/pageviews';

  // ==================== Profile Endpoints ====================

  /// Get current user's profile.
  static const String currentProfile = '/profile/me';

  /// Get profile by user ID.
  static String profile(String userId) => '/profile/$userId';

  /// Get profile by username.
  static String profileByUsername(String username) =>
      '/profile/username/$username';

  /// Update/Delete profile photo.
  static const String profilePhoto = '/profile/me/photo';

  /// Update/Delete profile cover photo.
  static const String profileCoverPhoto = '/profile/me/cover';

  /// Get/Update profile preferences.
  static const String profilePreferences = '/profile/me/preferences';

  /// Follow a user.
  static String followUser(String userId) => '/profile/$userId/follow';

  /// Get followers of a user.
  static String followers(String userId) => '/profile/$userId/followers';

  /// Get following list of a user.
  static String following(String userId) => '/profile/$userId/following';

  /// Check if following a user.
  static String isFollowing(String userId) => '/profile/$userId/is-following';

  /// Delete user account.
  static const String deleteAccount = '/account';

  /// Export user data.
  static const String exportData = '/account/export';
}
