import '../repositories/driver_home_repository.dart';

/// Use case for updating driver availability status
class UpdateAvailabilityStatus {
  final DriverHomeRepository repository;

  UpdateAvailabilityStatus(this.repository);

  Future<bool> call(bool isAvailable) async {
    return await repository.updateAvailabilityStatus(isAvailable);
  }
}