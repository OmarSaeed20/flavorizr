// lib/features/profile/presentation/pages/profile_settings_page.dart
import 'package:fast_golden_taxi/features/user/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileDetailProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, _) => Center(child: Text('Error: $error')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile data available'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(context, 'Account Information'),
              _buildInfoTile(
                context,
                icon: Icons.person,
                label: 'Name',
                value: profile.name ?? 'Not set',
              ),
              _buildInfoTile(
                context,
                icon: Icons.badge,
                label: 'Nickname',
                value: profile.nickname ?? 'Not set',
              ),
              _buildInfoTile(
                context,
                icon: Icons.email,
                label: 'Email',
                value: profile.email ?? 'Not set',
              ),
              _buildInfoTile(
                context,
                icon: Icons.phone,
                label: 'Phone',
                value: profile.phone ?? 'Not set',
              ),
              _buildInfoTile(
                context,
                icon: Icons.location_on,
                label: 'Country ID',
                value: profile.countryId?.toString() ?? 'Not set',
              ),
              _buildInfoTile(
                context,
                icon: Icons.map,
                label: 'Governorate ID',
                value: profile.governorateId?.toString() ?? 'Not set',
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Personal Information'),
              _buildInfoTile(
                context,
                icon: Icons.wc,
                label: 'Gender',
                value: profile.gender ?? 'Not set',
              ),
              _buildInfoTile(
                context,
                icon: Icons.cake,
                label: 'Birth Date',
                value: profile.birthDate ?? 'Not set',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(leading: Icon(icon), title: Text(label), subtitle: Text(value)),
    );
  }
}
