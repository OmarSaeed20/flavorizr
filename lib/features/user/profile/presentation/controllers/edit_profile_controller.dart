// lib/features/profile/presentation/controllers/edit_profile_controller.dart
import 'package:fast_golden_taxi/features/user/profile/domain/entities/profile.dart';
import 'package:fast_golden_taxi/features/user/profile/domain/usecases/profile_usecases.dart';
import 'package:fast_golden_taxi/features/user/profile/presentation/providers/profile_providers.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for profile editing.
class EditProfileState {
  const EditProfileState({
    this.profile,
    this.name = '',
    this.nickname = '',
    this.email = '',
    this.gender = 'male',
    this.birthDate = '',
    this.image = '',
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.nameError,
    this.emailError,
    this.birthDateError,
    this.isSuccess = false,
    this.hasChanges = false,
  });

  final Profile? profile;
  final String name;
  final String nickname;
  final String email;
  final String gender;
  final String birthDate;
  final String image;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? nameError;
  final String? emailError;
  final String? birthDateError;
  final bool isSuccess;
  final bool hasChanges;

  EditProfileState copyWith({
    Profile? profile,
    String? name,
    String? nickname,
    String? email,
    String? gender,
    String? birthDate,
    String? image,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? nameError,
    String? emailError,
    String? birthDateError,
    bool? isSuccess,
    bool? hasChanges,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return EditProfileState(
      profile: profile ?? this.profile,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      nameError: clearFieldErrors ? null : nameError ?? this.nameError,
      emailError: clearFieldErrors ? null : emailError ?? this.emailError,
      birthDateError: clearFieldErrors
          ? null
          : birthDateError ?? this.birthDateError,
      isSuccess: isSuccess ?? this.isSuccess,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

/// Controller for editing profile.
class EditProfileController extends AutoDisposeNotifier<EditProfileState> {
  late final GetProfileUseCase _getProfile;
  late final UpdateProfileInfoUseCase _updateProfileInfo;

  @override
  EditProfileState build() {
    _getProfile = ref.watch(getProfileUseCaseProvider);
    _updateProfileInfo = ref.watch(updateProfileInfoUseCaseProvider);
    return const EditProfileState();
  }

  /// Loads the current profile for editing.
  Future<void> loadProfile() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getProfile(const NoParams());

    if (result.error != null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.error!.message,
      );
      return;
    }

    final profile = result.data;
    state = state.copyWith(
      isLoading: false,
      profile: profile,
      name: profile?.name ?? '',
      nickname: profile?.nickname ?? '',
      email: profile?.email ?? '',
      gender: profile?.gender ?? 'male',
      birthDate: profile?.birthDate ?? '',
      image: profile?.image ?? '',
    );
  }

  /// Updates the name field.
  void updateName(String value) {
    state = state.copyWith(name: value, hasChanges: true);
  }

  /// Updates the nickname field.
  void updateNickname(String value) {
    state = state.copyWith(nickname: value, hasChanges: true);
  }

  /// Updates the email field.
  void updateEmail(String value) {
    state = state.copyWith(email: value, hasChanges: true);
  }

  /// Updates the gender field.
  void updateGender(String value) {
    state = state.copyWith(gender: value, hasChanges: true);
  }

  /// Updates the birth date field.
  void updateBirthDate(String value) {
    state = state.copyWith(birthDate: value, hasChanges: true);
  }

  /// Updates the image field (base64 encoded).
  void updateImage(String value) {
    state = state.copyWith(image: value, hasChanges: true);
  }

  /// Validates the form fields.
  bool validateForm() {
    bool isValid = true;
    String? nameError;
    String? emailError;
    String? birthDateError;

    // Validate name
    if (state.name.trim().isEmpty) {
      nameError = 'Name is required';
      isValid = false;
    } else if (state.name.trim().length < 2) {
      nameError = 'Name must be at least 2 characters';
      isValid = false;
    }

    // Validate email
    if (state.email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(state.email)) {
        emailError = 'Please enter a valid email address';
        isValid = false;
      }
    }

    // Validate birth date
    if (state.birthDate.isNotEmpty) {
      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!dateRegex.hasMatch(state.birthDate)) {
        birthDateError = 'Birth date must be in YYYY-MM-DD format';
        isValid = false;
      }
    }

    state = state.copyWith(
      nameError: nameError,
      emailError: emailError,
      birthDateError: birthDateError,
    );

    return isValid;
  }

  /// Saves the profile changes.
  Future<void> saveProfile() async {
    if (!validateForm()) {
      return;
    }

    if (state.isSaving) return;

    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearFieldErrors: true,
    );

    final updateData = ProfileUpdateData(
      name: state.name.trim().isEmpty ? null : state.name.trim(),
      nickname: state.nickname.trim().isEmpty ? null : state.nickname.trim(),
      email: state.email.trim().isEmpty ? null : state.email.trim(),
      gender: state.gender,
      birthDate: state.birthDate.trim().isEmpty ? null : state.birthDate.trim(),
      image: state.image.trim().isEmpty ? null : state.image.trim(),
    );

    final result = await _updateProfileInfo(updateData);

    if (result.error != null) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: result.error!.message,
      );
      return;
    }

    state = state.copyWith(
      isSaving: false,
      isSuccess: true,
      hasChanges: false,
      profile: result.data,
    );
  }

  /// Resets the success state.
  void resetSuccess() {
    state = state.copyWith(isSuccess: false);
  }

  /// Clears all errors.
  void clearErrors() {
    state = state.copyWith(clearError: true, clearFieldErrors: true);
  }

  /// Resets the form to the original profile values.
  void resetForm() {
    if (state.profile != null) {
      state = state.copyWith(
        name: state.profile!.name,
        nickname: state.profile!.nickname,
        email: state.profile!.email,
        gender: state.profile!.gender,
        birthDate: state.profile!.birthDate,
        image: state.profile!.image,
        hasChanges: false,
        clearError: true,
        clearFieldErrors: true,
      );
    }
  }
}
