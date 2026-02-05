import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_profile/data/endpoints/driver_profile_endpoints.dart';
import 'package:flavorizr/features/driver/driver_profile/data/models/driver_document_model.dart';
import 'package:flavorizr/features/driver/driver_profile/data/models/driver_profile_model.dart';
import 'package:flavorizr/features/driver/driver_profile/data/models/driver_vehicle_model.dart';
import 'package:flavorizr/features/driver/driver_profile/data/parameters/update_driver_profile_parameters.dart';
import 'package:flavorizr/features/driver/driver_profile/data/parameters/update_vehicle_parameters.dart';
import 'package:flavorizr/features/driver/driver_profile/data/parameters/upload_driver_document_parameters.dart';

/// Remote data source for driver profile operations.
///
/// Handles all HTTP requests related to driver profile management.
/// Returns ApiResult with success or error data.
abstract class DriverProfileRemoteDataSource {
  /// Gets driver profile summary.
  Future<ApiResult<DriverProfileModel>> getProfile();

  /// Gets driver profile details.
  Future<ApiResult<DriverProfileModel>> getProfileDetail();

  /// Updates driver profile information.
  Future<ApiResult<DriverProfileModel>> updateProfileInfo(UpdateDriverProfileParameters parameters);

  /// Updates driver profile image.
  Future<ApiResult<DriverProfileModel>> updateProfileImage(String imagePath);

  /// Gets driver vehicle information.
  Future<ApiResult<DriverVehicleModel>> getVehicle();

  /// Updates driver vehicle information.
  Future<ApiResult<DriverVehicleModel>> updateVehicle(UpdateVehicleParameters parameters);

  /// Gets driver documents.
  Future<ApiResult<List<DriverDocumentModel>>> getDocuments();

  /// Uploads driver document.
  Future<ApiResult<DriverDocumentModel>> uploadDocument(UploadDriverDocumentParameters parameters);

  /// Deletes driver document.
  Future<ApiResult<void>> deleteDocument(String documentId);

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
  Future<ApiResult<DriverProfileModel>> getProfile() async {
    return get<DriverProfileModel>(
      path: DriverProfileEndpoints.getProfile,
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverProfileModel>> getProfileDetail() async {
    return get<DriverProfileModel>(
      path: DriverProfileEndpoints.getProfileDetail,
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverProfileModel>> updateProfileInfo(
    UpdateDriverProfileParameters parameters,
  ) async {
    return post<DriverProfileModel>(
      path: DriverProfileEndpoints.updateProfileInfo,
      data: parameters.toJson(),
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverProfileModel>> updateProfileImage(String imagePath) async {
    final formData = createFormData(
      fields: {},
      files: [FileInfo(field: 'profile_image', path: imagePath)],
    );
    return post<DriverProfileModel>(
      path: DriverProfileEndpoints.updateProfileImage,
      data: formData,
      decoder: (data) => DriverProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverVehicleModel>> getVehicle() async {
    return get<DriverVehicleModel>(
      path: DriverProfileEndpoints.getVehicle,
      decoder: (data) => DriverVehicleModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<DriverVehicleModel>> updateVehicle(UpdateVehicleParameters parameters) async {
    return post<DriverVehicleModel>(
      path: DriverProfileEndpoints.updateVehicle,
      data: parameters.toJson(),
      decoder: (data) => DriverVehicleModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverDocumentModel>>> getDocuments() async {
    return get<List<DriverDocumentModel>>(
      path: DriverProfileEndpoints.getDocuments,
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
  Future<ApiResult<DriverDocumentModel>> uploadDocument(
    UploadDriverDocumentParameters parameters,
  ) async {
    final formData = createFormData(fields: parameters.toJson());
    return post<DriverDocumentModel>(
      path: DriverProfileEndpoints.uploadDocument,
      data: formData,
      decoder: (data) => DriverDocumentModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> deleteDocument(String documentId) async {
    return delete<void>(path: DriverProfileEndpoints.deleteDocument(documentId));
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getVerificationStatus() async {
    return get<Map<String, dynamic>>(
      path: DriverProfileEndpoints.getVerificationStatus,
      decoder: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResult<void>> submitVerification(Map<String, dynamic> data) async {
    return post<void>(path: DriverProfileEndpoints.submitVerification, data: data);
  }
}
