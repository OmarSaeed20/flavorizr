// lib/features/auth/role_selection/presentation/pages/role_selection_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Role that a user can select.
enum _UserRole {
  customer('customer', 'assets/icons/role_customer.png', Icons.person_outline),
  driver('Driver', 'assets/icons/role_driver.png', Icons.drive_eta_outlined),
  company('Company', 'assets/icons/role_company.png', Icons.business_outlined);

  const _UserRole(this.label, this.assetPath, this.fallbackIcon);
  final String label;
  final String assetPath;
  final IconData fallbackIcon;
}

/// Role Selection Page (Figma-accurate).
///
/// Layout:
/// - Background #F2F2F2
/// - 3 role cards stacked vertically (customer, driver, company)
///   - Each: 120×120 icon, 24px radius, card shadow
///   - Selected card has #F2C223 gold border
/// - Bottom sheet with "Select account type" title and subtitle
class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  _UserRole? _selectedRole = _UserRole.customer;

  void _navigateForRole(_UserRole role) {
    switch (role) {
      case _UserRole.customer:
        context.push(Routes.register);
      case _UserRole.driver:
        context.push(Routes.driverRegister);
      case _UserRole.company:
        context.push(Routes.companyRegister);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthDesignConstants.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Role cards ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                child: Column(
                  children: _UserRole.values.map((role) {
                    final isSelected = _selectedRole == role;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedRole = role);
                          _navigateForRole(role);
                        },
                        child: _RoleCard(role: role, isSelected: isSelected),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Bottom sheet ──
            const AuthBottomSheet(
              padding: AuthDesignConstants.sheetPadding,
              children: [
                AuthSheetHeader(
                  title: 'Select account type',
                  subtitle: 'Choose if you are a driver or a company',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A single role card matching Figma specs.
class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role, required this.isSelected});

  final _UserRole role;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: isSelected
              ? const BorderSide(color: AuthDesignConstants.primaryVariant)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(AuthDesignConstants.roleCardBorderRadius),
        ),
        shadows: const [AuthDesignConstants.cardShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Role icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.27)),
            child: Image.asset(
              role.assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => DecoratedBox(
                decoration: BoxDecoration(
                  color: AuthDesignConstants.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7.27),
                ),
                child: Icon(role.fallbackIcon, size: 60, color: AuthDesignConstants.primary),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Role label
          Text(role.label, style: AuthDesignConstants.roleLabel),
        ],
      ),
    );
  }
}
