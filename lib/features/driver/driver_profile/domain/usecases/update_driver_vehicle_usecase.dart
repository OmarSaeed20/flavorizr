import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_vehicle.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for updating driver vehicle.
class UpdateDriverVehicleUseCase {
  final DriverProfileRepository _repository;

  UpdateDriverVehicleUseCase(this._repository);

  /// Executes the update driver vehicle use case.
  Future<ApiResult<DriverVehicle>> call({
    String? make,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    String? vehicleType,
    int? capacity,
    String? vin,
    String? registrationNumber,
    DateTime? registrationExpiry,
  }) {
    return _repository.updateDriverVehicle(
      make: make,
      model: model,
      year: year,
      color: color,
      licensePlate: licensePlate,
      vehicleType: vehicleType,
      capacity: capacity,
      vin: vin,
      registrationNumber: registrationNumber,
      registrationExpiry: registrationExpiry,
    );
  }
}