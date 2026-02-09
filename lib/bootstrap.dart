// lib/bootstrap.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flavorizr/app.dart';
import 'package:flavorizr/config/app_config.dart';
import 'package:flavorizr/config/firebase/firebase_config.dart';
import 'package:flavorizr/config/flavors.dart';
import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/core/error/error_handler.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/router/app_router.dart';
import 'package:flavorizr/core/services/notification_service.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/observers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // 5. Set up Firebase Messaging background handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 6. Initialize app configuration
      AppConfig.initialize(flavor);

      // 7. Initialize logger
      await AppLogger.instance.initialize(
        config: flavor.isProduction ? const AppLoggerConfig.prodction() : const AppLoggerConfig(),
      );

      // 8. Initialize error handling
      ErrorHandler.initialize(enableCrashReporting: flavor.enableCrashReporting);

      // 9. Initialize notification service
      final notificationInitialized = await NotificationService.instance.initialize();
      if (notificationInitialized) {
        // Set foreground notification presentation options for iOS
        await NotificationService.instance.setForegroundNotificationPresentationOptions();

        await AppLogger.instance.logInfo(
          'Notification service initialized',
          data: {
            'fcmToken': NotificationService.instance.fcmToken?.substring(0, 20),
            'isAuthorized': NotificationService.instance.isAuthorized,
          },
        );
      } else {
        await AppLogger.instance.logWarning(
          'Notification service initialization failed or permission denied',
        );
      }

      // 10. Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // 11. Set system UI style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );

      // 12. Ensure screen size is initialized
      await ScreenUtil.ensureScreenSize();

      // 13. Initialize storage providers
      final sharedPreferences = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
      );

      // 14. Initialize router with authentication guards
      final routerGuards = _RouterGuards(
        secureStorage: secureStorage,
        sharedPreferences: sharedPreferences,
      );

      await AppRouter.instance.initialize(
        isAuthenticated: routerGuards.checkAuthentication,
        isOnboardingCompleted: routerGuards.checkOnboardingCompleted,
        getUserRole: routerGuards.getUserRole,
      );

      // 15. Initialize API client
      final apiClient = ApiClient.instance;

      // 16. Log successful bootstrap
      await AppLogger.instance.logInfo(
        'App bootstrapped successfully',
        data: {
          'flavor': flavor.name,
          'buildMode': kReleaseMode ? 'release' : 'debug',
          'timestamp': DateTime.now().toIso8601String(),
          'notificationsEnabled': notificationInitialized,
        },
      );

      // 17. Run the app with provider overrides
      runApp(
        ProviderScope(
          observers: kDebugMode ? [ProviderLogger()] : [],
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            apiClientProvider.overrideWithValue(apiClient),
          ],
          child: const App(),
        ),
      );
    },
    (error, stackTrace) {
      // Handle uncaught errors
      ErrorHandler.handleZoneError(error, stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    },
  );
}

// ==================== Helper Classes ====================

/// HTTP overrides for development to allow self-signed certificates.
class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
}

/// Helper class for router authentication and authorization guards.
///
/// Encapsulates all router guard logic to keep bootstrap code clean.
class _RouterGuards {
  const _RouterGuards({required this.secureStorage, required this.sharedPreferences});

  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  // Storage keys
  static const String _accessTokenKey = 'auth_access_token';
  static const String _accessTokenExpiryKey = 'auth_access_token_expiry';
  static const String _userDataKey = 'auth_user';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Checks if the user is authenticated by validating stored tokens.
  ///
  /// Returns `true` if:
  /// - Access token exists
  /// - Token expiry exists
  /// - Token has not expired
  Future<bool> checkAuthentication() async {
    try {
      final accessToken = await secureStorage.read(key: _accessTokenKey);
      final accessTokenExpiry = await secureStorage.read(key: _accessTokenExpiryKey);

      if (accessToken == null || accessTokenExpiry == null) {
        return false;
      }

      final expiryDate = DateTime.parse(accessTokenExpiry);
      final isValid = DateTime.now().isBefore(expiryDate);

      if (!isValid) {
        await AppLogger.instance.logDebug('Authentication token has expired');
      }

      return isValid;
    } catch (e) {
      await AppLogger.instance.logError(
        'Error checking authentication',
        data: {'error': e.toString()},
      );
      return false;
    }
  }

  /// Checks if the user has completed the onboarding flow.
  Future<bool> checkOnboardingCompleted() async {
    return sharedPreferences.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Determines the user's primary role from stored user data.
  ///
  /// Role priority: company/admin > driver > consumer (default)
  Future<String> getUserRole() async {
    try {
      final userJson = sharedPreferences.getString(_userDataKey);
      if (userJson == null) {
        await AppLogger.instance.logDebug('No user data found, defaulting to consumer role');
        return 'consumer';
      }

      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      final roles = List<String>.from(userData['roles'] as List? ?? []);

      // Determine primary role with priority
      final role = _determinePrimaryRole(roles);

      await AppLogger.instance.logDebug('User role determined: $role', data: {'roles': roles});
      return role;
    } catch (e) {
      await AppLogger.instance.logWarning(
        'Error getting user role, defaulting to consumer',
        data: {'error': e.toString()},
      );
      return 'consumer';
    }
  }

  /// Determines the primary role from a list of roles.
  String _determinePrimaryRole(List<String> roles) {
    if (roles.contains('company') || roles.contains('admin')) {
      return 'company';
    } else if (roles.contains('driver')) {
      return 'driver';
    } else {
      return 'consumer';
    }
  }
}
