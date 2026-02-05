class Notification {
  final int id;
  final String title;
  final String? body;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Notification({
    required this.id,
    required this.title,
    this.body,
    required this.type,
    required this.isRead,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  Notification copyWith({
    int? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum NotificationType {
  trip,
  payment,
  promotion,
  system,
  rating,
  driver,
  booking,
}
