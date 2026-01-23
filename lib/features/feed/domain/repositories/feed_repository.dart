// lib/features/feed/domain/repositories/feed_repository.dart
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/feed/domain/entities/post.dart';

/// Type alias for Either-like result handling.
typedef FeedEither<T> = Future<({T? data, Failure? failure})>;

/// Abstract repository defining feed operations.
///
/// This interface lives in the domain layer and defines the contract
/// that the data layer must implement.
abstract class FeedRepository {
  // ==================== Feed Operations ====================

  /// Gets a paginated list of posts for the main feed.
  ///
  /// Parameters:
  /// - [cursor] - Optional cursor for pagination
  /// - [limit] - Number of posts to fetch (default 20)
  ///
  /// Returns [PostPage] with posts and pagination info.
  FeedEither<PostPage> getFeedPosts({String? cursor, int limit = 20});

  /// Gets posts from a specific user.
  ///
  /// Parameters:
  /// - [userId] - ID of the user
  /// - [cursor] - Optional cursor for pagination
  /// - [limit] - Number of posts to fetch
  FeedEither<PostPage> getUserPosts({required String userId, String? cursor, int limit = 20});

  /// Gets a single post by ID.
  ///
  /// Parameters:
  /// - [postId] - ID of the post to fetch
  FeedEither<Post> getPost({required String postId});

  /// Searches posts by query.
  ///
  /// Parameters:
  /// - [query] - Search query string
  /// - [cursor] - Optional cursor for pagination
  /// - [limit] - Number of posts to fetch
  FeedEither<PostPage> searchPosts({required String query, String? cursor, int limit = 20});

  /// Gets posts by tag/hashtag.
  ///
  /// Parameters:
  /// - [tag] - Tag to filter by
  /// - [cursor] - Optional cursor for pagination
  /// - [limit] - Number of posts to fetch
  FeedEither<PostPage> getPostsByTag({required String tag, String? cursor, int limit = 20});

  // ==================== Post CRUD ====================

  /// Creates a new post.
  ///
  /// Parameters:
  /// - [content] - Text content of the post
  /// - [imageUrls] - Optional list of image URLs
  /// - [tags] - Optional list of tags
  /// - [isPublic] - Whether the post is public (default true)
  FeedEither<Post> createPost({
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
    bool isPublic = true,
  });

  /// Updates an existing post.
  ///
  /// Parameters:
  /// - [postId] - ID of the post to update
  /// - [content] - New text content
  /// - [imageUrls] - New list of image URLs
  /// - [tags] - New list of tags
  FeedEither<Post> updatePost({
    required String postId,
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
  });

  /// Deletes a post.
  ///
  /// Parameters:
  /// - [postId] - ID of the post to delete
  FeedEither<void> deletePost({required String postId});

  // ==================== Reactions ====================

  /// Adds or updates a reaction on a post.
  ///
  /// If the user already has a reaction, it will be updated.
  ///
  /// Parameters:
  /// - [postId] - ID of the post
  /// - [type] - Type of reaction
  FeedEither<Post> addReaction({required String postId, required ReactionType type});

  /// Removes a reaction from a post.
  ///
  /// Parameters:
  /// - [postId] - ID of the post
  FeedEither<Post> removeReaction({required String postId});

  /// Toggles a reaction on a post.
  ///
  /// If the same reaction exists, removes it. Otherwise, adds/updates it.
  ///
  /// Parameters:
  /// - [postId] - ID of the post
  /// - [type] - Type of reaction
  FeedEither<Post> toggleReaction({required String postId, required ReactionType type});

  // ==================== Sharing ====================

  /// Shares a post.
  ///
  /// Parameters:
  /// - [postId] - ID of the post to share
  FeedEither<void> sharePost({required String postId});

  // ==================== Caching ====================

  /// Gets cached feed posts (offline support).
  FeedEither<PostPage> getCachedFeedPosts();

  /// Caches feed posts for offline access.
  ///
  /// Parameters:
  /// - [posts] - List of posts to cache
  FeedEither<void> cacheFeedPosts({required List<Post> posts});

  /// Clears the feed cache.
  FeedEither<void> clearCache();

  // ==================== Streams ====================

  /// Stream of feed updates (real-time).
  Stream<Post> get feedUpdates;

  /// Stream of new posts.
  Stream<Post> get newPosts;
}
