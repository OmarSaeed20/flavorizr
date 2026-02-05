// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiUser _$ApiUserFromJson(Map<String, dynamic> json) => _ApiUser(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  nickname: json['nickname'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  country: json['country'] as String?,
  governorate: json['governorate'] as String?,
  birthdate: json['birthdate'] as String?,
  gender: json['gender'] as String?,
  avatar: json['avatar'] as String?,
  deviceType: json['deviceType'] as String?,
  deviceToken: json['deviceToken'] as String?,
  deviceId: json['deviceId'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ApiUserToJson(_ApiUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nickname': instance.nickname,
  'phone': instance.phone,
  'email': instance.email,
  'country': instance.country,
  'governorate': instance.governorate,
  'birthdate': instance.birthdate,
  'gender': instance.gender,
  'avatar': instance.avatar,
  'deviceType': instance.deviceType,
  'deviceToken': instance.deviceToken,
  'deviceId': instance.deviceId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
