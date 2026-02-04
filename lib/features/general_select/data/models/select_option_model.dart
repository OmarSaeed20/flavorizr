import 'package:flavorizr/features/general_select/domain/entities/select_option.dart';

class SelectOptionModel extends SelectOption {
  const SelectOptionModel({
    required super.id,
    required super.label,
    super.value,
    super.description,
    super.imageUrl,
    super.isEnabled = true,
    super.metadata,
  });

  factory SelectOptionModel.fromJson(Map<String, dynamic> json) {
    return SelectOptionModel(
      id: json['id'] as String,
      label: json['label'] as String,
      value: json['value'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isEnabled: json['is_enabled'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'description': description,
      'image_url': imageUrl,
      'is_enabled': isEnabled,
      'metadata': metadata,
    };
  }

  SelectOption toEntity() => this;
}