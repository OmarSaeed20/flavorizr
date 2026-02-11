// lib/features/auth/presentation/controllers/login_controller.dart
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/biometric_auth_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/login_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/social_auth_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the login form.
class LoginState {
  const LoginState({
    this.phone = '',
    this.phoneIsoCode = 'EG',
    this.password = '',
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.isBiometricLoading = false,
    this.errorMessage,
    this.phoneError,
    this.passwordError,
    this.isSuccess = false,
    this.showPassword = false,
    this.rememberMe = false,
  });

  final String phone;
  final String phoneIsoCode;
  final String password;
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isAppleLoading;
  final bool isBiometricLoading;
  final String? errorMessage;
  final String? phoneError;
  final String? passwordError;
  final bool isSuccess;
  final bool showPassword;
  final bool rememberMe;

  bool get isAnyLoading => isLoading || isGoogleLoading || isAppleLoading || isBiometricLoading;

  LoginState copyWith({
    String? phone,
    String? phoneIsoCode,
    String? password,
    bool? isLoading,
    bool? isGoogleLoading,
    bool? isAppleLoading,
    bool? isBiometricLoading,
    String? errorMessage,
    String? phoneError,
    String? passwordError,
    bool? isSuccess,
    bool? showPassword,
    bool? rememberMe,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      phoneIsoCode: phoneIsoCode ?? this.phoneIsoCode,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isAppleLoading: isAppleLoading ?? this.isAppleLoading,
      isBiometricLoading: isBiometricLoading ?? this.isBiometricLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      phoneError: clearFieldErrors ? null : phoneError ?? this.phoneError,
      passwordError: clearFieldErrors ? null : passwordError ?? this.passwordError,
      isSuccess: isSuccess ?? this.isSuccess,
      showPassword: showPassword ?? this.showPassword,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

/// Controller for the login page using Riverpod 3.x Notifier.
class LoginController extends AutoDisposeNotifier<LoginState> {
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

  /// Updates the phone field.
  void setPhone(String phone) {
    state = state.copyWith(phone: phone, clearError: true, clearFieldErrors: true);
  }

  /// Updates the phone ISO code field.
  void setPhoneIsoCode(String phoneIsoCode) {
    state = state.copyWith(phoneIsoCode: phoneIsoCode, clearError: true, clearFieldErrors: true);
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
    String? phoneError;
    String? passwordError;

    // Validate phone
    if (state.phone.isEmpty) {
      phoneError = 'Phone is required';
    } else if (!_isValidPhone(state.phone)) {
      phoneError = 'Please enter a valid phone number';
    }

    // Validate password
    if (state.password.isEmpty) {
      passwordError = 'Password is required';
    } else if (state.password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }

    if (phoneError != null || passwordError != null) {
      state = state.copyWith(phoneError: phoneError, passwordError: passwordError);
      return false;
    }

    return true;
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(phone.trim());
  }

  /// Submits the login form.
  Future<AuthResult?> login() async {
    if (state.isAnyLoading) return null;

    // Validate form
    if (!_validateForm()) return null;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _loginUseCase(
        LoginParams(
          phone: state.phone.trim(),
          phoneIsoCode: state.phoneIsoCode,
          password: state.password,
        ),
      );

      if (result.error != null) {
        state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
        return null;
      }

      // Login successful - set success state
      // Navigation will be handled by the UI layer based on isSuccess
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

      if (result.error != null) {
        state = state.copyWith(isGoogleLoading: false, errorMessage: result.error!.message);
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

      if (result.error != null) {
        state = state.copyWith(isAppleLoading: false, errorMessage: result.error!.message);
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

      if (result.error != null) {
        state = state.copyWith(isBiometricLoading: false, errorMessage: result.error!.message);
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
