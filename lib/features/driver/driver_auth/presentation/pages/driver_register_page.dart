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

/// Driver Registration page (Figma-accurate).
///
/// Note: The full driver registration requires many fields (national ID,
/// vehicle info, etc.). This page collects the basic info first; additional
/// fields will be handled in a multi-step flow.
class DriverRegisterPage extends ConsumerStatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  ConsumerState<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends ConsumerState<DriverRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordsDoNotMatch),
          backgroundColor: AuthDesignConstants.error,
        ),
      );
      return;
    }

    // Driver registration requires many fields. We pass defaults for the
    // fields that aren't collected on this screen yet (multi-step later).
    await ref
        .read(driverAuthControllerProvider.notifier)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: password,
          passwordConfirmation: confirm,
          countryId: 1,
          governorateId: 1,
          cityId: 1,
          birthdate: '1990-01-01',
          gender: 'male',
          nationalId: '',
          nationalIdImage: '',
          drivingLicenseImage: '',
          vehicleLicenseImage: '',
          vehicleImage: '',
          vehicleTypeId: 1,
          vehiclePlateNumber: '',
        );

    if (mounted) {
      final state = ref.read(driverAuthControllerProvider);
      if (state.isAuthenticated) {
        context.go(
          Routes.verifyPhone,
          extra: {'phone': _phoneController.text.trim(), 'flowContext': 'driverRegistration'},
        );
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
      appBarTitle: l10n.driverRegistration,
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
                      label: l10n.fullName,
                      hintText: l10n.enterFullName,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _emailFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      label: l10n.email,
                      hintText: l10n.enterEmailAddress,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
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
