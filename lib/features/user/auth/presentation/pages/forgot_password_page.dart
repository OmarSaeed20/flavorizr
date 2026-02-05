// lib/features/auth/presentation/pages/forgot_password_page.dart
import 'package:flavorizr/features/user/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:flavorizr/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flavorizr/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Forgot password page for requesting password reset.
///
/// Features:
/// - Phone input for password reset request
/// - Success confirmation with instructions
/// - Return to login option
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(forgotPasswordControllerProvider.notifier).sendResetEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(forgotPasswordControllerProvider);

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
          child: Icon(Icons.mark_email_read_outlined, size: 48, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Check your email',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          "We've sent password reset instructions to your email address. "
          'Please check your inbox and follow the link to reset your password.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Phone display
        Text(
          _phoneController.text,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Back to login button
        AppButton.primary(
          onPressed: () => context.pop(),
          text: 'Back to Sign In',
          width: double.infinity,
        ),

        const SizedBox(height: 16),

        // Resend link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Didn't receive the email? ", style: theme.textTheme.bodyMedium),
            TextButton(
              onPressed: () {
                ref.read(forgotPasswordControllerProvider.notifier).reset();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormContent(ThemeData theme, ForgotPasswordState state) {
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
            'Forgot Password?',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            "Enter your email address and we'll send you instructions to reset your password.",
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

          // Phone field
          AppTextField(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            label: 'Phone',
            hint: 'Enter your phone number',
            errorText: state.phoneError,
            enabled: !state.isLoading,
            autofocus: true,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            onChanged: (value) =>
                ref.read(forgotPasswordControllerProvider.notifier).setPhone(value),
            onSubmitted: (_) => _handleSendResetEmail(),
          ),
          const SizedBox(height: 24),

          // Submit button
          AppButton.primary(
            onPressed: state.isLoading ? null : _handleSendResetEmail,
            text: 'Send Reset Link',
            isLoading: state.isLoading,
            loadingText: 'Sending...',
            width: double.infinity,
          ),

          const SizedBox(height: 24),

          // Back to login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Remember your password? ', style: theme.textTheme.bodyMedium),
              TextButton(
                onPressed: state.isLoading ? null : () => context.pop(),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
