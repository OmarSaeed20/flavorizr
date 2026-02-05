// lib/features/driver_auth/data/endpoints/driver_auth_endpoints.dart
/// Defines all API endpoints for driver authentication operations.
abstract class DriverAuthEndpoints {
  const DriverAuthEndpoints._();

  /// Logs in a driver with phone and password.
  static const String login = '/driver/auth/login';

  /// Registers a new driver.
  static const String register = '/driver/auth/register';

  /// Logs out the current driver.
  static const String logout = '/driver/auth/logout';

  /// Verifies driver phone number with OTP.
  static const String verifyPhone = '/driver/auth/verify-phone';

  /// Resets driver password.
  static const String resetPassword = '/driver/auth/reset-password';

  /// Refreshes the access token.
  static const String refreshToken = '/driver/auth/refresh-token';

  /// Sends OTP to driver's phone.
  static const String sendOtp = '/driver/auth/send-otp';

  /// Verifies OTP code.
  static const String verifyOtp = '/driver/auth/verify-otp';

  /// Requests password reset.
  static const String forgotPassword = '/driver/auth/forgot-password';

  /// Changes password (authenticated).
  static const String changePassword = '/driver/auth/change-password';

  /// Sign out from all devices.
  static const String signOutAll = '/driver/auth/logout/all';
}
