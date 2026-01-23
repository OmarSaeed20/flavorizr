// lib/features/profile/presentation/controllers/edit_profile_controller.dart
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/repositories/profile_repository.dart';
import 'package:flavorizr/features/profile/domain/usecases/profile_usecases.dart';
import 'package:flavorizr/features/profile/presentation/providers/profile_providers.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for profile editing.
class EditProfileState {
  const EditProfileState({
    this.profile,
    this.displayName = '',
    this.bio = '',
    this.location = '',
    this.website = '',
    this.isLoading = false,
    this.isSaving = false,
    this.isPhotoUploading = false,
    this.errorMessage,
    this.displayNameError,
    this.bioError,
    this.websiteError,
    this.isSuccess = false,
    this.hasChanges = false,
  });

  final Profile? profile;
  final String displayName;
  final String bio;
  final String location;
  final String website;
  final bool isLoading;
  final bool isSaving;
  final bool isPhotoUploading;
  final String? errorMessage;
  final String? displayNameError;
  final String? bioError;
  final String? websiteError;
  final bool isSuccess;
  final bool hasChanges;

  EditProfileState copyWith({
    Profile? profile,
    String? displayName,
    String? bio,
    String? location,
    String? website,
    bool? isLoading,
    bool? isSaving,
    bool? isPhotoUploading,
    String? errorMessage,
    String? displayNameError,
    String? bioError,
    String? websiteError,
    bool? isSuccess,
    bool? hasChanges,
    bool clearError = false,
    bool clearFieldErrors = false,
  }) {
    return EditProfileState(
      profile: profile ?? this.profile,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isPhotoUploading: isPhotoUploading ?? this.isPhotoUploading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      displayNameError: clearFieldErrors ? null : displayNameError ?? this.displayNameError,
      bioError: clearFieldErrors ? null : bioError ?? this.bioError,
      websiteError: clearFieldErrors ? null : websiteError ?? this.websiteError,
      isSuccess: isSuccess ?? this.isSuccess,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

/// Controller for editing profile.
class EditProfileController extends Notifier<EditProfileState> {
  late final GetCurrentProfileUseCase _getCurrentProfile;
  late final UpdateProfileUseCase _updateProfile;
  late final UpdateProfilePhotoUseCase _updateProfilePhoto;
  late final UpdateCoverPhotoUseCase _updateCoverPhoto;
  late final RemoveProfilePhotoUseCase _removeProfilePhoto;
  late final RemoveCoverPhotoUseCase _removeCoverPhoto;

  @override
  EditProfileState build() {
    _getCurrentProfile = ref.watch(getCurrentProfileUseCaseProvider);
    _updateProfile = ref.watch(updateProfileUseCaseProvider);
    _updateProfilePhoto = ref.watch(updateProfilePhotoUseCaseProvider);
    _updateCoverPhoto = ref.watch(updateCoverPhotoUseCaseProvider);
    _removeProfilePhoto = ref.watch(removeProfilePhotoUseCaseProvider);
    _removeCoverPhoto = ref.watch(removeCoverPhotoUseCaseProvider);
    return const EditProfileState();
  }

  /// Loads the current profile for editing.
  Future<void> loadProfile() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getCurrentProfile(const NoParams());

    if (result.failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: result.failure!.message);
      return;
    }

    final profile = result.data;
    if (profile != null) {
      state = state.copyWith(
        isLoading: false,
        profile: profile,
        displayName: profile.displayName,
        bio: profile.bio ?? '',
        location: profile.location ?? '',
        website: profile.website ?? '',
        hasChanges: false,
      );
    } else {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load profile');
    }
  }

  /// Updates the display name field.
  void setDisplayName(String value) {
    state = state.copyWith(displayName: value, hasChanges: true, clearFieldErrors: true);
  }

  /// Updates the bio field.
  void setBio(String value) {
    state = state.copyWith(bio: value, hasChanges: true, clearFieldErrors: true);
  }

  /// Updates the location field.
  void setLocation(String value) {
    state = state.copyWith(location: value, hasChanges: true);
  }

  /// Updates the website field.
  void setWebsite(String value) {
    state = state.copyWith(website: value, hasChanges: true, clearFieldErrors: true);
  }

  /// Validates the form.
  bool _validateForm() {
    String? displayNameError;
    String? bioError;
    String? websiteError;

    // Validate display name
    if (state.displayName.trim().isEmpty) {
      displayNameError = 'Display name is required';
    } else if (state.displayName.trim().length < 2) {
      displayNameError = 'Display name must be at least 2 characters';
    }

    // Validate bio length
    if (state.bio.length > 500) {
      bioError = 'Bio cannot exceed 500 characters';
    }

    // Validate website URL
    if (state.website.isNotEmpty) {
      final urlRegex = RegExp(r'^https?://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/\S*)?$');
      if (!urlRegex.hasMatch(state.website)) {
        websiteError = 'Please enter a valid URL (e.g., https://example.com)';
      }
    }

    if (displayNameError != null || bioError != null || websiteError != null) {
      state = state.copyWith(
        displayNameError: displayNameError,
        bioError: bioError,
        websiteError: websiteError,
      );
      return false;
    }

    return true;
  }

  /// Saves the profile changes.
  Future<Profile?> saveProfile() async {
    if (state.isSaving || !state.hasChanges) return null;

    if (!_validateForm()) return null;

    state = state.copyWith(isSaving: true, clearError: true);

    final updateData = ProfileUpdateData(
      displayName: state.displayName.trim(),
      bio: state.bio.trim().isEmpty ? null : state.bio.trim(),
      location: state.location.trim().isEmpty ? null : state.location.trim(),
      website: state.website.trim().isEmpty ? null : state.website.trim(),
    );

    final result = await _updateProfile(updateData);

    if (result.failure != null) {
      state = state.copyWith(isSaving: false, errorMessage: result.failure!.message);
      return null;
    }

    state = state.copyWith(
      isSaving: false,
      isSuccess: true,
      profile: result.data,
      hasChanges: false,
    );

    // Invalidate the current profile provider to refresh data
    ref.invalidate(currentProfileProvider);

    return result.data;
  }

  /// Updates the profile photo.
  Future<Profile?> updatePhoto(String imagePath) async {
    if (state.isPhotoUploading) return null;

    state = state.copyWith(isPhotoUploading: true, clearError: true);

    final result = await _updateProfilePhoto(imagePath);

    if (result.failure != null) {
      state = state.copyWith(isPhotoUploading: false, errorMessage: result.failure!.message);
      return null;
    }

    state = state.copyWith(isPhotoUploading: false, profile: result.data);

    // Invalidate the current profile provider to refresh data
    ref.invalidate(currentProfileProvider);

    return result.data;
  }

  /// Updates the cover photo.
  Future<Profile?> updateCoverPhoto(String imagePath) async {
    if (state.isPhotoUploading) return null;

    state = state.copyWith(isPhotoUploading: true, clearError: true);

    final result = await _updateCoverPhoto(imagePath);

    if (result.failure != null) {
      state = state.copyWith(isPhotoUploading: false, errorMessage: result.failure!.message);
      return null;
    }

    state = state.copyWith(isPhotoUploading: false, profile: result.data);

    // Invalidate the current profile provider to refresh data
    ref.invalidate(currentProfileProvider);

    return result.data;
  }

  /// Removes the profile photo.
  Future<void> removePhoto() async {
    if (state.isPhotoUploading) return;

    state = state.copyWith(isPhotoUploading: true, clearError: true);

    final result = await _removeProfilePhoto(const NoParams());

    if (result.failure != null) {
      state = state.copyWith(isPhotoUploading: false, errorMessage: result.failure!.message);
      return;
    }

    state = state.copyWith(isPhotoUploading: false, profile: result.data);

    // Invalidate the current profile provider to refresh data
    ref.invalidate(currentProfileProvider);
  }

  /// Removes the cover photo.
  Future<void> removeCoverPhoto() async {
    if (state.isPhotoUploading) return;

    state = state.copyWith(isPhotoUploading: true, clearError: true);

    final result = await _removeCoverPhoto(const NoParams());

    if (result.failure != null) {
      state = state.copyWith(isPhotoUploading: false, errorMessage: result.failure!.message);
      return;
    }

    state = state.copyWith(isPhotoUploading: false, profile: result.data);

    // Invalidate the current profile provider to refresh data
    ref.invalidate(currentProfileProvider);
  }

  /// Clears the error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Resets the form to the original profile values.
  void resetForm() {
    if (state.profile != null) {
      state = state.copyWith(
        displayName: state.profile!.displayName,
        bio: state.profile!.bio ?? '',
        location: state.profile!.location ?? '',
        website: state.profile!.website ?? '',
        hasChanges: false,
        clearError: true,
        clearFieldErrors: true,
      );
    }
  }
}
