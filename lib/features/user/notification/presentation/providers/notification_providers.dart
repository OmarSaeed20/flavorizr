import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/user/notification/data/datasources/notification_remote_datasource.dart';
import 'package:flavorizr/features/user/notification/data/repositories/notification_repository_impl.dart';
import 'package:flavorizr/features/user/notification/domain/repositories/notification_repository.dart';
import 'package:flavorizr/features/user/notification/domain/usecases/get_notification_count_usecase.dart';
import 'package:flavorizr/features/user/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:flavorizr/features/user/notification/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:flavorizr/features/user/notification/domain/usecases/mark_as_read_usecase.dart';
import 'package:flavorizr/features/user/notification/presentation/controllers/notification_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Datasource Provider
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return NotificationRemoteDataSourceImpl(apiClient);
    });

// Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return NotificationRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

// Use Case Providers
final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationsUseCase(repository);
});

final getNotificationCountUseCaseProvider =
    Provider<GetNotificationCountUseCase>((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return GetNotificationCountUseCase(repository);
    });

final markAsReadUseCaseProvider = Provider<MarkAsReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAsReadUseCase(repository);
});

final markAllAsReadUseCaseProvider = Provider<MarkAllAsReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAllAsReadUseCase(repository);
});

// Controller Provider
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
      return NotificationController(
        ref.watch(getNotificationsUseCaseProvider),
        ref.watch(getNotificationCountUseCaseProvider),
        ref.watch(markAsReadUseCaseProvider),
        ref.watch(markAllAsReadUseCaseProvider),
      );
    });
