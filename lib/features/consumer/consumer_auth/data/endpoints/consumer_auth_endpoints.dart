// lib/features/consumer/consumer_auth/data/endpoints/consumer_auth_endpoints.dart
/// Consumer Authentication API Endpoints
///
/// Consumer authentication uses the same endpoints as user authentication
/// since consumers are regular users booking rides.
/// Based on API_DOCUMENTATION.md
class ConsumerAuthEndpoints {
  const ConsumerAuthEndpoints._();

  // ==================== Consumer Auth Endpoints ====================
  // Note: Consumers use the same auth endpoints as regular users

  /// Consumer login endpoint
  /// POST /auth/login
  static const String login = '/auth/login';

  /// Consumer register endpoint
  /// POST /auth/register
  static const String register = '/auth/register';

  /// Consumer logout endpoint
  /// POST /auth/logout
  static const String logout = '/auth/logout';

  /// Send verification code endpoint
  /// POST /auth/confirmation-code
  static const String sendVerificationCode = '/auth/confirmation-code';

  /// Verify phone endpoint
  /// POST /auth/user-verify
  static const String verifyPhone = '/auth/user-verify';

  /// Consumer forget password endpoint
  /// POST /auth/forget-password
  static const String forgetPassword = '/auth/forget-password';

  /// Consumer reset password endpoint
  /// POST /auth/reset-password
  static const String resetPassword = '/auth/reset-password';

  // ==================== Consumer Profile Endpoints ====================

  /// Get consumer profile endpoint
  /// GET /user/profile
  static const String profile = '/user/profile';

  /// Get consumer profile detail endpoint
  /// GET /user/profile/detail
  static const String profileDetail = '/user/profile/detail';

  /// Update consumer profile info endpoint
  /// POST /user/profile/update-info
  static const String updateProfileInfo = '/user/profile/update-info';

  // ==================== Token Refresh Endpoints ====================

  /// Consumer refresh token endpoint
  /// POST /auth/refresh
  static const String refreshToken = '/auth/refresh';
}
