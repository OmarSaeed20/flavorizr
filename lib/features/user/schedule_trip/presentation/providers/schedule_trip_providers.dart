import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/datasources/schedule_trip_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/data/repositories/schedule_trip_repository_impl.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/repositories/schedule_trip_repository.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/usecases/cancel_scheduled_trip_usecase.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/usecases/create_scheduled_trip_usecase.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/usecases/get_scheduled_trip_by_id_usecase.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/usecases/get_scheduled_trips_usecase.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/domain/usecases/update_scheduled_trip_usecase.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/presentation/controllers/schedule_trip_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ScheduleTripRemoteDataSource.
final scheduleTripRemoteDataSourceProvider = Provider<ScheduleTripRemoteDataSource>((ref) {
  return ScheduleTripRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Provider for ScheduleTripRepository.
final scheduleTripRepositoryProvider = Provider<ScheduleTripRepository>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final remoteDataSource = ref.watch(scheduleTripRemoteDataSourceProvider);

  return ScheduleTripRepositoryImpl(remoteDataSource: remoteDataSource, networkInfo: networkInfo);
});

/// Provider for GetScheduledTripsUseCase.
final getScheduledTripsUseCaseProvider = Provider<GetScheduledTripsUseCase>((ref) {
  return GetScheduledTripsUseCase(ref.watch(scheduleTripRepositoryProvider));
});

/// Provider for GetScheduledTripByIdUseCase.
final getScheduledTripByIdUseCaseProvider = Provider<GetScheduledTripByIdUseCase>((ref) {
  return GetScheduledTripByIdUseCase(ref.watch(scheduleTripRepositoryProvider));
});

/// Provider for CreateScheduledTripUseCase.
final createScheduledTripUseCaseProvider = Provider<CreateScheduledTripUseCase>((ref) {
  return CreateScheduledTripUseCase(ref.watch(scheduleTripRepositoryProvider));
});

/// Provider for UpdateScheduledTripUseCase.
final updateScheduledTripUseCaseProvider = Provider<UpdateScheduledTripUseCase>((ref) {
  return UpdateScheduledTripUseCase(ref.watch(scheduleTripRepositoryProvider));
});

/// Provider for CancelScheduledTripUseCase.
final cancelScheduledTripUseCaseProvider = Provider<CancelScheduledTripUseCase>((ref) {
  return CancelScheduledTripUseCase(ref.watch(scheduleTripRepositoryProvider));
});

/// Provider for ScheduleTripController.
final scheduleTripControllerProvider =
    StateNotifierProvider<ScheduleTripController, ScheduleTripState>((ref) {
      return ScheduleTripController(
        ref.watch(getScheduledTripsUseCaseProvider),
        ref.watch(getScheduledTripByIdUseCaseProvider),
        ref.watch(createScheduledTripUseCaseProvider),
        ref.watch(updateScheduledTripUseCaseProvider),
        ref.watch(cancelScheduledTripUseCaseProvider),
      );
    });
