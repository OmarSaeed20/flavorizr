// lib/features/onboarding/presentation/widgets/onboarding_page_view.dart
import 'package:fast_golden_taxi/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:flutter/material.dart';

/// Widget displaying a single onboarding page.
class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.page,
    this.imageBuilder,
    this.titleStyle,
    this.descriptionStyle,
  });

  /// The onboarding page data.
  final OnboardingPage page;

  /// Custom image builder (for when assets don't exist yet).
  final Widget Function(BuildContext context, String imagePath)? imageBuilder;

  /// Custom text style for the title.
  final TextStyle? titleStyle;

  /// Custom text style for the description.
  final TextStyle? descriptionStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image/Illustration
          SizedBox(
            height: size.height * 0.35,
            child: imageBuilder != null
                ? imageBuilder!(context, page.imagePath)
                : _buildDefaultImage(context),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style:
                titleStyle ??
                theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            style:
                descriptionStyle ??
                theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultImage(BuildContext context) {
    final theme = Theme.of(context);

    // Placeholder icon based on page id
    final icon = switch (page.id) {
      'welcome' => Icons.waving_hand_rounded,
      'features' => Icons.auto_awesome_rounded,
      'security' => Icons.security_rounded,
      'ready' => Icons.rocket_launch_rounded,
      _ => Icons.star_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 120, color: theme.colorScheme.primary),
    );
  }
}
