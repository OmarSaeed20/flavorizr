import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Company Admin Reset Password page (Figma-accurate).
class CompanyResetPasswordPage extends ConsumerStatefulWidget {
  final String? phone;
  final String? verificationCode;
  const CompanyResetPasswordPage({super.key, this.phone, this.verificationCode});

  @override
  ConsumerState<CompanyResetPasswordPage> createState() => _CompanyResetPasswordPageState();
}

class _CompanyResetPasswordPageState extends ConsumerState<CompanyResetPasswordPage> {
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

    final params = CompanyResetPasswordParameters(
      phone: widget.phone ?? '',
      phoneIsoCode: 'EG',
      confirmationCode: widget.verificationCode ?? '',
      password: password,
      passwordConfirmation: confirm,
    );

    await ref.read(companyAuthControllerProvider.notifier).resetPassword(params);

    if (mounted) {
      final state = ref.read(companyAuthControllerProvider);
      state.maybeWhen(
        passwordReset: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.passwordResetSuccess), backgroundColor: Colors.green),
          );
          context.go(Routes.companyLogin);
        },
        orElse: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companyAuthControllerProvider);
    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(companyAuthControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (exception) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(exception.toString()),
              backgroundColor: AuthDesignConstants.error,
            ),
          );
        },
        orElse: () {},
      );
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
              l10n.resetPasswordCompanyDescription,
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
