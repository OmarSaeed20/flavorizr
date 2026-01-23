// lib/features/profile/domain/entities/profile.dart
import 'package:flutter/foundation.dart';

/// Represents a user profile with extended information.
///
/// The profile entity contains all user-facing profile data
/// including personal information, preferences, and statistics.
@immutable
class Profile {
  const Profile({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    this.photoUrl,
    this.coverPhotoUrl,
    this.location,
    this.website,
    this.birthDate,
    this.phoneNumber,
    this.isPublic = true,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.preferences = const ProfilePreferences(),
    this.socialLinks = const {},
    this.badges = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Unique profile identifier.
  final String id;

  /// Associated user ID.
  final String userId;

  /// Display name shown to others.
  final String displayName;

  /// User bio/description.
  final String? bio;

  /// Profile photo URL.
  final String? photoUrl;

  /// Cover/banner photo URL.
  final String? coverPhotoUrl;

  /// User's location.
  final String? location;

  /// Personal website URL.
  final String? website;

  /// User's birth date.
  final DateTime? birthDate;

  /// Phone number.
  final String? phoneNumber;

  /// Whether the profile is public.
  final bool isPublic;

  /// Number of followers.
  final int followersCount;

  /// Number of users being followed.
  final int followingCount;

  /// Number of posts.
  final int postsCount;

  /// User preferences.
  final ProfilePreferences preferences;

  /// Social media links.
  final Map<String, String> socialLinks;

  /// Achievement badges.
  final List<ProfileBadge> badges;

  /// Profile creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Returns user's initials for avatar fallback.
  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Returns a formatted follower count (e.g., "1.2K").
  String get formattedFollowersCount => _formatCount(followersCount);

  /// Returns a formatted following count.
  String get formattedFollowingCount => _formatCount(followingCount);

  /// Returns a formatted posts count.
  String get formattedPostsCount => _formatCount(postsCount);

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  /// Creates a copy of this profile with the given fields replaced.
  Profile copyWith({
    String? id,
    String? userId,
    String? displayName,
    String? bio,
    String? photoUrl,
    String? coverPhotoUrl,
    String? location,
    String? website,
    DateTime? birthDate,
    String? phoneNumber,
    bool? isPublic,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    ProfilePreferences? preferences,
    Map<String, String>? socialLinks,
    List<ProfileBadge>? badges,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      location: location ?? this.location,
      website: website ?? this.website,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPublic: isPublic ?? this.isPublic,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      preferences: preferences ?? this.preferences,
      socialLinks: socialLinks ?? this.socialLinks,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId;

  @override
  int get hashCode => id.hashCode ^ userId.hashCode;
}

/// User profile preferences.
@immutable
class ProfilePreferences {
  const ProfilePreferences({
    this.showEmail = false,
    this.showPhone = false,
    this.showBirthDate = false,
    this.showLocation = true,
    this.allowDirectMessages = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.theme = 'system',
    this.language = 'en',
  });

  /// Whether to show email publicly.
  final bool showEmail;

  /// Whether to show phone publicly.
  final bool showPhone;

  /// Whether to show birth date publicly.
  final bool showBirthDate;

  /// Whether to show location publicly.
  final bool showLocation;

  /// Whether to allow direct messages.
  final bool allowDirectMessages;

  /// Whether email notifications are enabled.
  final bool emailNotifications;

  /// Whether push notifications are enabled.
  final bool pushNotifications;

  /// Preferred theme (system, light, dark).
  final String theme;

  /// Preferred language code.
  final String language;

  ProfilePreferences copyWith({
    bool? showEmail,
    bool? showPhone,
    bool? showBirthDate,
    bool? showLocation,
    bool? allowDirectMessages,
    bool? emailNotifications,
    bool? pushNotifications,
    String? theme,
    String? language,
  }) {
    return ProfilePreferences(
      showEmail: showEmail ?? this.showEmail,
      showPhone: showPhone ?? this.showPhone,
      showBirthDate: showBirthDate ?? this.showBirthDate,
      showLocation: showLocation ?? this.showLocation,
      allowDirectMessages: allowDirectMessages ?? this.allowDirectMessages,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }
}

/// Achievement badge for user profiles.
@immutable
class ProfileBadge {
  const ProfileBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    this.earnedAt,
  });

  /// Badge identifier.
  final String id;

  /// Badge name.
  final String name;

  /// Badge description.
  final String description;

  /// Badge icon URL.
  final String iconUrl;

  /// When the badge was earned.
  final DateTime? earnedAt;
}
