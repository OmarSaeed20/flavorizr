// lib/features/consumer/consumer_auth/presentation/pages/consumer_login_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/presentation/controllers/consumer_auth_controller.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/presentation/widgets/consumer_phone_input_widget.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Consumer login page.
///
/// Allows consumers to login with phone number and password.
/// Supports biometric authentication if credentials are saved.
class ConsumerLoginPage extends ConsumerStatefulWidget {
  const ConsumerLoginPage({super.key});

  @override
  ConsumerState<ConsumerLoginPage> createState() => _ConsumerLoginPageState();
}

class _ConsumerLoginPageState extends ConsumerState<ConsumerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneIsoCodeController = TextEditingController(text: 'EG');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneIsoCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Get Firebase token from FCM service
      const firebaseToken = 'mock_firebase_token';

      await ref
          .read(consumerAuthControllerProvider.notifier)
          .login(
            phone: _phoneController.text,
            phoneIsoCode: _phoneIsoCodeController.text,
            password: _passwordController.text,
            firebaseToken: firebaseToken,
          );

      // Check if login was successful
      final authState = ref.read(consumerAuthControllerProvider);
      if (authState.isAuthenticated && mounted) {
        context.go(Routes.consumerHome);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    // TODO: Implement biometric authentication
    // 1. Check if biometric is available
    // 2. Show biometric prompt
    // 3. Get saved credentials
    // 4. Login with credentials
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(consumerAuthControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60.h),
                // Logo or app name
                Icon(
                  Icons.local_taxi_rounded,
                  size: 80.sp,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n.welcomeBack,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.loginToContinue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),
                // Phone input
                ConsumerPhoneInputWidget(
                  phoneController: _phoneController,
                  phoneIsoCodeController: _phoneIsoCodeController,
                ),
                SizedBox(height: 24.h),
                // Password input
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push(Routes.forgotPassword);
                    },
                    child: Text(l10n.forgotPassword),
                  ),
                ),
                SizedBox(height: 24.h),
                // Login button
                FilledButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.login),
                ),
                SizedBox(height: 16.h),
                // Biometric login button
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleBiometricLogin,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(l10n.loginWithBiometric),
                ),
                SizedBox(height: 32.h),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(Routes.register);
                      },
                      child: Text(l10n.register),
                    ),
                  ],
                ),
                // Error message
                if (authState.isError) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            authState.maybeWhen(
                              error: (message, _) => message,
                              orElse: () => '',
                            ),
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
