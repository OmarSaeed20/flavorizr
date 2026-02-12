// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiGovernorate _$ApiGovernorateFromJson(Map<String, dynamic> json) =>
    _ApiGovernorate(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ApiGovernorateToJson(_ApiGovernorate instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_ApiUser _$ApiUserFromJson(Map<String, dynamic> json) => _ApiUser(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  nickname: json['nickname'] as String?,
  phone: json['phone'] as String,
  governorate: json['governorate'] == null
      ? null
      : ApiGovernorate.fromJson(json['governorate'] as Map<String, dynamic>),
  birthdate: (json['birthdate'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  phoneVerified: json['phone_verified'] as bool?,
  isBanned: json['is_banned'] as bool?,
  avatar: json['avatar'] as String?,
  referralCode: json['referralCode'] as String?,
  referredBy: json['referred_by'] as String?,
  referralPoints: (json['referral_points'] as num?)?.toInt(),
  email: json['email'] as String?,
  country: json['country'] as String?,
  deviceType: json['deviceType'] as String?,
  deviceToken: json['deviceToken'] as String?,
  deviceId: json['deviceId'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ApiUserToJson(_ApiUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nickname': instance.nickname,
  'phone': instance.phone,
  'governorate': instance.governorate,
  'birthdate': instance.birthdate,
  'gender': instance.gender,
  'phone_verified': instance.phoneVerified,
  'is_banned': instance.isBanned,
  'avatar': instance.avatar,
  'referralCode': instance.referralCode,
  'referred_by': instance.referredBy,
  'referral_points': instance.referralPoints,
  'email': instance.email,
  'country': instance.country,
  'deviceType': instance.deviceType,
  'deviceToken': instance.deviceToken,
  'deviceId': instance.deviceId,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
