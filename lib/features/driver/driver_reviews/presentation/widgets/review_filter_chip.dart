import 'package:flutter/material.dart';

/// Widget for displaying a review filter chip
class ReviewFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const ReviewFilterChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDeleted,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 12,
      ),
      deleteIconColor: Theme.of(context).primaryColor,
    );
  }
}
