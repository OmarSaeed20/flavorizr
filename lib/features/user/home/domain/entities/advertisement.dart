class Advertisement {
  final int id;
  final String title;
  final String? description;
  final String imageUrl;
  final String? linkUrl;
  final String? type;
  final int? duration;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Advertisement({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    this.linkUrl,
    this.type,
    this.duration,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Advertisement copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? linkUrl,
    String? type,
    int? duration,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Advertisement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
