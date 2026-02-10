// lib/features/consumer/consumer_auth/presentation/controllers/consumer_auth_controller.dart
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_login_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_logout_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_register_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/presentation/providers/consumer_auth_providers.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consumer_auth_controller.freezed.dart';
part 'consumer_auth_controller.g.dart';

/// Consumer authentication state.
@freezed
class ConsumerAuthState with _$ConsumerAuthState {
  const ConsumerAuthState._();

  const factory ConsumerAuthState.initial() = _Initial;

  const factory ConsumerAuthState.loading() = _Loading;

  const factory ConsumerAuthState.authenticated({required UserModel user}) = _Authenticated;

  const factory ConsumerAuthState.unauthenticated() = _Unauthenticated;

  const factory ConsumerAuthState.error({required String message, Failure? failure}) = _Error;

  const factory ConsumerAuthState.verificationCodeSent() = _VerificationCodeSent;

  const factory ConsumerAuthState.passwordResetRequested() = _PasswordResetRequested;

  const factory ConsumerAuthState.passwordReset() = _PasswordReset;

  bool get isLoading => maybeWhen(loading: () => true, orElse: () => false);

  bool get isAuthenticated => maybeWhen(authenticated: (_) => true, orElse: () => false);

  bool get isUnauthenticated => maybeWhen(unauthenticated: () => true, orElse: () => false);

  bool get isError => maybeWhen(error: (_, __) => true, orElse: () => false);
}

/// Consumer authentication controller.
///
/// Manages consumer authentication state and operations.
/// Uses Riverpod for state management.
@riverpod
class ConsumerAuthController extends _$ConsumerAuthController {
  @override
  ConsumerAuthState build() {
    return const ConsumerAuthState.initial();
  }

  /// Login consumer with phone and password.
  Future<void> login({
    required String phone,
    required String phoneIsoCode,
    required String password,
    required String firebaseToken,
    String? deviceType,
    String? deviceToken,
    String? deviceId,
  }) async {
    state = const ConsumerAuthState.loading();

    final parameters = ConsumerLoginParameters(
      phone: phone,
      phoneIsoCode: phoneIsoCode,
      password: password,
      firebaseToken: firebaseToken,
      deviceType: deviceType,
      deviceToken: deviceToken,
      deviceId: deviceId,
    );

    final result = await ref.read(consumerLoginUseCaseProvider)(parameters);

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (authResult) {
        state = ConsumerAuthState.authenticated(user: authResult.user.toModel());
      },
    );
  }

  /// Register new consumer.
  Future<void> register({
    required String name,
    String? nickname,
    required String phone,
    required String phoneIso2Code,
    required String password,
    required String passwordConfirmation,
    required int countryId,
    required int governorateId,
    required String birthdate,
    required String gender,
    String? deviceType,
    String? deviceToken,
    String? deviceId,
  }) async {
    state = const ConsumerAuthState.loading();

    final parameters = ConsumerRegisterParameters(
      companyType: 'customer',
      name: name,
      nickname: nickname,
      phone: phone,
      phoneIso2Code: phoneIso2Code,
      password: password,
      passwordConfirmation: passwordConfirmation,
      countryId: countryId,
      governorateId: governorateId,
      birthdate: birthdate,
      gender: gender,
      deviceType: deviceType,
      deviceToken: deviceToken,
      deviceId: deviceId,
    );

    final result = await ref.read(consumerRegisterUseCaseProvider)(parameters);

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (authResult) {
        state = ConsumerAuthState.authenticated(user: authResult.user.toModel());
      },
    );
  }

  /// Send verification code to consumer's phone.
  Future<void> sendVerificationCode({required String phone, required String phoneIsoCode}) async {
    state = const ConsumerAuthState.loading();

    final parameters = ConsumerSendVerificationCodeParameters(
      phone: phone,
      phoneIsoCode: phoneIsoCode,
    );

    final result = await ref.read(consumerSendVerificationCodeUseCaseProvider)(parameters);

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (_) {
        state = const ConsumerAuthState.verificationCodeSent();
      },
    );
  }

  /// Verify consumer phone with OTP code.
  Future<void> verifyPhone({
    required String phone,
    required String phoneIsoCode,
    required String code,
  }) async {
    state = const ConsumerAuthState.loading();

    final parameters = ConsumerVerifyPhoneParameters(
      phone: phone,
      phoneIsoCode: phoneIsoCode,
      code: code,
    );

    final result = await ref.read(consumerVerifyPhoneUseCaseProvider)(parameters);

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (authResult) {
        state = ConsumerAuthState.authenticated(user: authResult.user.toModel());
      },
    );
  }

  /// Request password reset code.
  Future<void> forgetPassword({required String phone, required String phoneIsoCode}) async {
    state = const ConsumerAuthState.loading();

    final parameters = ConsumerForgetPasswordParameters(phone: phone, phoneIsoCode: phoneIsoCode);

    final result = await ref.read(consumerForgetPasswordUseCaseProvider)(parameters);

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (_) {
        state = const ConsumerAuthState.passwordResetRequested();
      },
    );
  }

  /// Reset password with verification code.
  Future<void> resetPassword({
    required String phone,
    required String phoneIsoCode,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const ConsumerAuthState.loading();

    final parameters = ConsumerResetPasswordParameters(
      phone: phone,
      phoneIsoCode: phoneIsoCode,
      code: code,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    final result = await ref.read(consumerResetPasswordUseCaseProvider)(parameters);

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (_) {
        state = const ConsumerAuthState.passwordReset();
      },
    );
  }

  /// Logout consumer.
  Future<void> logout({String? deviceToken}) async {
    state = const ConsumerAuthState.loading();

    final parameters = ConsumerLogoutParameters(deviceToken: deviceToken);

    final result = await ref.read(consumerLogoutUseCaseProvider)(parameters);

    result.fold(
      (failure) {
        // Even if logout fails, set state to unauthenticated
        state = const ConsumerAuthState.unauthenticated();
      },
      (_) {
        state = const ConsumerAuthState.unauthenticated();
      },
    );
  }

  /// Get current consumer user.
  Future<void> getCurrentUser() async {
    state = const ConsumerAuthState.loading();

    final result = await ref.read(consumerGetCurrentUserUseCaseProvider)(const NoParams());

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (user) {
        state = ConsumerAuthState.authenticated(user: user);
      },
    );
  }

  /// Save biometric credentials.
  Future<void> saveBiometricCredentials({required String phone, required String password}) async {
    final useCase = ref.read(consumerBiometricAuthUseCaseProvider);
    final result = await useCase.saveCredentials(phone, password);

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (_) {
        // Credentials saved successfully
      },
    );
  }

  /// Get biometric credentials.
  Future<Map<String, String>?> getBiometricCredentials() async {
    final useCase = ref.read(consumerBiometricAuthUseCaseProvider);
    final result = await useCase.getCredentials();

    return result.fold((failure) {
      state = ConsumerAuthState.error(message: failure.message, failure: failure);
      return null;
    }, (credentials) => credentials);
  }

  /// Clear biometric credentials.
  Future<void> clearBiometricCredentials() async {
    final useCase = ref.read(consumerBiometricAuthUseCaseProvider);
    final result = await useCase.clearCredentials();

    result.fold(
      (failure) {
        state = ConsumerAuthState.error(message: failure.message, failure: failure);
      },
      (_) {
        // Credentials cleared successfully
      },
    );
  }

  /// Reset state to initial.
  void reset() {
    state = const ConsumerAuthState.initial();
  }
}
