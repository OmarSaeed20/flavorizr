// lib/features/auth/presentation/controllers/forgot_password_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flavorizr/features/auth/domain/usecases/password_reset_usecase.dart';
import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';

/// State for the forgot password form.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.email = '',
    this.isLoading = false,
    this.errorMessage,
    this.emailError,
    this.isSuccess = false,
  });

  final String email;
  final bool isLoading;
  final String? errorMessage;
  final String? emailError;
  final bool isSuccess;

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
    String? errorMessage,
    String? emailError,
    bool? isSuccess,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      emailError: clearFieldErrors ? null : emailError ?? this.emailError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Controller for the forgot password page using Riverpod 3.x Notifier.
class ForgotPasswordController extends Notifier<ForgotPasswordState> {
  late final ForgotPasswordUseCase _forgotPasswordUseCase;

  @override
  ForgotPasswordState build() {
    _forgotPasswordUseCase = ref.watch(forgotPasswordUseCaseProvider);
    return const ForgotPasswordState();
  }

  /// Updates the email field.
  void setEmail(String email) {
    state = state.copyWith(
      email: email,
      clearError: true,
      clearFieldErrors: true,
    );
  }

  /// Clears all errors.
  void clearErrors() {
    state = state.copyWith(clearError: true, clearFieldErrors: true);
  }

  /// Validates the form before submission.
  bool _validateForm() {
    String? emailError;

    // Validate email
    if (state.email.isEmpty) {
      emailError = 'Email is required';
    } else if (!_isValidEmail(state.email)) {
      emailError = 'Please enter a valid email';
    }

    if (emailError != null) {
      state = state.copyWith(emailError: emailError);
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Submits the forgot password request.
  Future<bool> sendResetEmail() async {
    if (state.isLoading) return false;

    // Validate form
    if (!_validateForm()) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _forgotPasswordUseCase(ForgotPasswordParams(
        email: state.email.trim(),
      ));

      if (result.failure != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.failure!.message,
        );
        return false;
      }

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Resets the state.
  void reset() {
    state = const ForgotPasswordState();
  }
}

/// Provider for the forgot password controller.
final forgotPasswordControllerProvider =
    NotifierProvider.autoDispose<ForgotPasswordController, ForgotPasswordState>(
  ForgotPasswordController.new,
);
