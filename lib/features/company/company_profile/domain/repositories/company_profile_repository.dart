// lib/features/company/company_profile/domain/repositories/company_profile_repository.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_image_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';

/// Company Profile Repository Interface
///
/// Defines contract for company profile operations.
/// Abstracts data sources and provides clean API for domain layer.
abstract class CompanyProfileRepository {
  /// Get company profile
  Future<ApiResult<UserModel>> getProfile();

  /// Get company profile detail
  Future<ApiResult<UserModel>> getProfileDetail();

  /// Update company profile info
  Future<ApiResult<UserModel>> updateProfileInfo(UpdateCompanyProfileParameters parameters);

  /// Update company profile image
  Future<ApiResult<UserModel>> updateProfileImage(UpdateCompanyProfileImageParameters parameters);

  /// Delete company profile image
  Future<ApiResult<UserModel>> deleteProfileImage();
}
