/// Defines all API endpoints for driver authentication operations.
///
/// All endpoints are based on the FAST App API documentation.
/// Base URL: https://fasttaxi.questifysolutions.com/api/v1
abstract class DriverAuthEndpoints {
  const DriverAuthEndpoints._();

  /// Logs in a driver with phone and password.
  /// Endpoint: POST /driver/auth/login
  static const String login = '/driver/auth/login';

  /// Registers a new driver.
  /// Endpoint: POST /driver/auth/register
  static const String register = '/driver/auth/register';

  /// Verifies driver phone number with verification code.
  /// Endpoint: POST /driver/auth/user-verify
  static const String verifyPhone = '/driver/auth/user-verify';

  /// Requests password reset for driver.
  /// Endpoint: POST /driver/auth/forget-password
  static const String forgetPassword = '/driver/auth/forget-password';

  /// Resets driver password using verification code.
  /// Endpoint: POST /driver/auth/reset-password
  static const String resetPassword = '/driver/auth/reset-password';

  /// Logs out the current driver.
  /// Endpoint: POST /driver/auth/logout
  static const String logout = '/driver/auth/logout';

  /// Refreshes the driver authentication token.
  /// Endpoint: POST /driver/auth/refresh
  static const String refreshToken = '/driver/auth/refresh';
}
