import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_settings/domain/entities/driver_settings.dart';
import 'package:flavorizr/features/driver_settings/domain/repositories/driver_settings_repository.dart';

/// Use case for toggling online status.
class ToggleOnlineStatusUseCase {
  final DriverSettingsRepository _repository;

  ToggleOnlineStatusUseCase(this._repository);

  Future<ApiResult<DriverSettings>> call(bool isOnline) {
    return _repository.toggleOnlineStatus(isOnline);
  }
}