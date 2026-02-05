// lib/features/auth/presentation/controllers/reset_password_controller.dart
import 'package:flavorizr/features/user/auth/domain/usecases/password_reset_usecase.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the reset password form.
class ResetPasswordState {
  const ResetPasswordState({
    this.token = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.errorMessage,
    this.passwordError,
    this.confirmPasswordError,
    this.isSuccess = false,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.passwordStrength = PasswordStrength.weak,
  });

  final String token;
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final String? errorMessage;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isSuccess;
  final bool showPassword;
  final bool showConfirmPassword;
  final PasswordStrength passwordStrength;

  ResetPasswordState copyWith({
    String? token,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    String? errorMessage,
    String? passwordError,
    String? confirmPasswordError,
    bool? isSuccess,
    bool? showPassword,
    bool? showConfirmPassword,
    PasswordStrength? passwordStrength,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return ResetPasswordState(
      token: token ?? this.token,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      passwordError: clearFieldErrors ? null : passwordError ?? this.passwordError,
      confirmPasswordError: clearFieldErrors
          ? null
          : confirmPasswordError ?? this.confirmPasswordError,
      isSuccess: isSuccess ?? this.isSuccess,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }
}

/// Password strength levels.
enum PasswordStrength { weak, fair, good, strong }

/// Controller for the reset password page using Riverpod 3.x Notifier.
class ResetPasswordController extends AutoDisposeNotifier<ResetPasswordState> {
  late final ResetPasswordUseCase _resetPasswordUseCase;

  @override
  ResetPasswordState build() {
    _resetPasswordUseCase = ref.watch(resetPasswordUseCaseProvider);
    return const ResetPasswordState();
  }

  /// Sets the reset token (from URL parameters).
  void setToken(String token) {
    state = state.copyWith(token: token);
  }

  /// Updates the new password field.
  void setNewPassword(String password) {
    final strength = _calculatePasswordStrength(password);
    state = state.copyWith(
      newPassword: password,
      passwordStrength: strength,
      clearError: true,
      clearFieldErrors: true,
    );
  }

  /// Updates the confirm password field.
  void setConfirmPassword(String password) {
    state = state.copyWith(confirmPassword: password, clearError: true, clearFieldErrors: true);
  }

  /// Toggles new password visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  /// Toggles confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  /// Clears all errors.
  void clearErrors() {
    state = state.copyWith(clearError: true, clearFieldErrors: true);
  }

  /// Calculates password strength based on various criteria.
  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    var score = 0;

    // Length checks
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;

    // Character type checks
    if (password.contains(RegExp('[A-Z]'))) score++;
    if (password.contains(RegExp('[a-z]'))) score++;
    if (password.contains(RegExp('[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 6) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  /// Validates the form before submission.
  bool _validateForm() {
    String? passwordError;
    String? confirmPasswordError;

    // Validate token
    if (state.token.isEmpty) {
      state = state.copyWith(errorMessage: 'Invalid reset link. Please request a new one.');
      return false;
    }

    // Validate password
    if (state.newPassword.isEmpty) {
      passwordError = 'Password is required';
    } else if (state.newPassword.length < 8) {
      passwordError = 'Password must be at least 8 characters';
    } else if (!state.newPassword.contains(RegExp('[A-Z]'))) {
      passwordError = 'Password must contain at least one uppercase letter';
    } else if (!state.newPassword.contains(RegExp('[a-z]'))) {
      passwordError = 'Password must contain at least one lowercase letter';
    } else if (!state.newPassword.contains(RegExp('[0-9]'))) {
      passwordError = 'Password must contain at least one number';
    }

    // Validate confirm password
    if (state.confirmPassword.isEmpty) {
      confirmPasswordError = 'Please confirm your password';
    } else if (state.newPassword != state.confirmPassword) {
      confirmPasswordError = 'Passwords do not match';
    }

    if (passwordError != null || confirmPasswordError != null) {
      state = state.copyWith(
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      );
      return false;
    }

    return true;
  }

  /// Submits the reset password request.
  Future<bool> resetPassword() async {
    if (state.isLoading) return false;

    // Validate form
    if (!_validateForm()) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _resetPasswordUseCase(
        ResetPasswordParams(
          token: state.token,
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
        ),
      );

      if (result.error != null) {
        state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
        return false;
      }

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
      return false;
    }
  }

  /// Resets the state.
  void reset() {
    state = const ResetPasswordState();
  }
}

/// Provider for the reset password controller.
final resetPasswordControllerProvider =
    NotifierProvider.autoDispose<ResetPasswordController, ResetPasswordState>(
      ResetPasswordController.new,
    );
