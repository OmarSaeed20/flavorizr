import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/driver/driver_profile/data/datasources/driver_profile_local_datasource.dart';
import 'package:flavorizr/features/driver/driver_profile/data/datasources/driver_profile_remote_datasource.dart';
import 'package:flavorizr/features/driver/driver_profile/data/repositories/driver_profile_repository_impl.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/usecases/delete_driver_document_usecase.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/usecases/get_driver_documents_usecase.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/usecases/get_driver_profile_usecase.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/usecases/get_driver_vehicle_usecase.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/usecases/update_driver_profile_usecase.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/usecases/update_driver_vehicle_usecase.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/usecases/upload_driver_document_usecase.dart';
import 'package:flavorizr/features/driver/driver_profile/presentation/controllers/driver_profile_controller.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for DriverProfileRemoteDataSource.
final driverProfileRemoteDataSourceProvider =
    Provider<DriverProfileRemoteDataSource>((ref) {
      return DriverProfileRemoteDataSourceImpl(ref.watch(apiClientProvider));
    });

/// Provider for DriverProfileLocalDataSource.
final driverProfileLocalDataSourceProvider =
    Provider<DriverProfileLocalDataSource>((ref) {
      return DriverProfileLocalDataSourceImpl(
        prefs: ref.watch(sharedPreferencesProvider),
      );
    });

/// Provider for DriverProfileRepository.
final driverProfileRepositoryProvider = Provider<DriverProfileRepository>((
  ref,
) {
  return DriverProfileRepositoryImpl(
    remoteDataSource: ref.watch(driverProfileRemoteDataSourceProvider),
    localDataSource: ref.watch(driverProfileLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

/// Provider for GetDriverProfileUseCase.
final getDriverProfileUseCaseProvider = Provider<GetDriverProfileUseCase>((
  ref,
) {
  return GetDriverProfileUseCase(ref.watch(driverProfileRepositoryProvider));
});

/// Provider for UpdateDriverProfileUseCase.
final updateDriverProfileUseCaseProvider = Provider<UpdateDriverProfileUseCase>(
  (ref) {
    return UpdateDriverProfileUseCase(
      ref.watch(driverProfileRepositoryProvider),
    );
  },
);

/// Provider for GetDriverVehicleUseCase.
final getDriverVehicleUseCaseProvider = Provider<GetDriverVehicleUseCase>((
  ref,
) {
  return GetDriverVehicleUseCase(ref.watch(driverProfileRepositoryProvider));
});

/// Provider for UpdateDriverVehicleUseCase.
final updateDriverVehicleUseCaseProvider = Provider<UpdateDriverVehicleUseCase>(
  (ref) {
    return UpdateDriverVehicleUseCase(
      ref.watch(driverProfileRepositoryProvider),
    );
  },
);

/// Provider for UploadDriverDocumentUseCase.
final uploadDriverDocumentUseCaseProvider =
    Provider<UploadDriverDocumentUseCase>((ref) {
      return UploadDriverDocumentUseCase(
        ref.watch(driverProfileRepositoryProvider),
      );
    });

/// Provider for GetDriverDocumentsUseCase.
final getDriverDocumentsUseCaseProvider = Provider<GetDriverDocumentsUseCase>((
  ref,
) {
  return GetDriverDocumentsUseCase(ref.watch(driverProfileRepositoryProvider));
});

/// Provider for DeleteDriverDocumentUseCase.
final deleteDriverDocumentUseCaseProvider =
    Provider<DeleteDriverDocumentUseCase>((ref) {
      return DeleteDriverDocumentUseCase(
        ref.watch(driverProfileRepositoryProvider),
      );
    });

/// Provider for DriverProfileController.
final driverProfileControllerProvider =
    StateNotifierProvider<DriverProfileController, DriverProfileState>((ref) {
      return DriverProfileController(
        ref.watch(getDriverProfileUseCaseProvider),
        ref.watch(updateDriverProfileUseCaseProvider),
        ref.watch(getDriverVehicleUseCaseProvider),
        ref.watch(updateDriverVehicleUseCaseProvider),
        ref.watch(uploadDriverDocumentUseCaseProvider),
        ref.watch(getDriverDocumentsUseCaseProvider),
        ref.watch(deleteDriverDocumentUseCaseProvider),
      );
    });
