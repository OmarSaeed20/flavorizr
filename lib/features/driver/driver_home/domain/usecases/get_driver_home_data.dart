import '../entities/driver_home_data.dart';
import '../repositories/driver_home_repository.dart';

/// Use case for getting complete driver home data
class GetDriverHomeData {
  final DriverHomeRepository repository;

  GetDriverHomeData(this.repository);

  Future<DriverHomeData> call() async {
    return await repository.getDriverHomeData();
  }
}