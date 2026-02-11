import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/controllers/driver_auth_controller.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/providers/driver_auth_providers.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Driver Reset Password page (Figma-accurate).
class DriverResetPasswordPage extends ConsumerStatefulWidget {
  final String? phone;
  final String? otp;
  const DriverResetPasswordPage({super.key, this.phone, this.otp});

  @override
  ConsumerState<DriverResetPasswordPage> createState() => _DriverResetPasswordPageState();
}

class _DriverResetPasswordPageState extends ConsumerState<DriverResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    if (password.isEmpty || confirm.isEmpty) return;
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordsDoNotMatch),
          backgroundColor: AuthDesignConstants.error,
        ),
      );
      return;
    }

    await ref
        .read(driverAuthControllerProvider.notifier)
        .resetPassword(
          code: widget.otp ?? '',
          phone: widget.phone ?? '',
          password: password,
          passwordConfirmation: confirm,
        );

    if (mounted) {
      final state = ref.read(driverAuthControllerProvider);
      if (state.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.passwordResetSuccess), backgroundColor: Colors.green),
        );
        context.go(Routes.driverLogin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverAuthControllerProvider);
    final isLoading = state.isLoading;
    final l10n = AppLocalizations.of(context)!;

    ref.listen<DriverAuthState>(driverAuthControllerProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AuthDesignConstants.error),
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
              l10n.resetPasswordDriverDescription,
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
                    isVisible: !_obscurePassword,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.next,
                    onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
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
                    isVisible: !_obscureConfirm,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.done,
                    onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    onSubmitted: (_) => _handleReset(),
                  ),
                  const SizedBox(height: 24),
                  AuthPrimaryButton(
                    text: l10n.resetPassword,
                    isLoading: isLoading,
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
