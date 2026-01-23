import 'package:flavorizr/core/theme/theme_controller.dart';
import 'package:flavorizr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeControllerProvider);
    final themeNotifier = ref.read(themeControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearance)),
      body: ListView(
        children: [
          _buildSectionHeader(context, l10n.theme),
          RadioListTile<ThemeMode>(
            title: Text(l10n.system),
            value: ThemeMode.system,
            groupValue: themeSettings.themeMode,
            onChanged: (value) => themeNotifier.setThemeMode(value!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.light),
            value: ThemeMode.light,
            groupValue: themeSettings.themeMode,
            onChanged: (value) => themeNotifier.setThemeMode(value!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.dark),
            value: ThemeMode.dark,
            groupValue: themeSettings.themeMode,
            onChanged: (value) => themeNotifier.setThemeMode(value!),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Use Dynamic Color'),
            subtitle: const Text('Use wallpaper colors (Android 12+)'),
            value: themeSettings.useDynamicColor,
            onChanged: themeNotifier.setUseDynamicColor,
          ),
          SwitchListTile(
            title: const Text('True Black (OLED)'),
            subtitle: const Text('Use pure black for dark mode'),
            value: themeSettings.useOledBlack,
            onChanged: themeNotifier.setUseOledBlack,
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
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
