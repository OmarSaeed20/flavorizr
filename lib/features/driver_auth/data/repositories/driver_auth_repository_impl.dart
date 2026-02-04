import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_auth/data/datasources/driver_auth_remote_datasource.dart';
import 'package:flavorizr/features/driver_auth/domain/entities/driver_credentials.dart';
import 'package:flavorizr/features/driver_auth/domain/repositories/driver_auth_repository.dart';

/// Implementation of DriverAuthRepository.
///
/// Extends BaseRepository for consistent error handling and network checks.
class DriverAuthRepositoryImpl extends BaseRepository implements DriverAuthRepository {
  final DriverAuthRemoteDataSource _remoteDataSource;

  DriverAuthRepositoryImpl({
    required DriverAuthRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;
  @override
  Future<ApiResult<DriverCredentials>> login({
    required String phone,
    required String password,
  }) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.login(phone: phone, password: password),
    );

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: (error) => ApiResult.error(error),
    );
  }

  @override
  Future<ApiResult<void>> logout() async {
    return executeRemoteRequest(request: _remoteDataSource.logout);
  }

  @override
  Future<ApiResult<DriverCredentials>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? profileImage,
  }) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        profileImage: profileImage,
      ),
    );

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: (error) => ApiResult.error(error),
    );
  }

  @override
  Future<ApiResult<DriverCredentials>> verifyPhone({
    required String phone,
    required String otp,
  }) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.verifyPhone(phone: phone, otp: otp),
    );

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: (error) => ApiResult.error(error),
    );
  }

  @override
  Future<ApiResult<void>> resetPassword({
    required String phone,
    required String newPassword,
    required String otp,
  }) async {
    return executeRemoteRequest(
      request: () =>
          _remoteDataSource.resetPassword(phone: phone, newPassword: newPassword, otp: otp),
    );
  }

  @override
  Future<ApiResult<DriverCredentials>> refreshToken({required String refreshToken}) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.refreshToken(refreshToken: refreshToken),
    );

    return result.when(
      success: (data) => ApiResult.success(data.toEntity()),
      exception: (error) => ApiResult.error(error),
    );
  }
}
