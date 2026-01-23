// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for logging out the current user.
///
/// This use case:
/// 1. Signs out from the backend (invalidates tokens)
/// 2. Clears local storage
/// 3. Resets auth state
class LogoutUseCase implements UseCase<void, NoParams> {
  LogoutUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(NoParams params) async {
    return _repository.signOut();
  }
}

/// Use case for logging out from all devices.
class LogoutAllDevicesUseCase implements UseCase<void, NoParams> {
  LogoutAllDevicesUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(NoParams params) async {
    return _repository.signOutAllDevices();
  }
}
