/// Auth API Endpoints
/// Contains all authentication-related endpoint paths
/// Based on API_DOCUMENTATION.md
class AuthEndpoints {
  const AuthEndpoints._();

  // ==================== User Auth Endpoints ====================

  /// User login endpoint
  /// POST /auth/login
  static const String login = '/auth/login';

  /// User register endpoint
  /// POST /auth/register
  static const String register = '/auth/register';

  /// User logout endpoint
  /// POST /auth/logout
  static const String logout = '/auth/logout';

  /// Send verification code endpoint
  /// POST /auth/confirmation-code
  static const String sendVerificationCode = '/auth/confirmation-code';

  /// Verify phone endpoint
  /// POST /auth/user-verify
  static const String verifyPhone = '/auth/user-verify';

  /// User forget password endpoint
  /// POST /auth/forget-password
  static const String forgetPassword = '/auth/forget-password';

  /// User reset password endpoint
  /// POST /auth/reset-password
  static const String resetPassword = '/auth/reset-password';

  // ==================== Driver Auth Endpoints ====================

  /// Driver login endpoint
  /// POST /driver/auth/login
  static const String driverLogin = '/driver/auth/login';

  /// Driver register endpoint
  /// POST /driver/auth/register
  static const String driverRegister = '/driver/auth/register';

  /// Driver logout endpoint
  /// POST /driver/auth/logout
  static const String driverLogout = '/driver/auth/logout';

  /// Driver refresh token endpoint
  /// POST /driver/auth/refresh
  static const String driverRefreshToken = '/driver/auth/refresh';

  /// Driver verify phone endpoint
  /// POST /driver/auth/user-verify
  static const String driverVerifyPhone = '/driver/auth/user-verify';

  /// Driver forget password endpoint
  /// POST /driver/auth/forget-password
  static const String driverForgetPassword = '/driver/auth/forget-password';

  /// Driver reset password endpoint
  /// POST /driver/auth/reset-password
  static const String driverResetPassword = '/driver/auth/reset-password';

  // ==================== Profile Endpoints ====================

  /// Get user profile endpoint
  /// GET /user/profile
  static const String profile = '/user/profile';

  /// Get user profile detail endpoint
  /// GET /user/profile/detail
  static const String profileDetail = '/user/profile/detail';

  /// Update user profile info endpoint
  /// POST /user/profile/update-info
  static const String updateProfileInfo = '/user/profile/update-info';

  /// Get driver profile endpoint
  /// GET /driver/profile
  static const String driverProfile = '/driver/profile';

  /// Get driver profile detail endpoint
  /// GET /driver/profile/detail
  static const String driverProfileDetail = '/driver/profile/detail';

  /// Update driver profile info endpoint
  /// POST /driver/profile/update-info
  static const String updateDriverProfileInfo = '/driver/profile/update-info';

  // ==================== Token Refresh Endpoints ====================

  /// User refresh token endpoint
  /// POST /auth/refresh
  static const String refreshToken = '/auth/refresh';
}
