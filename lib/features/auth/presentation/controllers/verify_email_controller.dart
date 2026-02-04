// lib/features/auth/presentation/controllers/verify_email_controller.dart
import 'package:flavorizr/features/auth/data/parameters/verify_email_parameters.dart';
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the verify email page.
class VerifyEmailState {
  const VerifyEmailState({
    this.token = '',
    this.isLoading = false,
    this.isVerifying = false,
    this.errorMessage,
    this.isSuccess = false,
    this.isResending = false,
    this.resendSuccess = false,
    this.resendCooldown = 0,
  });

  final String token;
  final bool isLoading;
  final bool isVerifying;
  final String? errorMessage;
  final bool isSuccess;
  final bool isResending;
  final bool resendSuccess;
  final int resendCooldown;

  /// Returns true if any loading operation is in progress.
  bool get isAnyLoading => isLoading || isVerifying || isResending;

  /// Returns true if resend button should be disabled.
  bool get isResendDisabled => isResending || resendCooldown > 0;

  VerifyEmailState copyWith({
    String? token,
    bool? isLoading,
    bool? isVerifying,
    String? errorMessage,
    bool? isSuccess,
    bool? isResending,
    bool? resendSuccess,
    int? resendCooldown,
    bool clearError = false,
  }) {
    return VerifyEmailState(
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      isVerifying: isVerifying ?? this.isVerifying,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isResending: isResending ?? this.isResending,
      resendSuccess: resendSuccess ?? this.resendSuccess,
      resendCooldown: resendCooldown ?? this.resendCooldown,
    );
  }
}

/// Controller for the verify email page using Riverpod 3.x Notifier.
class VerifyEmailController extends AutoDisposeNotifier<VerifyEmailState> {
  late final AuthRepository _repository;

  @override
  VerifyEmailState build() {
    _repository = ref.watch(authRepositoryProvider);
    return const VerifyEmailState();
  }

  /// Sets the verification token (from URL parameters).
  void setToken(String token) {
    state = state.copyWith(token: token);
  }

  /// Clears all errors.
  void clearErrors() {
    state = state.copyWith(clearError: true);
  }

  /// Verifies the email using the token.
  Future<bool> verifyEmail() async {
    if (state.isVerifying) return false;

    // Validate token
    if (state.token.isEmpty) {
      state = state.copyWith(errorMessage: 'Invalid verification link. Please request a new one.');
      return false;
    }

    state = state.copyWith(isVerifying: true, clearError: true);

    try {
      final params = VerifyEmailParameters(token: state.token);
      final result = await _repository.verifyEmail(params);

      if (result.error != null) {
        state = state.copyWith(isVerifying: false, errorMessage: result.error!.message);
        return false;
      }

      state = state.copyWith(isVerifying: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isVerifying: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Auto-verifies email when page loads with a token.
  Future<void> autoVerify(String token) async {
    if (token.isEmpty) return;

    setToken(token);
    await verifyEmail();
  }

  /// Resends the verification email.
  Future<bool> resendVerificationEmail() async {
    if (state.isResending || state.resendCooldown > 0) return false;

    state = state.copyWith(isResending: true, clearError: true, resendSuccess: false);

    try {
      final result = await _repository.resendEmailVerification();

      if (result.error != null) {
        state = state.copyWith(isResending: false, errorMessage: result.error!.message);
        return false;
      }

      state = state.copyWith(
        isResending: false,
        resendSuccess: true,
        resendCooldown: 60, // 60 second cooldown
      );

      // Start cooldown timer
      _startCooldownTimer();

      return true;
    } catch (e) {
      state = state.copyWith(
        isResending: false,
        errorMessage: 'Failed to resend verification email. Please try again.',
      );
      return false;
    }
  }

  /// Starts the cooldown timer for resend button.
  void _startCooldownTimer() {
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (state.resendCooldown > 0) {
        state = state.copyWith(resendCooldown: state.resendCooldown - 1);
        return true;
      }
      return false;
    });
  }

  /// Resets the state.
  void reset() {
    state = const VerifyEmailState();
  }
}

/// Provider for the verify email controller.
final verifyEmailControllerProvider =
    NotifierProvider.autoDispose<VerifyEmailController, VerifyEmailState>(
      VerifyEmailController.new,
    );
