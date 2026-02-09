// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:fast_golden_taxi/features/user/auth/data/parameters/logout_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

/// Use case for logging out the current user.
///
/// This use case:
/// 1. Signs out from the backend (invalidates tokens)
/// 2. Clears local storage
/// 3. Resets auth state
class LogoutUseCase implements UseCase<void, LogoutParams> {
  LogoutUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<void> call(LogoutParams params) async {
    final logoutParams = LogoutParameters(
      deviceType: params.deviceType,
      deviceToken: params.deviceToken,
      deviceId: params.deviceId,
    );
    return _repository.signOut(logoutParams);
  }
}

/// Parameters for the logout use case.
class LogoutParams {
  const LogoutParams({required this.deviceType, this.deviceToken, this.deviceId});

  final String deviceType;
  final String? deviceToken;
  final String? deviceId;
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
