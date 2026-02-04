import 'package:flavorizr/core/network/api/repositories/chat_repository.dart';
import 'package:flavorizr/core/network/api/repositories/chat_repository_impl.dart';
import 'package:flavorizr/core/network/api/repositories/general_repository.dart';
import 'package:flavorizr/core/network/api/repositories/general_repository_impl.dart';
import 'package:flavorizr/core/network/api/repositories/notification_repository.dart';
import 'package:flavorizr/core/network/api/repositories/notification_repository_impl.dart';
import 'package:flavorizr/core/network/api/repositories/trip_repository.dart';
import 'package:flavorizr/core/network/api/repositories/trip_repository_impl.dart';
import 'package:flavorizr/core/network/api/repositories/user_repository.dart';
import 'package:flavorizr/core/network/api/repositories/user_repository_impl.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dependency Injection Providers
/// Central location for all Riverpod providers

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.instance;
});

// User Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepositoryImpl(apiClient.dio);
});

// User Service Provider
// final userServiceProvider = Provider<UserService>((ref) {
//   final repository = ref.watch(userRepositoryProvider);
//   return UserService(repository: repository);
// });

// Trip Repository Provider
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TripRepositoryImpl(apiClient.dio);
});

// Trip Service Provider
// final tripServiceProvider = Provider<TripService>((ref) {
//   final repository = ref.watch(tripRepositoryProvider);
//   return TripService(repository: repository);
// });

// Notification Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepositoryImpl(apiClient.dio);
});

// Notification Service Provider
// final notificationServiceProvider = Provider<NotificationService>((ref) {
//   final repository = ref.watch(notificationRepositoryProvider);
//   return NotificationService(repository: repository);
// });

// Chat Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatRepositoryImpl(apiClient.dio);
});

// Chat Service Provider
// final chatServiceProvider = Provider<ChatService>((ref) {
//   final repository = ref.watch(chatRepositoryProvider);
//   return ChatService(repository: repository);
// });

// General Repository Provider
final generalRepositoryProvider = Provider<GeneralRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GeneralRepositoryImpl(apiClient.dio);
});

// General Service Provider
// final generalServiceProvider = Provider<GeneralService>((ref) {
//   final repository = ref.watch(generalRepositoryProvider);
//   return GeneralService(repository: repository);
// });
