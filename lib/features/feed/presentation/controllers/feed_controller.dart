// lib/features/feed/presentation/controllers/feed_controller.dart
import 'package:flavorizr/features/feed/domain/entities/post.dart';
import 'package:flavorizr/features/feed/domain/usecases/feed_usecases.dart';
import 'package:flavorizr/features/feed/presentation/providers/feed_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the feed.
class FeedState {
  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextCursor,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final List<Post> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? nextCursor;
  final String? errorMessage;
  final bool isRefreshing;

  FeedState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? nextCursor,
    String? errorMessage,
    bool? isRefreshing,
    bool clearError = false,
    bool clearCursor = false,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearCursor ? null : nextCursor ?? this.nextCursor,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

/// Controller for the main feed with infinite scroll.
class FeedController extends Notifier<FeedState> {
  late final GetFeedPostsUseCase _getFeedPosts;
  late final ToggleReactionUseCase _toggleReaction;
  late final DeletePostUseCase _deletePost;

  @override
  FeedState build() {
    _getFeedPosts = ref.watch(getFeedPostsUseCaseProvider);
    _toggleReaction = ref.watch(toggleReactionUseCaseProvider);
    _deletePost = ref.watch(deletePostUseCaseProvider);

    // Load initial feed
    Future.microtask(loadFeed);

    return const FeedState();
  }

  /// Loads the initial feed.
  Future<void> loadFeed() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true, clearCursor: true);

    final result = await _getFeedPosts(const GetFeedPostsParams());

    if (result.failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: result.failure!.message);
      return;
    }

    final page = result.data!;
    state = state.copyWith(
      isLoading: false,
      posts: page.posts,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  /// Loads more posts (pagination).
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.nextCursor == null) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    final result = await _getFeedPosts(GetFeedPostsParams(cursor: state.nextCursor));

    if (result.failure != null) {
      state = state.copyWith(isLoadingMore: false, errorMessage: result.failure!.message);
      return;
    }

    final page = result.data!;
    state = state.copyWith(
      isLoadingMore: false,
      posts: [...state.posts, ...page.posts],
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  /// Refreshes the feed (pull-to-refresh).
  Future<void> refresh() async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true, clearError: true);

    final result = await _getFeedPosts(const GetFeedPostsParams());

    if (result.failure != null) {
      state = state.copyWith(isRefreshing: false, errorMessage: result.failure!.message);
      return;
    }

    final page = result.data!;
    state = state.copyWith(
      isRefreshing: false,
      posts: page.posts,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  /// Toggles a reaction on a post.
  Future<void> toggleReaction(String postId, ReactionType type) async {
    // Optimistic update
    final postIndex = state.posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final currentPost = state.posts[postIndex];
    final newReaction = currentPost.userReaction == type ? null : type;

    // Update locally first
    final updatedPosts = List<Post>.from(state.posts);
    updatedPosts[postIndex] = currentPost.copyWith(
      userReaction: newReaction,
      clearUserReaction: newReaction == null,
    );
    state = state.copyWith(posts: updatedPosts);

    // Sync with server
    final result = await _toggleReaction(ToggleReactionParams(postId: postId, type: type));

    if (result.failure != null) {
      // Revert on failure
      updatedPosts[postIndex] = currentPost;
      state = state.copyWith(posts: updatedPosts, errorMessage: result.failure!.message);
      return;
    }

    // Update with server response
    updatedPosts[postIndex] = result.data!;
    state = state.copyWith(posts: updatedPosts);
  }

  /// Deletes a post.
  Future<bool> deletePost(String postId) async {
    final result = await _deletePost(postId);

    if (result.failure != null) {
      state = state.copyWith(errorMessage: result.failure!.message);
      return false;
    }

    // Remove from local list
    final updatedPosts = state.posts.where((p) => p.id != postId).toList();
    state = state.copyWith(posts: updatedPosts);
    return true;
  }

  /// Adds a new post to the top of the feed.
  void addPost(Post post) {
    state = state.copyWith(posts: [post, ...state.posts]);
  }

  /// Updates a post in the feed.
  void updatePost(Post post) {
    final index = state.posts.indexWhere((p) => p.id == post.id);
    if (index == -1) return;

    final updatedPosts = List<Post>.from(state.posts);
    updatedPosts[index] = post;
    state = state.copyWith(posts: updatedPosts);
  }

  /// Clears any error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for the feed controller.
final feedControllerProvider = NotifierProvider<FeedController, FeedState>(FeedController.new);
