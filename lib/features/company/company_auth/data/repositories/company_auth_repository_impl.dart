// lib/features/company/company_auth/data/repositories/company_auth_repository_impl.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/datasources/company_auth_local_datasource.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/datasources/company_auth_remote_datasource.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_login_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_logout_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_register_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/repositories/company_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Company Authentication Repository Implementation
///
/// Implements company authentication repository combining remote and local data sources.
/// Handles error mapping and data transformation.
class CompanyAuthRepositoryImpl implements CompanyAuthRepository {
  final CompanyAuthRemoteDataSource _remoteDataSource;
  final CompanyAuthLocalDataSource _localDataSource;

  CompanyAuthRepositoryImpl({
    required CompanyAuthRemoteDataSource remoteDataSource,
    required CompanyAuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<ApiResult<AuthTokens>> login(CompanyLoginParameters parameters) async {
    final result = await _remoteDataSource.login(parameters);

    return result.when(
      success: (authResponse, _) async {
        // Convert ApiAuthResponse to AuthTokens
        final expiresIn = authResponse.expiresIn ?? 3600;
        final tokens = AuthTokens(
          accessToken: authResponse.accessToken ?? authResponse.token ?? '',
          refreshToken: authResponse.refreshToken ?? '',
          accessTokenExpiresAt: DateTime.now().add(
            Duration(seconds: expiresIn),
          ),
          tokenType: authResponse.tokenType ?? 'Bearer',
        );

        // Save tokens locally
        await _localDataSource.saveTokens(tokens);

        // Save user data if available
        if (authResponse.user != null) {
          final user = UserModel.fromApiUser(authResponse.user!);
          await _localDataSource.saveUser(user);
        }

        return ApiResult.success(tokens);
      },
      exception: ApiResult.failure,
    );
  }

  @override
  Future<ApiResult<AuthTokens>> register(
    CompanyRegisterParameters parameters,
  ) async {
    final result = await _remoteDataSource.register(parameters);

    return result.when(
      success: (authResponse, _) async {
        // Convert ApiAuthResponse to AuthTokens
        final expiresIn = authResponse.expiresIn ?? 3600;
        final tokens = AuthTokens(
          accessToken: authResponse.accessToken ?? authResponse.token ?? '',
          refreshToken: authResponse.refreshToken ?? '',
          accessTokenExpiresAt: DateTime.now().add(
            Duration(seconds: expiresIn),
          ),
          tokenType: authResponse.tokenType ?? 'Bearer',
        );

        // Save tokens locally
        await _localDataSource.saveTokens(tokens);

        // Save user data if available
        if (authResponse.user != null) {
          final user = UserModel.fromApiUser(authResponse.user!);
          await _localDataSource.saveUser(user);
        }

        return ApiResult.success(tokens);
      },
      exception: ApiResult.failure,
    );
  }

  @override
  Future<ApiResult<void>> logout(CompanyLogoutParameters parameters) async {
    final result = await _remoteDataSource.logout(parameters);

    return result.when(
      success: (_, __) async {
        // Clear local auth data
        await _localDataSource.clearAll();
        return const ApiResult.success(null);
      },
      exception: (error) async {
        // Even if API call fails, clear local data
        await _localDataSource.clearAll();
        return ApiResult.failure(error);
      },
    );
  }

  @override
  Future<ApiResult<void>> sendVerificationCode(
    CompanySendVerificationCodeParameters parameters,
  ) async {
    return _remoteDataSource.sendVerificationCode(parameters);
  }

  @override
  Future<ApiResult<AuthTokens>> verifyPhone(
    CompanyVerifyPhoneParameters parameters,
  ) async {
    final result = await _remoteDataSource.verifyPhone(parameters);

    return result.when(
      success: (authResponse, _) async {
        // Convert ApiAuthResponse to AuthTokens
        final expiresIn = authResponse.expiresIn ?? 3600;
        final tokens = AuthTokens(
          accessToken: authResponse.accessToken ?? authResponse.token ?? '',
          refreshToken: authResponse.refreshToken ?? '',
          accessTokenExpiresAt: DateTime.now().add(
            Duration(seconds: expiresIn),
          ),
          tokenType: authResponse.tokenType ?? 'Bearer',
        );

        // Save tokens locally
        await _localDataSource.saveTokens(tokens);

        // Save user data if available
        if (authResponse.user != null) {
          final user = UserModel.fromApiUser(authResponse.user!);
          await _localDataSource.saveUser(user);
        }

        return ApiResult.success(tokens);
      },
      exception: ApiResult.failure,
    );
  }

  @override
  Future<ApiResult<void>> forgetPassword(
    CompanyForgetPasswordParameters parameters,
  ) async {
    return _remoteDataSource.forgetPassword(parameters);
  }

  @override
  Future<ApiResult<void>> resetPassword(
    CompanyResetPasswordParameters parameters,
  ) async {
    return _remoteDataSource.resetPassword(parameters);
  }

  @override
  Future<AuthTokens?> getTokens() async {
    return _localDataSource.getTokens();
  }

  @override
  Future<UserModel?> getUser() async {
    return _localDataSource.getUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _localDataSource.isLoggedIn();
  }

  @override
  Future<void> clearAuthData() async {
    await _localDataSource.clearAuthData();
  }
}
