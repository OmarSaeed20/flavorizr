// lib/features/settings/presentation/widgets/settings_switch_tile.dart
import 'package:flutter/material.dart';

/// A list tile with a switch for toggling settings.
///
/// Provides a consistent design for boolean settings with
/// an icon, title, subtitle, and switch control.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.onChanged,
    this.enabled = true,
  });

  /// The title of the setting.
  final String title;

  /// The current value of the setting.
  final bool value;

  /// An optional description of the setting.
  final String? subtitle;

  /// An optional icon displayed before the title.
  final IconData? icon;

  /// Callback when the value changes. If null, the switch is disabled.
  final ValueChanged<bool>? onChanged;

  /// Whether the tile is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = enabled && onChanged != null;

    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: isEnabled
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface.withValues(alpha: 0.38),
            )
          : null,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isEnabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isEnabled
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurface.withValues(alpha: 0.38),
              ),
            )
          : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: isEnabled ? onChanged : null,
      ),
      onTap: isEnabled
          ? () {
              onChanged?.call(!value);
            }
          : null,
      enabled: isEnabled,
    );
  }
}
