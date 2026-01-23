// lib/features/auth/presentation/pages/login_page.dart
import 'dart:io';

import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/auth/presentation/controllers/login_controller.dart';
import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/auth/presentation/widgets/social_login_buttons.dart';
import 'package:flavorizr/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flavorizr/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Login page for email/password and social authentication.
///
/// Features:
/// - Email/password login form
/// - Google and Apple sign-in
/// - Biometric authentication (if available)
/// - Links to register and forgot password
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    context.go(Routes.home);
    // if (_formKey.currentState?.validate() ?? false) {
    //   final result = await ref.read(loginControllerProvider.notifier).login();

    //   if (result != null && mounted) {
    //     // Navigate to home on success
    //     context.go(Routes.home);
    //   }
    // }
  }

  Future<void> _handleGoogleSignIn() async {
    final result = await ref.read(loginControllerProvider.notifier).signInWithGoogle();

    if (result != null && mounted) {
      context.go(Routes.home);
    }
  }

  Future<void> _handleAppleSignIn() async {
    final result = await ref.read(loginControllerProvider.notifier).signInWithApple();

    if (result != null && mounted) {
      context.go(Routes.home);
    }
  }

  Future<void> _handleBiometricSignIn() async {
    final result = await ref.read(loginControllerProvider.notifier).signInWithBiometrics();

    if (result != null && mounted) {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(loginControllerProvider);
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);

    // Get biometric values safely
    final isBiometricAvailable = biometricAvailable.when(
      data: (value) => value,
      loading: () => false,
      error: (_, __) => false,
    );
    final isBiometricEnabled = biometricEnabled.when(
      data: (value) => value,
      loading: () => false,
      error: (_, __) => false,
    );

    return Scaffold(
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
                    // Logo/Icon
                    Icon(Icons.lock_outline, size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Sign in to continue',
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

                    // Email field
                    EmailTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      label: 'Email',
                      hint: 'Enter your email',
                      errorText: state.emailError,
                      enabled: !state.isAnyLoading,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) =>
                          ref.read(loginControllerProvider.notifier).setEmail(value),
                      onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    PasswordTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      label: 'Password',
                      hint: 'Enter your password',
                      errorText: state.passwordError,
                      isVisible: state.showPassword,
                      enabled: !state.isAnyLoading,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onToggleVisibility: () =>
                          ref.read(loginControllerProvider.notifier).togglePasswordVisibility(),
                      onChanged: (value) =>
                          ref.read(loginControllerProvider.notifier).setPassword(value),
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: 8),

                    // Remember me & Forgot password row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember me checkbox
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: state.rememberMe,
                                onChanged: state.isAnyLoading
                                    ? null
                                    : (_) => ref
                                          .read(loginControllerProvider.notifier)
                                          .toggleRememberMe(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Remember me', style: theme.textTheme.bodySmall),
                          ],
                        ),

                        // Forgot password link
                        TextButton(
                          onPressed: state.isAnyLoading
                              ? null
                              : () => context.push(Routes.forgotPassword),
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    AppButton.primary(
                      onPressed: state.isAnyLoading ? null : _handleLogin,
                      text: 'Sign In',
                      isLoading: state.isLoading,
                      loadingText: 'Signing in...',
                      width: double.infinity,
                    ),

                    // Biometric button (if available and enabled)
                    if (isBiometricAvailable && isBiometricEnabled) ...[
                      const SizedBox(height: 12),
                      AppButton.outlined(
                        onPressed: state.isAnyLoading ? null : _handleBiometricSignIn,
                        text: 'Sign in with Biometrics',
                        icon: Icon(Platform.isIOS ? Icons.face : Icons.fingerprint),
                        isLoading: state.isBiometricLoading,
                      ),
                    ],

                    // OR divider
                    const OrDivider(),

                    // Social login buttons
                    SocialLoginButtons(
                      onGooglePressed: state.isAnyLoading ? null : _handleGoogleSignIn,
                      onApplePressed: state.isAnyLoading ? null : _handleAppleSignIn,
                      isGoogleLoading: state.isGoogleLoading,
                      isAppleLoading: state.isAppleLoading,
                    ),

                    const SizedBox(height: 32),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: state.isAnyLoading
                              ? null
                              : () => context.push(Routes.register),
                          child: const Text('Sign Up'),
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
