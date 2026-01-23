// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/api_endpoints.dart';
import 'package:flavorizr/features/profile/data/models/profile_model.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/repositories/profile_repository.dart';

/// Remote data source for profile operations.
///
/// Handles all HTTP requests related to profile management.
/// Throws exceptions on errors which are caught by the repository.
abstract class ProfileRemoteDataSource {
  /// Gets the current user's profile.
  Future<ProfileModel> getCurrentProfile();

  /// Gets a profile by user ID.
  Future<ProfileModel> getProfileByUserId(String userId);

  /// Gets a profile by username.
  Future<ProfileModel> getProfileByUsername(String username);

  /// Updates the current user's profile.
  Future<ProfileModel> updateProfile(ProfileUpdateData data);

  /// Updates the profile photo.
  Future<ProfileModel> updateProfilePhoto(String imagePath);

  /// Updates the cover photo.
  Future<ProfileModel> updateCoverPhoto(String imagePath);

  /// Removes the profile photo.
  Future<ProfileModel> removeProfilePhoto();

  /// Removes the cover photo.
  Future<ProfileModel> removeCoverPhoto();

  /// Gets the current user's profile preferences.
  Future<ProfilePreferencesModel> getPreferences();

  /// Updates the current user's profile preferences.
  Future<ProfilePreferencesModel> updatePreferences(ProfilePreferences preferences);

  /// Follows a user.
  Future<void> followUser(String userId);

  /// Unfollows a user.
  Future<void> unfollowUser(String userId);

  /// Gets the list of followers for a user.
  Future<List<ProfileModel>> getFollowers(String userId, {int page = 1, int limit = 20});

  /// Gets the list of users being followed.
  Future<List<ProfileModel>> getFollowing(String userId, {int page = 1, int limit = 20});

  /// Checks if the current user is following another user.
  Future<bool> isFollowing(String userId);

  /// Deletes the current user's account.
  Future<void> deleteAccount(String password);

  /// Exports all user data.
  Future<String> exportUserData();
}

/// Implementation of [ProfileRemoteDataSource] using ApiClient.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ProfileModel> getCurrentProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.currentProfile);
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfileModel> getProfileByUserId(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.profile(userId));
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfileModel> getProfileByUsername(String username) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.profileByUsername(username),
    );
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileUpdateData data) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      ApiEndpoints.currentProfile,
      data: data.toJson(),
    );
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfileModel> updateProfilePhoto(String imagePath) async {
    final response = await _apiClient.uploadFile<Map<String, dynamic>>(
      ApiEndpoints.profilePhoto,
      filePath: imagePath,
      fieldName: 'photo',
    );
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfileModel> updateCoverPhoto(String imagePath) async {
    final response = await _apiClient.uploadFile<Map<String, dynamic>>(
      ApiEndpoints.profileCoverPhoto,
      filePath: imagePath,
      fieldName: 'cover',
    );
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfileModel> removeProfilePhoto() async {
    final response = await _apiClient.delete<Map<String, dynamic>>(ApiEndpoints.profilePhoto);
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfileModel> removeCoverPhoto() async {
    final response = await _apiClient.delete<Map<String, dynamic>>(ApiEndpoints.profileCoverPhoto);
    return ProfileModel.fromJson(response.data!);
  }

  @override
  Future<ProfilePreferencesModel> getPreferences() async {
    final response = await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.profilePreferences);
    return ProfilePreferencesModel.fromJson(response.data!);
  }

  @override
  Future<ProfilePreferencesModel> updatePreferences(ProfilePreferences preferences) async {
    final prefsModel = ProfilePreferencesModel.fromEntity(preferences);
    final response = await _apiClient.patch<Map<String, dynamic>>(
      ApiEndpoints.profilePreferences,
      data: prefsModel.toJson(),
    );
    return ProfilePreferencesModel.fromJson(response.data!);
  }

  @override
  Future<void> followUser(String userId) async {
    await _apiClient.post<void>(ApiEndpoints.followUser(userId));
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await _apiClient.delete<void>(ApiEndpoints.followUser(userId));
  }

  @override
  Future<List<ProfileModel>> getFollowers(String userId, {int page = 1, int limit = 20}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.followers(userId),
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data!;
    final items = (data['data'] as List? ?? data['items'] as List? ?? [])
        .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return items;
  }

  @override
  Future<List<ProfileModel>> getFollowing(String userId, {int page = 1, int limit = 20}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.following(userId),
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data!;
    final items = (data['data'] as List? ?? data['items'] as List? ?? [])
        .map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return items;
  }

  @override
  Future<bool> isFollowing(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.isFollowing(userId));
    return response.data!['following'] as bool? ?? false;
  }

  @override
  Future<void> deleteAccount(String password) async {
    await _apiClient.delete<void>(ApiEndpoints.deleteAccount, data: {'password': password});
  }

  @override
  Future<String> exportUserData() async {
    final response = await _apiClient.post<Map<String, dynamic>>(ApiEndpoints.exportData);
    return response.data!['downloadUrl'] as String? ?? '';
  }
}
