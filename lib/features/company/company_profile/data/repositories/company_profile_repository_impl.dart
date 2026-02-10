// lib/features/company/company_profile/data/repositories/company_profile_repository_impl.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/datasources/company_profile_remote_datasource.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_image_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/repositories/company_profile_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Company Profile Repository Implementation
///
/// Implements company profile repository combining remote data source.
/// Handles error mapping and data transformation.
class CompanyProfileRepositoryImpl implements CompanyProfileRepository {
  final CompanyProfileRemoteDataSource _remoteDataSource;

  CompanyProfileRepositoryImpl({
    required CompanyProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<UserModel>> getProfile() async {
    return _remoteDataSource.getProfile();
  }

  @override
  Future<ApiResult<UserModel>> getProfileDetail() async {
    return _remoteDataSource.getProfileDetail();
  }

  @override
  Future<ApiResult<UserModel>> updateProfileInfo(
    UpdateCompanyProfileParameters parameters,
  ) async {
    return _remoteDataSource.updateProfileInfo(parameters);
  }

  @override
  Future<ApiResult<UserModel>> updateProfileImage(
    UpdateCompanyProfileImageParameters parameters,
  ) async {
    return _remoteDataSource.updateProfileImage(parameters);
  }

  @override
  Future<ApiResult<UserModel>> deleteProfileImage() async {
    return _remoteDataSource.deleteProfileImage();
  }
}
