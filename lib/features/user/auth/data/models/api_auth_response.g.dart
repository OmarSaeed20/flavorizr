// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiAuthResponse _$ApiAuthResponseFromJson(Map<String, dynamic> json) =>
    _ApiAuthResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      user: json['user'] == null
          ? null
          : ApiUser.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['token_type'] as String?,
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      accessToken: json['access_token'] as String?,
    );

Map<String, dynamic> _$ApiAuthResponseToJson(_ApiAuthResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'user': instance.user,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'access_token': instance.accessToken,
    };
