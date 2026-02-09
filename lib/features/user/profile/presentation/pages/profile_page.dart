// lib/features/profile/presentation/pages/profile_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/core/ui/responsive/src/responsive_extensions.dart';
import 'package:fast_golden_taxi/features/user/auth/auth.dart';
import 'package:fast_golden_taxi/features/user/profile/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current user
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Please log in to view your profile')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Profile Settings',
            onPressed: () {
              context.goNamed(Routes.profileSettingsName);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Profile Header
          Column(
            children: [
              UserAvatar(
                photoUrl: user.photoUrl,
                displayName: user.displayName ?? 'User',
                size: 100,
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName ?? 'No Name',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Menu Items
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(Routes.editProfileName), // Push Edit Profile
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('App Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to Settings tab
                    // Since it's a shell route (bottom nav item), we use goNamed to switch tabs.
                    context.goNamed(Routes.settingsName);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(Routes.helpName),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () => _handleLogout(context, ref),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              'Version 1.0.0', // TODO: Get from package_info_plus
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );

    if ((shouldLogout ?? false) && context.mounted) {
      await ref
          .read(logoutUseCaseProvider)
          .call(LogoutParams(deviceType: context.responsive.deviceType.name));
      // Router should automatically redirect based on auth state changes
    }
  }
}
