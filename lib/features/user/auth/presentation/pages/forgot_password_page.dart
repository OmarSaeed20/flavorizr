// lib/features/auth/presentation/pages/forgot_password_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Forgot Password page (Figma-accurate).
///
/// Layout:
/// - Background #F2F2F2 with back button
/// - 250x250 illustration centered above bottom sheet
/// - Bottom sheet with title, subtitle, phone input, national ID input,
///   Continue button
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _nationalIdFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _nationalIdController.dispose();
    _phoneFocusNode.dispose();
    _nationalIdFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    await ref.read(forgotPasswordControllerProvider.notifier).sendResetEmail();
    if (mounted) {
      final state = ref.read(forgotPasswordControllerProvider);
      if (state.isSuccess) {
        context.push(
          Routes.verifyPhone,
          extra: {'phone': _phoneController.text, 'flowContext': 'forgot-password'},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);

    return AuthScaffold(
      body: Column(
        children: [
          // ── Illustration area ──
          Expanded(
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Image.asset(
                  'assets/images/forgot_password.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.lock_reset_outlined,
                    size: 120,
                    color: AuthDesignConstants.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom sheet ──
          AuthBottomSheet(
            padding: AuthDesignConstants.sheetPadding,
            children: [
              // Header
              const AuthSheetHeader(
                title: 'Forgot Password',
                subtitle: 'Enter your phone number to help us sending \nyou the verification code',
              ),

              // Phone number field
              PhoneInputField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                label: 'Phone number',
                hintText: '135 153 968 312 025',
                errorText: state.phoneError,
                enabled: !state.isLoading,
                textInputAction: TextInputAction.next,
                onChanged: (value) =>
                    ref.read(forgotPasswordControllerProvider.notifier).setPhone(value),
                onSubmitted: (_) => _nationalIdFocusNode.requestFocus(),
              ),

              // National ID field
              AuthTextField(
                controller: _nationalIdController,
                focusNode: _nationalIdFocusNode,
                label: 'National ID',
                hintText: 'Enter your National ID',
                enabled: !state.isLoading,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _handleContinue(),
              ),

              // Continue button
              AuthPrimaryButton(
                text: 'Continue ',
                isLoading: state.isLoading,
                onPressed: _handleContinue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
