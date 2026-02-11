import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/providers/driver_auth_providers.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Driver Forgot Password page (Figma-accurate).
class DriverForgotPasswordPage extends ConsumerStatefulWidget {
  const DriverForgotPasswordPage({super.key});

  @override
  ConsumerState<DriverForgotPasswordPage> createState() => _DriverForgotPasswordPageState();
}

class _DriverForgotPasswordPageState extends ConsumerState<DriverForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    context.go(Routes.verifyPhone, extra: {'phone': phone, 'flowContext': 'driverForgotPassword'});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverAuthControllerProvider);
    final isLoading = state.isLoading;
    final l10n = AppLocalizations.of(context)!;

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
                    enabled: !isLoading,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                  const SizedBox(height: 24),
                  AuthPrimaryButton(
                    text: l10n.sendVerificationCode,
                    isLoading: isLoading,
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
