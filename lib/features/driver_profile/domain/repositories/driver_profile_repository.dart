import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_document.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_profile.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_vehicle.dart';

/// Repository interface for driver profile operations.
abstract class DriverProfileRepository {
  /// Gets driver profile.
  Future<ApiResult<DriverProfile>> getDriverProfile();

  /// Updates driver profile.
  Future<ApiResult<DriverProfile>> updateDriverProfile({
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

  /// Gets driver vehicle.
  Future<ApiResult<DriverVehicle>> getDriverVehicle();

  /// Updates driver vehicle.
  Future<ApiResult<DriverVehicle>> updateDriverVehicle({
    String? make,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    String? vehicleType,
    int? capacity,
    String? vin,
    String? registrationNumber,
    DateTime? registrationExpiry,
  });

  /// Uploads driver document.
  Future<ApiResult<DriverDocument>> uploadDriverDocument({
    required String documentType,
    required String documentNumber,
    String? frontImageUrl,
    String? backImageUrl,
    DateTime? expiryDate,
  });

  /// Gets driver documents.
  Future<ApiResult<List<DriverDocument>>> getDriverDocuments();

  /// Deletes driver document.
  Future<ApiResult<void>> deleteDriverDocument(String documentId);
}