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
  /// POST /auth/send-verification-code
  static const String sendVerificationCode = '/auth/send-verification-code';

  /// Verify phone endpoint
  /// POST /auth/verify-phone
  static const String verifyPhone = '/auth/verify-phone';

  /// User forget password endpoint
  /// POST /user/auth/forget_password
  static const String forgetPassword = '/user/auth/forget_password';

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
  /// POST /driver/auth/verify
  static const String driverVerifyPhone = '/driver/auth/verify';

  /// Driver forget password endpoint
  /// POST /driver/auth/forget_password
  static const String driverForgetPassword = '/driver/auth/forget_password';

  /// Driver reset password endpoint
  /// POST /driver/auth/reset_password
  static const String driverResetPassword = '/driver/auth/reset_password';

  // ==================== Profile Endpoints ====================

  /// Get user profile endpoint
  /// GET /profile
  static const String profile = '/profile';

  /// Get user profile detail endpoint
  /// GET /user/profile/detail
  static const String profileDetail = '/user/profile/detail';

  /// Update user profile info endpoint
  /// POST /user/profile/updateInfo
  static const String updateProfileInfo = '/user/profile/updateInfo';

  /// Get driver profile endpoint
  /// GET /driver/profile
  static const String driverProfile = '/driver/profile';

  /// Get driver profile detail endpoint
  /// GET /driver/profile/detail
  static const String driverProfileDetail = '/driver/profile/detail';

  /// Update driver profile info endpoint
  /// POST /driver/profile/updateInfo
  static const String updateDriverProfileInfo = '/driver/profile/updateInfo';
}
