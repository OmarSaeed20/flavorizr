// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:flavorizr/core/network/exception/network_exceptions.dart'
    show
        ConflictException,
        NoInternetException,
        NotFoundException,
        ServerException,
        UnauthorizedException,
        ValidationException;
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/auth/data/parameters/change_password_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/logout_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/register_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/reset_password_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/save_biometric_credentials_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/send_magic_link_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/send_otp_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/send_password_reset_email_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/sign_in_with_email_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/sign_in_with_magic_link_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/sign_in_with_otp_parameters.dart';
import 'package:flavorizr/features/auth/data/parameters/verify_email_parameters.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_tokens.dart';
import 'package:flavorizr/features/auth/domain/entities/user.dart';

/// Type alias for ApiResult-based result handling.
typedef AuthEither<T> = Future<ApiResult<T>>;

/// Abstract repository defining authentication operations.
///
/// This interface lives in the domain layer and defines the contract
/// that the data layer must implement. The domain layer should not
/// know about the specific implementation details (Firebase, REST, etc.).
abstract class AuthRepository {
  // ==================== Authentication ====================

  /// Signs in with email and password.
  ///
  /// Returns [AuthResult] on success.
  ///
  /// Possible failures:
  /// - [UnauthorizedException] - Wrong email or password
  /// - [NoInternetException] - No internet connection
  /// - [ServerException] - Server error
  AuthEither<AuthResult> signInWithEmail(SignInWithEmailParameters parameters);

  /// Signs in with Google OAuth.
  ///
  /// Opens Google sign-in flow and exchanges the token with backend.
  ///
  /// Possible failures:
  /// - [CancelledException] - User cancelled sign-in
  /// - [NoInternetException] - No internet connection
  /// - [ServerException] - Server error
  AuthEither<AuthResult> signInWithGoogle();

  /// Signs in with Apple OAuth (iOS/macOS).
  ///
  /// Opens Apple sign-in flow and exchanges the token with backend.
  ///
  /// Possible failures:
  /// - [CancelledException] - User cancelled sign-in
  /// - [NoInternetException] - No internet connection
  /// - [ServerException] - Server error
  AuthEither<AuthResult> signInWithApple();

  /// Signs in with phone number OTP.
  ///
  /// First call [sendOtp] to get the verification ID,
  /// then use this method with the OTP code.
  AuthEither<AuthResult> signInWithOtp(SignInWithOtpParameters parameters);

  /// Signs in with magic link (passwordless).
  ///
  /// User clicks a link in their email to authenticate.
  AuthEither<AuthResult> signInWithMagicLink(SignInWithMagicLinkParameters parameters);

  // ==================== Registration ====================

  /// Creates a new user account with email and password.
  ///
  /// Possible failures:
  /// - [ValidationException] - Invalid email or weak password
  /// - [ConflictException] - Email already in use
  /// - [NoInternetException] - No internet connection
  AuthEither<AuthResult> signUp(RegisterParameters parameters);

  // ==================== Password Recovery ====================

  /// Sends a password reset email.
  ///
  /// User receives an email with a link to reset their password.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Email not registered
  /// - [NoInternetException] - No internet connection
  AuthEither<void> sendPasswordResetEmail(SendPasswordResetEmailParameters parameters);

  /// Resets the password using a reset token.
  AuthEither<void> resetPassword(ResetPasswordParameters parameters);

  /// Changes the current user's password.
  ///
  /// Requires the current password for verification.
  AuthEither<void> changePassword(ChangePasswordParameters parameters);

  // ==================== OTP / Verification ====================

  /// Sends OTP to a phone number for verification.
  ///
  /// Returns a verification ID to use with [signInWithOtp].
  AuthEither<String> sendOtp(SendOtpParameters parameters);

  /// Sends a magic link to an email for passwordless login.
  AuthEither<void> sendMagicLink(SendMagicLinkParameters parameters);

  /// Resends email verification link.
  AuthEither<void> resendEmailVerification();

  /// Verifies email with token from verification link.
  AuthEither<void> verifyEmail(VerifyEmailParameters parameters);

  // ==================== Session Management ====================

  /// Gets the currently authenticated user.
  ///
  /// Returns null if no user is logged in.
  AuthEither<User?> getCurrentUser();

  /// Refreshes the access token using the refresh token.
  ///
  /// Called automatically by the auth interceptor when
  /// the access token expires.
  AuthEither<AuthTokens> refreshTokens();

  /// Signs out the current user.
  ///
  /// Clears local tokens and invalidates server session.
  AuthEither<void> signOut(LogoutParameters parameters);

  /// Signs out from all devices.
  ///
  /// Invalidates all refresh tokens for this user.
  AuthEither<void> signOutAllDevices();

  // ==================== Biometric Authentication ====================

  /// Checks if biometric authentication is available.
  Future<bool> isBiometricAvailable();

  /// Checks if biometric authentication is enabled for the user.
  Future<bool> isBiometricEnabled();

  /// Enables biometric authentication.
  ///
  /// Stores credentials securely for biometric unlock.
  AuthEither<void> enableBiometric(SaveBiometricCredentialsParameters parameters);

  /// Disables biometric authentication.
  AuthEither<void> disableBiometric();

  /// Authenticates using biometrics.
  ///
  /// Uses stored credentials to sign in after biometric verification.
  AuthEither<AuthResult> signInWithBiometric();

  // ==================== Streams ====================

  /// Stream of authentication state changes.
  ///
  /// Emits the current user when auth state changes:
  /// - User object when signed in
  /// - null when signed out
  Stream<User?> get authStateChanges;

  /// Stream of token refresh events.
  ///
  /// Useful for updating UI or logging token refreshes.
  Stream<AuthTokens> get tokenRefreshes;
}
