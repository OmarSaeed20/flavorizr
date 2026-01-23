// lib/core/error/error_boundary.dart
import 'package:flutter/material.dart';

import 'package:flavorizr/core/logger/advanced_app_logger.dart';

/// Widget that catches and handles errors in its child widget tree.
///
/// Use this to wrap feature modules or sections of the app to prevent
/// a single error from crashing the entire app.
///
/// Usage:
/// ```dart
/// ErrorBoundary(
///   onError: (error, stack) => analytics.logError(error),
///   child: FeatureModule(),
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
    this.errorBuilder,
    this.showErrorInDebug = true,
    this.allowRetry = true,
  });

  /// The child widget tree to wrap.
  final Widget child;

  /// Called when an error is caught.
  final void Function(Object error, StackTrace stack)? onError;

  /// Custom error widget to display. If null, [DefaultErrorWidget] is used.
  final Widget Function(Object error, VoidCallback retry)? errorBuilder;

  /// Whether to show the error in debug mode.
  final bool showErrorInDebug;

  /// Whether to allow retry after error.
  final bool allowRetry;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _retry) ??
          DefaultErrorWidget(
            error: _error!,
            stackTrace: _stackTrace,
            showDetails: widget.showErrorInDebug,
            onRetry: widget.allowRetry ? _retry : null,
          );
    }

    return _ErrorCatcher(onError: _handleError, child: widget.child);
  }

  void _handleError(Object error, StackTrace stack) {
    // Log the error
    AppLogger.instance.logError(
      'ErrorBoundary caught error: $error',
      stackTrace: stack.toString(),
      category: LogCategory.ui,
    );

    // Call the onError callback
    widget.onError?.call(error, stack);

    // Update state to show error widget
    if (mounted) {
      setState(() {
        _error = error;
        _stackTrace = stack;
      });
    }
  }

  void _retry() {
    if (mounted) {
      setState(() {
        _error = null;
        _stackTrace = null;
      });
    }
  }
}

/// Internal widget that catches errors during build.
class _ErrorCatcher extends StatelessWidget {
  const _ErrorCatcher({required this.child, required this.onError});
  final Widget child;
  final void Function(Object error, StackTrace stack) onError;

  @override
  Widget build(BuildContext context) {
    // Note: This catches errors during build only.
    // For async errors, use proper error handling in your logic.
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // Call onError in the next frame to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onError(details.exception, details.stack ?? StackTrace.current);
      });

      return const SizedBox.shrink();
    };

    return child;
  }
}

/// Default error widget shown when ErrorBoundary catches an error.
class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
    super.key,
    required this.error,
    this.stackTrace,
    this.showDetails = false,
    this.onRetry,
  });
  final Object error;
  final StackTrace? stackTrace;
  final bool showDetails;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Icon(Icons.error_outline_rounded, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),

            // Error title
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Error message
            Text(
              'An unexpected error occurred.\nPlease try again.',
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),

            // Show error details in debug mode
            if (showDetails) ...[
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error: $error',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                      if (stackTrace != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Stack trace:\n$stackTrace',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            color: colorScheme.onErrorContainer.withValues(alpha: 0.7),
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            // Retry button
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A variant of ErrorBoundary that shows a snackbar on error
/// instead of replacing the widget.
class ErrorSnackbarBoundary extends StatefulWidget {
  const ErrorSnackbarBoundary({super.key, required this.child, this.onError});
  final Widget child;
  final void Function(Object error, StackTrace stack)? onError;

  @override
  State<ErrorSnackbarBoundary> createState() => _ErrorSnackbarBoundaryState();
}

class _ErrorSnackbarBoundaryState extends State<ErrorSnackbarBoundary> {
  @override
  Widget build(BuildContext context) => _ErrorCatcher(onError: _handleError, child: widget.child);

  void _handleError(Object error, StackTrace stack) {
    // Log the error
    AppLogger.instance.logError(
      'ErrorSnackbarBoundary caught error: $error',
      stackTrace: stack.toString(),
      category: LogCategory.ui,
    );

    // Call the onError callback
    widget.onError?.call(error, stack);

    // Show snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occurred'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
