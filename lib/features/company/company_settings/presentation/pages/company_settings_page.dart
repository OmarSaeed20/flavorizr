// lib/features/company/company_settings/presentation/pages/company_settings_page.dart
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Company Settings Page
///
/// Main settings page for company accounts.
/// Provides access to various settings options.
class CompanySettingsPage extends ConsumerWidget {
  const CompanySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader(context, 'Account'),
          _buildSettingsTile(
            context,
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'Manage your company profile',
            onTap: () {
              context.push('/company/profile');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              context.push('/company/settings/notifications');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.security,
            title: 'Security',
            subtitle: 'Password and security settings',
            onTap: () {
              context.push('/company/settings/security');
            },
          ),
          const Divider(height: 32),
          // Information Section
          _buildSectionHeader(context, 'Information'),
          _buildSettingsTile(
            context,
            icon: Icons.info,
            title: 'About Us',
            subtitle: 'Learn about Fast Golden Taxi',
            onTap: () {
              context.push('/company/settings/about');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help,
            title: 'FAQ',
            subtitle: 'Frequently asked questions',
            onTap: () {
              context.push('/company/settings/faq');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              context.push('/company/settings/privacy');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.gavel,
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            onTap: () {
              context.push('/company/settings/terms');
            },
          ),
          const Divider(height: 32),
          // Support Section
          _buildSectionHeader(context, 'Support'),
          _buildSettingsTile(
            context,
            icon: Icons.contact_support,
            title: 'Contact Support',
            subtitle: 'Get help from our support team',
            onTap: () {
              context.push('/company/settings/support');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.report,
            title: 'Report a Problem',
            subtitle: 'Report an issue or bug',
            onTap: () {
              context.push('/company/settings/report');
            },
          ),
          const Divider(height: 32),
          // App Section
          _buildSectionHeader(context, 'App'),
          _buildSettingsTile(
            context,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Change app language',
            onTap: () {
              context.push('/company/settings/language');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode,
            title: 'Theme',
            subtitle: 'Change app theme',
            onTap: () {
              context.push('/company/settings/theme');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: 'Version 1.0.0',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: AppTextStyles.of(
          context,
        ).titleMedium.copyWith(color: AppColors.of(context).primary, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {

    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.of(context).primary),
      title: Text(title, style: AppTextStyles.of(context).bodyLarge),
      subtitle: Text(subtitle, style: AppTextStyles.of(context).bodySmall),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}
