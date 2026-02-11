import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Company Admin Forgot Password page (Figma-accurate).
class CompanyForgotPasswordPage extends ConsumerStatefulWidget {
  const CompanyForgotPasswordPage({super.key});

  @override
  ConsumerState<CompanyForgotPasswordPage> createState() => _CompanyForgotPasswordPageState();
}

class _CompanyForgotPasswordPageState extends ConsumerState<CompanyForgotPasswordPage> {
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

    final params = CompanyForgetPasswordParameters(phone: phone, phoneIsoCode: 'EG');

    await ref.read(companyAuthControllerProvider.notifier).forgetPassword(params);

    if (mounted) {
      final state = ref.read(companyAuthControllerProvider);
      state.maybeWhen(
        verificationCodeSent: () {
          context.go(
            Routes.verifyPhone,
            extra: {'phone': phone, 'flowContext': 'companyForgotPassword'},
          );
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
