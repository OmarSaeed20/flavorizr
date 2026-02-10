// lib/shared/widgets/success_message.dart
import 'package:flutter/material.dart';

/// Success Message Widget
///
/// Displays a success message with optional action.
/// Use this to show successful operation completion.
///
/// Example:
/// ```dart
/// SuccessMessage(
///   message: 'Profile updated successfully',
///   icon: Icons.check_circle,
/// )
/// ```
class SuccessMessage extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const SuccessMessage({
    super.key,
    required this.message,
    this.subMessage,
    this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.check_circle, color: Colors.green, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: theme.textTheme.titleMedium?.copyWith(color: Colors.green)),
                if (subMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(width: 8),
            TextButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}

/// Info Message Widget
///
/// Displays an informational message.
class InfoMessage extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData? icon;

  const InfoMessage({super.key, required this.message, this.subMessage, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.info, color: Colors.blue, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: theme.textTheme.titleMedium?.copyWith(color: Colors.blue)),
                if (subMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Warning Message Widget
///
/// Displays a warning message.
class WarningMessage extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData? icon;

  const WarningMessage({super.key, required this.message, this.subMessage, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.warning, color: Colors.orange, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: theme.textTheme.titleMedium?.copyWith(color: Colors.orange)),
                if (subMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Error Message Widget
///
/// Displays an error message.
class ErrorMessage extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData? icon;

  const ErrorMessage({super.key, required this.message, this.subMessage, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.error, color: theme.colorScheme.error, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
                ),
                if (subMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
