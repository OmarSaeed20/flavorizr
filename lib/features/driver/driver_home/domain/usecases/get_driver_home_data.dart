import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_home_data.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/repositories/driver_home_repository.dart';

/// Use case for getting complete driver home data
class GetDriverHomeData {
  final DriverHomeRepository repository;

  GetDriverHomeData(this.repository);

  Future<ApiResult<DriverHomeData>> call() async {
    return repository.getDriverHomeData();
  }
}
