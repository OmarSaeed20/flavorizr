// lib/features/auth/presentation/pages/reset_password_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/reset_password_controller.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Reset Password page (Figma-accurate).
///
/// Layout:
/// - Background #F2F2F2 with back button
/// - 250x250 illustration centered
/// - Bottom sheet with title, subtitle, password + confirm password fields,
///   Continue button
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, this.token});

  /// The password reset token from the verification flow.
  final String? token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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

  Future<void> _handleContinue() async {
    await ref.read(resetPasswordControllerProvider.notifier).resetPassword();
    if (mounted) {
      final state = ref.read(resetPasswordControllerProvider);
      if (state.isSuccess) {
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordControllerProvider);

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
                  'assets/images/reset_password.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.lock_outline,
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
                title: 'Reset Password',
                subtitle: 'Please enter your new password',
              ),

              // Password field
              AuthPasswordField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                label: 'Password',
                hintText: 'Enter your password',
                errorText: state.passwordError,
                isVisible: state.showPassword,
                enabled: !state.isLoading,
                textInputAction: TextInputAction.next,
                onToggleVisibility: () =>
                    ref.read(resetPasswordControllerProvider.notifier).togglePasswordVisibility(),
                onChanged: (value) =>
                    ref.read(resetPasswordControllerProvider.notifier).setNewPassword(value),
                onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
              ),

              // Confirm Password field
              AuthPasswordField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                label: 'Confirm Password',
                hintText: 'Enter your password',
                errorText: state.confirmPasswordError,
                isVisible: state.showConfirmPassword,
                enabled: !state.isLoading,
                textInputAction: TextInputAction.done,
                onToggleVisibility: () => ref
                    .read(resetPasswordControllerProvider.notifier)
                    .toggleConfirmPasswordVisibility(),
                onChanged: (value) =>
                    ref.read(resetPasswordControllerProvider.notifier).setConfirmPassword(value),
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
