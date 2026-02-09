// lib/features/onboarding/data/models/onboarding_page_model.dart
import 'package:fast_golden_taxi/features/onboarding/domain/entities/onboarding_page.dart';

/// Model class for onboarding page data.
///
/// Extends [OnboardingPage] with serialization capabilities.
class OnboardingPageModel extends OnboardingPage {
  const OnboardingPageModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imagePath,
    super.backgroundColor,
  });

  /// Creates an instance from a JSON map.
  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      backgroundColor: json['backgroundColor'] as int?,
    );
  }

  /// Creates from an entity.
  factory OnboardingPageModel.fromEntity(OnboardingPage entity) {
    return OnboardingPageModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
      backgroundColor: entity.backgroundColor,
    );
  }

  /// Converts to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'backgroundColor': backgroundColor,
    };
  }
}
