// lib/shared/widgets/loading_overlay.dart
import 'package:fast_golden_taxi/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Loading Overlay Widget
///
/// Displays a full-screen loading overlay with a spinner.
/// Use this to indicate that an operation is in progress.
///
/// Example:
/// ```dart
/// Stack(
///   children: [
///     YourContent(),
///     if (isLoading) const LoadingOverlay(),
///   ],
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isTransparent;

  const LoadingOverlay({super.key, this.message, this.isTransparent = true});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isTransparent ? Colors.black.withOpacity(0.5) : Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.primary),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Small Loading Indicator
///
/// A compact loading indicator for inline use.
class SmallLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const SmallLoadingIndicator({super.key, this.color, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? context.colorScheme.primary),
      ),
    );
  }
}

/// Button Loading State
///
/// Wraps a button to show loading state.
class ButtonLoadingState extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;

  const ButtonLoadingState({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        if (loadingText != null) ...[const SizedBox(width: 8), Text(loadingText!)],
      ],
    );
  }
}
