// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiTokenData _$ApiTokenDataFromJson(Map<String, dynamic> json) =>
    _ApiTokenData(
      token: json['token'] as String,
      expiration: (json['expiration'] as num).toInt(),
    );

Map<String, dynamic> _$ApiTokenDataToJson(_ApiTokenData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expiration': instance.expiration,
    };

_ApiToken _$ApiTokenFromJson(Map<String, dynamic> json) => _ApiToken(
  access: ApiTokenData.fromJson(json['access'] as Map<String, dynamic>),
  refresh: ApiTokenData.fromJson(json['refresh'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiTokenToJson(_ApiToken instance) => <String, dynamic>{
  'access': instance.access,
  'refresh': instance.refresh,
};

_ApiAuthData _$ApiAuthDataFromJson(Map<String, dynamic> json) => _ApiAuthData(
  user: ApiUser.fromJson(json['user'] as Map<String, dynamic>),
  token: ApiToken.fromJson(json['token'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiAuthDataToJson(_ApiAuthData instance) =>
    <String, dynamic>{'user': instance.user, 'token': instance.token};

_ApiAuthResponse _$ApiAuthResponseFromJson(Map<String, dynamic> json) =>
    _ApiAuthResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: ApiAuthData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiAuthResponseToJson(_ApiAuthResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
