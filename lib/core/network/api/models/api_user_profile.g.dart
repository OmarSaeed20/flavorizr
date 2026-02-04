// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiUserProfile _$ApiUserProfileFromJson(Map<String, dynamic> json) =>
    _ApiUserProfile(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nickname: json['nickname'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      companyType: json['companyType'] as String,
      country: json['country'] as String?,
      governorate: json['governorate'] as String?,
      birthdate: json['birthdate'] as String?,
      gender: json['gender'] as String?,
      isVerified: json['isVerified'] as bool?,
      isActive: json['isActive'] as bool?,
      firebaseToken: json['firebaseToken'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalTrips: (json['totalTrips'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ApiUserProfileToJson(_ApiUserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'email': instance.email,
      'avatar': instance.avatar,
      'companyType': instance.companyType,
      'country': instance.country,
      'governorate': instance.governorate,
      'birthdate': instance.birthdate,
      'gender': instance.gender,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'firebaseToken': instance.firebaseToken,
      'rating': instance.rating,
      'totalTrips': instance.totalTrips,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_ApiDriverProfile _$ApiDriverProfileFromJson(Map<String, dynamic> json) =>
    _ApiDriverProfile(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nickname: json['nickname'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      country: json['country'] as String?,
      governorate: json['governorate'] as String?,
      birthdate: json['birthdate'] as String?,
      gender: json['gender'] as String?,
      isVerified: json['isVerified'] as bool?,
      isActive: json['isActive'] as bool?,
      vehicleType: json['vehicleType'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehiclePlateNumber: json['vehiclePlateNumber'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalTrips: (json['totalTrips'] as num?)?.toInt(),
      totalReviews: (json['totalReviews'] as num?)?.toInt(),
      isAvailable: json['isAvailable'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ApiDriverProfileToJson(_ApiDriverProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'email': instance.email,
      'avatar': instance.avatar,
      'country': instance.country,
      'governorate': instance.governorate,
      'birthdate': instance.birthdate,
      'gender': instance.gender,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'vehicleType': instance.vehicleType,
      'vehicleModel': instance.vehicleModel,
      'vehiclePlateNumber': instance.vehiclePlateNumber,
      'licenseNumber': instance.licenseNumber,
      'rating': instance.rating,
      'totalTrips': instance.totalTrips,
      'totalReviews': instance.totalReviews,
      'isAvailable': instance.isAvailable,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
