// lib/features/profile/presentation/controllers/profile_controller.dart
import 'package:fast_golden_taxi/features/user/profile/domain/entities/profile.dart';
import 'package:fast_golden_taxi/features/user/profile/domain/usecases/profile_usecases.dart';
import 'package:fast_golden_taxi/features/user/profile/presentation/providers/profile_providers.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for profile viewing.
class ProfileState {
  const ProfileState({this.profile, this.isLoading = false, this.errorMessage});

  final Profile? profile;
  final bool isLoading;
  final String? errorMessage;

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// Controller for viewing profiles.
class ProfileController extends AutoDisposeNotifier<ProfileState> {
  late final GetProfileUseCase _getProfile;
  late final GetProfileDetailUseCase _getProfileDetail;

  @override
  ProfileState build() {
    _getProfile = ref.watch(getProfileUseCaseProvider);
    _getProfileDetail = ref.watch(getProfileDetailUseCaseProvider);
    return const ProfileState();
  }

  /// Loads the current user's profile.
  Future<void> loadProfile() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getProfile(const NoParams());

    if (result.error != null) {
      state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
      return;
    }

    state = state.copyWith(isLoading: false, profile: result.data);
  }

  /// Loads detailed profile information.
  Future<void> loadProfileDetail() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getProfileDetail(const NoParams());

    if (result.error != null) {
      state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
      return;
    }

    state = state.copyWith(isLoading: false, profile: result.data);
  }

  /// Refreshes the current profile.
  Future<void> refresh() async {
    await loadProfile();
  }

  /// Clears the error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
