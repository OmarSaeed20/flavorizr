import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/datasources/driver_profile_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/datasources/driver_profile_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/models/driver_document_model.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/models/driver_profile_model.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/models/driver_vehicle_model.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/parameters/update_driver_profile_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/parameters/update_vehicle_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/parameters/upload_driver_document_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_document.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_profile.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_vehicle.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Implementation of DriverProfileRepository.
///
/// Extends BaseRepository for consistent error handling and network checks.
/// Provides offline capability with local caching.
class DriverProfileRepositoryImpl extends BaseRepository
    implements DriverProfileRepository {
  final DriverProfileRemoteDataSource _remoteDataSource;
  final DriverProfileLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  DriverProfileRepositoryImpl({
    required DriverProfileRemoteDataSource remoteDataSource,
    required DriverProfileLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<DriverProfile>> getProfile() async {
    final result = await fetchWithCache<DriverProfileModel>(
      cacheKey: 'driver_profile',
      remoteFetcher: _remoteDataSource.getProfile,
      localFetcher: _localDataSource.getCachedProfile,
      cacheSaver: _localDataSource.cacheProfile,
    );

    return result.when(
      success: (data, _) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverProfile>> getProfileDetail() async {
    final result = await fetchWithCache<DriverProfileModel>(
      cacheKey: 'driver_profile_detail',
      remoteFetcher: _remoteDataSource.getProfileDetail,
      localFetcher: _localDataSource.getCachedProfile,
      cacheSaver: _localDataSource.cacheProfile,
    );

    return result.when(
      success: (data, _) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
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
  }) async {
    final builder = UpdateDriverProfileParameters.builder();
    if (firstName != null) builder.withFirstName(firstName);
    if (lastName != null) builder.withLastName(lastName);
    if (email != null) builder.withEmail(email);
    if (phone != null) builder.withPhone(phone);
    if (profileImage != null) builder.withProfileImage(profileImage);
    if (bio != null) builder.withBio(bio);
    if (address != null) builder.withAddress(address);
    if (city != null) builder.withCity(city);
    if (country != null) builder.withCountry(country);
    if (dateOfBirth != null) builder.withDateOfBirth(dateOfBirth);
    if (gender != null) builder.withGender(gender);
    final parameters = builder.build();

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateProfileInfo(parameters),
    );

    return result.when(
      success: (data, _) async {
        await _localDataSource.cacheProfile(data);
        return ApiResult.success(data.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverProfile>> updateProfileImage(String imagePath) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateProfileImage(imagePath),
    );

    return result.when(
      success: (data, _) async {
        await _localDataSource.cacheProfile(data);
        return ApiResult.success(data.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverVehicle>> getVehicle() async {
    final result = await fetchWithCache<DriverVehicleModel>(
      cacheKey: 'driver_vehicle',
      remoteFetcher: _remoteDataSource.getVehicle,
      localFetcher: _localDataSource.getCachedVehicle,
      cacheSaver: _localDataSource.cacheVehicle,
    );

    return result.when(
      success: (data, _) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverVehicle>> updateVehicle({
    String? vehicleTypeId,
    String? vehiclePlateNumber,
    String? vehicleImage,
    String? vehicleLicenseImage,
  }) async {
    final builder = UpdateVehicleParameters.builder();
    if (vehicleTypeId != null) {
      builder.withVehicleTypeId(int.parse(vehicleTypeId));
    }
    if (vehiclePlateNumber != null) {
      builder.withVehiclePlateNumber(vehiclePlateNumber);
    }
    if (vehicleImage != null) builder.withVehicleImage(vehicleImage);
    if (vehicleLicenseImage != null) {
      builder.withVehicleLicenseImage(vehicleLicenseImage);
    }
    final parameters = builder.build();

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.updateVehicle(parameters),
    );

    return result.when(
      success: (data, _) async {
        await _localDataSource.cacheVehicle(data);
        return ApiResult.success(data.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<List<DriverDocument>>> getDocuments() async {
    final result = await fetchWithCache<List<DriverDocumentModel>>(
      cacheKey: 'driver_documents',
      remoteFetcher: _remoteDataSource.getDocuments,
      localFetcher: _localDataSource.getCachedDocuments,
      cacheSaver: _localDataSource.cacheDocuments,
    );

    return result.when(
      success: (data, _) =>
          ApiResult.success(data.map((e) => e.toEntity()).toList()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverDocument>> uploadDocument({
    required String documentType,
    required String documentImage,
  }) async {
    final parameters = UploadDriverDocumentParameters.builder()
        .withDocumentType(documentType)
        .withDocumentNumber(documentImage)
        .build();

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.uploadDocument(parameters),
    );

    return result.when(
      success: (data, _) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> deleteDocument(String documentId) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.deleteDocument(documentId),
    );

    return result.when(
      success: (data, _) => const ApiResult.success(null),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getVerificationStatus() async {
    final result = await fetchWithCache<Map<String, dynamic>>(
      cacheKey: 'driver_verification_status',
      remoteFetcher: _remoteDataSource.getVerificationStatus,
      localFetcher: _localDataSource.getCachedVerificationStatus,
      cacheSaver: _localDataSource.cacheVerificationStatus,
    );

    return result.when(
      success: (data, _) => ApiResult.success(data),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> submitVerification({
    String? nationalId,
    String? nationalIdImage,
    String? drivingLicenseImage,
    String? vehicleLicenseImage,
    String? vehicleImage,
  }) async {
    final data = {
      if (nationalId != null) 'national_id': nationalId,
      if (nationalIdImage != null) 'national_id_image': nationalIdImage,
      if (drivingLicenseImage != null)
        'driving_license_image': drivingLicenseImage,
      if (vehicleLicenseImage != null)
        'vehicle_license_image': vehicleLicenseImage,
      if (vehicleImage != null) 'vehicle_image': vehicleImage,
    };

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.submitVerification(data),
    );

    return result.when(
      success: (data, _) => const ApiResult.success(null),
      exception: ApiResult.exception,
    );
  }
}
