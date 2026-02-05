// lib/shared/presentation/widgets/buttons/app_button.dart
import 'package:flutter/material.dart';

/// A customizable button widget with consistent styling.
///
/// Supports multiple variants: primary, secondary, outlined, and text.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.width,
    this.icon,
    this.loadingText,
  });

  /// Creates a primary button with text.
  factory AppButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
    bool isDisabled = false,
    AppButtonSize size = AppButtonSize.medium,
    double? width,
    Widget? icon,
    String? loadingText,
  }) {
    return AppButton(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      size: size,
      width: width,
      icon: icon,
      loadingText: loadingText,
      child: Text(text),
    );
  }

  /// Creates a secondary button with text.
  factory AppButton.secondary({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
    bool isDisabled = false,
    AppButtonSize size = AppButtonSize.medium,
    double? width,
    Widget? icon,
  }) {
    return AppButton(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      variant: AppButtonVariant.secondary,
      size: size,
      width: width,
      icon: icon,
      child: Text(text),
    );
  }

  /// Creates an outlined button with text.
  factory AppButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
    bool isDisabled = false,
    AppButtonSize size = AppButtonSize.medium,
    double? width,
    Widget? icon,
  }) {
    return AppButton(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      variant: AppButtonVariant.outlined,
      size: size,
      width: width,
      icon: icon,
      child: Text(text),
    );
  }

  /// Creates a text button.
  factory AppButton.text({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
    bool isDisabled = false,
    AppButtonSize size = AppButtonSize.medium,
    Widget? icon,
  }) {
    return AppButton(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      variant: AppButtonVariant.text,
      size: size,
      icon: icon,
      child: Text(text),
    );
  }

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The button's child widget (usually a Text widget).
  final Widget child;

  /// Whether to show a loading indicator.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button variant/style.
  final AppButtonVariant variant;

  /// The button size.
  final AppButtonSize size;

  /// Optional fixed width.
  final double? width;

  /// Optional icon to show before the text.
  final Widget? icon;

  /// Text to show while loading.
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    // Get dimensions based on size
    final height = switch (size) {
      AppButtonSize.small => 36.0,
      AppButtonSize.medium => 48.0,
      AppButtonSize.large => 56.0,
    };

    final padding = switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 12),
      AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 24),
      AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 32),
    };

    final textStyle = switch (size) {
      AppButtonSize.small => theme.textTheme.labelMedium,
      AppButtonSize.medium => theme.textTheme.labelLarge,
      AppButtonSize.large => theme.textTheme.titleMedium,
    };

    // Build button content
    final Widget buttonChild = isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size == AppButtonSize.small ? 16 : 20,
                height: size == AppButtonSize.small ? 16 : 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    variant == AppButtonVariant.primary
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.primary,
                  ),
                ),
              ),
              if (loadingText != null) ...[
                const SizedBox(width: 8),
                Text(loadingText!),
              ],
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              DefaultTextStyle(
                style:
                    textStyle?.copyWith(fontWeight: FontWeight.w600) ??
                    const TextStyle(fontWeight: FontWeight.w600),
                child: child,
              ),
            ],
          );

    // Build button based on variant
    final buttonStyle = switch (variant) {
      AppButtonVariant.primary => FilledButton.styleFrom(
        minimumSize: Size(width ?? 0, height),
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      AppButtonVariant.secondary => FilledButton.styleFrom(
        minimumSize: Size(width ?? 0, height),
        padding: padding,
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      AppButtonVariant.outlined => OutlinedButton.styleFrom(
        minimumSize: Size(width ?? 0, height),
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      AppButtonVariant.text => TextButton.styleFrom(
        minimumSize: Size(width ?? 0, height),
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    };

    return switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.secondary => FilledButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonChild,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonChild,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonChild,
      ),
    };
  }
}

/// Button variants.
enum AppButtonVariant { primary, secondary, outlined, text }

/// Button sizes.
enum AppButtonSize { small, medium, large }
