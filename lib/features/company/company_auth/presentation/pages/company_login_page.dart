// lib/features/company/company_auth/presentation/pages/company_login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_login_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/widgets/company_phone_input_widget.dart';
import 'package:fast_golden_taxi/shared/widgets/loading_overlay.dart';

/// Company Login Page
///
/// Login page for company accounts.
/// Supports phone number and password authentication.
class CompanyLoginPage extends ConsumerStatefulWidget {
  const CompanyLoginPage({super.key});

  @override
  ConsumerState<CompanyLoginPage> createState() => _CompanyLoginPageState();
}

class _CompanyLoginPageState extends ConsumerState<CompanyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneIsoCodeController = TextEditingController(text: 'EG');
  bool _obscurePassword = true;
  bool _rememberMe = false;

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

    final parameters = CompanyLoginParameters(
      phone: _phoneController.text.trim(),
      phoneIsoCode: _phoneIsoCodeController.text.trim(),
      password: _passwordController.text,
      firebaseToken: 'firebase_token_placeholder', // TODO: Get from Firebase
    );

    await ref.read(companyAuthControllerProvider.notifier).login(parameters);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(companyAuthControllerProvider);

    ref.listen<CompanyAuthState>(companyAuthControllerProvider, (previous, next) {
      next.maybeWhen(
        authenticated: () {
          context.go('/company/home');
        },
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message), backgroundColor: AppColors.of(context).error),
          );
        },
        orElse: () {},
      );
    });

    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    // Logo
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.business, size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      'Company Login',
                      style: AppTextStyles.of(context).headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome back! Login to manage your fleet',
                      style: AppTextStyles.of(
                        context,
                      ).bodyMedium.copyWith(color: AppColors.of(context).textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Phone Input
                    CompanyPhoneInputWidget(
                      phoneController: _phoneController,
                      phoneIsoCodeController: _phoneIsoCodeController,
                    ),
                    const SizedBox(height: 24),
                    // Password Input
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Remember Me & Forgot Password
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            context.push('/company/forgot-password');
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Login Button
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.of(context).bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/company/register');
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Back to Role Selection
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Back to Role Selection'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}
