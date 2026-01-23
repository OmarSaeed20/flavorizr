// lib/features/auth/presentation/controllers/register_controller.dart
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/usecases/register_usecase.dart';
import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the registration form.
class RegisterState {
  const RegisterState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.displayName = '',
    this.isLoading = false,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.displayNameError,
    this.isSuccess = false,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.acceptedTerms = false,
  });

  final String email;
  final String password;
  final String confirmPassword;
  final String displayName;
  final bool isLoading;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? displayNameError;
  final bool isSuccess;
  final bool showPassword;
  final bool showConfirmPassword;
  final bool acceptedTerms;

  RegisterState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? displayName,
    bool? isLoading,
    String? errorMessage,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? displayNameError,
    bool? isSuccess,
    bool? showPassword,
    bool? showConfirmPassword,
    bool? acceptedTerms,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      displayName: displayName ?? this.displayName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      emailError: clearFieldErrors ? null : emailError ?? this.emailError,
      passwordError: clearFieldErrors ? null : passwordError ?? this.passwordError,
      confirmPasswordError: clearFieldErrors
          ? null
          : confirmPasswordError ?? this.confirmPasswordError,
      displayNameError: clearFieldErrors ? null : displayNameError ?? this.displayNameError,
      isSuccess: isSuccess ?? this.isSuccess,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}

/// Controller for the registration page using Riverpod 3.x Notifier.
class RegisterController extends Notifier<RegisterState> {
  late final RegisterUseCase _registerUseCase;

  @override
  RegisterState build() {
    _registerUseCase = ref.watch(registerUseCaseProvider);
    return const RegisterState();
  }

  /// Updates the email field.
  void setEmail(String email) {
    state = state.copyWith(email: email, clearError: true, clearFieldErrors: true);
  }

  /// Updates the password field.
  void setPassword(String password) {
    state = state.copyWith(password: password, clearError: true, clearFieldErrors: true);
  }

  /// Updates the confirm password field.
  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(
      confirmPassword: confirmPassword,
      clearError: true,
      clearFieldErrors: true,
    );
  }

  /// Updates the display name field.
  void setDisplayName(String displayName) {
    state = state.copyWith(displayName: displayName, clearError: true, clearFieldErrors: true);
  }

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  /// Toggles confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  /// Toggles terms acceptance.
  void toggleTermsAcceptance() {
    state = state.copyWith(acceptedTerms: !state.acceptedTerms);
  }

  /// Clears all errors.
  void clearErrors() {
    state = state.copyWith(clearError: true, clearFieldErrors: true);
  }

  /// Validates the form before submission.
  bool _validateForm() {
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;
    String? displayNameError;

    // Validate email
    if (state.email.isEmpty) {
      emailError = 'Email is required';
    } else if (!_isValidEmail(state.email)) {
      emailError = 'Please enter a valid email';
    }

    // Validate password
    final passwordErrors = _validatePassword(state.password);
    if (passwordErrors.isNotEmpty) {
      passwordError = passwordErrors.first;
    }

    // Validate confirm password
    if (state.confirmPassword.isEmpty) {
      confirmPasswordError = 'Please confirm your password';
    } else if (state.password != state.confirmPassword) {
      confirmPasswordError = 'Passwords do not match';
    }

    // Validate display name (optional but if provided must be valid)
    if (state.displayName.isNotEmpty && state.displayName.trim().length < 2) {
      displayNameError = 'Name must be at least 2 characters';
    }

    // Check terms acceptance
    if (!state.acceptedTerms) {
      state = state.copyWith(errorMessage: 'Please accept the terms and conditions');
      return false;
    }

    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null ||
        displayNameError != null) {
      state = state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
        displayNameError: displayNameError,
      );
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }

  List<String> _validatePassword(String password) {
    final errors = <String>[];

    if (password.isEmpty) {
      errors.add('Password is required');
      return errors;
    }

    if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }
    if (!password.contains(RegExp('[A-Z]'))) {
      errors.add('Password must contain an uppercase letter');
    }
    if (!password.contains(RegExp('[a-z]'))) {
      errors.add('Password must contain a lowercase letter');
    }
    if (!password.contains(RegExp('[0-9]'))) {
      errors.add('Password must contain a number');
    }

    return errors;
  }

  /// Submits the registration form.
  Future<AuthResult?> register() async {
    if (state.isLoading) return null;

    // Validate form
    if (!_validateForm()) return null;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _registerUseCase(
        RegisterParams(
          email: state.email.trim(),
          password: state.password,
          confirmPassword: state.confirmPassword,
          displayName: state.displayName.trim().isNotEmpty ? state.displayName.trim() : null,
        ),
      );

      if (result.failure != null) {
        state = state.copyWith(isLoading: false, errorMessage: result.failure!.message);
        return null;
      }

      state = state.copyWith(isLoading: false, isSuccess: true);
      return result.data;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred');
      return null;
    }
  }

  /// Resets the state.
  void reset() {
    state = const RegisterState();
  }
}

/// Provider for the register controller.
final registerControllerProvider = NotifierProvider.autoDispose<RegisterController, RegisterState>(
  RegisterController.new,
);
