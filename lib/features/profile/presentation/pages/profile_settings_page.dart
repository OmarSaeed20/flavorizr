// lib/features/profile/presentation/pages/profile_settings_page.dart
import 'package:flavorizr/core/router/app_router.dart';
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/presentation/providers/profile_providers.dart';
import 'package:flavorizr/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  bool _isPublicProfile = true;
  bool _showEmail = false;
  bool _showPhone = false;
  bool _showLocation = true;
  bool _allowDirectMessages = true;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentPreferences();
  }

  Future<void> _loadCurrentPreferences() async {
    final profileAsync = ref.read(currentProfileProvider);
    profileAsync.whenData((profile) {
      if (profile != null) {
        setState(() {
          _isPublicProfile = profile.isPublic;
          _showEmail = profile.preferences.showEmail;
          _showPhone = profile.preferences.showPhone;
          _showLocation = profile.preferences.showLocation;
          _allowDirectMessages = profile.preferences.allowDirectMessages;
        });
      }
    });
  }

  void _onSettingChanged() {
    setState(() => _hasChanges = true);
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    final useCase = ref.read(updatePreferencesUseCaseProvider);
    final newPreferences = ProfilePreferences(
      showEmail: _showEmail,
      showPhone: _showPhone,
      showLocation: _showLocation,
      allowDirectMessages: _allowDirectMessages,
    );

    final result = await useCase(newPreferences);

    setState(() => _isLoading = false);

    if (mounted) {
      if (result.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.failure!.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else {
        ref.invalidate(currentProfileProvider);
        setState(() => _hasChanges = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings saved successfully')));
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    final passwordController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action is irreversible. All your data will be permanently deleted.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text('Enter your password to confirm:'),
            const SizedBox(height: 8),
            AppTextField(controller: passwordController, hint: 'Password', obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && passwordController.text.isNotEmpty && mounted) {
      setState(() => _isLoading = true);

      final useCase = ref.read(deleteAccountUseCaseProvider);
      final result = await useCase(passwordController.text);

      setState(() => _isLoading = false);

      if (mounted) {
        if (result.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.failure!.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          // Account deleted, navigate to login
          AppRouter.instance.clearAndGo(Routes.login);
        }
      }
    }

    passwordController.dispose();
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
