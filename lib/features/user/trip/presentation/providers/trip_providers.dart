// lib/features/trip/presentation/providers/trip_providers.dart
import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/user/trip/data/datasources/trip_local_datasource.dart';
import 'package:flavorizr/features/user/trip/data/datasources/trip_remote_datasource.dart';
import 'package:flavorizr/features/user/trip/data/repositories/trip_repository_impl.dart';
import 'package:flavorizr/features/user/trip/domain/repositories/trip_repository.dart';
import 'package:flavorizr/features/user/trip/domain/usecases/trip_usecases.dart';
import 'package:flavorizr/features/user/trip/presentation/controllers/trip_controller.dart';
import 'package:flavorizr/features/user/trip/presentation/controllers/trip_history_controller.dart';
import 'package:flavorizr/features/user/trip/presentation/controllers/trip_order_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== Data Sources ====================

/// Provider for TripRemoteDataSource.
final tripRemoteDataSourceProvider = Provider<TripRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TripRemoteDataSourceImpl(apiClient);
});

/// Provider for TripLocalDataSource.
final tripLocalDataSourceProvider = Provider<TripLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TripLocalDataSourceImpl(prefs: prefs);
});

// ==================== Repository ====================

/// Provider for TripRepository.
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final remoteDataSource = ref.watch(tripRemoteDataSourceProvider);
  final localDataSource = ref.watch(tripLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return TripRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

// ==================== Use Cases ====================

/// Provider for GetTripTypesUseCase.
final getTripTypesUseCaseProvider = Provider<GetTripTypesUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return GetTripTypesUseCase(repository);
});

/// Provider for GetTripDetailUseCase.
final getTripDetailUseCaseProvider = Provider<GetTripDetailUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return GetTripDetailUseCase(repository);
});

/// Provider for GetCaptainTripDetailUseCase.
final getCaptainTripDetailUseCaseProvider = Provider<GetCaptainTripDetailUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return GetCaptainTripDetailUseCase(repository);
});

/// Provider for GetTripHistoryUseCase.
final getTripHistoryUseCaseProvider = Provider<GetTripHistoryUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return GetTripHistoryUseCase(repository);
});

/// Provider for GetAvailablePublicTripsUseCase.
final getAvailablePublicTripsUseCaseProvider = Provider<GetAvailablePublicTripsUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return GetAvailablePublicTripsUseCase(repository);
});

/// Provider for StorePublicTripUseCase.
final storePublicTripUseCaseProvider = Provider<StorePublicTripUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return StorePublicTripUseCase(repository);
});

/// Provider for StorePrivateTripUseCase.
final storePrivateTripUseCaseProvider = Provider<StorePrivateTripUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return StorePrivateTripUseCase(repository);
});

/// Provider for EditPrivateTripUseCase.
final editPrivateTripUseCaseProvider = Provider<EditPrivateTripUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return EditPrivateTripUseCase(repository);
});

/// Provider for ConfirmTripUseCase.
final confirmTripUseCaseProvider = Provider<ConfirmTripUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return ConfirmTripUseCase(repository);
});

/// Provider for CancelTripUseCase.
final cancelTripUseCaseProvider = Provider<CancelTripUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return CancelTripUseCase(repository);
});

/// Provider for ReportTripUseCase.
final reportTripUseCaseProvider = Provider<ReportTripUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return ReportTripUseCase(repository);
});

/// Provider for TripEvaluationUseCase.
final tripEvaluationUseCaseProvider = Provider<TripEvaluationUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return TripEvaluationUseCase(repository);
});

/// Provider for BookNowOrderUseCase.
final bookNowOrderUseCaseProvider = Provider<BookNowOrderUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return BookNowOrderUseCase(repository);
});

/// Provider for GetMyOrdersUseCase.
final getMyOrdersUseCaseProvider = Provider<GetMyOrdersUseCase>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return GetMyOrdersUseCase(repository);
});

// ==================== Controllers ====================

/// Provider for TripController.
final tripControllerProvider = AutoDisposeNotifierProvider<TripController, TripState>(
  TripController.new,
);

/// Provider for TripHistoryController.
final tripHistoryControllerProvider =
    AutoDisposeNotifierProvider<TripHistoryController, TripHistoryState>(TripHistoryController.new);

/// Provider for TripOrderController.
final tripOrderControllerProvider =
    AutoDisposeNotifierProvider<TripOrderController, TripOrderState>(TripOrderController.new);
