import '../entities/driver_stats.dart';
import '../repositories/driver_home_repository.dart';

/// Use case for getting driver statistics
class GetDriverStats {
  final DriverHomeRepository repository;

  GetDriverStats(this.repository);

  Future<DriverStats> call() async {
    return await repository.getDriverStats();
  }
}