// lib/features/auth/presentation/pages/register_page.dart
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/user/auth/presentation/controllers/register_controller.dart';
import 'package:flavorizr/features/user/auth/presentation/widgets/social_login_buttons.dart';
import 'package:flavorizr/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flavorizr/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Registration page for creating new accounts.
///
/// Features:
/// - Phone/password registration form
/// - Password strength validation
/// - Terms and conditions acceptance
/// - Social sign-up options
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _displayNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final result = await ref.read(registerControllerProvider.notifier).register();

      if (result != null && mounted) {
        // Navigate to home on success
        context.go(Routes.home);
      }
    }
  }

  void _showTermsDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'By creating an account, you agree to our Terms of Service and Privacy Policy. '
            'You must be at least 13 years old to use this service.\n\n'
            'We collect and process your personal data in accordance with our Privacy Policy. '
            'You can withdraw your consent at any time by deleting your account.',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(registerControllerProvider);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'Create Account',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Sign up to get started',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
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

                    // Display name field (optional)
                    AppTextField(
                      controller: _displayNameController,
                      focusNode: _displayNameFocusNode,
                      label: 'Name (optional)',
                      hint: 'Enter your name',
                      errorText: state.displayNameError,
                      enabled: !state.isLoading,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      prefixIcon: const Icon(Icons.person_outline),
                      onChanged: (value) =>
                          ref.read(registerControllerProvider.notifier).setDisplayName(value),
                      onSubmitted: (_) => _phoneFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 16),

                    // Phone field
                    AppTextField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      label: 'Phone',
                      hint: 'Enter your phone number',
                      errorText: state.phoneError,
                      enabled: !state.isLoading,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) =>
                          ref.read(registerControllerProvider.notifier).setPhone(value),
                      onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    PasswordTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      label: 'Password',
                      hint: 'Create a password',
                      errorText: state.passwordError,
                      isVisible: state.showPassword,
                      enabled: !state.isLoading,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      onToggleVisibility: () =>
                          ref.read(registerControllerProvider.notifier).togglePasswordVisibility(),
                      onChanged: (value) =>
                          ref.read(registerControllerProvider.notifier).setPassword(value),
                      onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 4),

                    // Password requirements hint
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '8+ characters, uppercase, lowercase, and a number',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    PasswordTextField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      errorText: state.confirmPasswordError,
                      isVisible: state.showConfirmPassword,
                      enabled: !state.isLoading,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      onToggleVisibility: () => ref
                          .read(registerControllerProvider.notifier)
                          .toggleConfirmPasswordVisibility(),
                      onChanged: (value) =>
                          ref.read(registerControllerProvider.notifier).setConfirmPassword(value),
                      onSubmitted: (_) => _handleRegister(),
                    ),
                    const SizedBox(height: 16),

                    // Terms and conditions checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: state.acceptedTerms,
                            onChanged: state.isLoading
                                ? null
                                : (_) => ref
                                      .read(registerControllerProvider.notifier)
                                      .toggleTermsAcceptance(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodySmall,
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = _showTermsDialog,
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = _showTermsDialog,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    AppButton.primary(
                      onPressed: state.isLoading ? null : _handleRegister,
                      text: 'Create Account',
                      isLoading: state.isLoading,
                      loadingText: 'Creating account...',
                      width: double.infinity,
                    ),

                    // OR divider
                    const OrDivider(text: 'OR SIGN UP WITH'),

                    // Social sign-up buttons
                    SocialLoginButtons(
                      onGooglePressed: state.isLoading
                          ? null
                          : () {
                              // Handle Google sign-up (same as sign-in for OAuth)
                            },
                      onApplePressed: state.isLoading
                          ? null
                          : () {
                              // Handle Apple sign-up (same as sign-in for OAuth)
                            },
                    ),

                    const SizedBox(height: 32),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: state.isLoading ? null : () => context.pop(),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
