import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:fast_golden_taxi/features/user/home/data/datasources/home_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/home/data/repositories/home_repository_impl.dart';
import 'package:fast_golden_taxi/features/user/home/domain/repositories/home_repository.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_advertisements_usecase.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_available_trips_usecase.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_home_data_usecase.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_notification_count_usecase.dart';
import 'package:fast_golden_taxi/features/user/home/presentation/controllers/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Datasource Provider
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeRemoteDataSourceImpl(apiClient);
});

// Repository Provider
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return HomeRepositoryImpl(remoteDataSource: remoteDataSource, networkInfo: networkInfo);
});

// Use Case Providers
final getHomeDataUseCaseProvider = Provider<GetHomeDataUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetHomeDataUseCase(repository);
});

final getAdvertisementsUseCaseProvider = Provider<GetAdvertisementsUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetAdvertisementsUseCase(repository);
});

final getAvailableTripsUseCaseProvider = Provider<GetAvailableTripsUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetAvailableTripsUseCase(repository);
});

final getNotificationCountUseCaseProvider = Provider<GetNotificationCountUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetNotificationCountUseCase(repository);
});

// Controller Provider
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(
    ref.watch(getHomeDataUseCaseProvider),
    ref.watch(getAdvertisementsUseCaseProvider),
    ref.watch(getAvailableTripsUseCaseProvider),
    ref.watch(getNotificationCountUseCaseProvider),
  );
});
