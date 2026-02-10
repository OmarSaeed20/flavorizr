// lib/features/company/company_profile/data/datasources/company_profile_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/config/app_config.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/endpoints/company_profile_endpoints.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_image_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Company Profile Remote Data Source
///
/// Handles all company profile API calls.
/// Uses BaseRemoteDataSource mixin for consistent API call handling.
class CompanyProfileRemoteDataSource with BaseRemoteDataSource {
  @override
  final Dio dio;

  @override
  String get baseUrl => AppConfig.instance.apiBaseUrl;

  CompanyProfileRemoteDataSource({required this.dio});

  /// Get company profile
  ///
  /// Retrieves company profile information.
  Future<ApiResult<UserModel>> getProfile() async {
    return safeApiCall(
      () => dio.get(CompanyProfileEndpoints.profile),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Get company profile detail
  ///
  /// Retrieves detailed company profile information.
  Future<ApiResult<UserModel>> getProfileDetail() async {
    return safeApiCall(
      () => dio.get(CompanyProfileEndpoints.profileDetail),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Update company profile info
  ///
  /// Updates company profile information.
  Future<ApiResult<UserModel>> updateProfileInfo(
    UpdateCompanyProfileParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyProfileEndpoints.updateProfileInfo,
        data: parameters.toJson(),
        cancelToken: parameters.cancelToken,
      ),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Update company profile image
  ///
  /// Updates company profile image.
  Future<ApiResult<UserModel>> updateProfileImage(
    UpdateCompanyProfileImageParameters parameters,
  ) async {
    return safeApiCall(
      () => dio.post(
        CompanyProfileEndpoints.updateProfileImage,
        data: parameters.toFormData(),
        cancelToken: parameters.cancelToken,
      ),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Delete company profile image
  ///
  /// Deletes company profile image.
  Future<ApiResult<UserModel>> deleteProfileImage() async {
    return safeApiCall(
      () => dio.delete(CompanyProfileEndpoints.deleteProfileImage),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }
}
