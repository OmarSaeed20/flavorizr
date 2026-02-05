import 'package:flutter/material.dart';

/// Widget for toggling availability status.
class AvailabilityStatusSwitch extends StatelessWidget {
  final bool isAvailable;
  final ValueChanged<bool> onChanged;
  final bool isUpdating;

  const AvailabilityStatusSwitch({
    super.key,
    required this.isAvailable,
    required this.onChanged,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.blue : Colors.grey,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available for Trips',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isAvailable ? 'Accepting ride requests' : 'Not accepting requests',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isAvailable,
          onChanged: isUpdating ? null : onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}