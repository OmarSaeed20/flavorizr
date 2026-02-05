import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_document.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_profile.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_vehicle.dart';

/// Repository interface for driver profile operations.
abstract class DriverProfileRepository {
  /// Gets driver profile summary.
  Future<ApiResult<DriverProfile>> getProfile();

  /// Gets driver profile details.
  Future<ApiResult<DriverProfile>> getProfileDetail();

  /// Updates driver profile information.
  Future<ApiResult<DriverProfile>> updateProfileInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    String? bio,
    String? address,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? gender,
  });

  /// Updates driver profile image.
  Future<ApiResult<DriverProfile>> updateProfileImage(String imagePath);

  /// Gets driver vehicle information.
  Future<ApiResult<DriverVehicle>> getVehicle();

  /// Updates driver vehicle information.
  Future<ApiResult<DriverVehicle>> updateVehicle({
    String? vehicleTypeId,
    String? vehiclePlateNumber,
    String? vehicleImage,
    String? vehicleLicenseImage,
  });

  /// Gets driver documents.
  Future<ApiResult<List<DriverDocument>>> getDocuments();

  /// Uploads driver document.
  Future<ApiResult<DriverDocument>> uploadDocument({
    required String documentType,
    required String documentImage,
  });

  /// Deletes driver document.
  Future<ApiResult<void>> deleteDocument(String documentId);

  /// Gets driver verification status.
  Future<ApiResult<Map<String, dynamic>>> getVerificationStatus();

  /// Submits driver verification documents.
  Future<ApiResult<void>> submitVerification({
    String? nationalId,
    String? nationalIdImage,
    String? drivingLicenseImage,
    String? vehicleLicenseImage,
    String? vehicleImage,
  });
}
