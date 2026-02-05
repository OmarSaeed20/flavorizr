class Banner {
  final int id;
  final String title;
  final String? description;
  final String imageUrl;
  final String? linkUrl;
  final int? order;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Banner({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    this.linkUrl,
    this.order,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Banner copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? linkUrl,
    int? order,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Banner(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
