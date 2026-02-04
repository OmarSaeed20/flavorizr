// lib/features/profile/presentation/controllers/profile_controller.dart
import 'package:flavorizr/features/profile/domain/entities/profile.dart';
import 'package:flavorizr/features/profile/domain/usecases/profile_usecases.dart';
import 'package:flavorizr/features/profile/presentation/providers/profile_providers.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for profile viewing.
class ProfileState {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isFollowing = false,
    this.isFollowLoading = false,
    this.errorMessage,
  });

  final Profile? profile;
  final bool isLoading;
  final bool isFollowing;
  final bool isFollowLoading;
  final String? errorMessage;

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    bool? isFollowing,
    bool? isFollowLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// Controller for viewing profiles.
class ProfileController extends AutoDisposeNotifier<ProfileState> {
  late final GetCurrentProfileUseCase _getCurrentProfile;
  late final GetProfileByUserIdUseCase _getProfileByUserId;
  late final FollowUserUseCase _followUser;
  late final UnfollowUserUseCase _unfollowUser;

  @override
  ProfileState build() {
    _getCurrentProfile = ref.watch(getCurrentProfileUseCaseProvider);
    _getProfileByUserId = ref.watch(getProfileByUserIdUseCaseProvider);
    _followUser = ref.watch(followUserUseCaseProvider);
    _unfollowUser = ref.watch(unfollowUserUseCaseProvider);
    return const ProfileState();
  }

  /// Loads the current user's profile.
  Future<void> loadCurrentProfile() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getCurrentProfile(const NoParams());

    if (result.error != null) {
      state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
      return;
    }

    state = state.copyWith(isLoading: false, profile: result.data);
  }

  /// Loads a user's profile by ID.
  Future<void> loadProfile(String userId) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getProfileByUserId(userId);

    if (result.error != null) {
      state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
      return;
    }

    // Check if current user follows this profile
    final repository = ref.read(profileRepositoryProvider);
    final followResult = await repository.isFollowing(userId);

    state = state.copyWith(
      isLoading: false,
      profile: result.data,
      isFollowing: followResult.data ?? false,
    );
  }

  /// Toggles following status.
  Future<void> toggleFollow() async {
    if (state.isFollowLoading || state.profile == null) return;

    state = state.copyWith(isFollowLoading: true);

    final userId = state.profile!.userId;
    final wasFollowing = state.isFollowing;

    // Optimistically update UI
    state = state.copyWith(
      isFollowing: !wasFollowing,
      profile: state.profile!.copyWith(
        followersCount: state.profile!.followersCount + (wasFollowing ? -1 : 1),
      ),
    );

    final result = wasFollowing ? await _unfollowUser(userId) : await _followUser(userId);

    if (result.error != null) {
      // Revert on failure
      state = state.copyWith(
        isFollowLoading: false,
        isFollowing: wasFollowing,
        profile: state.profile!.copyWith(
          followersCount: state.profile!.followersCount + (wasFollowing ? 1 : -1),
        ),
        errorMessage: result.error!.message,
      );
      return;
    }

    state = state.copyWith(isFollowLoading: false);
  }

  /// Refreshes the current profile.
  Future<void> refresh() async {
    if (state.profile != null) {
      await loadProfile(state.profile!.userId);
    } else {
      await loadCurrentProfile();
    }
  }

  /// Clears the error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
