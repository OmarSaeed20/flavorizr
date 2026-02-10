// lib/features/auth/role_selection/presentation/pages/role_selection_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';

/// Role Selection Page
///
/// Allows users to select their role (Consumer, Driver, or Company)
/// and routes them to the appropriate registration flow.
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.local_taxi, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Center(
                child: Text('Fast Golden Taxi', style: AppTextStyles.of(context).headlineLarge),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Center(
                child: Text(
                  'Choose your role to get started',
                  style: AppTextStyles.of(
                    context,
                  ).bodyLarge.copyWith(color: AppColors.of(context).textSecondary),
                ),
              ),
              const SizedBox(height: 48),
              // Role Cards
              _buildRoleCard(
                context,
                icon: Icons.person,
                title: 'Consumer',
                description: 'Book rides and travel comfortably',
                color: AppColors.of(context).primary,
                onTap: () {
                  context.push('/consumer/auth/register');
                },
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                context,
                icon: Icons.drive_eta,
                title: 'Driver',
                description: 'Earn money by driving',
                color: AppColors.of(context).success,
                onTap: () {
                  context.push('/driver/auth/register');
                },
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                context,
                icon: Icons.business,
                title: 'Company',
                description: 'Manage your fleet efficiently',
                color: AppColors.of(context).warning,
                onTap: () {
                  context.push('/company/auth/register');
                },
              ),
              const Spacer(),
              // Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.of(context).bodyMedium),
                    TextButton(
                      onPressed: () {
                        context.push('/auth/login');
                      },
                      child: Text(
                        'Login',
                        style: AppTextStyles.of(context).bodyMedium.copyWith(
                          color: AppColors.of(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.of(
                      context,
                    ).titleLarge.copyWith(color: color, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.of(
                      context,
                    ).bodyMedium.copyWith(color: AppColors.of(context).textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
