// lib/features/feed/data/repositories/feed_repository_impl.dart
import 'dart:async';

import 'package:flavorizr/core/error/error_handler.dart';
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:flavorizr/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:flavorizr/features/feed/data/models/post_model.dart';
import 'package:flavorizr/features/feed/domain/entities/post.dart';
import 'package:flavorizr/features/feed/domain/repositories/feed_repository.dart';

/// Implementation of [FeedRepository].
///
/// Coordinates between remote and local data sources,
/// handles network connectivity, and manages caching.
class FeedRepositoryImpl implements FeedRepository {

  FeedRepositoryImpl({
    required FeedRemoteDataSource remoteDataSource,
    required FeedLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;
  final FeedRemoteDataSource _remoteDataSource;
  final FeedLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  final _feedUpdatesController = StreamController<Post>.broadcast();
  final _newPostsController = StreamController<Post>.broadcast();

  @override
  FeedEither<PostPage> getFeedPosts({String? cursor, int limit = 20}) async {
    try {
      if (!await _networkInfo.isConnected) {
        // If offline and requesting first page, try cache
        if (cursor == null) {
          final cached = await _localDataSource.getCachedFeedPosts();
          if (cached != null) {
            return (data: cached.toEntity(), failure: null);
          }
        }
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.getFeedPosts(
        cursor: cursor,
        limit: limit,
      );

      // Cache first page
      if (cursor == null) {
        await _localDataSource.cacheFeedPosts(result.posts);
      }

      return (data: result.toEntity(), failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<PostPage> getUserPosts({
    required String userId,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.getUserPosts(
        userId: userId,
        cursor: cursor,
        limit: limit,
      );
      return (data: result.toEntity(), failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<Post> getPost({required String postId}) async {
    try {
      if (!await _networkInfo.isConnected) {
        // Try to get from cache
        final cached = await _localDataSource.getCachedPost(postId);
        if (cached != null) {
          return (data: cached.toEntity(), failure: null);
        }
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.getPost(postId: postId);
      await _localDataSource.cachePost(result);
      return (data: result.toEntity(), failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<PostPage> searchPosts({
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.searchPosts(
        query: query,
        cursor: cursor,
        limit: limit,
      );
      return (data: result.toEntity(), failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<PostPage> getPostsByTag({
    required String tag,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.getPostsByTag(
        tag: tag,
        cursor: cursor,
        limit: limit,
      );
      return (data: result.toEntity(), failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<Post> createPost({
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
    bool isPublic = true,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.createPost(
        content: content,
        imageUrls: imageUrls,
        tags: tags,
        isPublic: isPublic,
      );

      final post = result.toEntity();
      _newPostsController.add(post);
      return (data: post, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<Post> updatePost({
    required String postId,
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.updatePost(
        postId: postId,
        content: content,
        imageUrls: imageUrls,
        tags: tags,
      );

      final post = result.toEntity();
      _feedUpdatesController.add(post);
      return (data: post, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<void> deletePost({required String postId}) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      await _remoteDataSource.deletePost(postId: postId);
      return (data: null, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<Post> addReaction({
    required String postId,
    required ReactionType type,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.addReaction(
        postId: postId,
        reactionType: type.name,
      );

      final post = result.toEntity();
      _feedUpdatesController.add(post);
      return (data: post, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<Post> removeReaction({required String postId}) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      final result = await _remoteDataSource.removeReaction(postId: postId);

      final post = result.toEntity();
      _feedUpdatesController.add(post);
      return (data: post, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<Post> toggleReaction({
    required String postId,
    required ReactionType type,
  }) async {
    try {
      // Get current post state
      final postResult = await getPost(postId: postId);
      if (postResult.failure != null) {
        return (data: null, failure: postResult.failure);
      }

      final currentPost = postResult.data!;

      if (currentPost.userReaction == type) {
        // Same reaction - remove it
        return removeReaction(postId: postId);
      } else {
        // Different reaction or no reaction - add/update
        return addReaction(postId: postId, type: type);
      }
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<void> sharePost({required String postId}) async {
    try {
      if (!await _networkInfo.isConnected) {
        return (data: null, failure: const NetworkFailure(message: 'No internet connection'));
      }

      await _remoteDataSource.sharePost(postId: postId);
      return (data: null, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<PostPage> getCachedFeedPosts() async {
    try {
      final cached = await _localDataSource.getCachedFeedPosts();
      if (cached == null) {
        return (data: null, failure: const CacheFailure(message: 'No cached feed'));
      }
      return (data: cached.toEntity(), failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<void> cacheFeedPosts({required List<Post> posts}) async {
    try {
      final models = posts.map(PostModel.fromEntity).toList();
      await _localDataSource.cacheFeedPosts(models);
      return (data: null, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  FeedEither<void> clearCache() async {
    try {
      await _localDataSource.clearCache();
      return (data: null, failure: null);
    } catch (e, s) {
      return (data: null, failure: ErrorHandler.mapExceptionToFailure(e, s));
    }
  }

  @override
  Stream<Post> get feedUpdates => _feedUpdatesController.stream;

  @override
  Stream<Post> get newPosts => _newPostsController.stream;

  /// Closes the stream controllers.
  void dispose() {
    _feedUpdatesController.close();
    _newPostsController.close();
  }
}
