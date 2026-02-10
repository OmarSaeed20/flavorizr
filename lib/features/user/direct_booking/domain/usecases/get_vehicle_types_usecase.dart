import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/vehicle_type.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Use case for getting vehicle types.
class GetVehicleTypesUseCase {
  final DirectBookingRepository _repository;

  GetVehicleTypesUseCase(this._repository);

  Future<ApiResult<List<VehicleType>>> call() {
    return _repository.getVehicleTypes();
  }
}
