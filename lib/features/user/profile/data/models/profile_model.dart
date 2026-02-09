// lib/features/profile/data/models/profile_model.dart
import 'package:fast_golden_taxi/features/user/profile/domain/entities/profile.dart';

/// Data model for profile JSON serialization.
class ProfileModel extends Profile {
  const ProfileModel({
    super.id,
    super.name,
    super.nickname,
    super.email,
    super.gender,
    super.birthDate,
    super.image,
    super.phone,
    super.phoneIso2Code,
    super.countryId,
    super.governorateId,
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a ProfileModel from JSON data.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nickname: json['nickname'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] as String?,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      phoneIso2Code: json['phone_iso2_code'] as String?,
      countryId: json['country_id'] as int?,
      governorateId: json['governorate_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  /// Creates a ProfileModel from a Profile entity.
  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      nickname: profile.nickname,
      email: profile.email,
      gender: profile.gender,
      birthDate: profile.birthDate,
      image: profile.image,
      phone: profile.phone,
      phoneIso2Code: profile.phoneIso2Code,
      countryId: profile.countryId,
      governorateId: profile.governorateId,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nickname != null) 'nickname': nickname,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (birthDate != null) 'birth_date': birthDate,
      if (image != null) 'image': image,
      if (phone != null) 'phone': phone,
      if (phoneIso2Code != null) 'phone_iso2_code': phoneIso2Code,
      if (countryId != null) 'country_id': countryId,
      if (governorateId != null) 'governorate_id': governorateId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Converts this model to a Profile entity.
  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      nickname: nickname,
      email: email,
      gender: gender,
      birthDate: birthDate,
      image: image,
      phone: phone,
      phoneIso2Code: phoneIso2Code,
      countryId: countryId,
      governorateId: governorateId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
