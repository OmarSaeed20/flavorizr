import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/datasources/driver_auth_local_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/datasources/driver_auth_remote_datasource.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/parameters/driver_login_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/parameters/driver_register_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/parameters/reset_driver_password_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/data/parameters/verify_driver_phone_parameters.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/entities/driver_credentials.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Implementation of DriverAuthRepository.
///
/// Extends BaseRepository for consistent error handling and network checks.
/// Based on the FAST App API documentation.
class DriverAuthRepositoryImpl extends BaseRepository implements DriverAuthRepository {
  final DriverAuthRemoteDataSource _remoteDataSource;
  final DriverAuthLocalDataSource _localDataSource;

  DriverAuthRepositoryImpl({
    required DriverAuthRemoteDataSource remoteDataSource,
    required DriverAuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<DriverCredentials>> login({
    required String phone,
    required String password,
  }) async {
    final parameters = DriverLoginParameters.builder()
        .withPhone(phone)
        .withPassword(password)
        .build();

    final result = await executeRemoteRequest(request: () => _remoteDataSource.login(parameters));

    return result.when(
      success: (data, _) async {
        // Cache credentials locally for offline access
        await _localDataSource.cacheCredentials(data);
        await _localDataSource.saveAccessToken(data.accessToken);
        await _localDataSource.saveRefreshToken(data.refreshToken);
        await _localDataSource.saveDriverId(data.driver.id);
        return ApiResult.success(data.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverCredentials>> register({
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
    final parameters = DriverRegisterParameters.builder()
        .withPhone(phone)
        .withPassword(password)
        .withPasswordConfirmation(passwordConfirmation)
        .withName(name)
        .withEmail(email)
        .withCountryId(countryId)
        .withGovernorateId(governorateId)
        .withCityId(cityId)
        .withBirthdate(birthdate)
        .withGender(gender)
        .withNationalId(nationalId)
        .withNationalIdImage(nationalIdImage)
        .withDrivingLicenseImage(drivingLicenseImage)
        .withVehicleLicenseImage(vehicleLicenseImage)
        .withVehicleImage(vehicleImage)
        .withVehicleTypeId(vehicleTypeId)
        .withVehiclePlateNumber(vehiclePlateNumber)
        .build();

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.register(parameters),
    );

    return result.when(
      success: (data, _) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverCredentials>> verifyPhone({
    required String phone,
    required String code,
    required String firebaseToken,
  }) async {
    final parameters = VerifyDriverPhoneParameters.builder()
        .withPhone(phone)
        .withCode(code)
        .withFirebaseToken(firebaseToken)
        .build();

    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.verifyPhone(parameters),
    );

    return result.when(
      success: (data, _) async {
        // Cache credentials locally for offline access
        await _localDataSource.cacheCredentials(data);
        await _localDataSource.saveAccessToken(data.accessToken);
        await _localDataSource.saveRefreshToken(data.refreshToken);
        await _localDataSource.saveDriverId(data.driver.id);
        return ApiResult.success(data.toEntity());
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<void>> forgetPassword({required String phone}) async {
    return executeRemoteRequest(request: () => _remoteDataSource.forgetPassword(phone: phone));
  }

  @override
  Future<ApiResult<void>> resetPassword({
    required String code,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final parameters = ResetDriverPasswordParameters.builder()
        .withCode(code)
        .withPhone(phone)
        .withPassword(password)
        .withPasswordConfirmation(passwordConfirmation)
        .build();

    return executeRemoteRequest(request: () => _remoteDataSource.resetPassword(parameters));
  }

  @override
  Future<ApiResult<void>> logout() async {
    final result = await executeRemoteRequest(request: _remoteDataSource.logout);

    return result.when(
      success: (_, __) async {
        // Clear all cached credentials
        await _localDataSource.clearCredentials();
        await _localDataSource.clearAccessToken();
        await _localDataSource.clearRefreshToken();
        await _localDataSource.clearDriverId();
        return const ApiResult.success(null);
      },
      exception: ApiResult.exception,
    );
  }

  @override
  Future<ApiResult<DriverCredentials>> refreshToken() async {
    final result = await executeRemoteRequest(request: _remoteDataSource.refreshToken);

    return result.when(
      success: (data, _) => ApiResult.success(data.toEntity()),
      exception: ApiResult.exception,
    );
  }
}
