import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Consumer Forgot Password page (Figma-accurate).
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

  Future<void> _handleSubmit() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    ref.read(forgotPasswordControllerProvider.notifier).setPhone(phone);
    final success = await ref.read(forgotPasswordControllerProvider.notifier).sendResetEmail();

    if (success && mounted) {
      context.go(Routes.verifyPhone, extra: {'phone': phone, 'flowContext': 'forgotPassword'});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<ForgotPasswordState>(forgotPasswordControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AuthDesignConstants.error),
        );
      }
    });

    return AuthScaffold(
      appBarTitle: l10n.forgotPassword,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              l10n.forgotPasswordDescription,
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
                  PhoneInputField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    label: l10n.phoneNumber,
                    hintText: l10n.enterPhoneNumber,
                    enabled: !state.isLoading,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        ref.read(forgotPasswordControllerProvider.notifier).setPhone(value),
                    onSubmitted: (_) => _nationalIdFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _nationalIdController,
                    focusNode: _nationalIdFocusNode,
                    label: l10n.nationalId,
                    hintText: l10n.enterNationalId,
                    enabled: !state.isLoading,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                  const SizedBox(height: 24),
                  AuthPrimaryButton(
                    text: l10n.sendVerificationCode,
                    isLoading: state.isLoading,
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: AuthFooterLink(
                text: '${l10n.rememberPassword} ',
                actionText: l10n.signIn,
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
