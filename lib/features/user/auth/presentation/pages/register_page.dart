import 'package:fast_golden_taxi/core/router/route_navigation.dart';
import 'package:fast_golden_taxi/core/theme/app_theme.dart';
import 'package:fast_golden_taxi/features/auth/otp/presentation/controllers/otp_controller.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/register_controller.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/widgets/social_login_buttons.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Consumer Registration page (Figma-accurate).
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();

  late String _role;

  @override
  void initState() {
    super.initState();
    // Get role from navigation state
    final state = GoRouterState.of(context);
    final extra = state.extra as Map<String, dynamic>?;
    _role = extra?['role'] as String? ?? 'customer';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _displayNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final result = await ref.read(registerControllerProvider.notifier).register();
      if (result != null && mounted) {
        // Determine the correct flow context based on role
        final flowContext = switch (_role.toLowerCase()) {
          'driver' => OtpFlowContext.driverRegistration,
          'company' => OtpFlowContext.companyRegistration,
          _ => OtpFlowContext.registration,
        };

        // Navigate to OTP verification after successful registration
        RouteNavigation.navigateToVerifyPhone(
          _role,
          phone: _phoneController.text.trim(),
          flowContext: flowContext,
        );
      }
    }
  }

  void _showTermsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.termsAndConditions),
        content: const SingleChildScrollView(
          child: Text(
            'By creating an account, you agree to our Terms of Service '
            'and Privacy Policy. You must be at least 13 years old to use '
            'this service.',
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.close))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AuthDesignConstants.error),
        );
      }
    });

    return Scaffold(
      backgroundColor: AuthDesignConstants.backgroundAlt,
      body: Column(
        children: [
          // White header bar
          ColoredBox(
            color: context.colorScheme.surface,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: AuthDesignConstants.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.createAccount,
                          textAlign: TextAlign.center,
                          style: AuthDesignConstants.appBarTitle,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Form content
          Expanded(
            child: SingleChildScrollView(
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
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(AuthDesignConstants.cardBorderRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthTextField(
                            controller: _displayNameController,
                            focusNode: _displayNameFocusNode,
                            label: l10n.name,
                            hintText: l10n.enterName,
                            errorText: state.displayNameError,
                            enabled: !state.isLoading,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) =>
                                ref.read(registerControllerProvider.notifier).setDisplayName(value),
                            onSubmitted: (_) => _phoneFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 16),
                          PhoneInputField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            label: l10n.phone,
                            hintText: l10n.enterPhoneNumber,
                            errorText: state.phoneError,
                            enabled: !state.isLoading,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) =>
                                ref.read(registerControllerProvider.notifier).setPhone(value),
                            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 16),
                          AuthPasswordField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            label: l10n.password,
                            hintText: l10n.createPassword,
                            errorText: state.passwordError,
                            isVisible: state.showPassword,
                            enabled: !state.isLoading,
                            textInputAction: TextInputAction.next,
                            onToggleVisibility: () => ref
                                .read(registerControllerProvider.notifier)
                                .togglePasswordVisibility(),
                            onChanged: (value) =>
                                ref.read(registerControllerProvider.notifier).setPassword(value),
                            onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                            errorText: state.confirmPasswordError,
                            isVisible: state.showConfirmPassword,
                            enabled: !state.isLoading,
                            textInputAction: TextInputAction.done,
                            onToggleVisibility: () => ref
                                .read(registerControllerProvider.notifier)
                                .toggleConfirmPasswordVisibility(),
                            onChanged: (value) => ref
                                .read(registerControllerProvider.notifier)
                                .setConfirmPassword(value),
                            onSubmitted: (_) => _handleRegister(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: state.acceptedTerms,
                                  activeColor: AuthDesignConstants.primary,
                                  onChanged: state.isLoading
                                      ? null
                                      : (_) => ref
                                            .read(registerControllerProvider.notifier)
                                            .toggleTermsAcceptance(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: AuthDesignConstants.textTertiary,
                                      fontSize: 12,
                                      fontFamily: AuthDesignConstants.fontBody,
                                    ),
                                    children: [
                                      TextSpan(text: l10n.agreeToTerms),
                                      TextSpan(
                                        text: l10n.termsConditions,
                                        style: const TextStyle(
                                          color: AuthDesignConstants.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _showTermsDialog,
                                      ),
                                      TextSpan(text: ' ${l10n.and} '),
                                      TextSpan(
                                        text: l10n.privacyPolicy,
                                        style: const TextStyle(
                                          color: AuthDesignConstants.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _showTermsDialog,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          AuthPrimaryButton(
                            text: l10n.createAccount,
                            isLoading: state.isLoading,
                            isEnabled: state.acceptedTerms,
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
          ),
          // Bottom sheet with social login
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AuthDesignConstants.bottomSheetRadius),
                topRight: Radius.circular(AuthDesignConstants.bottomSheetRadius),
              ),
              boxShadow: const [AuthDesignConstants.bottomSheetShadow],
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SocialLoginButtons(
                  onGooglePressed: state.isLoading ? null : () {},
                  onApplePressed: state.isLoading ? null : () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
