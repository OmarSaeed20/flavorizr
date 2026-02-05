import 'package:flavorizr/core/network/api/models/api_user_profile.dart';
import 'package:flavorizr/core/network/api/parameters/user_parameters.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// User Repository Interface
/// Defines all user-related operations
abstract class UserRepository {
  /// Get user profile
  Future<ApiResult<ApiResponse<ApiUserProfile>>> getProfile(
    GetProfileParameters parameters,
  );

  /// Update user profile
  Future<ApiResult<ApiResponse<ApiUserProfile>>> updateProfile(
    UpdateProfileParameters parameters,
  );

  /// Get user profile detail
  Future<ApiResult<ApiResponse<ApiUserProfile>>> getProfileDetail(
    GetProfileParameters parameters,
  );
}
