// lib/features/auth/presentation/controllers/forgot_password_controller.dart
import 'package:flavorizr/features/user/auth/domain/usecases/password_reset_usecase.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the forgot password form.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.phone = '',
    this.isLoading = false,
    this.errorMessage,
    this.phoneError,
    this.isSuccess = false,
  });

  final String phone;
  final bool isLoading;
  final String? errorMessage;
  final String? phoneError;
  final bool isSuccess;

  ForgotPasswordState copyWith({
    String? phone,
    bool? isLoading,
    String? errorMessage,
    String? phoneError,
    bool? isSuccess,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return ForgotPasswordState(
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      phoneError: clearFieldErrors ? null : phoneError ?? this.phoneError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Controller for the forgot password page using Riverpod 3.x Notifier.
class ForgotPasswordController extends AutoDisposeNotifier<ForgotPasswordState> {
  late final ForgotPasswordUseCase _forgotPasswordUseCase;

  @override
  ForgotPasswordState build() {
    _forgotPasswordUseCase = ref.watch(forgotPasswordUseCaseProvider);
    return const ForgotPasswordState();
  }

  /// Updates the phone field.
  void setPhone(String phone) {
    state = state.copyWith(phone: phone, clearError: true, clearFieldErrors: true);
  }

  /// Clears all errors.
  void clearErrors() {
    state = state.copyWith(clearError: true, clearFieldErrors: true);
  }

  /// Validates the form before submission.
  bool _validateForm() {
    String? phoneError;

    // Validate phone
    if (state.phone.isEmpty) {
      phoneError = 'Phone is required';
    } else if (!_isValidPhone(state.phone)) {
      phoneError = 'Please enter a valid phone number';
    }

    if (phoneError != null) {
      state = state.copyWith(phoneError: phoneError);
      return false;
    }

    return true;
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(phone.trim());
  }

  /// Submits the forgot password request.
  Future<bool> sendResetEmail() async {
    if (state.isLoading) return false;

    // Validate form
    if (!_validateForm()) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _forgotPasswordUseCase(ForgotPasswordParams(phone: state.phone.trim()));

      if (result.error != null) {
        state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
        return false;
      }

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred');
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
