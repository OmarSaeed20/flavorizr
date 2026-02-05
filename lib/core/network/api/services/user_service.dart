/* import 'package:flavorizr/core/network/api/models/api_user_profile.dart';
import 'package:flavorizr/core/network/api/parameters/user_parameters.dart';
import 'package:flavorizr/core/network/api/repositories/user_repository.dart';
import 'package:flavorizr/core/network/api_response.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';

/// User Service
/// Business logic layer for user operations
class UserService {
  final UserRepository _repository;

  UserService({required UserRepository repository}) : _repository = repository;

  /// Get user profile
  /// Returns NetworkResult with ApiUserProfile on success
  Future<ApiResult<ApiResponse<ApiUserProfile>>> getProfile() async {
    final parameters = GetProfileParameters.builder();

    return _repository.getProfile(parameters);
  }

  /// Update user profile
  /// Returns NetworkResult with ApiUserProfile on success
  Future<ApiResult<ApiResponse<ApiUserProfile>>> updateProfile({
    String? name,
    String? nickname,
    String? email,
    String? avatar,
    String? country,
    String? governorate,
    String? birthdate,
    String? gender,
  }) async {
    final parameters = UpdateProfileParameters.builder()
        .withName(name)
        .withNickname(nickname)
        .withEmail(email)
        .withAvatar(avatar)
        .withCountry(country)
        .withGovernorate(governorate)
        .withBirthdate(birthdate)
        .withGender(gender)
        .build();

    return _repository.updateProfile(parameters);
  }

  /// Get user profile detail
  /// Returns NetworkResult with ApiUserProfile on success
  Future<ApiResult<ApiResponse<ApiUserProfile>>> getProfileDetail() async {
    final parameters = GetProfileParameters.builder().build();

    return _repository.getProfileDetail(parameters);
  }
}
 */
