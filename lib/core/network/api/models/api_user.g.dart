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
  avatar: json['avatar'] as String?,
  companyType: json['companyType'] as String,
  country: json['country'] as String?,
  governorate: json['governorate'] as String?,
  birthdate: json['birthdate'] as String?,
  gender: json['gender'] as String?,
  isVerified: json['isVerified'] as bool?,
  isActive: json['isActive'] as bool?,
  firebaseToken: json['firebaseToken'] as String?,
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
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_ApiAuthResponse _$ApiAuthResponseFromJson(Map<String, dynamic> json) =>
    _ApiAuthResponse(
      user: ApiUser.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['tokenType'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApiAuthResponseToJson(_ApiAuthResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
    };
