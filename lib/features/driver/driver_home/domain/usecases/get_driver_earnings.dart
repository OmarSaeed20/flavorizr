import '../entities/driver_earnings.dart';
import '../repositories/driver_home_repository.dart';

/// Use case for getting driver earnings
class GetDriverEarnings {
  final DriverHomeRepository repository;

  GetDriverEarnings(this.repository);

  Future<DriverEarnings> call() async {
    return await repository.getDriverEarnings();
  }
}