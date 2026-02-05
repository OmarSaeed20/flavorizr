// lib/features/profile/presentation/pages/profile_settings_page.dart
import 'package:flavorizr/features/user/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileDetailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
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
                value: profile.name,
              ),
              _buildInfoTile(
                context,
                icon: Icons.badge,
                label: 'Nickname',
                value: profile.nickname,
              ),
              _buildInfoTile(
                context,
                icon: Icons.email,
                label: 'Email',
                value: profile.email,
              ),
              _buildInfoTile(
                context,
                icon: Icons.phone,
                label: 'Phone',
                value: profile.phone,
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
                value: profile.gender,
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
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveSettings,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (profile) => ListView(
          children: [
            _buildSectionHeader(context, 'Privacy'),
            SwitchListTile(
              title: const Text('Public Profile'),
              subtitle: const Text('Allow others to find your profile'),
              value: _isPublicProfile,
              secondary: const Icon(Icons.public),
              onChanged: (value) {
                setState(() => _isPublicProfile = value);
                _onSettingChanged();
              },
            ),
            SwitchListTile(
              title: const Text('Show Email'),
              subtitle: const Text('Display your email on your public profile'),
              value: _showEmail,
              secondary: const Icon(Icons.email_outlined),
              onChanged: (value) {
                setState(() => _showEmail = value);
                _onSettingChanged();
              },
            ),
            SwitchListTile(
              title: const Text('Show Phone Number'),
              subtitle: const Text('Display your phone on your public profile'),
              value: _showPhone,
              secondary: const Icon(Icons.phone_outlined),
              onChanged: (value) {
                setState(() => _showPhone = value);
                _onSettingChanged();
              },
            ),
            SwitchListTile(
              title: const Text('Show Location'),
              subtitle: const Text('Display your location on your public profile'),
              value: _showLocation,
              secondary: const Icon(Icons.location_on_outlined),
              onChanged: (value) {
                setState(() => _showLocation = value);
                _onSettingChanged();
              },
            ),

            const Divider(),
            _buildSectionHeader(context, 'Communication'),

            SwitchListTile(
              title: const Text('Allow Direct Messages'),
              subtitle: const Text('Let others send you direct messages'),
              value: _allowDirectMessages,
              secondary: const Icon(Icons.message_outlined),
              onChanged: (value) {
                setState(() => _allowDirectMessages = value);
                _onSettingChanged();
              },
            ),

            const Divider(),
            _buildSectionHeader(context, 'Data & Storage'),

            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Download My Data'),
              subtitle: const Text('Request a copy of your personal data'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data request functionality coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services_outlined),
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Cache cleared successfully')));
              },
            ),

            const Divider(),
            _buildSectionHeader(context, 'Account Actions'),

            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Permanently remove your account and data'),
              onTap: _handleDeleteAccount,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
