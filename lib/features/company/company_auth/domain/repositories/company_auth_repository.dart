// lib/features/company/company_auth/domain/repositories/company_auth_repository.dart
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_login_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_logout_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_register_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Company Authentication Repository Interface
///
/// Defines contract for company authentication operations.
/// Abstracts data sources and provides clean API for domain layer.
abstract class CompanyAuthRepository {
  /// Login company with phone and password
  Future<ApiResult<AuthTokens>> login(CompanyLoginParameters parameters);

  /// Register new company account
  Future<ApiResult<AuthTokens>> register(CompanyRegisterParameters parameters);

  /// Logout company account
  Future<ApiResult<void>> logout(CompanyLogoutParameters parameters);

  /// Send verification code to company phone
  Future<ApiResult<void>> sendVerificationCode(
    CompanySendVerificationCodeParameters parameters,
  );

  /// Verify company phone with confirmation code
  Future<ApiResult<AuthTokens>> verifyPhone(
    CompanyVerifyPhoneParameters parameters,
  );

  /// Initiate password reset
  Future<ApiResult<void>> forgetPassword(
    CompanyForgetPasswordParameters parameters,
  );

  /// Reset password with verification code
  Future<ApiResult<void>> resetPassword(
    CompanyResetPasswordParameters parameters,
  );

  /// Get stored auth tokens
  Future<AuthTokens?> getTokens();

  /// Get stored user data
  Future<UserModel?> getUser();

  /// Check if company is logged in
  Future<bool> isLoggedIn();

  /// Clear auth data
  Future<void> clearAuthData();
}
