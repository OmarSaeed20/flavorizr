import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/entities/driver_settings.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/repositories/driver_settings_repository.dart';

/// Use case for toggling availability status.
/// Note: This functionality needs to be added to the repository interface
class ToggleAvailabilityStatusUseCase {
  final DriverSettingsRepository repository;

  ToggleAvailabilityStatusUseCase(this.repository);

  Future<ApiResult<DriverSettings>> call(bool isAvailable) {
    // Implement when toggleAvailabilityStatus is added to repository
    throw UnimplementedError('toggleAvailabilityStatus not yet implemented in repository');
  }
}
