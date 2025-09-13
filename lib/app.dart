import 'package:flavorizr/core/logger/logger_ui_components.dart';
import 'package:flavorizr/pages/my_home_page.dart';
import 'package:flutter/material.dart';

import 'config/flavors.dart';
import 'core/logger/logger_integration_helpers.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [LoggerNavigatorObserver()],
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/logs': (context) => const LogViewerScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const LoggerSettingsScreen(),
      },
      builder: (context, child) {
        final show = !F.appFlavor.isProduction;
        return LoggerDebugPanel(
          enabled: show,
          child: _flavorBanner(
            show: show,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) =>
      switch (show) {
        false => child,
        _ => Banner(
          location: BannerLocation.topEnd,
          message: F.name,
          color: Colors.green.withAlpha(150),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 1,
          ),
          textDirection: TextDirection.ltr,
          child: child,
        ),
      };
}
