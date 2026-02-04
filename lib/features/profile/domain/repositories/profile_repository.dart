// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';

/// Repository interface for profile operations.
///
/// Defines the contract for profile data operations. Implementations
/// should handle both remote API and local storage.
abstract class ProfileRepository {
  // ==================== Profile CRUD ====================

  /// Gets the current user's profile.
  ///
  /// Returns the profile if found, or a failure if not authenticated
  /// or profile doesn't exist.
  Future<ApiResult<Profile>> getCurrentProfile();

  /// Gets a profile by user ID.
  ///
  /// Returns the profile if found, or a failure if not found or
  /// the profile is private.
  Future<ApiResult<Profile>> getProfileByUserId(String userId);

  /// Gets a profile by username/handle.
  ///
  /// Returns the profile if found, or a failure if not found.
  Future<ApiResult<Profile>> getProfileByUsername(String username);

  /// Updates the current user's profile.
  ///
  /// Only authenticated users can update their own profile.
  Future<ApiResult<Profile>> updateProfile(ProfileUpdateData data);

  /// Updates the profile photo.
  ///
  /// [imagePath] is the local path to the image file.
  /// Returns the updated profile with the new photo URL.
  Future<ApiResult<Profile>> updateProfilePhoto(String imagePath);

  /// Updates the cover photo.
  ///
  /// [imagePath] is the local path to the image file.
  /// Returns the updated profile with the new cover photo URL.
  Future<ApiResult<Profile>> updateCoverPhoto(String imagePath);

  /// Removes the profile photo.
  Future<ApiResult<Profile>> removeProfilePhoto();

  /// Removes the cover photo.
  Future<ApiResult<Profile>> removeCoverPhoto();

  // ==================== Preferences ====================

  /// Gets the current user's profile preferences.
  Future<ApiResult<ProfilePreferences>> getPreferences();

  /// Updates the current user's profile preferences.
  Future<ApiResult<ProfilePreferences>> updatePreferences(
    ProfilePreferences preferences,
  );

  // ==================== Social ====================

  /// Follows a user.
  Future<ApiResult<bool>> followUser(String userId);

  /// Unfollows a user.
  Future<ApiResult<bool>> unfollowUser(String userId);

  /// Gets the list of followers for a user.
  Future<ApiResult<List<Profile>>> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  });

  /// Gets the list of users being followed.
  Future<ApiResult<List<Profile>>> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  });

  /// Checks if the current user is following another user.
  Future<ApiResult<bool>> isFollowing(String userId);

  // ==================== Account ====================

  /// Deletes the current user's account.
  ///
  /// This is a destructive operation that cannot be undone.
  /// Requires password confirmation.
  Future<ApiResult<bool>> deleteAccount(String password);

  /// Exports all user data.
  ///
  /// Returns a URL to download the data export.
  Future<ApiResult<String?>> exportUserData();

  // ==================== Cache ====================

  /// Gets the cached profile for the current user.
  Future<ApiResult<Profile?>> getCachedProfile();

  /// Caches a profile locally.
  Future<void> cacheProfile(Profile profile);

  /// Clears the profile cache.
  Future<void> clearProfileCache();

  // ==================== Stream ====================

  /// Stream of profile updates for the current user.
  Stream<Profile?> get profileUpdates;
}

/// Data class for profile updates.
class ProfileUpdateData {
  const ProfileUpdateData({
    this.displayName,
    this.bio,
    this.location,
    this.website,
    this.birthDate,
    this.phoneNumber,
    this.isPublic,
    this.socialLinks,
  });

  final String? displayName;
  final String? bio;
  final String? location;
  final String? website;
  final DateTime? birthDate;
  final String? phoneNumber;
  final bool? isPublic;
  final Map<String, String>? socialLinks;

  bool get isEmpty =>
      displayName == null &&
      bio == null &&
      location == null &&
      website == null &&
      birthDate == null &&
      phoneNumber == null &&
      isPublic == null &&
      socialLinks == null;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (displayName != null) json['displayName'] = displayName;
    if (bio != null) json['bio'] = bio;
    if (location != null) json['location'] = location;
    if (website != null) json['website'] = website;
    if (birthDate != null) json['birthDate'] = birthDate!.toIso8601String();
    if (phoneNumber != null) json['phoneNumber'] = phoneNumber;
    if (isPublic != null) json['isPublic'] = isPublic;
    if (socialLinks != null) json['socialLinks'] = socialLinks;
    return json;
  }
}
