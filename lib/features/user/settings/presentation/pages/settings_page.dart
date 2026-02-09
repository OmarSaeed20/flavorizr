// lib/features/settings/presentation/pages/settings_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/settings/presentation/widgets/settings_section.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Main Settings Page with navigation to all settings sub-pages.
///
/// Features:
/// - Account settings section
/// - App settings section (notifications, appearance, language)
/// - Privacy & security section
/// - Support section (help, feedback, about)
/// - Sign out option
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    }
  }

  Future<void> _handleSignOut() async {
    final l10n = AppLocalizations.of(context)!;
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );

    if ((shouldSignOut ?? false) && mounted) {
      // Trigger sign out logic
      // For now, navigate to login
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Account Section
          SettingsSection(
            title: l10n.account,
            children: [
              _SettingsNavigationTile(
                title: l10n.editProfile,
                subtitle: l10n.editProfileSubtitle,
                icon: Icons.person_outline,
                onTap: () => context.push(Routes.editProfile),
              ),
              _SettingsNavigationTile(
                title: l10n.profileSettings,
                subtitle: l10n.profileSettingsSubtitle,
                icon: Icons.manage_accounts_outlined,
                onTap: () => context.push(Routes.profileSettings),
              ),
            ],
          ),

          // App Settings Section
          SettingsSection(
            title: l10n.appSettings,
            children: [
              _SettingsNavigationTile(
                title: l10n.notifications,
                subtitle: l10n.notificationsSubtitle,
                icon: Icons.notifications_outlined,
                onTap: () => context.push(Routes.notificationSettings),
              ),
              _SettingsNavigationTile(
                title: l10n.appearance,
                subtitle: l10n.appearanceSubtitle,
                icon: Icons.palette_outlined,
                onTap: () => context.push(Routes.appearanceSettings),
              ),
              _SettingsNavigationTile(
                title: l10n.language,
                subtitle: l10n.languageSubtitle,
                icon: Icons.language_outlined,
                onTap: () => context.push(Routes.languageSettings),
              ),
            ],
          ),

          // Privacy & Security Section
          SettingsSection(
            title: l10n.privacySecurity,
            children: [
              _SettingsNavigationTile(
                title: l10n.privacy,
                subtitle: l10n.privacySubtitle,
                icon: Icons.privacy_tip_outlined,
                onTap: () => context.push(Routes.privacySettings),
              ),
              _SettingsNavigationTile(
                title: l10n.security,
                subtitle: l10n.securitySubtitle,
                icon: Icons.security_outlined,
                onTap: () => context.push(Routes.securitySettings),
              ),
            ],
          ),

          // Support Section
          SettingsSection(
            title: l10n.support,
            children: [
              _SettingsNavigationTile(
                title: l10n.helpCenter,
                subtitle: l10n.helpCenterSubtitle,
                icon: Icons.help_outline,
                onTap: () => context.push(Routes.help),
              ),
              _SettingsNavigationTile(
                title: l10n.sendFeedback,
                subtitle: l10n.sendFeedbackSubtitle,
                icon: Icons.feedback_outlined,
                onTap: () => context.push(Routes.feedback),
              ),
              _SettingsNavigationTile(
                title: l10n.about,
                subtitle: l10n.aboutSubtitle,
                icon: Icons.info_outline,
                onTap: () => context.push(Routes.about),
              ),
            ],
          ),

          // Sign Out Section
          SettingsSection(
            title: '',
            children: [
              _SettingsActionTile(
                title: l10n.signOut,
                icon: Icons.logout,
                color: theme.colorScheme.error,
                onTap: _handleSignOut,
              ),
            ],
          ),

          // App Version
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                '${l10n.version} $_appVersion',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// A navigation tile that navigates to another page.
class _SettingsNavigationTile extends StatelessWidget {
  const _SettingsNavigationTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

/// An action tile for destructive or special actions.
class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: effectiveColor),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(color: effectiveColor),
      ),
      onTap: onTap,
    );
  }
}
