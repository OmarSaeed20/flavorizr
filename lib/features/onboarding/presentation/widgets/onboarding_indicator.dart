// lib/features/onboarding/presentation/widgets/onboarding_indicator.dart
import 'package:flutter/material.dart';

/// Dot indicator widget for onboarding page progress.
class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor,
    this.inactiveColor,
    this.activeSize = 10.0,
    this.inactiveSize = 8.0,
    this.spacing = 8.0,
  });

  /// Total number of pages.
  final int count;

  /// Current page index.
  final int currentIndex;

  /// Color for the active dot.
  final Color? activeColor;

  /// Color for inactive dots.
  final Color? inactiveColor;

  /// Size of the active dot.
  final double activeSize;

  /// Size of inactive dots.
  final double inactiveSize;

  /// Spacing between dots.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => _buildDot(
          index: index,
          isActive: index == currentIndex,
          activeColor: effectiveActiveColor,
          inactiveColor: effectiveInactiveColor,
        ),
      ),
    );
  }

  Widget _buildDot({
    required int index,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      width: isActive ? activeSize * 2.5 : inactiveSize,
      height: isActive ? activeSize : inactiveSize,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(isActive ? activeSize / 2 : inactiveSize / 2),
      ),
    );
  }
}

/// Alternative progress bar style indicator.
class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({
    super.key,
    required this.progress,
    this.height = 4.0,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius = 2.0,
  });

  /// Progress value (0.0 to 1.0).
  final double progress;

  /// Height of the progress bar.
  final double height;

  /// Background color of the progress bar.
  final Color? backgroundColor;

  /// Color of the progress indicator.
  final Color? progressColor;

  /// Border radius of the progress bar.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.1);
    final effectiveProgressColor = progressColor ?? theme.colorScheme.primary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                height: height,
                decoration: BoxDecoration(
                  color: effectiveProgressColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
