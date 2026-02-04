import '../repositories/driver_home_repository.dart';

/// Use case for updating driver online status
class UpdateOnlineStatus {
  final DriverHomeRepository repository;

  UpdateOnlineStatus(this.repository);

  Future<bool> call(bool isOnline) async {
    return await repository.updateOnlineStatus(isOnline);
  }
}