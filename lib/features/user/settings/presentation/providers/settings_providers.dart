// lib/features/settings/presentation/providers/settings_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/user/settings/data/repositories/notification_settings_repository_impl.dart';
import 'package:fast_golden_taxi/features/user/settings/domain/entities/notification_settings.dart';
import 'package:fast_golden_taxi/features/user/settings/domain/repositories/notification_settings_repository.dart';
import 'package:fast_golden_taxi/features/user/settings/presentation/controllers/notification_settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== Repository Providers ====================

/// Provider for NotificationSettingsRepository.
final notificationSettingsRepositoryProvider = Provider<NotificationSettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return NotificationSettingsRepositoryImpl(prefs: prefs, networkInfo: networkInfo);
});

// ==================== State Providers ====================

/// Provider for the current notification settings.
final currentNotificationSettingsProvider = FutureProvider<NotificationSettings>((ref) async {
  final repository = ref.watch(notificationSettingsRepositoryProvider);
  final result = await repository.getSettings();
  return result.data ?? const NotificationSettings();
});

/// Stream provider for notification settings updates.
final notificationSettingsStreamProvider = StreamProvider<NotificationSettings>((ref) {
  final repository = ref.watch(notificationSettingsRepositoryProvider);
  return repository.settingsUpdates;
});

// ==================== Controller Providers ====================

/// Provider for NotificationSettingsController.
final notificationSettingsControllerProvider =
    NotifierProvider.autoDispose<NotificationSettingsController, NotificationSettingsState>(
      NotificationSettingsController.new,
    );
