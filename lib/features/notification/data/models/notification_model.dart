import 'package:flavorizr/features/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.title,
    super.body,
    required super.type,
    required super.isRead,
    super.data,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      type: _parseNotificationType(json['type'] as String),
      isRead: json['is_read'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'is_read': isRead,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'trip':
        return NotificationType.trip;
      case 'payment':
        return NotificationType.payment;
      case 'promotion':
        return NotificationType.promotion;
      case 'system':
        return NotificationType.system;
      case 'rating':
        return NotificationType.rating;
      case 'driver':
        return NotificationType.driver;
      case 'booking':
        return NotificationType.booking;
      default:
        return NotificationType.system;
    }
  }

  Notification toEntity() => this;
}