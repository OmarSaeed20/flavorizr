// lib/features/feed/domain/usecases/feed_usecases.dart
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/feed/domain/entities/post.dart';
import 'package:flavorizr/features/feed/domain/repositories/feed_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for getting feed posts with pagination.
///
/// Supports infinite scroll by using cursor-based pagination.
class GetFeedPostsUseCase implements UseCase<PostPage, GetFeedPostsParams> {
  GetFeedPostsUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({PostPage? data, Failure? failure})> call(GetFeedPostsParams params) async {
    // Try to get from network first
    final result = await _repository.getFeedPosts(cursor: params.cursor, limit: params.limit);

    // If network fails and no cursor (first page), try cache
    if (result.failure != null && params.cursor == null) {
      final cachedResult = await _repository.getCachedFeedPosts();
      if (cachedResult.data != null) {
        return (data: cachedResult.data, failure: null);
      }
    }

    // Cache successful results
    if (result.data != null && params.cursor == null) {
      await _repository.cacheFeedPosts(posts: result.data!.posts);
    }

    return result;
  }
}

/// Parameters for getting feed posts.
class GetFeedPostsParams {
  const GetFeedPostsParams({this.cursor, this.limit = 20});
  final String? cursor;
  final int limit;
}

/// Use case for getting a user's posts.
class GetUserPostsUseCase implements UseCase<PostPage, GetUserPostsParams> {
  GetUserPostsUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({PostPage? data, Failure? failure})> call(GetUserPostsParams params) {
    return _repository.getUserPosts(
      userId: params.userId,
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}

/// Parameters for getting user posts.
class GetUserPostsParams {
  const GetUserPostsParams({required this.userId, this.cursor, this.limit = 20});
  final String userId;
  final String? cursor;
  final int limit;
}

/// Use case for getting a single post.
class GetPostUseCase implements UseCase<Post, String> {
  GetPostUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({Post? data, Failure? failure})> call(String postId) {
    return _repository.getPost(postId: postId);
  }
}

/// Use case for creating a new post.
class CreatePostUseCase implements UseCase<Post, CreatePostParams> {
  CreatePostUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({Post? data, Failure? failure})> call(CreatePostParams params) async {
    // Validate that post has some content
    final hasContent = params.content != null && params.content!.trim().isNotEmpty;
    final hasImages = params.imageUrls != null && params.imageUrls!.isNotEmpty;

    if (!hasContent && !hasImages) {
      return (
        data: null,
        failure: const ValidationFailure(message: 'Post must have content or images'),
      );
    }

    return _repository.createPost(
      content: params.content,
      imageUrls: params.imageUrls,
      tags: params.tags,
      isPublic: params.isPublic,
    );
  }
}

/// Parameters for creating a post.
class CreatePostParams {
  const CreatePostParams({this.content, this.imageUrls, this.tags, this.isPublic = true});
  final String? content;
  final List<String>? imageUrls;
  final List<String>? tags;
  final bool isPublic;
}

/// Use case for updating a post.
class UpdatePostUseCase implements UseCase<Post, UpdatePostParams> {
  UpdatePostUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({Post? data, Failure? failure})> call(UpdatePostParams params) {
    return _repository.updatePost(
      postId: params.postId,
      content: params.content,
      imageUrls: params.imageUrls,
      tags: params.tags,
    );
  }
}

/// Parameters for updating a post.
class UpdatePostParams {
  const UpdatePostParams({required this.postId, this.content, this.imageUrls, this.tags});
  final String postId;
  final String? content;
  final List<String>? imageUrls;
  final List<String>? tags;
}

/// Use case for deleting a post.
class DeletePostUseCase implements UseCase<void, String> {
  DeletePostUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({void data, Failure? failure})> call(String postId) {
    return _repository.deletePost(postId: postId);
  }
}

/// Use case for toggling a reaction on a post.
class ToggleReactionUseCase implements UseCase<Post, ToggleReactionParams> {
  ToggleReactionUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({Post? data, Failure? failure})> call(ToggleReactionParams params) {
    return _repository.toggleReaction(postId: params.postId, type: params.type);
  }
}

/// Parameters for toggling a reaction.
class ToggleReactionParams {
  const ToggleReactionParams({required this.postId, required this.type});
  final String postId;
  final ReactionType type;
}

/// Use case for searching posts.
class SearchPostsUseCase implements UseCase<PostPage, SearchPostsParams> {
  SearchPostsUseCase(this._repository);
  final FeedRepository _repository;

  @override
  Future<({PostPage? data, Failure? failure})> call(SearchPostsParams params) async {
    if (params.query.trim().isEmpty) {
      return (
        data: null,
        failure: const ValidationFailure(message: 'Search query cannot be empty'),
      );
    }

    return _repository.searchPosts(query: params.query, cursor: params.cursor, limit: params.limit);
  }
}

/// Parameters for searching posts.
class SearchPostsParams {
  const SearchPostsParams({required this.query, this.cursor, this.limit = 20});
  final String query;
  final String? cursor;
  final int limit;
}
