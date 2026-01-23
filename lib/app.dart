import 'package:flavorizr/config/flavors.dart';
import 'package:flavorizr/core/logger/logger_ui_components.dart';
import 'package:flavorizr/core/router/app_router.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: F.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: AppRouter.instance.router,
      builder: (context, child) {
        final show = !F.appFlavor.isProduction;
        return LoggerDebugPanel(
          enabled: show,
          child: _flavorBanner(show: show, child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => switch (show) {
    false => child,
    _ => Banner(
      location: BannerLocation.topEnd,
      message: F.name,
      color: Colors.green.withAlpha(150),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 1),
      textDirection: TextDirection.ltr,
      child: child,
    ),
  };
}
