import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_profile/data/datasources/driver_profile_remote_datasource.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_document.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_profile.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_vehicle.dart';
import 'package:flavorizr/features/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Implementation of DriverProfileRepository.
///
/// Extends BaseRepository for consistent error handling and network checks.
class DriverProfileRepositoryImpl extends BaseRepository implements DriverProfileRepository {
  final DriverProfileRemoteDataSource _remoteDataSource;

  DriverProfileRepositoryImpl({
    required DriverProfileRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<DriverProfile>> getDriverProfile() async {
    final result = await executeRemoteRequest(request: _remoteDataSource.getDriverProfile);

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
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
  }) async {
    final data = {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (profileImage != null) 'profile_image': profileImage,
      if (bio != null) 'bio': bio,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
      if (gender != null) 'gender': gender,
    };

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateDriverProfile(data),
    );

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverVehicle>> getDriverVehicle() async {
    final result = await executeRemoteRequest(request: _remoteDataSource.getDriverVehicle);

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
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
  }) async {
    final data = {
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (color != null) 'color': color,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (capacity != null) 'capacity': capacity,
      if (vin != null) 'vin': vin,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (registrationExpiry != null) 'registration_expiry': registrationExpiry.toIso8601String(),
    };

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateDriverVehicle(data),
    );

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverDocument>> uploadDriverDocument({
    required String documentType,
    required String documentNumber,
    String? frontImageUrl,
    String? backImageUrl,
    DateTime? expiryDate,
  }) async {
    final data = {
      'document_type': documentType,
      'document_number': documentNumber,
      if (frontImageUrl != null) 'front_image_url': frontImageUrl,
      if (backImageUrl != null) 'back_image_url': backImageUrl,
      if (expiryDate != null) 'expiry_date': expiryDate.toIso8601String(),
    };

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.uploadDriverDocument(data),
    );

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<DriverDocument>>> getDriverDocuments() async {
    final result = await executeRemoteRequest(request: _remoteDataSource.getDriverDocuments);

    return result.when(
      success: (data) => ApiResult.success(data.map((e) => e.toEntity()).toList()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> deleteDriverDocument(String documentId) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.deleteDriverDocument(documentId),
    );

    return result.when(
      success: (data) => const ApiResult.success(null),
      exception: ApiResult.exception,
    );
  }
}
