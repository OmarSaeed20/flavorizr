// lib/features/auth/presentation/pages/login_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/controllers/login_controller.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Login page (Figma-accurate).
///
/// Layout:
/// - White AppBar with back arrow + "Login" title
/// - Background #F2F2F2 with centered logo card
/// - Bottom sheet with phone input, password input, Login button, footer link
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
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);

    return AuthScaffold(
      appBarTitle: 'Login',
      body: Column(
        children: [
          // ── Logo card area ──
          const Expanded(child: Center(child: AuthLogoCard())),

          // ── Bottom sheet ──
          AuthBottomSheet(
            padding: AuthDesignConstants.sheetPaddingExtended,
            spacing: 24,
            children: [
              // Phone number field
              PhoneInputField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                label: 'Phone number',
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
                label: 'Password',
                hintText: 'Enter your password',
                errorText: state.passwordError,
                isVisible: state.showPassword,
                enabled: !state.isAnyLoading,
                textInputAction: TextInputAction.done,
                onToggleVisibility: () =>
                    ref.read(loginControllerProvider.notifier).togglePasswordVisibility(),
                onChanged: (value) => ref.read(loginControllerProvider.notifier).setPassword(value),
                onSubmitted: (_) => _handleLogin(),
              ),

              // Login button
              AuthPrimaryButton(
                text: 'Login ',
                isLoading: state.isLoading,
                onPressed: _handleLogin,
              ),

              // Footer link
              AuthFooterLink(
                text: "Don't have an account? ",
                actionText: 'Sign Up',
                onPressed: () => context.push(Routes.register),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
