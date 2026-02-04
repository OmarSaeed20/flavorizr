import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_profile/data/endpoints/driver_profile_endpoints.dart';
import 'package:flavorizr/features/driver_profile/data/models/driver_document_model.dart';
import 'package:flavorizr/features/driver_profile/data/models/driver_profile_model.dart';
import 'package:flavorizr/features/driver_profile/data/models/driver_vehicle_model.dart';
import 'package:flavorizr/features/driver_profile/data/parameters/update_driver_profile_parameters.dart';
import 'package:flavorizr/features/driver_profile/data/parameters/update_driver_vehicle_parameters.dart';
import 'package:flavorizr/features/driver_profile/data/parameters/upload_driver_document_parameters.dart';

/// Remote data source for driver profile operations.
///
/// Handles all HTTP requests related to driver profile management.
/// Returns ApiResult with success or error data.
abstract class DriverProfileRemoteDataSource {
  /// Gets driver profile.
  Future<ApiResult<DriverProfileModel>> getDriverProfile();

  /// Updates driver profile.
  Future<ApiResult<DriverProfileModel>> updateDriverProfile(
    UpdateDriverProfileParameters parameters,
  );

  /// Gets driver vehicle.
  Future<ApiResult<DriverVehicleModel>> getDriverVehicle();

  /// Updates driver vehicle.
  Future<ApiResult<DriverVehicleModel>> updateDriverVehicle(
    UpdateDriverVehicleParameters parameters,
  );

  /// Uploads driver document.
  Future<ApiResult<DriverDocumentModel>> uploadDriverDocument(
    UploadDriverDocumentParameters parameters,
  );

  /// Gets driver documents.
  Future<ApiResult<List<DriverDocumentModel>>> getDriverDocuments();

  /// Gets a specific driver document by ID.
  Future<ApiResult<DriverDocumentModel>> getDriverDocumentById(String documentId);

  /// Deletes driver document.
  Future<ApiResult<void>> deleteDriverDocument(String documentId);

  /// Updates driver profile photo.
  Future<ApiResult<DriverProfileModel>> updateProfilePhoto(String imagePath);

  /// Updates driver license photo.
  Future<ApiResult<DriverProfileModel>> updateLicensePhoto(String imagePath);

  /// Gets driver verification status.
  Future<ApiResult<Map<String, dynamic>>> getVerificationStatus();

  /// Submits driver verification documents.
  Future<ApiResult<void>> submitVerification(Map<String, dynamic> data);
}

/// Implementation of [DriverProfileRemoteDataSource] using BaseRemoteDataSource.
class DriverProfileRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DriverProfileRemoteDataSource {
  const DriverProfileRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<DriverProfileModel>> getDriverProfile() async {
    return get<DriverProfileModel>(
      path: DriverProfileEndpoints.profile,
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverProfileModel>> updateDriverProfile(
    UpdateDriverProfileParameters parameters,
  ) async {
    return put<DriverProfileModel>(
      path: DriverProfileEndpoints.updateProfile,
      data: parameters.toJson(),
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverVehicleModel>> getDriverVehicle() async {
    return get<DriverVehicleModel>(
      path: DriverProfileEndpoints.vehicle,
      decoder: (data) => DriverVehicleModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverVehicleModel>> updateDriverVehicle(
    UpdateDriverVehicleParameters parameters,
  ) async {
    return put<DriverVehicleModel>(
      path: DriverProfileEndpoints.updateVehicle,
      data: parameters.toJson(),
      decoder: (data) => DriverVehicleModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverDocumentModel>> uploadDriverDocument(
    UploadDriverDocumentParameters parameters,
  ) async {
    final formData = createFormData(fields: parameters.toJson(), files: parameters.files);
    return post<DriverDocumentModel>(
      path: DriverProfileEndpoints.uploadDocument,
      data: formData,
      decoder: (data) => DriverDocumentModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverDocumentModel>>> getDriverDocuments() async {
    return get<List<DriverDocumentModel>>(
      path: DriverProfileEndpoints.documents,
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['documents'] as List? ?? jsonData['data'] as List? ?? [])
            .map((e) => DriverDocumentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<DriverDocumentModel>> getDriverDocumentById(String documentId) async {
    return get<DriverDocumentModel>(
      path: DriverProfileEndpoints.documentById(documentId),
      decoder: (data) => DriverDocumentModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> deleteDriverDocument(String documentId) async {
    return delete<void>(path: DriverProfileEndpoints.deleteDocument(documentId));
  }

  @override
  Future<ApiResult<DriverProfileModel>> updateProfilePhoto(String imagePath) async {
    final formData = createFormData(
      fields: {},
      files: [FileInfo(field: 'photo', path: imagePath)],
    );
    return post<DriverProfileModel>(
      path: DriverProfileEndpoints.profilePhoto,
      data: formData,
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverProfileModel>> updateLicensePhoto(String imagePath) async {
    final formData = createFormData(
      fields: {},
      files: [FileInfo(field: 'license_photo', path: imagePath)],
    );
    return post<DriverProfileModel>(
      path: DriverProfileEndpoints.licensePhoto,
      data: formData,
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getVerificationStatus() async {
    return get<Map<String, dynamic>>(
      path: DriverProfileEndpoints.verificationStatus,
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<void>> submitVerification(Map<String, dynamic> data) async {
    return post<void>(path: DriverProfileEndpoints.submitVerification, data: data);
  }
}
