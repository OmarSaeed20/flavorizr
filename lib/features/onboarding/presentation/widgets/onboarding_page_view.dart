// lib/features/onboarding/presentation/widgets/onboarding_page_view.dart
import 'package:fast_golden_taxi/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:fast_golden_taxi/features/onboarding/onboarding.dart' show OnboardingScreen;
import 'package:fast_golden_taxi/features/onboarding/presentation/pages/onboarding_page.dart'
    show OnboardingScreen;
import 'package:flutter/material.dart';

/// Widget displaying a single onboarding page content (image area only).
///
/// The bottom card with title, description, indicators and button
/// is handled by the parent [OnboardingScreen].
class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({super.key, required this.page, this.imageBuilder});

  /// The onboarding page data.
  final OnboardingPage page;

  /// Custom image builder (for when assets don't exist yet).
  final Widget Function(BuildContext context, String imagePath)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: imageBuilder != null
            ? imageBuilder!(context, page.imagePath)
            : _buildDefaultImage(context),
      ),
    );
  }

  Widget _buildDefaultImage(BuildContext context) {
    // Placeholder icon based on page id
    final icon = switch (page.id) {
      'welcome' => Icons.local_taxi_rounded,
      'trip_booking' => Icons.map_rounded,
      'vehicle_rentals' => Icons.directions_car_rounded,
      'advertisements' => Icons.campaign_rounded,
      _ => Icons.star_rounded,
    };

    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFFFFBF00).withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 120, color: const Color(0xFFFFBF00)),
    );
  }
}
