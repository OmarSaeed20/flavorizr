// lib/core/router/widgets/main_shell.dart
import 'package:flavorizr/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main shell with bottom navigation.
///
/// This widget wraps the main app content with a bottom navigation bar
/// for switching between primary app sections.
class MainShell extends StatelessWidget {
  const MainShell({required this.currentRoute, required this.child, super.key});

  final String currentRoute;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: child,
    bottomNavigationBar: NavigationBar(
      selectedIndex: _getSelectedIndex(),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );

  int _getSelectedIndex() {
    if (currentRoute.startsWith(Routes.home)) return 0;
    if (currentRoute.startsWith(Routes.search)) return 1;
    if (currentRoute.startsWith(Routes.notifications)) return 2;
    if (currentRoute.startsWith(Routes.settings)) return 3;
    if (currentRoute.startsWith(Routes.profile)) return 4;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final routes = [Routes.home, Routes.search, Routes.notifications, Routes.settings, Routes.profile];

    if (index >= 0 && index < routes.length) {
      context.go(routes[index]);
    }
  }
}
