import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/direct_booking/data/parameters/get_nearby_drivers_parameters.dart';
import 'package:flavorizr/features/user/direct_booking/domain/entities/driver.dart';
import 'package:flavorizr/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Use case for getting nearby drivers.
class GetNearbyDriversUseCase {
  final DirectBookingRepository _repository;

  GetNearbyDriversUseCase(this._repository);

  Future<ApiResult<List<Driver>>> call(
    GetNearbyDriversParameters params,
  ) {
    return _repository.getNearbyDrivers(params);
  }
}