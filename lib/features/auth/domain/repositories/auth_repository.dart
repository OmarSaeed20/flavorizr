// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_tokens.dart';
import 'package:flavorizr/features/auth/domain/entities/user.dart';

/// Type alias for Either-like result handling.
typedef AuthEither<T> = Future<({T? data, Failure? failure})>;

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
  /// - [InvalidCredentialsFailure] - Wrong email or password
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error
  AuthEither<AuthResult> signInWithEmail({required String email, required String password});

  /// Signs in with Google OAuth.
  ///
  /// Opens Google sign-in flow and exchanges the token with backend.
  ///
  /// Possible failures:
  /// - [CancelledFailure] - User cancelled sign-in
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error
  AuthEither<AuthResult> signInWithGoogle();

  /// Signs in with Apple OAuth (iOS/macOS).
  ///
  /// Opens Apple sign-in flow and exchanges the token with backend.
  ///
  /// Possible failures:
  /// - [CancelledFailure] - User cancelled sign-in
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error
  AuthEither<AuthResult> signInWithApple();

  /// Signs in with phone number OTP.
  ///
  /// First call [sendOtp] to get the verification ID,
  /// then use this method with the OTP code.
  ///
  /// Parameters:
  /// - [verificationId] - ID returned from [sendOtp]
  /// - [otpCode] - 6-digit code entered by user
  AuthEither<AuthResult> signInWithOtp({required String verificationId, required String otpCode});

  /// Signs in with magic link (passwordless).
  ///
  /// User clicks a link in their email to authenticate.
  ///
  /// Parameters:
  /// - [token] - Token from the magic link URL
  AuthEither<AuthResult> signInWithMagicLink({required String token});

  // ==================== Registration ====================

  /// Creates a new user account with email and password.
  ///
  /// Parameters:
  /// - [email] - User's email address
  /// - [password] - Password (min 8 chars, mixed case, number)
  /// - [displayName] - Optional display name
  ///
  /// Possible failures:
  /// - [ValidationFailure] - Invalid email or weak password
  /// - [ConflictFailure] - Email already in use
  /// - [NetworkFailure] - No internet connection
  AuthEither<AuthResult> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  // ==================== Password Recovery ====================

  /// Sends a password reset email.
  ///
  /// User receives an email with a link to reset their password.
  ///
  /// Possible failures:
  /// - [NotFoundFailure] - Email not registered
  /// - [NetworkFailure] - No internet connection
  AuthEither<void> sendPasswordResetEmail({required String email});

  /// Resets the password using a reset token.
  ///
  /// Parameters:
  /// - [token] - Token from the reset email link
  /// - [newPassword] - New password to set
  AuthEither<void> resetPassword({required String token, required String newPassword});

  /// Changes the current user's password.
  ///
  /// Requires the current password for verification.
  AuthEither<void> changePassword({required String currentPassword, required String newPassword});

  // ==================== OTP / Verification ====================

  /// Sends OTP to a phone number for verification.
  ///
  /// Returns a verification ID to use with [signInWithOtp].
  ///
  /// Parameters:
  /// - [phoneNumber] - E.164 format (e.g., +1234567890)
  AuthEither<String> sendOtp({required String phoneNumber});

  /// Sends a magic link to an email for passwordless login.
  AuthEither<void> sendMagicLink({required String email});

  /// Resends email verification link.
  AuthEither<void> resendEmailVerification();

  /// Verifies email with token from verification link.
  AuthEither<void> verifyEmail({required String token});

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
  AuthEither<void> signOut();

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
  AuthEither<void> enableBiometric();

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
