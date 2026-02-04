import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_vehicle.dart';
import 'package:flavorizr/features/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for getting driver vehicle.
class GetDriverVehicleUseCase {
  final DriverProfileRepository _repository;

  GetDriverVehicleUseCase(this._repository);

  /// Executes the get driver vehicle use case.
  Future<ApiResult<DriverVehicle>> call() {
    return _repository.getDriverVehicle();
  }
}