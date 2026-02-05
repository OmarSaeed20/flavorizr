import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/entities/driver_settings.dart';
import 'package:flavorizr/features/driver/driver_settings/domain/repositories/driver_settings_repository.dart';

/// Use case for getting driver settings.
class GetDriverSettingsUseCase {
  final DriverSettingsRepository _repository;

  GetDriverSettingsUseCase(this._repository);

  Future<ApiResult<DriverSettings>> call() {
    return _repository.getSettings();
  }
}
