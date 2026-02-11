// lib/features/auth/presentation/pages/login_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/login_controller.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Consumer Login page (Figma-accurate).
///
/// Layout:
/// - White AppBar with back arrow + "Login" title
/// - Background #F2F2F2 with centered logo card
/// - Bottom sheet with phone input, password input, forgot password link,
///   Login button, footer link to Sign Up
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final result = await ref.read(loginControllerProvider.notifier).login();
    if (result != null && mounted) {
      // Navigate to home after successful login
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    // Listen for successful authentication (after OTP in some flows)
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AuthDesignConstants.error),
        );
      }
    });

    return AuthScaffold(
      appBarTitle: l10n.login,
      body: Column(
        children: [
          // ── Logo card area ──
          const Expanded(child: Center(child: AuthLogoCard())),

          // ── Bottom sheet ──
          AuthBottomSheet(
            padding: AuthDesignConstants.sheetPaddingExtended,
            children: [
              // Phone number field
              PhoneInputField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                label: l10n.phoneNumber,
                hintText: '135 153 968 312 025',
                errorText: state.phoneError,
                enabled: !state.isAnyLoading,
                textInputAction: TextInputAction.next,
                onChanged: (value) => ref.read(loginControllerProvider.notifier).setPhone(value),
                onSubmitted: (_) => _passwordFocusNode.requestFocus(),
              ),

              // Password field
              AuthPasswordField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                label: l10n.password,
                hintText: l10n.passwordHint,
                errorText: state.passwordError,
                isVisible: state.showPassword,
                enabled: !state.isAnyLoading,
                textInputAction: TextInputAction.done,
                onToggleVisibility: () =>
                    ref.read(loginControllerProvider.notifier).togglePasswordVisibility(),
                onChanged: (value) => ref.read(loginControllerProvider.notifier).setPassword(value),
                onSubmitted: (_) => _handleLogin(),
              ),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.push(Routes.forgotPassword),
                  child: Text(
                    l10n.forgotPassword,
                    style: const TextStyle(
                      color: AuthDesignConstants.primary,
                      fontSize: 12,
                      fontFamily: AuthDesignConstants.fontBody,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Error message
              if (state.errorMessage != null && state.errorMessage!.isNotEmpty)
                Text(
                  state.errorMessage!,
                  style: const TextStyle(
                    color: AuthDesignConstants.error,
                    fontSize: 12,
                    fontFamily: AuthDesignConstants.fontBody,
                  ),
                  textAlign: TextAlign.center,
                ),

              // Login button
              AuthPrimaryButton(
                text: l10n.login,
                isLoading: state.isLoading,
                onPressed: _handleLogin,
              ),

              // Footer link
              AuthFooterLink(
                text: l10n.dontHaveAccount,
                actionText: l10n.signUp,
                onPressed: () => context.push(Routes.register),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
