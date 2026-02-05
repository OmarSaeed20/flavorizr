/// General API Endpoints
/// Defines all general/settings-related API endpoint paths
class GeneralEndpoints {
  // Base path for general endpoints
  static const String _basePath = '/user/setting';

  /// Get about us information
  /// GET /user/setting/about_us
  static const String getAboutUs = '$_basePath/about_us';

  /// Get questions/FAQ
  /// GET /user/setting/questions
  static const String getQuestions = '$_basePath/questions';

  /// Get policies (terms and conditions, privacy policy)
  /// GET /user/setting/policies
  static const String getPolicies = '$_basePath/policies';

  /// Get general settings
  /// GET /user/setting/general
  static const String getGeneralSettings = '$_basePath/general';
}
