// lib/features/auth/presentation/pages/select_login_signup_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Select Login / Signup screen (Figma A.5).
///
/// Layout:
/// - Background: #F2F2F2
/// - White app bar with back button
/// - Logo card centered
/// - Bottom sheet at bottom with Login (gold) + Sign up (outlined) buttons
///
/// Accepts extra data: {'role': 'customer'|'driver'|'company'}
class SelectLoginSignupPage extends StatelessWidget {
  const SelectLoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final extra = state.extra as Map<String, dynamic>?;
    final role = extra?['role'] as String? ?? 'customer';
    final l10n = AppLocalizations.of(context)!;

    return AuthScaffold(
      showLogoCard: false,
      body: Column(
        children: [
          // ── Top area with logo card ──
          const Expanded(child: Center(child: AuthLogoCard())),

          // ── Bottom sheet ──
          AuthBottomSheet(
            padding: AuthDesignConstants.sheetPaddingExtended,
            spacing: 24,
            children: [
              // Login button - navigate to role-specific login
              AuthPrimaryButton(
                text: l10n.signIn,
                onPressed: () => _navigateToLogin(context, role),
              ),

              // Sign up button - navigate to role-specific register
              AuthSecondaryButton(
                text: l10n.signUp,
                onPressed: () => _navigateToRegister(context, role),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToLogin(BuildContext context, String role) {
    switch (role.toLowerCase()) {
      case 'driver':
        context.push(Routes.driverLogin);
        break;
      case 'company':
        context.push(Routes.companyLogin);
        break;
      default:
        context.push(Routes.login);
    }
  }

  void _navigateToRegister(BuildContext context, String role) {
    switch (role.toLowerCase()) {
      case 'driver':
        context.push(Routes.driverRegister, extra: {'role': role});
      case 'company':
        context.push(Routes.companyRegister, extra: {'role': role});
      case 'user':
        context.push(Routes.register, extra: {'role': role});
    }
  }
}
