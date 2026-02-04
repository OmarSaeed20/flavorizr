import 'package:flutter/material.dart';

/// Widget for notification settings tile.
class NotificationSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isUpdating;

  const NotificationSettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: isUpdating ? null : onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}