import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/datasources/direct_booking_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/repositories/direct_booking_repository_impl.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/create_booking_usecase.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/get_nearby_drivers_usecase.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/get_vehicle_types_usecase.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/presentation/controllers/direct_booking_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DirectBookingRemoteDataSource.
final directBookingRemoteDataSourceProvider = Provider<DirectBookingRemoteDataSource>((ref) {
  return DirectBookingRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Provider for DirectBookingRepository.
final directBookingRepositoryProvider = Provider<DirectBookingRepository>((ref) {
  final remoteDataSource = ref.watch(directBookingRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DirectBookingRepositoryImpl(remoteDataSource: remoteDataSource, networkInfo: networkInfo);
});

/// Provider for GetVehicleTypesUseCase.
final getVehicleTypesUseCaseProvider = Provider<GetVehicleTypesUseCase>((ref) {
  return GetVehicleTypesUseCase(ref.watch(directBookingRepositoryProvider));
});

/// Provider for GetNearbyDriversUseCase.
final getNearbyDriversUseCaseProvider = Provider<GetNearbyDriversUseCase>((ref) {
  return GetNearbyDriversUseCase(ref.watch(directBookingRepositoryProvider));
});

/// Provider for CreateBookingUseCase.
final createBookingUseCaseProvider = Provider<CreateBookingUseCase>((ref) {
  return CreateBookingUseCase(ref.watch(directBookingRepositoryProvider));
});

/// Provider for CancelBookingUseCase.
final cancelBookingUseCaseProvider = Provider<CancelBookingUseCase>((ref) {
  return CancelBookingUseCase(ref.watch(directBookingRepositoryProvider));
});

/// Provider for DirectBookingController.
final directBookingControllerProvider =
    StateNotifierProvider<DirectBookingController, DirectBookingState>((ref) {
      return DirectBookingController(
        ref.watch(getVehicleTypesUseCaseProvider),
        ref.watch(getNearbyDriversUseCaseProvider),
        ref.watch(createBookingUseCaseProvider),
        ref.watch(cancelBookingUseCaseProvider),
      );
    });
