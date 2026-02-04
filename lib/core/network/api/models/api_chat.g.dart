// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiChatMessage _$ApiChatMessageFromJson(Map<String, dynamic> json) =>
    _ApiChatMessage(
      id: (json['id'] as num).toInt(),
      orderId: (json['orderId'] as num).toInt(),
      driverId: (json['driverId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      message: json['message'] as String,
      isFromUser: json['isFromUser'] as bool,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      driver: json['driver'] == null
          ? null
          : ApiChatDriver.fromJson(json['driver'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : ApiChatUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiChatMessageToJson(_ApiChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'driverId': instance.driverId,
      'userId': instance.userId,
      'message': instance.message,
      'isFromUser': instance.isFromUser,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'driver': instance.driver,
      'user': instance.user,
    };

_ApiChatDriver _$ApiChatDriverFromJson(Map<String, dynamic> json) =>
    _ApiChatDriver(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ApiChatDriverToJson(_ApiChatDriver instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'image': instance.image,
    };

_ApiChatUser _$ApiChatUserFromJson(Map<String, dynamic> json) => _ApiChatUser(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$ApiChatUserToJson(_ApiChatUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'image': instance.image,
    };
