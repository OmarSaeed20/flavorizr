// lib/features/company/company_auth/data/endpoints/company_auth_endpoints.dart
/// Company Authentication API Endpoints
///
/// Company authentication uses the same endpoints as user authentication
/// since companies register with company_type: "company".
/// Based on API_DOCUMENTATION.md
class CompanyAuthEndpoints {
  const CompanyAuthEndpoints._();

  /// Base URL for company authentication API
  static const String baseUrl = 'https://api.fastgoldentaxi.com';

  // ==================== Company Auth Endpoints ====================
  // Note: Companies use the same auth endpoints as regular users

  /// Company login endpoint
  /// POST /auth/login
  static const String login = '/auth/login';

  /// Company register endpoint
  /// POST /auth/register
  static const String register = '/auth/register';

  /// Company logout endpoint
  /// POST /auth/logout
  static const String logout = '/auth/logout';

  /// Send verification code endpoint
  /// POST /auth/confirmation-code
  static const String sendVerificationCode = '/auth/confirmation-code';

  /// Verify phone endpoint
  /// POST /auth/user-verify
  static const String verifyPhone = '/auth/user-verify';

  /// Company forget password endpoint
  /// POST /auth/forget-password
  static const String forgetPassword = '/auth/forget-password';

  /// Company reset password endpoint
  /// POST /auth/reset-password
  static const String resetPassword = '/auth/reset-password';

  // ==================== Company Profile Endpoints ====================

  /// Get company profile endpoint
  /// GET /user/profile
  static const String profile = '/user/profile';

  /// Get company profile detail endpoint
  /// GET /user/profile/detail
  static const String profileDetail = '/user/profile/detail';

  /// Update company profile info endpoint
  /// POST /user/profile/update-info
  static const String updateProfileInfo = '/user/profile/update-info';

  // ==================== Token Refresh Endpoints ====================

  /// Company refresh token endpoint
  /// POST /auth/refresh
  static const String refreshToken = '/auth/refresh';
}
