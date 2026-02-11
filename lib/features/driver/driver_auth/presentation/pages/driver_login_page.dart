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

/// Driver Login page (Figma-accurate).
class DriverLoginPage extends ConsumerStatefulWidget {
  const DriverLoginPage({super.key});

  @override
  ConsumerState<DriverLoginPage> createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends ConsumerState<DriverLoginPage> {
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

    await ref.read(driverAuthControllerProvider.notifier).login(phone: phone, password: password);

    if (mounted) {
      final state = ref.read(driverAuthControllerProvider);
      if (state.isAuthenticated) {
        context.go(Routes.driverHome);
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
      appBarTitle: l10n.driverSignIn,
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
                      onPressed: isLoading ? null : () => context.go(Routes.driverForgotPassword),
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
                onPressed: () => context.go(Routes.driverRegister),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
