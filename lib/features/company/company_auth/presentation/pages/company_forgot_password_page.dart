// lib/features/company/company_auth/presentation/pages/company_forgot_password_page.dart
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/widgets/company_phone_input_widget.dart';
import 'package:fast_golden_taxi/shared/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Company Forgot Password Page
///
/// Page for initiating password reset.
/// Sends verification code to company phone.
class CompanyForgotPasswordPage extends ConsumerStatefulWidget {
  const CompanyForgotPasswordPage({super.key});

  @override
  ConsumerState<CompanyForgotPasswordPage> createState() =>
      _CompanyForgotPasswordPageState();
}

class _CompanyForgotPasswordPageState
    extends ConsumerState<CompanyForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneIsoCodeController = TextEditingController(text: 'EG');

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneIsoCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parameters = CompanyForgetPasswordParameters(
      phone: _phoneController.text.trim(),
      phoneIsoCode: _phoneIsoCodeController.text.trim(),
    );

    await ref
        .read(companyAuthControllerProvider.notifier)
        .forgetPassword(parameters);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(companyAuthControllerProvider);

    ref.listen<CompanyAuthState>(companyAuthControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        passwordResetRequested: () {
          context.push(
            '/company/reset-password',
            extra: {
              'phone': _phoneController.text.trim(),
              'phoneIsoCode': _phoneIsoCodeController.text.trim(),
            },
          );
        },
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppColors.of(context).error,
            ),
          );
        },
        orElse: () {},
      );
    });

    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
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
                    // Icon
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: 60,
                          color: AppColors.of(context).primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      'Forgot Password?',
                      style: AppTextStyles.of(context).headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your phone number to receive a verification code',
                      style: AppTextStyles.of(context).bodyMedium.copyWith(
                        color: AppColors.of(context).textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Phone Input
                    CompanyPhoneInputWidget(
                      phoneController: _phoneController,
                      phoneIsoCodeController: _phoneIsoCodeController,
                    ),
                    const SizedBox(height: 32),
                    // Send Code Button
                    ElevatedButton(
                      onPressed: _handleSendCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send Verification Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Back to Login
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Back to Login'),
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
