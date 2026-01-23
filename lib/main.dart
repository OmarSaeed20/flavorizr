import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:flavorizr/core/logger/logger_integration_helpers.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:flutter_screenutil/flutter_screenutil.dart' as s;

import 'app.dart';
import 'config/firebase/firebase_config.dart' show FirebaseConfig;
import 'config/flavors.dart';
import 'core/logger/advanced_app_logger.dart';
// import 'observers.dart' show Observers;

void main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      // Critical initializations that must happen first
      WidgetsFlutterBinding.ensureInitialized();
      HttpOverrides.global = MyHttpOverrides();

      F.appFlavor = Flavor.values.firstWhere(
        (element) => element.name == appFlavor,
      );
      await FirebaseConfig.setup();

      // Initialize logger
      await AppLogger.instance.initialize(
        config: switch (F.appFlavor.isDebugMode) {
          false => const AppLoggerConfig.prodction(),
          _ => null,
        },
      );

      await s.ScreenUtil.ensureScreenSize();

      // Initialize error handling
      AppErrorHandler.initialize();

      // Log app startup
      await AppLogger.instance.logInfo(
        'App started',
        data: {
          'buildMode': kReleaseMode ? 'release' : 'debug',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      runApp(const ProviderScope(/* observers: [Observers()], */ child: App()));
    },
    (error, StackTrace stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    },
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
}




/* 

Can Help me to Create full Advanced Complete AppRouter 
Using go_router: ^16.2.1 Package act Senior? * Frist Give me plan Mode?
 */