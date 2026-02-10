import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/data/parameters/update_driver_settings_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/entities/driver_settings.dart';
import 'package:fast_golden_taxi/features/driver/driver_settings/domain/repositories/driver_settings_repository.dart';

/// Use case for updating driver settings.
class UpdateDriverSettingsUseCase {
  final DriverSettingsRepository _repository;

  UpdateDriverSettingsUseCase(this._repository);

  Future<ApiResult<DriverSettings>> call(
    UpdateDriverSettingsParameters params,
  ) {
    return _repository.updateSettings(params);
  }
}
