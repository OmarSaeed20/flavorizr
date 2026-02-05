/// Authentication API Endpoints
/// Contains all authentication-related API endpoint paths
class AuthEndpoints {
  AuthEndpoints._();

  /// Login endpoint
  /// POST /api/user/auth/login
  static const String login = '/api/user/auth/login';

  /// Register endpoint
  /// POST /api/user/auth/register
  static const String register = '/api/user/auth/register';

  /// Logout endpoint
  /// POST /api/user/auth/logout
  static const String logout = '/api/user/auth/logout';

  /// Refresh token endpoint
  /// POST /api/user/auth/refresh
  static const String refreshToken = '/api/user/auth/refresh';

  /// User verify endpoint
  /// POST /api/user/auth/verify
  static const String verifyUser = '/api/user/auth/verify';

  /// Reset password endpoint
  /// POST /api/user/auth/reset-password
  static const String resetPassword = '/api/user/auth/reset-password';

  /// Forget password endpoint
  /// POST /api/user/auth/forget-password
  static const String forgetPassword = '/api/user/auth/forget-password';

  /// Confirmation code endpoint
  /// POST /api/user/auth/confirmation-code
  static const String confirmationCode = '/api/user/auth/confirmation-code';
}
