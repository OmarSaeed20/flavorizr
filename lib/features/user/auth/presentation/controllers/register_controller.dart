// lib/features/auth/presentation/controllers/register_controller.dart
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/usecases/register_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the registration form.
class RegisterState {
  const RegisterState({
    this.phone = '',
    this.phoneIso2Code = 'EG',
    this.password = '',
    this.confirmPassword = '',
    this.displayName = '',
    this.name = '',
    this.nickname = '',
    this.companyType = 'customer',
    this.countryId = 1,
    this.governorateId = 1,
    this.birthdate = '2000-01-01',
    this.gender = 'male',
    this.isLoading = false,
    this.errorMessage,
    this.phoneError,
    this.passwordError,
    this.confirmPasswordError,
    this.displayNameError,
    this.nameError,
    this.birthdateError,
    this.genderError,
    this.isSuccess = false,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.acceptedTerms = false,
  });

  final String phone;
  final String phoneIso2Code;
  final String password;
  final String confirmPassword;
  final String displayName;
  final String name;
  final String nickname;
  final String companyType;
  final int countryId;
  final int governorateId;
  final String birthdate;
  final String gender;
  final bool isLoading;
  final String? errorMessage;
  final String? phoneError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? displayNameError;
  final String? nameError;
  final String? birthdateError;
  final String? genderError;
  final bool isSuccess;
  final bool showPassword;
  final bool showConfirmPassword;
  final bool acceptedTerms;

  RegisterState copyWith({
    String? phone,
    String? phoneIso2Code,
    String? password,
    String? confirmPassword,
    String? displayName,
    String? name,
    String? nickname,
    String? companyType,
    int? countryId,
    int? governorateId,
    String? birthdate,
    String? gender,
    bool? isLoading,
    String? errorMessage,
    String? phoneError,
    String? passwordError,
    String? confirmPasswordError,
    String? displayNameError,
    String? nameError,
    String? birthdateError,
    String? genderError,
    bool? isSuccess,
    bool? showPassword,
    bool? showConfirmPassword,
    bool? acceptedTerms,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return RegisterState(
      phone: phone ?? this.phone,
      phoneIso2Code: phoneIso2Code ?? this.phoneIso2Code,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      companyType: companyType ?? this.companyType,
      countryId: countryId ?? this.countryId,
      governorateId: governorateId ?? this.governorateId,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      phoneError: clearFieldErrors ? null : phoneError ?? this.phoneError,
      passwordError: clearFieldErrors ? null : passwordError ?? this.passwordError,
      confirmPasswordError: clearFieldErrors
          ? null
          : confirmPasswordError ?? this.confirmPasswordError,
      displayNameError: clearFieldErrors ? null : displayNameError ?? this.displayNameError,
      nameError: clearFieldErrors ? null : nameError ?? this.nameError,
      birthdateError: clearFieldErrors ? null : birthdateError ?? this.birthdateError,
      genderError: clearFieldErrors ? null : genderError ?? this.genderError,
      isSuccess: isSuccess ?? this.isSuccess,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}

/// Controller for the registration page using Riverpod 3.x Notifier.
class RegisterController extends AutoDisposeNotifier<RegisterState> {
  late final RegisterUseCase _registerUseCase;

  @override
  RegisterState build() {
    _registerUseCase = ref.watch(registerUseCaseProvider);
    return const RegisterState();
  }

  /// Updates the phone field.
  void setPhone(String phone) {
    state = state.copyWith(phone: phone, clearError: true, clearFieldErrors: true);
  }

  /// Updates the phone ISO2 code field.
  void setPhoneIso2Code(String phoneIso2Code) {
    state = state.copyWith(phoneIso2Code: phoneIso2Code, clearError: true, clearFieldErrors: true);
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

  /// Updates the name field.
  void setName(String name) {
    state = state.copyWith(name: name, clearError: true, clearFieldErrors: true);
  }

  /// Updates the nickname field.
  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname, clearError: true, clearFieldErrors: true);
  }

  /// Updates the country ID field.
  void setCountryId(int countryId) {
    state = state.copyWith(countryId: countryId, clearError: true, clearFieldErrors: true);
  }

  /// Updates the governorate ID field.
  void setGovernorateId(int governorateId) {
    state = state.copyWith(governorateId: governorateId, clearError: true, clearFieldErrors: true);
  }

  /// Updates the birthdate field.
  void setBirthdate(String birthdate) {
    state = state.copyWith(birthdate: birthdate, clearError: true, clearFieldErrors: true);
  }

  /// Updates the gender field.
  void setGender(String gender) {
    state = state.copyWith(gender: gender, clearError: true, clearFieldErrors: true);
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
    String? phoneError;
    String? passwordError;
    String? confirmPasswordError;
    String? displayNameError;
    String? nameError;
    String? birthdateError;
    String? genderError;

    // Validate phone
    if (state.phone.isEmpty) {
      phoneError = 'Phone is required';
    } else if (!_isValidPhone(state.phone)) {
      phoneError = 'Please enter a valid phone number';
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

    // Validate name (optional but if provided must be valid)
    if (state.name.isNotEmpty && state.name.trim().length < 2) {
      nameError = 'Name must be at least 2 characters';
    }

    // Validate birthdate format
    if (state.birthdate.isNotEmpty) {
      final birthdateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!birthdateRegex.hasMatch(state.birthdate)) {
        birthdateError = 'Birthdate must be in YYYY-MM-DD format';
      }
    }

    // Validate gender
    if (state.gender.isNotEmpty && state.gender != 'male' && state.gender != 'female') {
      genderError = 'Gender must be either male or female';
    }

    // Check terms acceptance
    if (!state.acceptedTerms) {
      state = state.copyWith(errorMessage: 'Please accept the terms and conditions');
      return false;
    }

    if (phoneError != null ||
        passwordError != null ||
        confirmPasswordError != null ||
        displayNameError != null ||
        nameError != null ||
        birthdateError != null ||
        genderError != null) {
      state = state.copyWith(
        phoneError: phoneError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
        displayNameError: displayNameError,
        nameError: nameError,
        birthdateError: birthdateError,
        genderError: genderError,
      );
      return false;
    }

    return true;
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(phone.trim());
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
          phone: state.phone.trim(),
          phoneIso2Code: state.phoneIso2Code,
          password: state.password,
          confirmPassword: state.confirmPassword,
          displayName: state.displayName.trim().isNotEmpty ? state.displayName.trim() : null,
          name: state.name.trim(),
          nickname: state.nickname.trim().isNotEmpty ? state.nickname.trim() : null,
          countryId: state.countryId,
          governorateId: state.governorateId,
          birthdate: state.birthdate,
          gender: state.gender,
        ),
      );

      if (result.error != null) {
        state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
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
