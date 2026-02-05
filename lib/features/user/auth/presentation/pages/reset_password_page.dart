// lib/features/auth/presentation/pages/reset_password_page.dart
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/user/auth/presentation/controllers/reset_password_controller.dart';
import 'package:flavorizr/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flavorizr/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Reset password page for setting a new password.
///
/// Features:
/// - New password input with strength indicator
/// - Confirm password validation
/// - Success confirmation with login redirect
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, this.token});

  /// The password reset token from the email link.
  final String? token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set the token if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.token != null && widget.token!.isNotEmpty) {
        ref.read(resetPasswordControllerProvider.notifier).setToken(widget.token!);
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(resetPasswordControllerProvider.notifier).resetPassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(resetPasswordControllerProvider);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: state.isSuccess
                  ? _buildSuccessContent(theme)
                  : _buildFormContent(theme, state),
            ),
          ),
        ),
      ),
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
          child: Icon(Icons.check_circle_outline, size: 48, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Password Reset Complete',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          'Your password has been reset successfully. '
          'You can now sign in with your new password.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Sign in button
        AppButton.primary(
          onPressed: () => context.go(Routes.login),
          text: 'Sign In',
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildFormContent(ThemeData theme, ResetPasswordState state) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(Icons.lock_reset_outlined, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 24),

          // Title
          Text(
            'Reset Password',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            "Enter your new password below. Make sure it's strong and secure.",
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Error message
          if (state.errorMessage != null) ...[
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // New password field
          PasswordTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            label: 'New Password',
            hint: 'Enter your new password',
            errorText: state.passwordError,
            isVisible: state.showPassword,
            enabled: !state.isLoading,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            onToggleVisibility: () =>
                ref.read(resetPasswordControllerProvider.notifier).togglePasswordVisibility(),
            onChanged: (value) =>
                ref.read(resetPasswordControllerProvider.notifier).setNewPassword(value),
            onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 8),

          // Password strength indicator
          _buildPasswordStrengthIndicator(theme, state.passwordStrength),
          const SizedBox(height: 16),

          // Confirm password field
          PasswordTextField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            label: 'Confirm Password',
            hint: 'Confirm your new password',
            errorText: state.confirmPasswordError,
            isVisible: state.showConfirmPassword,
            enabled: !state.isLoading,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            onToggleVisibility: () => ref
                .read(resetPasswordControllerProvider.notifier)
                .toggleConfirmPasswordVisibility(),
            onChanged: (value) =>
                ref.read(resetPasswordControllerProvider.notifier).setConfirmPassword(value),
            onSubmitted: (_) => _handleResetPassword(),
          ),
          const SizedBox(height: 24),

          // Password requirements
          _buildPasswordRequirements(theme, state.newPassword),
          const SizedBox(height: 24),

          // Submit button
          AppButton.primary(
            onPressed: state.isLoading ? null : _handleResetPassword,
            text: 'Reset Password',
            isLoading: state.isLoading,
            loadingText: 'Resetting...',
            width: double.infinity,
          ),

          const SizedBox(height: 24),

          // Back to login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Remember your password? ', style: theme.textTheme.bodyMedium),
              TextButton(
                onPressed: state.isLoading ? null : () => context.go(Routes.login),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(ThemeData theme, PasswordStrength strength) {
    final colors = {
      PasswordStrength.weak: theme.colorScheme.error,
      PasswordStrength.fair: Colors.orange,
      PasswordStrength.good: Colors.amber,
      PasswordStrength.strong: Colors.green,
    };

    final labels = {
      PasswordStrength.weak: 'Weak',
      PasswordStrength.fair: 'Fair',
      PasswordStrength.good: 'Good',
      PasswordStrength.strong: 'Strong',
    };

    final progress = {
      PasswordStrength.weak: 0.25,
      PasswordStrength.fair: 0.5,
      PasswordStrength.good: 0.75,
      PasswordStrength.strong: 1.0,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password Strength: ',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              labels[strength]!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors[strength],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress[strength],
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(colors[strength]!),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements(ThemeData theme, String password) {
    final requirements = [
      (label: 'At least 8 characters', met: password.length >= 8),
      (label: 'One uppercase letter', met: password.contains(RegExp('[A-Z]'))),
      (label: 'One lowercase letter', met: password.contains(RegExp('[a-z]'))),
      (label: 'One number', met: password.contains(RegExp('[0-9]'))),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password must contain:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...requirements.map(
          (req) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  req.met ? Icons.check_circle : Icons.circle_outlined,
                  size: 16,
                  color: req.met ? Colors.green : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  req.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: req.met ? Colors.green : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
