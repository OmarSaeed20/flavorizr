// lib/features/settings/presentation/widgets/quiet_hours_picker.dart
import 'package:flutter/material.dart';

/// A widget for selecting quiet hours time range.
///
/// Allows users to set start and end times for the quiet hours period
/// when notifications should be muted.
class QuietHoursPicker extends StatelessWidget {
  const QuietHoursPicker({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  /// The starting hour of quiet period (0-23).
  final int startHour;

  /// The ending hour of quiet period (0-23).
  final int endHour;

  /// Callback when the start hour changes.
  final ValueChanged<int> onStartChanged;

  /// Callback when the end hour changes.
  final ValueChanged<int> onEndChanged;

  String _formatHour(int hour) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:00 $period';
  }

  Future<void> _showTimePicker(
    BuildContext context, {
    required int currentHour,
    required ValueChanged<int> onChanged,
    required String title,
  }) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: 0),
      helpText: title,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (time != null) {
      onChanged(time.hour);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Range Display
          Row(
            children: [
              // Start Time
              Expanded(
                child: _TimeCard(
                  label: 'From',
                  time: _formatHour(startHour),
                  icon: Icons.bedtime_outlined,
                  onTap: () => _showTimePicker(
                    context,
                    currentHour: startHour,
                    onChanged: onStartChanged,
                    title: 'Select Start Time',
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Arrow
              Icon(
                Icons.arrow_forward,
                color: theme.colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 16),

              // End Time
              Expanded(
                child: _TimeCard(
                  label: 'To',
                  time: _formatHour(endHour),
                  icon: Icons.wb_sunny_outlined,
                  onTap: () => _showTimePicker(
                    context,
                    currentHour: endHour,
                    onChanged: onEndChanged,
                    title: 'Select End Time',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Info Text
          Text(
            'Notifications will be muted during quiet hours',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.label,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String time;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
