// lib/features/company/company_auth/presentation/controllers/company_auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_login_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_logout_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_register_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_forget_password_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_login_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_logout_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_register_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_reset_password_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_send_verification_code_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_auth/domain/usecases/company_verify_phone_usecase.dart';

part 'company_auth_controller.freezed.dart';

/// Company Auth State
///
/// Represents the current state of company authentication.
@freezed
class CompanyAuthState with _$CompanyAuthState {
  const CompanyAuthState._();

  const factory CompanyAuthState.initial() = _Initial;

  const factory CompanyAuthState.loading() = _Loading;

  const factory CompanyAuthState.authenticated() = _Authenticated;

  const factory CompanyAuthState.unauthenticated() = _Unauthenticated;

  const factory CompanyAuthState.error(NetworkException error) = _Error;

  const factory CompanyAuthState.verificationCodeSent() = _VerificationCodeSent;

  const factory CompanyAuthState.phoneVerified() = _PhoneVerified;

  const factory CompanyAuthState.passwordResetRequested() = _PasswordResetRequested;

  const factory CompanyAuthState.passwordReset() = _PasswordReset;
}

/// Company Auth Controller
///
/// Manages company authentication state and operations.
/// Uses Riverpod for state management.
class CompanyAuthController extends StateNotifier<CompanyAuthState> {
  final CompanyLoginUseCase _loginUseCase;
  final CompanyRegisterUseCase _registerUseCase;
  final CompanyLogoutUseCase _logoutUseCase;
  final CompanySendVerificationCodeUseCase _sendVerificationCodeUseCase;
  final CompanyVerifyPhoneUseCase _verifyPhoneUseCase;
  final CompanyForgetPasswordUseCase _forgetPasswordUseCase;
  final CompanyResetPasswordUseCase _resetPasswordUseCase;

  CompanyAuthController({
    required CompanyLoginUseCase loginUseCase,
    required CompanyRegisterUseCase registerUseCase,
    required CompanyLogoutUseCase logoutUseCase,
    required CompanySendVerificationCodeUseCase sendVerificationCodeUseCase,
    required CompanyVerifyPhoneUseCase verifyPhoneUseCase,
    required CompanyForgetPasswordUseCase forgetPasswordUseCase,
    required CompanyResetPasswordUseCase resetPasswordUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _sendVerificationCodeUseCase = sendVerificationCodeUseCase,
       _verifyPhoneUseCase = verifyPhoneUseCase,
       _forgetPasswordUseCase = forgetPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       super(const CompanyAuthState.initial());

  /// Login company
  Future<void> login(CompanyLoginParameters parameters) async {
    state = const CompanyAuthState.loading();

    final result = await _loginUseCase.execute(parameters);

    result.when(
      success: (_, __) {
        state = const CompanyAuthState.authenticated();
      },
      exception: (error) {
        state = CompanyAuthState.error(error);
      },
    );
  }

  /// Register new company
  Future<void> register(CompanyRegisterParameters parameters) async {
    state = const CompanyAuthState.loading();

    final result = await _registerUseCase.execute(parameters);

    result.when(
      success: (_, __) {
        state = const CompanyAuthState.authenticated();
      },
      exception: (error) {
        state = CompanyAuthState.error(error);
      },
    );
  }

  /// Logout company
  Future<void> logout(CompanyLogoutParameters parameters) async {
    state = const CompanyAuthState.loading();

    final result = await _logoutUseCase.execute(parameters);

    result.when(
      success: (_, __) {
        state = const CompanyAuthState.unauthenticated();
      },
      exception: (error) {
        state = CompanyAuthState.error(error);
      },
    );
  }

  /// Send verification code
  Future<void> sendVerificationCode(CompanySendVerificationCodeParameters parameters) async {
    state = const CompanyAuthState.loading();

    final result = await _sendVerificationCodeUseCase.execute(parameters);

    result.when(
      success: (_, __) {
        state = const CompanyAuthState.verificationCodeSent();
      },
      exception: (error) {
        state = CompanyAuthState.error(error);
      },
    );
  }

  /// Verify phone
  Future<void> verifyPhone(CompanyVerifyPhoneParameters parameters) async {
    state = const CompanyAuthState.loading();

    final result = await _verifyPhoneUseCase.execute(parameters);

    result.when(
      success: (_, __) {
        state = const CompanyAuthState.phoneVerified();
      },
      exception: (error) {
        state = CompanyAuthState.error(error);
      },
    );
  }

  /// Forget password
  Future<void> forgetPassword(CompanyForgetPasswordParameters parameters) async {
    state = const CompanyAuthState.loading();

    final result = await _forgetPasswordUseCase.execute(parameters);

    result.when(
      success: (_, __) {
        state = const CompanyAuthState.passwordResetRequested();
      },
      exception: (error) {
        state = CompanyAuthState.error(error);
      },
    );
  }

  /// Reset password
  Future<void> resetPassword(CompanyResetPasswordParameters parameters) async {
    state = const CompanyAuthState.loading();

    final result = await _resetPasswordUseCase.execute(parameters);

    result.when(
      success: (_, __) {
        state = const CompanyAuthState.passwordReset();
      },
      exception: (error) {
        state = CompanyAuthState.error(error);
      },
    );
  }

  /// Reset state to initial
  void resetState() {
    state = const CompanyAuthState.initial();
  }
}
