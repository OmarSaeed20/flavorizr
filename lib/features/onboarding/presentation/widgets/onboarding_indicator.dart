// lib/features/onboarding/presentation/widgets/onboarding_indicator.dart
import 'package:flutter/material.dart';

/// Dot indicator widget for onboarding page progress.
///
/// Displays simple 8x8 circle dots matching the Figma design.
/// Active dot is primary (#FFBF00), inactive dots are #E4E4E4.
class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = const Color(0xFFFFBF00),
    this.inactiveColor = const Color(0xFFE4E4E4),
    this.dotSize = 8.0,
    this.spacing = 12.0,
  });

  /// Total number of pages.
  final int count;

  /// Current page index.
  final int currentIndex;

  /// Color for the active dot.
  final Color activeColor;

  /// Color for inactive dots.
  final Color inactiveColor;

  /// Size of each dot (width & height).
  final double dotSize;

  /// Spacing between dots.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return Padding(
          padding: EdgeInsets.only(right: index < count - 1 ? spacing : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: dotSize,
            height: dotSize,
            decoration: ShapeDecoration(
              color: isActive ? activeColor : inactiveColor,
              shape: const OvalBorder(),
            ),
          ),
        );
      }),
    );
  }
}
