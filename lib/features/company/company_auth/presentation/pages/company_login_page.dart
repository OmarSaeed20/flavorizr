import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_login_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Company Admin Login page (Figma-accurate).
class CompanyLoginPage extends ConsumerStatefulWidget {
  const CompanyLoginPage({super.key});

  @override
  ConsumerState<CompanyLoginPage> createState() => _CompanyLoginPageState();
}

class _CompanyLoginPageState extends ConsumerState<CompanyLoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    if (phone.isEmpty || password.isEmpty) return;

    final params = CompanyLoginParameters(
      phone: phone,
      phoneIsoCode: 'EG',
      password: password,
      firebaseToken: '',
    );

    await ref.read(companyAuthControllerProvider.notifier).login(params);

    if (mounted) {
      final state = ref.read(companyAuthControllerProvider);
      state.maybeWhen(
        authenticated: () {
          context.go(Routes.companyDashboard);
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
      appBarTitle: l10n.companySignIn,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    label: l10n.phone,
                    hintText: l10n.enterPhoneNumber,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    label: l10n.password,
                    hintText: l10n.enterPassword,
                    isVisible: !_obscurePassword,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.done,
                    onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                    onSubmitted: (_) => _handleLogin(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: isLoading ? null : () => context.go(Routes.companyForgotPassword),
                      child: Text(
                        l10n.forgotPassword,
                        style: const TextStyle(
                          color: AuthDesignConstants.primary,
                          fontSize: 12,
                          fontFamily: AuthDesignConstants.fontBody,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AuthPrimaryButton(
                    text: l10n.signIn,
                    isLoading: isLoading,
                    onPressed: _handleLogin,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: AuthFooterLink(
                text: '${l10n.dontHaveAccount} ',
                actionText: l10n.signUp,
                onPressed: () => context.go(Routes.companyRegister),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
