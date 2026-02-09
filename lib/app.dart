import 'package:fast_golden_taxi/config/flavors.dart';
import 'package:fast_golden_taxi/core/localization/locale_controller.dart';
import 'package:fast_golden_taxi/core/logger/logger_ui_components.dart';
import 'package:fast_golden_taxi/core/router/app_router.dart';
import 'package:fast_golden_taxi/core/theme/app_theme.dart';
import 'package:fast_golden_taxi/core/theme/theme_controller.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: F.title,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light(settings: themeSettings),
      darkTheme: AppTheme.dark(settings: themeSettings),
      themeMode: themeSettings.themeMode,

      // Localization
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: AppRouter.instance.router,
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
