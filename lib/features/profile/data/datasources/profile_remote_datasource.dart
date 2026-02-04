// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/api_endpoints.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/profile/data/models/profile_model.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/repositories/profile_repository.dart';

/// Remote data source for profile operations.
///
/// Handles all HTTP requests related to profile management.
/// Throws exceptions on errors which are caught by the repository.
abstract class ProfileRemoteDataSource {
  /// Gets the current user's profile.
  Future<ApiResult<ProfileModel>> getCurrentProfile();

  /// Gets a profile by user ID.
  Future<ApiResult<ProfileModel>> getProfileByUserId(String userId);

  /// Gets a profile by username.
  Future<ApiResult<ProfileModel>> getProfileByUsername(String username);

  /// Updates the current user's profile.
  Future<ApiResult<ProfileModel>> updateProfile(ProfileUpdateData data);

  /// Updates the profile photo.
  Future<ApiResult<ProfileModel>> updateProfilePhoto(String imagePath);

  /// Updates the cover photo.
  Future<ApiResult<ProfileModel>> updateCoverPhoto(String imagePath);

  /// Removes the profile photo.
  Future<ApiResult<ProfileModel>> removeProfilePhoto();

  /// Removes the cover photo.
  Future<ApiResult<ProfileModel>> removeCoverPhoto();

  /// Gets the current user's profile preferences.
  Future<ApiResult<ProfilePreferencesModel>> getPreferences();

  /// Updates the current user's profile preferences.
  Future<ApiResult<ProfilePreferencesModel>> updatePreferences(ProfilePreferences preferences);

  /// Follows a user.
  Future<ApiResult<void>> followUser(String userId);

  /// Unfollows a user.
  Future<ApiResult<void>> unfollowUser(String userId);

  /// Gets the list of followers for a user.
  Future<ApiResult<List<ProfileModel>>> getFollowers(String userId, {int page = 1, int limit = 20});

  /// Gets the list of users being followed.
  Future<ApiResult<List<ProfileModel>>> getFollowing(String userId, {int page = 1, int limit = 20});

  /// Checks if the current user is following another user.
  Future<ApiResult<bool>> isFollowing(String userId);

  /// Deletes the current user's account.
  Future<ApiResult<void>> deleteAccount(String password);

  /// Exports all user data.
  Future<ApiResult<String>> exportUserData();
}

/// Implementation of [ProfileRemoteDataSource] using BaseRemoteDataSource.
class ProfileRemoteDataSourceImpl with BaseRemoteDataSource implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<ProfileModel>> getCurrentProfile() async {
    return get<ProfileModel>(
      path: ApiEndpoints.currentProfile,
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> getProfileByUserId(String userId) async {
    return get<ProfileModel>(
      path: ApiEndpoints.profile(userId),
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> getProfileByUsername(String username) async {
    return get<ProfileModel>(
      path: ApiEndpoints.profileByUsername(username),
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> updateProfile(ProfileUpdateData data) async {
    return patch<ProfileModel>(
      path: ApiEndpoints.currentProfile,
      data: data.toJson(),
      decoder: (responseData) => ProfileModel.fromJson(responseData as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> updateProfilePhoto(String imagePath) async {
    final formData = createFormData(
      fields: {},
      files: [FileInfo(field: 'photo', path: imagePath)],
    );
    return upload<ProfileModel>(
      path: ApiEndpoints.profilePhoto,
      formData: formData,
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> updateCoverPhoto(String imagePath) async {
    final formData = createFormData(
      fields: {},
      files: [FileInfo(field: 'cover', path: imagePath)],
    );
    return upload<ProfileModel>(
      path: ApiEndpoints.profileCoverPhoto,
      formData: formData,
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> removeProfilePhoto() async {
    return delete<ProfileModel>(
      path: ApiEndpoints.profilePhoto,
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfileModel>> removeCoverPhoto() async {
    return delete<ProfileModel>(
      path: ApiEndpoints.profileCoverPhoto,
      decoder: (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfilePreferencesModel>> getPreferences() async {
    return get<ProfilePreferencesModel>(
      path: ApiEndpoints.profilePreferences,
      decoder: (data) => ProfilePreferencesModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<ProfilePreferencesModel>> updatePreferences(
    ProfilePreferences preferences,
  ) async {
    final prefsModel = ProfilePreferencesModel.fromEntity(preferences);
    return patch<ProfilePreferencesModel>(
      path: ApiEndpoints.profilePreferences,
      data: prefsModel.toJson(),
      decoder: (data) => ProfilePreferencesModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<void>> followUser(String userId) async {
    return post<void>(path: ApiEndpoints.followUser(userId));
  }

  @override
  Future<ApiResult<void>> unfollowUser(String userId) async {
    return delete<void>(path: ApiEndpoints.followUser(userId));
  }

  @override
  Future<ApiResult<List<ProfileModel>>> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    return get<List<ProfileModel>>(
      path: ApiEndpoints.followers(userId),
      queryParameters: {'page': page, 'limit': limit},
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['data'] as List? ?? jsonData['items'] as List? ?? [])
            .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<List<ProfileModel>>> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    return get<List<ProfileModel>>(
      path: ApiEndpoints.following(userId),
      queryParameters: {'page': page, 'limit': limit},
      decoder: (data) {
        final jsonData = data as Map<String, dynamic>;
        final items = (jsonData['data'] as List? ?? jsonData['items'] as List? ?? [])
            .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return items;
      },
    );
  }

  @override
  Future<ApiResult<bool>> isFollowing(String userId) async {
    return get<bool>(
      path: ApiEndpoints.isFollowing(userId),
      decoder: (data) => (data as Map<String, dynamic>)['following'] as bool? ?? false,
    );
  }

  @override
  Future<ApiResult<void>> deleteAccount(String password) async {
    return delete<void>(path: ApiEndpoints.deleteAccount, data: {'password': password});
  }

  @override
  Future<ApiResult<String>> exportUserData() async {
    return post<String>(
      path: ApiEndpoints.exportData,
      decoder: (data) => (data as Map<String, dynamic>)['downloadUrl'] as String? ?? '',
    );
  }
}
