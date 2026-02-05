// lib/features/auth/presentation/widgets/social_login_buttons.dart
import 'dart:io';

import 'package:flutter/material.dart';

/// Social login buttons for OAuth providers.
///
/// Displays buttons for Google and optionally Apple sign-in.
/// Uses brand-compliant styling and icons.
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.showApple = true,
  });

  /// Callback when Google button is pressed.
  final VoidCallback? onGooglePressed;

  /// Callback when Apple button is pressed.
  final VoidCallback? onApplePressed;

  /// Whether Google button is loading.
  final bool isGoogleLoading;

  /// Whether Apple button is loading.
  final bool isAppleLoading;

  /// Whether to show Apple sign-in button.
  /// Set to false on Android or when not configured.
  final bool showApple;

  @override
  Widget build(BuildContext context) {
    final showAppleButton = showApple && (Platform.isIOS || Platform.isMacOS);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Google Sign-In Button
        _SocialButton(
          onPressed: isGoogleLoading ? null : onGooglePressed,
          isLoading: isGoogleLoading,
          icon: const _GoogleIcon(),
          label: 'Continue with Google',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          borderColor: Colors.grey.shade300,
        ),

        if (showAppleButton) ...[
          const SizedBox(height: 12),
          // Apple Sign-In Button
          _SocialButton(
            onPressed: isAppleLoading ? null : onApplePressed,
            isLoading: isAppleLoading,
            icon: const Icon(Icons.apple, size: 24),
            label: 'Continue with Apple',
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ],
      ],
    );
  }
}

/// Internal social button widget.
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final VoidCallback? onPressed;
  final String label;
  final Widget icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.surface,
          foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
          side: BorderSide(color: borderColor ?? theme.colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    foregroundColor ?? theme.colorScheme.primary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: foregroundColor ?? theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Google icon widget.
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

/// Custom painter for the Google "G" logo.
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Blue arc (bottom right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5,
      1.7,
      true,
      paint,
    );

    // Green arc (bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.2,
      1.2,
      true,
      paint,
    );

    // Yellow arc (top)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.4,
      1.2,
      true,
      paint,
    );

    // Red arc (top right)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.6,
      1.2,
      true,
      paint,
    );

    // White center (creates the G shape)
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);

    // Blue horizontal bar
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - radius * 0.15,
        radius * 0.9,
        radius * 0.3,
      ),
      paint,
    );

    // White cutout for G opening
    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - radius * 0.55,
        radius * 0.6,
        radius * 0.4,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Divider with "OR" text.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.text = 'OR'});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
