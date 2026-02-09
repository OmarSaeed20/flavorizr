import 'package:fast_golden_taxi/features/user/home/domain/entities/banner.dart';

class BannerModel extends Banner {
  const BannerModel({
    required super.id,
    required super.title,
    super.description,
    required super.imageUrl,
    super.linkUrl,
    super.order,
    required super.isActive,
    super.startDate,
    super.endDate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String,
      linkUrl: json['link_url'] as String?,
      order: json['order'] as int?,
      isActive: json['is_active'] as bool? ?? true,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'order': order,
      'is_active': isActive,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Banner toEntity() => this;
}
