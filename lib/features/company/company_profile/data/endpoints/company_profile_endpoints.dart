// lib/features/company/company_profile/data/endpoints/company_profile_endpoints.dart
/// Company Profile API Endpoints
///
/// Company profile management endpoints.
/// Based on API_DOCUMENTATION.md
class CompanyProfileEndpoints {
  const CompanyProfileEndpoints._();

  /// Base URL for company profile API
  static const String baseUrl = 'https://api.fastgoldentaxi.com';

  /// Get company profile endpoint
  /// GET /user/profile
  static const String profile = '/user/profile';

  /// Get company profile detail endpoint
  /// GET /user/profile/detail
  static const String profileDetail = '/user/profile/detail';

  /// Update company profile info endpoint
  /// POST /user/profile/update-info
  static const String updateProfileInfo = '/user/profile/update-info';

  /// Update company profile image endpoint
  /// POST /user/profile/update-image
  static const String updateProfileImage = '/user/profile/update-image';

  /// Delete company profile image endpoint
  /// DELETE /user/profile/delete-image
  static const String deleteProfileImage = '/user/profile/delete-image';
}
