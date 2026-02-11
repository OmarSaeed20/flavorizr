// lib/features/auth/presentation/pages/select_login_signup_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
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
class SelectLoginSignupPage extends StatelessWidget {
  const SelectLoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Login button
              AuthPrimaryButton(text: 'Login ', onPressed: () => context.push(Routes.login)),

              // Sign up button
              AuthSecondaryButton(
                text: 'Sign up',
                onPressed: () => context.push(Routes.roleSelection),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
