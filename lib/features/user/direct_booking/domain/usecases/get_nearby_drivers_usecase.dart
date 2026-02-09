import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/get_nearby_drivers_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/driver.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Use case for getting nearby drivers.
class GetNearbyDriversUseCase {
  final DirectBookingRepository _repository;

  GetNearbyDriversUseCase(this._repository);

  Future<ApiResult<List<TaxiDriver>>> call(GetNearbyDriversParameters params) {
    return _repository.getNearbyDrivers(params);
  }
}
