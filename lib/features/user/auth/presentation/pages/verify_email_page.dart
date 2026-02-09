// lib/features/auth/presentation/pages/verify_email_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/verify_email_controller.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Email verification page for confirming user email.
///
/// Features:
/// - Auto-verify when opened with token
/// - Manual resend verification email
/// - Success/error states with appropriate actions
class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key, this.token});

  /// The email verification token from the email link.
  final String? token;

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    // Auto-verify if token is provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.token != null && widget.token!.isNotEmpty) {
        ref.read(verifyEmailControllerProvider.notifier).autoVerify(widget.token!);
      }
    });
  }

  Future<void> _handleResendEmail() async {
    await ref.read(verifyEmailControllerProvider.notifier).resendVerificationEmail();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(verifyEmailControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Skip/Close button
          TextButton(onPressed: () => context.go(Routes.home), child: const Text('Skip')),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildContent(theme, state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, VerifyEmailState state) {
    // Show loading state while verifying
    if (state.isVerifying) {
      return _buildVerifyingContent(theme);
    }

    // Show success state
    if (state.isSuccess) {
      return _buildSuccessContent(theme);
    }

    // Show error state if token verification failed
    if (state.errorMessage != null && widget.token != null && widget.token!.isNotEmpty) {
      return _buildErrorContent(theme, state);
    }

    // Show waiting for verification content (no token or pending)
    return _buildPendingContent(theme, state);
  }

  Widget _buildVerifyingContent(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Loading indicator
        const CircularProgressIndicator(),
        const SizedBox(height: 24),

        // Title
        Text(
          'Verifying Email',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          'Please wait while we verify your email address...',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccessContent(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mark_email_read_outlined, size: 48, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Email Verified!',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          'Your email has been verified successfully. '
          'You now have full access to all features.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Continue button
        AppButton.primary(
          onPressed: () => context.go(Routes.home),
          text: 'Continue to App',
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildErrorContent(ThemeData theme, VerifyEmailState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Verification Failed',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Error message
        Text(
          state.errorMessage ??
              'Unable to verify your email. The link may have expired or is invalid.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Resend button
        _buildResendButton(theme, state),

        const SizedBox(height: 16),

        // Back to login
        TextButton(onPressed: () => context.go(Routes.login), child: const Text('Back to Sign In')),
      ],
    );
  }

  Widget _buildPendingContent(ThemeData theme, VerifyEmailState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Email icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mail_outline, size: 48, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Verify Your Email',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          "We've sent a verification link to your email address. "
          'Please check your inbox and click the link to verify your account.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Check spam notice
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.onSurfaceVariant, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Can't find it? Check your spam folder.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Resend success message
        if (state.resendSuccess) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verification email sent successfully!',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Error message
        if (state.errorMessage != null && !state.resendSuccess) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Resend button
        _buildResendButton(theme, state),

        const SizedBox(height: 24),

        // Already verified link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already verified? ', style: theme.textTheme.bodyMedium),
            TextButton(onPressed: () => context.go(Routes.home), child: const Text('Continue')),
          ],
        ),
      ],
    );
  }

  Widget _buildResendButton(ThemeData theme, VerifyEmailState state) {
    String buttonText;
    if (state.isResending) {
      buttonText = 'Sending...';
    } else if (state.resendCooldown > 0) {
      buttonText = 'Resend in ${state.resendCooldown}s';
    } else {
      buttonText = 'Resend Verification Email';
    }

    return AppButton.secondary(
      onPressed: state.isResendDisabled ? null : _handleResendEmail,
      text: buttonText,
      isLoading: state.isResending,
      width: double.infinity,
    );
  }
}
