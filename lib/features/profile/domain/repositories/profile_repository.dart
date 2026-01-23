// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:flavorizr/core/error/failures.dart';
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
  Future<({Profile? data, Failure? failure})> getCurrentProfile();

  /// Gets a profile by user ID.
  ///
  /// Returns the profile if found, or a failure if not found or
  /// the profile is private.
  Future<({Profile? data, Failure? failure})> getProfileByUserId(String userId);

  /// Gets a profile by username/handle.
  ///
  /// Returns the profile if found, or a failure if not found.
  Future<({Profile? data, Failure? failure})> getProfileByUsername(String username);

  /// Updates the current user's profile.
  ///
  /// Only authenticated users can update their own profile.
  Future<({Profile? data, Failure? failure})> updateProfile(ProfileUpdateData data);

  /// Updates the profile photo.
  ///
  /// [imagePath] is the local path to the image file.
  /// Returns the updated profile with the new photo URL.
  Future<({Profile? data, Failure? failure})> updateProfilePhoto(String imagePath);

  /// Updates the cover photo.
  ///
  /// [imagePath] is the local path to the image file.
  /// Returns the updated profile with the new cover photo URL.
  Future<({Profile? data, Failure? failure})> updateCoverPhoto(String imagePath);

  /// Removes the profile photo.
  Future<({Profile? data, Failure? failure})> removeProfilePhoto();

  /// Removes the cover photo.
  Future<({Profile? data, Failure? failure})> removeCoverPhoto();

  // ==================== Preferences ====================

  /// Gets the current user's profile preferences.
  Future<({ProfilePreferences? data, Failure? failure})> getPreferences();

  /// Updates the current user's profile preferences.
  Future<({ProfilePreferences? data, Failure? failure})> updatePreferences(
    ProfilePreferences preferences,
  );

  // ==================== Social ====================

  /// Follows a user.
  Future<({bool? data, Failure? failure})> followUser(String userId);

  /// Unfollows a user.
  Future<({bool? data, Failure? failure})> unfollowUser(String userId);

  /// Gets the list of followers for a user.
  Future<({List<Profile>? data, Failure? failure})> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  });

  /// Gets the list of users being followed.
  Future<({List<Profile>? data, Failure? failure})> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  });

  /// Checks if the current user is following another user.
  Future<({bool? data, Failure? failure})> isFollowing(String userId);

  // ==================== Account ====================

  /// Deletes the current user's account.
  ///
  /// This is a destructive operation that cannot be undone.
  /// Requires password confirmation.
  Future<({bool? data, Failure? failure})> deleteAccount(String password);

  /// Exports all user data.
  ///
  /// Returns a URL to download the data export.
  Future<({String? data, Failure? failure})> exportUserData();

  // ==================== Cache ====================

  /// Gets the cached profile for the current user.
  Future<Profile?> getCachedProfile();

  /// Caches a profile locally.
  Future<void> cacheProfile(Profile profile);

  /// Clears the profile cache.
  Future<void> clearCache();

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
