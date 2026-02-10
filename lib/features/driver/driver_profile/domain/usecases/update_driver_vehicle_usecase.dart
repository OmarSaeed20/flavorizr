import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_vehicle.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for updating driver vehicle.
class UpdateDriverVehicleUseCase {
  final DriverProfileRepository _repository;

  UpdateDriverVehicleUseCase(this._repository);

  /// Executes the update driver vehicle use case.
  Future<ApiResult<DriverVehicle>> call({
    String? vehicleTypeId,
    String? vehiclePlateNumber,
    String? vehicleImage,
    String? vehicleLicenseImage,
  }) {
    return _repository.updateVehicle(
      vehicleTypeId: vehicleTypeId,
      vehiclePlateNumber: vehiclePlateNumber,
      vehicleImage: vehicleImage,
      vehicleLicenseImage: vehicleLicenseImage,
    );
  }
}
