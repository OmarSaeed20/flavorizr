// lib/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_login_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_logout_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_register_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Repository interface for consumer authentication operations.
///
/// Defines the contract for authentication-related business logic.
/// Consumers are regular users booking rides (company_type: "customer").
abstract class ConsumerAuthRepository {
  /// Signs in consumer with phone and password.
  ///
  /// Returns [AuthResult] with tokens and user data on success.
  /// Returns [Failure] on error.
  Future<Either<Failure, AuthResult>> login(ConsumerLoginParameters parameters);

  /// Creates a new consumer account.
  ///
  /// Returns [AuthResult] with tokens and user data on success.
  /// Returns [Failure] on error.
  Future<Either<Failure, AuthResult>> register(ConsumerRegisterParameters parameters);

  /// Logs out the current consumer.
  ///
  /// Clears tokens and user data from local storage.
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> logout(ConsumerLogoutParameters parameters);

  /// Sends verification code to consumer's phone.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> sendVerificationCode(
    ConsumerSendVerificationCodeParameters parameters,
  );

  /// Verifies consumer phone number with verification code.
  ///
  /// Returns [AuthResult] with tokens and user data on success.
  /// Returns [Failure] on error.
  Future<Either<Failure, AuthResult>> verifyPhone(ConsumerVerifyPhoneParameters parameters);

  /// Resets password with verification code.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> resetPassword(ConsumerResetPasswordParameters parameters);

  /// Requests password reset code.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> forgetPassword(ConsumerForgetPasswordParameters parameters);

  /// Gets current consumer profile.
  ///
  /// Returns cached user data if available, otherwise fetches from remote.
  /// Returns [Failure] on error.
  Future<Either<Failure, UserModel>> getCurrentUser();

  /// Signs out from all devices.
  ///
  /// Invalidates all refresh tokens and clears local data.
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> signOutAllDevices();

  /// Refreshes authentication tokens.
  ///
  /// Uses stored refresh token to get new access token.
  /// Returns [Failure] on error.
  Future<Either<Failure, AuthTokens>> refreshToken();

  /// Checks if user is authenticated.
  ///
  /// Returns true if valid access token exists.
  /// Returns [Failure] on error.
  Future<Either<Failure, bool>> isAuthenticated();

  /// Checks if onboarding is completed.
  ///
  /// Returns true if user has completed onboarding.
  /// Returns [Failure] on error.
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Sets onboarding completion status.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> setOnboardingCompleted(bool completed);

  /// Saves biometric credentials for quick login.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> saveBiometricCredentials(String phone, String password);

  /// Gets stored biometric credentials.
  ///
  /// Returns null if no credentials are stored.
  /// Returns [Failure] on error.
  Future<Either<Failure, Map<String, String>?>> getBiometricCredentials();

  /// Clears stored biometric credentials.
  ///
  /// Returns [Failure] on error.
  Future<Either<Failure, void>> clearBiometricCredentials();
}
