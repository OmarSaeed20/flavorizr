// lib/features/feed/data/datasources/feed_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_endpoints.dart';
import 'package:flavorizr/features/feed/data/models/post_model.dart';

/// Remote data source for feed operations.
///
/// Handles all HTTP requests related to the feed.
abstract class FeedRemoteDataSource {
  /// Gets paginated feed posts.
  Future<PostPageModel> getFeedPosts({String? cursor, int limit = 20});

  /// Gets posts from a specific user.
  Future<PostPageModel> getUserPosts({required String userId, String? cursor, int limit = 20});

  /// Gets a single post by ID.
  Future<PostModel> getPost({required String postId});

  /// Searches posts.
  Future<PostPageModel> searchPosts({required String query, String? cursor, int limit = 20});

  /// Gets posts by tag.
  Future<PostPageModel> getPostsByTag({required String tag, String? cursor, int limit = 20});

  /// Creates a new post.
  Future<PostModel> createPost({
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
    bool isPublic = true,
  });

  /// Updates a post.
  Future<PostModel> updatePost({
    required String postId,
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
  });

  /// Deletes a post.
  Future<void> deletePost({required String postId});

  /// Adds/updates a reaction.
  Future<PostModel> addReaction({required String postId, required String reactionType});

  /// Removes a reaction.
  Future<PostModel> removeReaction({required String postId});

  /// Shares a post.
  Future<void> sharePost({required String postId});
}

/// Implementation of [FeedRemoteDataSource] using Dio.
class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  FeedRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<PostPageModel> getFeedPosts({String? cursor, int limit = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.feed,
      queryParameters: {'limit': limit, if (cursor != null) 'cursor': cursor},
    );
    return PostPageModel.fromJson(response.data!);
  }

  @override
  Future<PostPageModel> getUserPosts({
    required String userId,
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.user(userId)}/posts',
      queryParameters: {'limit': limit, if (cursor != null) 'cursor': cursor},
    );
    return PostPageModel.fromJson(response.data!);
  }

  @override
  Future<PostModel> getPost({required String postId}) async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.post(postId));
    return PostModel.fromJson(response.data!['post'] as Map<String, dynamic>);
  }

  @override
  Future<PostPageModel> searchPosts({required String query, String? cursor, int limit = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.feed}/search',
      queryParameters: {'q': query, 'limit': limit, if (cursor != null) 'cursor': cursor},
    );
    return PostPageModel.fromJson(response.data!);
  }

  @override
  Future<PostPageModel> getPostsByTag({required String tag, String? cursor, int limit = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.feed}/tags/$tag',
      queryParameters: {'limit': limit, if (cursor != null) 'cursor': cursor},
    );
    return PostPageModel.fromJson(response.data!);
  }

  @override
  Future<PostModel> createPost({
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
    bool isPublic = true,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.createPost,
      data: {
        if (content != null) 'content': content,
        if (imageUrls != null) 'image_urls': imageUrls,
        if (tags != null) 'tags': tags,
        'is_public': isPublic,
      },
    );
    return PostModel.fromJson(response.data!['post'] as Map<String, dynamic>);
  }

  @override
  Future<PostModel> updatePost({
    required String postId,
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.updatePost(postId),
      data: {
        if (content != null) 'content': content,
        if (imageUrls != null) 'image_urls': imageUrls,
        if (tags != null) 'tags': tags,
      },
    );
    return PostModel.fromJson(response.data!['post'] as Map<String, dynamic>);
  }

  @override
  Future<void> deletePost({required String postId}) async {
    await _dio.delete<void>(ApiEndpoints.deletePost(postId));
  }

  @override
  Future<PostModel> addReaction({required String postId, required String reactionType}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.reactToPost(postId),
      data: {'type': reactionType},
    );
    return PostModel.fromJson(response.data!['post'] as Map<String, dynamic>);
  }

  @override
  Future<PostModel> removeReaction({required String postId}) async {
    final response = await _dio.delete<Map<String, dynamic>>(ApiEndpoints.postReactions(postId));
    return PostModel.fromJson(response.data!['post'] as Map<String, dynamic>);
  }

  @override
  Future<void> sharePost({required String postId}) async {
    await _dio.post<void>('${ApiEndpoints.post(postId)}/share');
  }
}
