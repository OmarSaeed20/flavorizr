// lib/features/onboarding/domain/entities/onboarding_page.dart
import 'package:flutter/foundation.dart';

/// Entity representing an onboarding page.
///
/// Contains all the information needed to display a single
/// page in the onboarding flow.
@immutable
class OnboardingPage {
  const OnboardingPage({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.backgroundColor,
  });

  /// Unique identifier for the page.
  final String id;

  /// Title text displayed on the page.
  final String title;

  /// Description text displayed below the title.
  final String description;

  /// Path to the image/illustration asset.
  final String imagePath;

  /// Optional background color for the page.
  final int? backgroundColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingPage &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode => Object.hash(id, title, description, imagePath);
}
