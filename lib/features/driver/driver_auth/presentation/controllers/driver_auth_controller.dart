import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/entities/driver_credentials.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/usecases/driver_login_usecase.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/usecases/driver_logout_usecase.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/usecases/driver_register_usecase.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/usecases/reset_driver_password_usecase.dart';
import 'package:flavorizr/features/driver/driver_auth/domain/usecases/verify_driver_phone_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for driver authentication operations.
class DriverAuthState {
  final DriverCredentials? credentials;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const DriverAuthState({
    this.credentials,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  DriverAuthState copyWith({
    DriverCredentials? credentials,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return DriverAuthState(
      credentials: credentials ?? this.credentials,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
    );
  }
}

/// Controller for managing driver authentication operations.
class DriverAuthController extends StateNotifier<DriverAuthState> {
  final DriverLoginUseCase _driverLoginUseCase;
  final DriverLogoutUseCase _driverLogoutUseCase;
  final DriverRegisterUseCase _driverRegisterUseCase;
  final VerifyDriverPhoneUseCase _verifyDriverPhoneUseCase;
  final ResetDriverPasswordUseCase _resetDriverPasswordUseCase;

  DriverAuthController(
    this._driverLoginUseCase,
    this._driverLogoutUseCase,
    this._driverRegisterUseCase,
    this._verifyDriverPhoneUseCase,
    this._resetDriverPasswordUseCase,
  ) : super(const DriverAuthState());

  /// Logs in a driver.
  Future<void> login({required String phone, required String password}) async {
    state = state.copyWith(isLoading: true);

    final result = await _driverLoginUseCase(phone: phone, password: password);

    result.when(
      success: (data, _) {
        state = state.copyWith(credentials: data, isAuthenticated: true, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Logs out the current driver.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await _driverLogoutUseCase();

    result.when(
      success: (_, _) {
        state = const DriverAuthState();
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Registers a new driver.
  Future<void> register({
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String name,
    required String email,
    required int countryId,
    required int governorateId,
    required int cityId,
    required String birthdate,
    required String gender,
    required String nationalId,
    required String nationalIdImage,
    required String drivingLicenseImage,
    required String vehicleLicenseImage,
    required String vehicleImage,
    required int vehicleTypeId,
    required String vehiclePlateNumber,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _driverRegisterUseCase(
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
      name: name,
      email: email,
      countryId: countryId,
      governorateId: governorateId,
      cityId: cityId,
      birthdate: birthdate,
      gender: gender,
      nationalId: nationalId,
      nationalIdImage: nationalIdImage,
      drivingLicenseImage: drivingLicenseImage,
      vehicleLicenseImage: vehicleLicenseImage,
      vehicleImage: vehicleImage,
      vehicleTypeId: vehicleTypeId,
      vehiclePlateNumber: vehiclePlateNumber,
    );

    result.when(
      success: (data, _) {
        state = state.copyWith(credentials: data, isAuthenticated: true, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Verifies driver phone number with OTP.
  Future<void> verifyPhone({
    required String phone,
    required String code,
    required String firebaseToken,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _verifyDriverPhoneUseCase(
      phone: phone,
      code: code,
      firebaseToken: firebaseToken,
    );

    result.when(
      success: (data, _) {
        state = state.copyWith(credentials: data, isAuthenticated: true, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Resets driver password.
  Future<void> resetPassword({
    required String code,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _resetDriverPasswordUseCase(
      code: code,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.when(
      success: (_, _) {
        state = state.copyWith(isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Clears the current state.
  void clear() {
    state = const DriverAuthState();
  }

  /// Clears the error message.
  void clearError() {
    state = state.copyWith();
  }
}
