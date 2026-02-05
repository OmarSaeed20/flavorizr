// lib/features/general_select/data/endpoints/general_select_endpoints.dart
/// Defines all API endpoints for general select operations.
///
/// Based on FAST App API Documentation - General Endpoints
abstract class GeneralSelectEndpoints {
  const GeneralSelectEndpoints._();

  // ==================== Select Options Endpoints ====================

  /// Gets select options based on type and filters.
  /// Endpoint: GET /select/options
  static const String selectOptions = '/select/options';

  /// Gets list of available vehicle types.
  /// Endpoint: GET /select/vehicle-type
  static const String vehicleTypes = '/select/vehicle-type';

  /// Gets list of cities.
  /// Endpoint: GET /select/cities
  static const String cities = '/select/cities';

  /// Gets list of common problems/issues.
  /// Endpoint: GET /select/common-problem
  static const String commonProblems = '/select/common-problem';

  /// Gets list of countries.
  /// Endpoint: GET /select/countries
  static const String countries = '/select/countries';

  // ==================== Settings Endpoints ====================

  /// Gets about us information.
  /// Endpoint: GET /setting/about_us
  static const String aboutUs = '/setting/about_us';

  /// Gets frequently asked questions.
  /// Endpoint: GET /setting/questions
  static const String questions = '/setting/questions';

  /// Gets app policies.
  /// Endpoint: GET /setting/policies
  static const String policies = '/setting/policies';

  /// Gets general app settings.
  /// Endpoint: GET /setting/general
  static const String general = '/setting/general';
}
