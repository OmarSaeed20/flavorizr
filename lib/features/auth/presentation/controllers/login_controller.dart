// lib/features/auth/presentation/controllers/login_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flavorizr/shared/domain/usecases/usecase.dart';
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/usecases/login_usecase.dart';
import 'package:flavorizr/features/auth/domain/usecases/social_auth_usecase.dart';
import 'package:flavorizr/features/auth/domain/usecases/biometric_auth_usecase.dart';
import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';

/// State for the login form.
class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.isBiometricLoading = false,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.isSuccess = false,
    this.showPassword = false,
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isAppleLoading;
  final bool isBiometricLoading;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;
  final bool isSuccess;
  final bool showPassword;
  final bool rememberMe;

  bool get isAnyLoading => isLoading || isGoogleLoading || isAppleLoading || isBiometricLoading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? isGoogleLoading,
    bool? isAppleLoading,
    bool? isBiometricLoading,
    String? errorMessage,
    String? emailError,
    String? passwordError,
    bool? isSuccess,
    bool? showPassword,
    bool? rememberMe,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isAppleLoading: isAppleLoading ?? this.isAppleLoading,
      isBiometricLoading: isBiometricLoading ?? this.isBiometricLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      emailError: clearFieldErrors ? null : emailError ?? this.emailError,
      passwordError: clearFieldErrors ? null : passwordError ?? this.passwordError,
      isSuccess: isSuccess ?? this.isSuccess,
      showPassword: showPassword ?? this.showPassword,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

/// Controller for the login page using Riverpod 3.x Notifier.
class LoginController extends Notifier<LoginState> {
  late final LoginUseCase _loginUseCase;
  late final GoogleSignInUseCase _googleSignInUseCase;
  late final AppleSignInUseCase _appleSignInUseCase;
  late final BiometricSignInUseCase _biometricSignInUseCase;

  @override
  LoginState build() {
    _loginUseCase = ref.watch(loginUseCaseProvider);
    _googleSignInUseCase = ref.watch(googleSignInUseCaseProvider);
    _appleSignInUseCase = ref.watch(appleSignInUseCaseProvider);
    _biometricSignInUseCase = ref.watch(biometricSignInUseCaseProvider);
    return const LoginState();
  }

  /// Updates the email field.
  void setEmail(String email) {
    state = state.copyWith(email: email, clearError: true, clearFieldErrors: true);
  }

  /// Updates the password field.
  void setPassword(String password) {
    state = state.copyWith(password: password, clearError: true, clearFieldErrors: true);
  }

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  /// Toggles remember me checkbox.
  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  /// Clears all errors.
  void clearErrors() {
    state = state.copyWith(clearError: true, clearFieldErrors: true);
  }

  /// Validates the form before submission.
  bool _validateForm() {
    String? emailError;
    String? passwordError;

    // Validate email
    if (state.email.isEmpty) {
      emailError = 'Email is required';
    } else if (!_isValidEmail(state.email)) {
      emailError = 'Please enter a valid email';
    }

    // Validate password
    if (state.password.isEmpty) {
      passwordError = 'Password is required';
    } else if (state.password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }

    if (emailError != null || passwordError != null) {
      state = state.copyWith(emailError: emailError, passwordError: passwordError);
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }

  /// Submits the login form.
  Future<AuthResult?> login() async {
    if (state.isAnyLoading) return null;

    // Validate form
    if (!_validateForm()) return null;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _loginUseCase(
        LoginParams(email: state.email.trim(), password: state.password),
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

  /// Signs in with Google.
  Future<AuthResult?> signInWithGoogle() async {
    if (state.isAnyLoading) return null;

    state = state.copyWith(isGoogleLoading: true, clearError: true);

    try {
      final result = await _googleSignInUseCase(const NoParams());

      if (result.failure != null) {
        state = state.copyWith(isGoogleLoading: false, errorMessage: result.failure!.message);
        return null;
      }

      state = state.copyWith(isGoogleLoading: false, isSuccess: true);
      return result.data;
    } catch (e) {
      state = state.copyWith(isGoogleLoading: false, errorMessage: 'Failed to sign in with Google');
      return null;
    }
  }

  /// Signs in with Apple.
  Future<AuthResult?> signInWithApple() async {
    if (state.isAnyLoading) return null;

    state = state.copyWith(isAppleLoading: true, clearError: true);

    try {
      final result = await _appleSignInUseCase(const NoParams());

      if (result.failure != null) {
        state = state.copyWith(isAppleLoading: false, errorMessage: result.failure!.message);
        return null;
      }

      state = state.copyWith(isAppleLoading: false, isSuccess: true);
      return result.data;
    } catch (e) {
      state = state.copyWith(isAppleLoading: false, errorMessage: 'Failed to sign in with Apple');
      return null;
    }
  }

  /// Signs in with biometrics.
  Future<AuthResult?> signInWithBiometrics() async {
    if (state.isAnyLoading) return null;

    state = state.copyWith(isBiometricLoading: true, clearError: true);

    try {
      final result = await _biometricSignInUseCase(const NoParams());

      if (result.failure != null) {
        state = state.copyWith(isBiometricLoading: false, errorMessage: result.failure!.message);
        return null;
      }

      state = state.copyWith(isBiometricLoading: false, isSuccess: true);
      return result.data;
    } catch (e) {
      state = state.copyWith(
        isBiometricLoading: false,
        errorMessage: 'Failed to authenticate with biometrics',
      );
      return null;
    }
  }

  /// Resets the state.
  void reset() {
    state = const LoginState();
  }
}

/// Provider for the login controller.
final loginControllerProvider = NotifierProvider.autoDispose<LoginController, LoginState>(
  LoginController.new,
);
