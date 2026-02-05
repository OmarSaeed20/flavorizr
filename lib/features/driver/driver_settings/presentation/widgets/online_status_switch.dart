import 'package:flutter/material.dart';

/// Widget for toggling online status.
class OnlineStatusSwitch extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool> onChanged;
  final bool isUpdating;

  const OnlineStatusSwitch({
    super.key,
    required this.isOnline,
    required this.onChanged,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isOnline ? Icons.wifi : Icons.wifi_off,
          color: isOnline ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Online Status',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isOnline ? 'You are online' : 'You are offline',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isOnline,
          onChanged: isUpdating ? null : onChanged,
          activeColor: Colors.green,
        ),
      ],
    );
  }
}