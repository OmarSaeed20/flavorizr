// lib/features/settings/presentation/pages/notification_settings_page.dart
import 'package:fast_golden_taxi/features/user/settings/presentation/controllers/notification_settings_controller.dart';
import 'package:fast_golden_taxi/features/user/settings/presentation/providers/settings_providers.dart';
import 'package:fast_golden_taxi/features/user/settings/presentation/widgets/quiet_hours_picker.dart';
import 'package:fast_golden_taxi/features/user/settings/presentation/widgets/settings_section.dart';
import 'package:fast_golden_taxi/features/user/settings/presentation/widgets/settings_switch_tile.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Notification Settings Page for managing notification preferences.
///
/// Features:
/// - Toggle push, email, SMS, in-app notifications
/// - Configure sound, vibration, badge, preview settings
/// - Manage social notification types (messages, mentions, etc.)
/// - Set up quiet hours
/// - Reset to defaults
class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationSettingsControllerProvider.notifier).loadSettings();
    });
  }

  Future<bool> _onWillPop() async {
    final state = ref.read(notificationSettingsControllerProvider);
    if (!state.hasChanges) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  Future<void> _handleSave() async {
    final success = await ref
        .read(notificationSettingsControllerProvider.notifier)
        .saveSettings();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults?'),
        content: const Text(
          'This will reset all notification settings to their default values. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset ?? false) {
      await ref
          .read(notificationSettingsControllerProvider.notifier)
          .resetToDefaults();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings reset to defaults'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationSettingsControllerProvider);
    final theme = Theme.of(context);

    // Listen for errors
    ref.listen<NotificationSettingsState>(
      notificationSettingsControllerProvider,
      (previous, next) {
        if (next.errorMessage != null &&
            next.errorMessage != previous?.errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );

    return PopScope(
      canPop: !state.hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'reset') {
                  _handleReset();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'reset',
                  child: Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 12),
                      Text('Reset to Defaults'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(context, state),
        bottomNavigationBar: state.isLoading
            ? null
            : _buildBottomBar(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationSettingsState state) {
    final controller = ref.read(
      notificationSettingsControllerProvider.notifier,
    );
    final settings = state.settings;

    return ListView(
      children: [
        // General Notifications Section
        SettingsSection(
          title: 'General',
          children: [
            SettingsSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive notifications on your device',
              icon: Icons.notifications_outlined,
              value: settings.pushEnabled,
              onChanged: controller.setPushEnabled,
            ),
            SettingsSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              icon: Icons.email_outlined,
              value: settings.emailEnabled,
              onChanged: controller.setEmailEnabled,
            ),
            SettingsSwitchTile(
              title: 'SMS Notifications',
              subtitle: 'Receive notifications via text message',
              icon: Icons.sms_outlined,
              value: settings.smsEnabled,
              onChanged: controller.setSmsEnabled,
            ),
            SettingsSwitchTile(
              title: 'In-App Notifications',
              subtitle: 'Show notifications while using the app',
              icon: Icons.app_settings_alt_outlined,
              value: settings.inAppEnabled,
              onChanged: controller.setInAppEnabled,
            ),
          ],
        ),

        // Delivery Settings Section
        SettingsSection(
          title: 'Delivery',
          children: [
            SettingsSwitchTile(
              title: 'Sound',
              subtitle: 'Play sound when notification arrives',
              icon: Icons.volume_up_outlined,
              value: settings.soundEnabled,
              onChanged: settings.pushEnabled
                  ? controller.setSoundEnabled
                  : null,
              enabled: settings.pushEnabled,
            ),
            SettingsSwitchTile(
              title: 'Vibration',
              subtitle: 'Vibrate when notification arrives',
              icon: Icons.vibration_outlined,
              value: settings.vibrationEnabled,
              onChanged: settings.pushEnabled
                  ? controller.setVibrationEnabled
                  : null,
              enabled: settings.pushEnabled,
            ),
            SettingsSwitchTile(
              title: 'Badge Count',
              subtitle: 'Show unread count on app icon',
              icon: Icons.badge_outlined,
              value: settings.badgeEnabled,
              onChanged: settings.pushEnabled
                  ? controller.setBadgeEnabled
                  : null,
              enabled: settings.pushEnabled,
            ),
            SettingsSwitchTile(
              title: 'Preview',
              subtitle: 'Show notification content in preview',
              icon: Icons.preview_outlined,
              value: settings.previewEnabled,
              onChanged: settings.pushEnabled
                  ? controller.setPreviewEnabled
                  : null,
              enabled: settings.pushEnabled,
            ),
          ],
        ),

        // Social Notifications Section
        SettingsSection(
          title: 'Social',
          children: [
            SettingsSwitchTile(
              title: 'Messages',
              subtitle: 'New message notifications',
              icon: Icons.message_outlined,
              value: settings.messagesEnabled,
              onChanged: controller.setMessagesEnabled,
            ),
            SettingsSwitchTile(
              title: 'Mentions',
              subtitle: 'When someone mentions you',
              icon: Icons.alternate_email_outlined,
              value: settings.mentionsEnabled,
              onChanged: controller.setMentionsEnabled,
            ),
            SettingsSwitchTile(
              title: 'Comments',
              subtitle: 'New comment notifications',
              icon: Icons.comment_outlined,
              value: settings.commentsEnabled,
              onChanged: controller.setCommentsEnabled,
            ),
            SettingsSwitchTile(
              title: 'Likes',
              subtitle: 'When someone likes your content',
              icon: Icons.favorite_outline,
              value: settings.likesEnabled,
              onChanged: controller.setLikesEnabled,
            ),
            SettingsSwitchTile(
              title: 'New Followers',
              subtitle: 'When someone follows you',
              icon: Icons.person_add_outlined,
              value: settings.followsEnabled,
              onChanged: controller.setFollowsEnabled,
            ),
            SettingsSwitchTile(
              title: 'Direct Messages',
              subtitle: 'Private message notifications',
              icon: Icons.chat_outlined,
              value: settings.directMessagesEnabled,
              onChanged: controller.setDirectMessagesEnabled,
            ),
            SettingsSwitchTile(
              title: 'Group Messages',
              subtitle: 'Group conversation notifications',
              icon: Icons.groups_outlined,
              value: settings.groupMessagesEnabled,
              onChanged: controller.setGroupMessagesEnabled,
            ),
          ],
        ),

        // Other Notifications Section
        SettingsSection(
          title: 'Other',
          children: [
            SettingsSwitchTile(
              title: 'App Updates',
              subtitle: 'New features and improvements',
              icon: Icons.system_update_outlined,
              value: settings.updatesEnabled,
              onChanged: controller.setUpdatesEnabled,
            ),
            SettingsSwitchTile(
              title: 'Security Alerts',
              subtitle: 'Account security notifications',
              icon: Icons.security_outlined,
              value: settings.securityAlertsEnabled,
              onChanged: controller.setSecurityAlertsEnabled,
            ),
            SettingsSwitchTile(
              title: 'Reminders',
              subtitle: 'Task and event reminders',
              icon: Icons.alarm_outlined,
              value: settings.reminderEnabled,
              onChanged: controller.setReminderEnabled,
            ),
            SettingsSwitchTile(
              title: 'Promotional',
              subtitle: 'Deals, offers, and promotions',
              icon: Icons.local_offer_outlined,
              value: settings.promotionalEnabled,
              onChanged: controller.setPromotionalEnabled,
            ),
          ],
        ),

        // Quiet Hours Section
        SettingsSection(
          title: 'Quiet Hours',
          children: [
            SettingsSwitchTile(
              title: 'Enable Quiet Hours',
              subtitle: 'Mute notifications during specific hours',
              icon: Icons.do_not_disturb_on_outlined,
              value: settings.quietHoursEnabled,
              onChanged: controller.setQuietHoursEnabled,
            ),
            if (settings.quietHoursEnabled)
              QuietHoursPicker(
                startHour: settings.quietHoursStart ?? 22,
                endHour: settings.quietHoursEnd ?? 7,
                onStartChanged: controller.setQuietHoursStart,
                onEndChanged: controller.setQuietHoursEnd,
              ),
          ],
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    NotificationSettingsState state,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton.primary(
          onPressed: state.hasChanges && !state.isSaving ? _handleSave : null,
          text: 'Save Changes',
          isLoading: state.isSaving,
          isDisabled: !state.hasChanges,
          width: double.infinity,
        ),
      ),
    );
  }
}
