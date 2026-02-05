import 'package:flavorizr/features/general_select/domain/entities/select_option.dart';

/// Data model for SelectOption, used for JSON serialization.
///
/// This model handles the conversion between API JSON
/// and the domain SelectOption entity.
class SelectOptionModel {
  const SelectOptionModel({
    required this.id,
    required this.label,
    this.value,
    this.description,
    this.imageUrl,
    this.isEnabled = true,
    this.metadata,
  });

  /// Creates a model from JSON.
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

  /// Creates a model from a domain entity.
  factory SelectOptionModel.fromEntity(SelectOption entity) {
    return SelectOptionModel(
      id: entity.id,
      label: entity.label,
      value: entity.value,
      description: entity.description,
      imageUrl: entity.imageUrl,
      isEnabled: entity.isEnabled,
      metadata: entity.metadata,
    );
  }

  /// Unique identifier for the select option.
  final String id;

  /// Display label for the option.
  final String label;

  /// Optional value associated with the option.
  final String? value;

  /// Optional description of the option.
  final String? description;

  /// Optional image URL for the option.
  final String? imageUrl;

  /// Whether the option is enabled/active.
  final bool isEnabled;

  /// Optional metadata for additional information.
  final Map<String, dynamic>? metadata;

  /// Converts the model to JSON.
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

  /// Converts the model to a domain entity.
  SelectOption toEntity() {
    return SelectOption(
      id: id,
      label: label,
      value: value,
      description: description,
      imageUrl: imageUrl,
      isEnabled: isEnabled,
      metadata: metadata,
    );
  }
}
