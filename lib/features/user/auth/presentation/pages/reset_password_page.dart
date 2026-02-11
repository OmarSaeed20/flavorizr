import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/reset_password_controller.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Consumer Reset Password page (Figma-accurate).
class ResetPasswordPage extends ConsumerStatefulWidget {
  final String? token;
  final String? phone;
  final String? otp;
  const ResetPasswordPage({super.key, this.token, this.phone, this.otp});

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
    if (widget.token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(resetPasswordControllerProvider.notifier).setToken(widget.token!);
      });
    }
    if (widget.phone != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(resetPasswordControllerProvider.notifier).setPhone(widget.phone!);
      });
    }
    if (widget.otp != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(resetPasswordControllerProvider.notifier).setOtp(widget.otp!);
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final l10n = AppLocalizations.of(context)!;
    await ref.read(resetPasswordControllerProvider.notifier).resetPassword();

    if (mounted) {
      final state = ref.read(resetPasswordControllerProvider);
      if (!state.isLoading && state.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.passwordResetSuccess), backgroundColor: Colors.green),
        );
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<ResetPasswordState>(resetPasswordControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AuthDesignConstants.error),
        );
      }
    });

    return AuthScaffold(
      appBarTitle: l10n.resetPassword,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              l10n.resetPasswordDescription,
              style: const TextStyle(
                color: AuthDesignConstants.textSecondary,
                fontSize: 14,
                fontFamily: AuthDesignConstants.fontBody,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDesignConstants.cardBorderRadius),
              ),
              child: Column(
                children: [
                  AuthPasswordField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    label: l10n.newPassword,
                    hintText: l10n.enterNewPassword,
                    errorText: state.passwordError,
                    isVisible: state.showPassword,
                    enabled: !state.isLoading,
                    textInputAction: TextInputAction.next,
                    onToggleVisibility: () => ref
                        .read(resetPasswordControllerProvider.notifier)
                        .togglePasswordVisibility(),
                    onChanged: (value) =>
                        ref.read(resetPasswordControllerProvider.notifier).setNewPassword(value),
                    onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.passwordRequirements,
                      style: const TextStyle(
                        color: AuthDesignConstants.textTertiary,
                        fontSize: 10,
                        fontFamily: AuthDesignConstants.fontBody,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    label: l10n.confirmPassword,
                    hintText: l10n.confirmNewPassword,
                    errorText: state.confirmPasswordError,
                    isVisible: state.showConfirmPassword,
                    enabled: !state.isLoading,
                    textInputAction: TextInputAction.done,
                    onToggleVisibility: () => ref
                        .read(resetPasswordControllerProvider.notifier)
                        .toggleConfirmPasswordVisibility(),
                    onChanged: (value) => ref
                        .read(resetPasswordControllerProvider.notifier)
                        .setConfirmPassword(value),
                    onSubmitted: (_) => _handleReset(),
                  ),
                  const SizedBox(height: 24),
                  AuthPrimaryButton(
                    text: l10n.resetPassword,
                    isLoading: state.isLoading,
                    onPressed: _handleReset,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
