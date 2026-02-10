// lib/core/router/widgets/not_found_screen.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Not found (404) screen displayed when a route doesn't exist.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 16),
            Text('Page Not Found', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              "The page you are looking for doesn't exist.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
