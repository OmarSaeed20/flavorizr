import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavorizr/features/driver/driver_settings/presentation/controllers/driver_settings_controller.dart';
import 'package:flavorizr/features/driver/driver_settings/presentation/providers/driver_settings_providers.dart';
import 'package:flavorizr/features/driver/driver_settings/presentation/widgets/online_status_switch.dart';
import 'package:flavorizr/features/driver/driver_settings/presentation/widgets/availability_status_switch.dart';
import 'package:flavorizr/features/driver/driver_settings/presentation/widgets/notification_settings_tile.dart';

/// Page for managing driver settings.
class DriverSettingsPage extends ConsumerStatefulWidget {
  const DriverSettingsPage({super.key});

  @override
  ConsumerState<DriverSettingsPage> createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends ConsumerState<DriverSettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    ref.read(driverSettingsControllerProvider.notifier).getDriverSettings();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Settings'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        state.error!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSettings,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : state.settings == null
                  ? const Center(child: Text('No settings available'))
                  : ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        // Status Section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                OnlineStatusSwitch(
                                  isOnline: state.settings!.isOnline,
                                  onChanged: (value) {
                                    ref
                                        .read(driverSettingsControllerProvider
                                            .notifier)
                                        .toggleOnlineStatus(value);
                                  },
                                  isUpdating: state.isUpdating,
                                ),
                                const SizedBox(height: 16),
                                AvailabilityStatusSwitch(
                                  isAvailable: state.settings!.isAvailable,
                                  onChanged: (value) {
                                    ref
                                        .read(driverSettingsControllerProvider
                                            .notifier)
                                        .toggleAvailabilityStatus(value);
                                  },
                                  isUpdating: state.isUpdating,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Notifications Section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notifications',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                NotificationSettingsTile(
                                  title: 'Enable Notifications',
                                  subtitle: 'Receive push notifications',
                                  value: state.settings!.notificationsEnabled,
                                  onChanged: (value) {
                                    ref
                                        .read(driverSettingsControllerProvider
                                            .notifier)
                                        .updateDriverSettings(
                                          notificationsEnabled: value,
                                        );
                                  },
                                  isUpdating: state.isUpdating,
                                ),
                                const Divider(),
                                NotificationSettingsTile(
                                  title: 'Sound',
                                  subtitle: 'Play sound for notifications',
                                  value: state.settings!.soundEnabled,
                                  onChanged: (value) {
                                    ref
                                        .read(driverSettingsControllerProvider
                                            .notifier)
                                        .updateDriverSettings(
                                          soundEnabled: value,
                                        );
                                  },
                                  isUpdating: state.isUpdating,
                                ),
                                const Divider(),
                                NotificationSettingsTile(
                                  title: 'Vibration',
                                  subtitle: 'Vibrate for notifications',
                                  value: state.settings!.vibrationEnabled,
                                  onChanged: (value) {
                                    ref
                                        .read(driverSettingsControllerProvider
                                            .notifier)
                                        .updateDriverSettings(
                                          vibrationEnabled: value,
                                        );
                                  },
                                  isUpdating: state.isUpdating,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Preferences Section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Preferences',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  title: const Text('Language'),
                                  subtitle: Text(
                                    state.settings!.language ?? 'Not set',
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    // Navigate to language selection
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  title: const Text('Currency'),
                                  subtitle: Text(
                                    state.settings!.currency ?? 'Not set',
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    // Navigate to currency selection
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  title: const Text('Max Distance'),
                                  subtitle: Text(
                                    state.settings!.maxDistance != null
                                        ? '${state.settings!.maxDistance} km'
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    // Navigate to max distance selection
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}