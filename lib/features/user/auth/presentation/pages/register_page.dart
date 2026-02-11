// lib/features/auth/presentation/pages/register_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/register_controller.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/widgets/social_login_buttons.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/buttons/app_button.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/inputs/app_text_field.dart';
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

  bool _isEnglish = true;

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
      backgroundColor: const Color(0xFFF2F5F4),
      body: Column(
        children: [
          // White header
          Container(
            height: 109,
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Transform.rotate(
                        angle: 3.14,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                          color: Color(0xFF353535),
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    // Title
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Color(0xFF353535),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.56,
                      ),
                    ),
                    // Language toggle
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEnglish = !_isEnglish;
                        });
                      },
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: _isEnglish ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _isEnglish ? 'EN' : 'AR',
                            style: TextStyle(
                              color: _isEnglish ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Error message
                          if (state.errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: theme.colorScheme.error,
                                    size: 20,
                                  ),
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
                          ],

                          // Display name field
                          AppTextField(
                            controller: _displayNameController,
                            focusNode: _displayNameFocusNode,
                            label: 'Name',
                            hint: 'Enter your name',
                            errorText: state.displayNameError,
                            enabled: !state.isLoading,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            autofillHints: const [AutofillHints.name],
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
                            onToggleVisibility: () => ref
                                .read(registerControllerProvider.notifier)
                                .togglePasswordVisibility(),
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
                            onChanged: (value) => ref
                                .read(registerControllerProvider.notifier)
                                .setConfirmPassword(value),
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
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _showTermsDialog,
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _showTermsDialog,
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = state.isLoading ? null : () => context.pop(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom sheet with social login
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 56),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Social login buttons
                SocialLoginButtons(
                  onGooglePressed: state.isLoading
                      ? null
                      : () {
                          // Handle Google sign-up
                        },
                  onApplePressed: state.isLoading
                      ? null
                      : () {
                          // Handle Apple sign-up
                        },
                ),
                const SizedBox(height: 24),

                // Terms text
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666666)),
                    children: [
                      const TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms of Service',
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
              ],
            ),
          ),

          // Home indicator
          Container(
            height: 32,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Container(
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
