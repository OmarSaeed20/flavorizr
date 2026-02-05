/// Defines all API endpoints for driver profile operations.
///
/// All endpoints are based on the FAST App API documentation.
/// Base URL: https://fasttaxi.questifysolutions.com/api/v1
abstract class DriverProfileEndpoints {
  const DriverProfileEndpoints._();

  /// Get driver profile.
  /// Endpoint: GET /driver/profile
  static const String getProfile = '/driver/profile';

  /// Get driver profile detail.
  /// Endpoint: GET /driver/profile/detail
  static const String getProfileDetail = '/driver/profile/detail';

  /// Update driver profile info.
  /// Endpoint: POST /driver/profile/update-info
  static const String updateProfileInfo = '/driver/profile/update-info';

  /// Update driver profile image.
  /// Endpoint: POST /driver/profile/update-image
  static const String updateProfileImage = '/driver/profile/update-image';

  /// Get driver vehicle information.
  /// Endpoint: GET /driver/vehicle
  static const String getVehicle = '/driver/vehicle';

  /// Update driver vehicle information.
  /// Endpoint: POST /driver/vehicle/update
  static const String updateVehicle = '/driver/vehicle/update';

  /// Get driver documents.
  /// Endpoint: GET /driver/documents
  static const String getDocuments = '/driver/documents';

  /// Upload driver document.
  /// Endpoint: POST /driver/documents/upload
  static const String uploadDocument = '/driver/documents/upload';

  /// Delete driver document.
  /// Endpoint: DELETE /driver/documents/{document_id}
  static String deleteDocument(String documentId) => '/driver/documents/$documentId';

  /// Get driver verification status.
  /// Endpoint: GET /driver/verification/status
  static const String getVerificationStatus = '/driver/verification/status';

  /// Submit driver verification documents.
  /// Endpoint: POST /driver/verification/submit
  static const String submitVerification = '/driver/verification/submit';
}
