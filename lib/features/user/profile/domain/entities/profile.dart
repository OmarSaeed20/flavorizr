// lib/features/profile/domain/entities/profile.dart
import 'package:flutter/foundation.dart';

/// Represents a user profile for FAST Taxi App.
///
/// The profile entity contains user profile data as per FAST API specification.
@immutable
class Profile {
  const Profile({
    this.id,
    this.name,
    this.nickname,
    this.email,
    this.gender,
    this.birthDate,
    this.image,
    this.phone,
    this.phoneIso2Code,
    this.countryId,
    this.governorateId,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique profile identifier.
  final int? id;

  /// User's full name.
  final String? name;

  /// User's nickname.
  final String? nickname;

  /// User's email address.
  final String? email;

  /// User's gender ('male' or 'female').
  final String? gender;

  /// User's birth date (YYYY-MM-DD format).
  final String? birthDate;

  /// Profile image (base64 encoded string).
  final String? image;

  /// Phone number.
  final String? phone;

  /// ISO2 country code for phone.
  final String? phoneIso2Code;

  /// Country ID.
  final int? countryId;

  /// Governorate ID.
  final int? governorateId;

  /// Profile creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Returns user's initials for avatar fallback.
  String get initials {
    final parts = (name ?? '').trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Creates a copy of this profile with the given fields replaced.
  Profile copyWith({
    int? id,
    String? name,
    String? nickname,
    String? email,
    String? gender,
    String? birthDate,
    String? image,
    String? phone,
    String? phoneIso2Code,
    int? countryId,
    int? governorateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      phoneIso2Code: phoneIso2Code ?? this.phoneIso2Code,
      countryId: countryId ?? this.countryId,
      governorateId: governorateId ?? this.governorateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Data class for updating profile information.
@immutable
class ProfileUpdateData {
  const ProfileUpdateData({
    this.name,
    this.nickname,
    this.email,
    this.gender,
    this.birthDate,
    this.image,
  });

  final String? name;
  final String? nickname;
  final String? email;
  final String? gender;
  final String? birthDate;
  final String? image;

  bool get isEmpty =>
      name == null &&
      nickname == null &&
      email == null &&
      gender == null &&
      birthDate == null &&
      image == null;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (nickname != null) 'nickname': nickname,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (birthDate != null) 'birth_date': birthDate,
      if (image != null) 'image': image,
    };
  }

  ProfileUpdateData copyWith({
    String? name,
    String? nickname,
    String? email,
    String? gender,
    String? birthDate,
    String? image,
  }) {
    return ProfileUpdateData(
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
    );
  }
}
