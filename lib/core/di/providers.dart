// lib/core/di/providers.dart
/// Dependency Injection Providers
///
/// Central location for all Riverpod providers in the application.
/// This file provides a single import point for all dependencies.
library;

import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/chat_repository.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/chat_repository_impl.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/general_repository.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/general_repository_impl.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/notification_repository.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/notification_repository_impl.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/trip_repository.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/trip_repository_impl.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/user_repository.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/user_repository_impl.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/websocket/websocket_manager.dart';
import 'package:fast_golden_taxi/core/performance/image_cache_service.dart';
import 'package:fast_golden_taxi/core/platform/platform_service.dart';
import 'package:fast_golden_taxi/core/services/notification_service.dart';
import 'package:fast_golden_taxi/services/analytics/analytics_service.dart';
import 'package:fast_golden_taxi/services/analytics/crashlytics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Export all providers for easy access
export 'package:fast_golden_taxi/core/di/providers.dart'
    show
        analyticsServiceProvider,
        apiClientProvider,
        appInitializationProvider,
        appLoggerProvider,
        chatRepositoryProvider,
        crashlyticsServiceProvider,
        generalRepositoryProvider,
        imageCacheServiceProvider,
        networkInfoProvider,
        notificationRepositoryProvider,
        notificationServiceProvider,
        platformServiceProvider,
        sharedPreferencesProvider,
        tripRepositoryProvider,
        userRepositoryProvider,
        webSocketManagerProvider;

// ==================== Storage Providers ====================

/// Provider for SharedPreferences instance.
///
/// This provider is typically overridden during app initialization
/// with the actual SharedPreferences instance.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs;
});

// ==================== Network Providers ====================

/// Provider for the API client singleton.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.instance;
});

/// Provider for network information (connectivity).
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

// ==================== Repository Providers ====================

/// Provider for the user repository.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepositoryImpl(apiClient.dio);
});

/// Provider for the trip repository.
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TripRepositoryImpl(apiClient.dio);
});

/// Provider for the notification repository.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepositoryImpl(apiClient.dio);
});

/// Provider for the chat repository.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatRepositoryImpl(apiClient.dio);
});

/// Provider for the general repository.
final generalRepositoryProvider = Provider<GeneralRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GeneralRepositoryImpl(apiClient.dio);
});

// ==================== Service Providers ====================

/// Provider for the notification service.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

/// Provider for the analytics service.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService.instance;
});

/// Provider for the crashlytics service.
final crashlyticsServiceProvider = Provider<CrashlyticsService>((ref) {
  return CrashlyticsService.instance;
});

/// Provider for the image cache service.
final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService.instance;
});

/// Provider for the platform service.
final platformServiceProvider = Provider<PlatformService>((ref) {
  return PlatformService.instance;
});

/// Provider for the WebSocket manager.
final webSocketManagerProvider = Provider<WebSocketManager>((ref) {
  return WebSocketManager.instance;
});

/// Provider for the app logger.
final appLoggerProvider = Provider<AppLogger>((ref) {
  return AppLogger.instance;
});

// ==================== Async Providers ====================

/// Async provider that initializes when the app starts.
///
/// This provider can be used to trigger initialization of services
/// that need to be set up before the app is fully ready.
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Initialize image cache service
  await ref.read(imageCacheServiceProvider).initialize();

  // Initialize platform service
  // await ref.read(platformServiceProvider).initialize();

  // Initialize WebSocket manager (will connect when authenticated)
  ref.read(webSocketManagerProvider);

  // Log initialization complete
  await AppLogger.instance.logInfo('App initialization complete');
});
