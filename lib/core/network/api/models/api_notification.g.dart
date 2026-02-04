// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiNotification _$ApiNotificationFromJson(Map<String, dynamic> json) =>
    _ApiNotification(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ApiNotificationToJson(_ApiNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'isRead': instance.isRead,
      'data': instance.data,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_ApiNotificationCount _$ApiNotificationCountFromJson(
  Map<String, dynamic> json,
) => _ApiNotificationCount(
  count: (json['count'] as num).toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApiNotificationCountToJson(
  _ApiNotificationCount instance,
) => <String, dynamic>{
  'count': instance.count,
  'totalCount': instance.totalCount,
};
