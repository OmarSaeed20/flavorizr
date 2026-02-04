// lib/features/driver_profile/data/endpoints/driver_profile_endpoints.dart
/// Defines all API endpoints for driver profile operations.
abstract class DriverProfileEndpoints {
  const DriverProfileEndpoints._();

  /// Gets driver profile.
  static const String profile = '/driver/profile';

  /// Updates driver profile.
  static const String updateProfile = '/driver/profile';

  /// Gets driver vehicle.
  static const String vehicle = '/driver/vehicle';

  /// Updates driver vehicle.
  static const String updateVehicle = '/driver/vehicle';

  /// Uploads driver document.
  static const String uploadDocument = '/driver/documents';

  /// Gets driver documents.
  static const String documents = '/driver/documents';

  /// Deletes a specific driver document.
  static String deleteDocument(String documentId) => '/driver/documents/$documentId';

  /// Gets driver document by ID.
  static String documentById(String documentId) => '/driver/documents/$documentId';

  /// Updates driver profile photo.
  static const String profilePhoto = '/driver/profile/photo';

  /// Updates driver license photo.
  static const String licensePhoto = '/driver/profile/license-photo';

  /// Gets driver verification status.
  static const String verificationStatus = '/driver/verification/status';

  /// Submits driver verification documents.
  static const String submitVerification = '/driver/verification/submit';
}
