import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/direct_booking/domain/entities/vehicle_type.dart';
import 'package:flavorizr/features/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Use case for getting vehicle types.
class GetVehicleTypesUseCase {
  final DirectBookingRepository _repository;

  GetVehicleTypesUseCase(this._repository);

  Future<ApiResult<List<VehicleType>>> call() {
    return _repository.getVehicleTypes();
  }
}