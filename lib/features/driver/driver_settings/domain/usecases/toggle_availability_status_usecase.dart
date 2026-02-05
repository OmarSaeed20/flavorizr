import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/entities/driver_settings.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/repositories/driver_settings_repository.dart';

/// Use case for toggling availability status.
class ToggleAvailabilityStatusUseCase {
  final DriverSettingsRepository _repository;

  ToggleAvailabilityStatusUseCase(this._repository);

  Future<ApiResult<DriverSettings>> call(bool isAvailable) {
    return _repository.toggleAvailabilityStatus(isAvailable);
  }
}