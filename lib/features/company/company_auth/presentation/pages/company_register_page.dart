import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_register_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Company Admin Registration page (Figma-accurate).
class CompanyRegisterPage extends ConsumerStatefulWidget {
  const CompanyRegisterPage({super.key});

  @override
  ConsumerState<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends ConsumerState<CompanyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _nicknameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _nicknameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = CompanyRegisterParameters(
      companyType: 'individual',
      name: _nameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      phone: _phoneController.text.trim(),
      phoneIso2Code: 'EG',
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
      countryId: 1,
      governorateId: 1,
      birthdate: '1990-01-01',
      gender: 'male',
    );

    await ref.read(companyAuthControllerProvider.notifier).register(params);

    if (mounted) {
      final state = ref.read(companyAuthControllerProvider);
      state.maybeWhen(
        authenticated: () {
          context.go(
            Routes.verifyPhone,
            extra: {
              'role': 'company',
              'phone': _phoneController.text.trim(),
              'flowContext': 'companyRegistration',
            },
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
      appBarTitle: l10n.companyRegistration,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AuthDesignConstants.cardBorderRadius),
                ),
                child: Column(
                  children: [
                    AuthTextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      label: l10n.companyName,
                      hintText: l10n.enterCompanyName,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _nicknameFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _nicknameController,
                      focusNode: _nicknameFocusNode,
                      label: l10n.nickname,
                      hintText: l10n.enterNickname,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _phoneFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 16),
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
                      hintText: l10n.createPassword,
                      isVisible: !_obscurePassword,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      onToggleVisibility: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
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
                      hintText: l10n.confirmPasswordHint,
                      isVisible: !_obscureConfirm,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      onSubmitted: (_) => _handleRegister(),
                    ),
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      text: l10n.createAccount,
                      isLoading: isLoading,
                      onPressed: _handleRegister,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: AuthFooterLink(
                  text: '${l10n.alreadyHaveAccount} ',
                  actionText: l10n.signIn,
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
