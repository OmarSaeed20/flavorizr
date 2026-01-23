// lib/bootstrap.dart
import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flavorizr/app.dart';
import 'package:flavorizr/config/app_config.dart';
import 'package:flavorizr/config/firebase/firebase_config.dart';
import 'package:flavorizr/config/flavors.dart';
import 'package:flavorizr/core/error/error_handler.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bootstraps the application with the specified [flavor].
///
/// This function:
/// 1. Ensures Flutter bindings are initialized
/// 2. Sets up error handling
/// 3. Initializes app configuration
/// 4. Initializes core services (logging, storage, etc.)
/// 5. Runs the app
///
/// All errors during initialization are caught and logged.
Future<void> bootstrap(Flavor flavor) async {
  // Catch all errors during bootstrap
  await runZonedGuarded<Future<void>>(
    () async {
      // 1. Ensure Flutter bindings are initialized
      WidgetsFlutterBinding.ensureInitialized();

      // 2. Set flavor
      F.appFlavor = flavor;

      // 3. Set up HTTP overrides for development
      if (!flavor.isProduction) {
        HttpOverrides.global = _DevHttpOverrides();
      }

      // 4. Initialize Firebase
      await FirebaseConfig.setup();

      // 5. Initialize app configuration
      AppConfig.initialize(flavor);

      // 6. Initialize logger
      await AppLogger.instance.initialize(
        config: flavor.isProduction ? const AppLoggerConfig.prodction() : const AppLoggerConfig(),
      );

      // 7. Initialize error handling
      ErrorHandler.initialize(enableCrashReporting: flavor.enableCrashReporting);

      // 8. Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // 9. Set system UI style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );

      // 10. Ensure screen size is initialized
      await ScreenUtil.ensureScreenSize();

      // 11. Initialize router
      await AppRouter.instance.initialize();

      // 12. Log app startup
      await AppLogger.instance.logInfo(
        'App bootstrapped',
        data: {
          'flavor': flavor.name,
          'buildMode': kReleaseMode ? 'release' : 'debug',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // 13. Run the app
      runApp(ProviderScope(observers: kDebugMode ? [_ProviderLogger()] : [], child: const App()));
    },
    (error, stackTrace) {
      // Handle uncaught errors
      ErrorHandler.handleZoneError(error, stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    },
  );
}

/// HTTP overrides for development to allow self-signed certificates.
class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
}

/// A Riverpod observer that logs provider state changes in debug mode.
final class _ProviderLogger extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    AppLogger.instance.logDebug(
      'Provider added: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    AppLogger.instance.logDebug(
      'Provider disposed: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }

  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    AppLogger.instance.logDebug(
      'Provider updated: ${context.provider.name ?? context.provider.runtimeType}',
      data: {'previousValue': previousValue?.toString(), 'newValue': newValue?.toString()},
    );
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    AppLogger.instance.logError(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
      stackTrace: stackTrace.toString(),
      data: {'error': error.toString()},
    );
  }
}
