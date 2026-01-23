// lib/core/router/widgets/placeholder_screen.dart
import 'package:flutter/material.dart';

/// Placeholder screen for routes not yet implemented.
///
/// This is useful during development to mark routes that
/// will have proper implementations later.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(message, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
