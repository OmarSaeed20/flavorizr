// lib/features/profile/data/models/profile_model.dart
import 'package:flavorizr/features/profile/domain/entities/profile.dart';

/// Data model for profile JSON serialization.
class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.userId,
    required super.displayName,
    super.bio,
    super.photoUrl,
    super.coverPhotoUrl,
    super.location,
    super.website,
    super.birthDate,
    super.phoneNumber,
    super.isPublic = true,
    super.followersCount = 0,
    super.followingCount = 0,
    super.postsCount = 0,
    super.preferences = const ProfilePreferences(),
    super.socialLinks = const {},
    super.badges = const [],
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a ProfileModel from JSON data.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? json['display_name'] as String? ?? 'Unknown',
      bio: json['bio'] as String?,
      photoUrl: json['photoUrl'] as String? ?? json['photo_url'] as String?,
      coverPhotoUrl: json['coverPhotoUrl'] as String? ?? json['cover_photo_url'] as String?,
      location: json['location'] as String?,
      website: json['website'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'] as String)
          : json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      phoneNumber: json['phoneNumber'] as String? ?? json['phone_number'] as String?,
      isPublic: json['isPublic'] as bool? ?? json['is_public'] as bool? ?? true,
      followersCount: json['followersCount'] as int? ?? json['followers_count'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? json['following_count'] as int? ?? 0,
      postsCount: json['postsCount'] as int? ?? json['posts_count'] as int? ?? 0,
      preferences: json['preferences'] != null
          ? ProfilePreferencesModel.fromJson(json['preferences'] as Map<String, dynamic>)
          : const ProfilePreferences(),
      socialLinks: json['socialLinks'] != null
          ? Map<String, String>.from(json['socialLinks'] as Map)
          : json['social_links'] != null
          ? Map<String, String>.from(json['social_links'] as Map)
          : const {},
      badges: json['badges'] != null
          ? (json['badges'] as List)
                .map((e) => ProfileBadgeModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  /// Creates a ProfileModel from a Profile entity.
  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      userId: profile.userId,
      displayName: profile.displayName,
      bio: profile.bio,
      photoUrl: profile.photoUrl,
      coverPhotoUrl: profile.coverPhotoUrl,
      location: profile.location,
      website: profile.website,
      birthDate: profile.birthDate,
      phoneNumber: profile.phoneNumber,
      isPublic: profile.isPublic,
      followersCount: profile.followersCount,
      followingCount: profile.followingCount,
      postsCount: profile.postsCount,
      preferences: profile.preferences,
      socialLinks: profile.socialLinks,
      badges: profile.badges,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (coverPhotoUrl != null) 'coverPhotoUrl': coverPhotoUrl,
      if (location != null) 'location': location,
      if (website != null) 'website': website,
      if (birthDate != null) 'birthDate': birthDate!.toIso8601String(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'isPublic': isPublic,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'preferences': ProfilePreferencesModel.fromEntity(preferences).toJson(),
      'socialLinks': socialLinks,
      'badges': badges.map((b) => ProfileBadgeModel.fromEntity(b).toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// Converts this model to a Profile entity.
  Profile toEntity() {
    return Profile(
      id: id,
      userId: userId,
      displayName: displayName,
      bio: bio,
      photoUrl: photoUrl,
      coverPhotoUrl: coverPhotoUrl,
      location: location,
      website: website,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      isPublic: isPublic,
      followersCount: followersCount,
      followingCount: followingCount,
      postsCount: postsCount,
      preferences: preferences,
      socialLinks: socialLinks,
      badges: badges,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Data model for ProfilePreferences JSON serialization.
class ProfilePreferencesModel extends ProfilePreferences {
  const ProfilePreferencesModel({
    super.showEmail = false,
    super.showPhone = false,
    super.showBirthDate = false,
    super.showLocation = true,
    super.allowDirectMessages = true,
    super.emailNotifications = true,
    super.pushNotifications = true,
    super.theme = 'system',
    super.language = 'en',
  });

  /// Creates from JSON data.
  factory ProfilePreferencesModel.fromJson(Map<String, dynamic> json) {
    return ProfilePreferencesModel(
      showEmail: json['showEmail'] as bool? ?? json['show_email'] as bool? ?? false,
      showPhone: json['showPhone'] as bool? ?? json['show_phone'] as bool? ?? false,
      showBirthDate: json['showBirthDate'] as bool? ?? json['show_birth_date'] as bool? ?? false,
      showLocation: json['showLocation'] as bool? ?? json['show_location'] as bool? ?? true,
      allowDirectMessages:
          json['allowDirectMessages'] as bool? ?? json['allow_direct_messages'] as bool? ?? true,
      emailNotifications:
          json['emailNotifications'] as bool? ?? json['email_notifications'] as bool? ?? true,
      pushNotifications:
          json['pushNotifications'] as bool? ?? json['push_notifications'] as bool? ?? true,
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
    );
  }

  /// Creates from entity.
  factory ProfilePreferencesModel.fromEntity(ProfilePreferences prefs) {
    return ProfilePreferencesModel(
      showEmail: prefs.showEmail,
      showPhone: prefs.showPhone,
      showBirthDate: prefs.showBirthDate,
      showLocation: prefs.showLocation,
      allowDirectMessages: prefs.allowDirectMessages,
      emailNotifications: prefs.emailNotifications,
      pushNotifications: prefs.pushNotifications,
      theme: prefs.theme,
      language: prefs.language,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'showEmail': showEmail,
      'showPhone': showPhone,
      'showBirthDate': showBirthDate,
      'showLocation': showLocation,
      'allowDirectMessages': allowDirectMessages,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'theme': theme,
      'language': language,
    };
  }
}

/// Data model for ProfileBadge JSON serialization.
class ProfileBadgeModel extends ProfileBadge {
  const ProfileBadgeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconUrl,
    super.earnedAt,
  });

  /// Creates from JSON data.
  factory ProfileBadgeModel.fromJson(Map<String, dynamic> json) {
    return ProfileBadgeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? json['icon_url'] as String? ?? '',
      earnedAt: json['earnedAt'] != null
          ? DateTime.tryParse(json['earnedAt'] as String)
          : json['earned_at'] != null
          ? DateTime.tryParse(json['earned_at'] as String)
          : null,
    );
  }

  /// Creates from entity.
  factory ProfileBadgeModel.fromEntity(ProfileBadge badge) {
    return ProfileBadgeModel(
      id: badge.id,
      name: badge.name,
      description: badge.description,
      iconUrl: badge.iconUrl,
      earnedAt: badge.earnedAt,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      if (earnedAt != null) 'earnedAt': earnedAt!.toIso8601String(),
    };
  }
}
