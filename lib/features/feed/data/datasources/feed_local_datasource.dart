// lib/features/feed/data/datasources/feed_local_datasource.dart
import 'dart:convert';

import 'package:flavorizr/features/feed/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching feed data.
///
/// Uses SharedPreferences for simple caching.
/// For production, consider using a proper database like Hive or SQLite.
abstract class FeedLocalDataSource {
  /// Gets cached feed posts.
  Future<PostPageModel?> getCachedFeedPosts();

  /// Caches feed posts.
  Future<void> cacheFeedPosts(List<PostModel> posts);

  /// Gets a cached post by ID.
  Future<PostModel?> getCachedPost(String postId);

  /// Caches a single post.
  Future<void> cachePost(PostModel post);

  /// Clears the feed cache.
  Future<void> clearCache();

  /// Gets the last cache timestamp.
  Future<DateTime?> getLastCacheTime();
}

/// Implementation of [FeedLocalDataSource].
class FeedLocalDataSourceImpl implements FeedLocalDataSource {
  FeedLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  static const String _feedCacheKey = 'cached_feed_posts';
  static const String _postCachePrefix = 'cached_post_';
  static const String _cacheTimeKey = 'feed_cache_time';

  @override
  Future<PostPageModel?> getCachedFeedPosts() async {
    final jsonString = _prefs.getString(_feedCacheKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PostPageModel.fromJson(json);
    } catch (e) {
      // Clear corrupted cache
      await clearCache();
      return null;
    }
  }

  @override
  Future<void> cacheFeedPosts(List<PostModel> posts) async {
    final pageModel = PostPageModel(
      posts: posts,
      hasMore: false, // Cached data doesn't support pagination
      totalCount: posts.length,
    );

    await _prefs.setString(_feedCacheKey, jsonEncode(pageModel.toJson()));
    await _prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());

    // Also cache individual posts
    for (final post in posts) {
      await cachePost(post);
    }
  }

  @override
  Future<PostModel?> getCachedPost(String postId) async {
    final jsonString = _prefs.getString('$_postCachePrefix$postId');
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PostModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cachePost(PostModel post) async {
    await _prefs.setString('$_postCachePrefix${post.id}', jsonEncode(post.toJson()));
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_feedCacheKey);
    await _prefs.remove(_cacheTimeKey);

    // Remove all cached posts
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_postCachePrefix)) {
        await _prefs.remove(key);
      }
    }
  }

  @override
  Future<DateTime?> getLastCacheTime() async {
    final timeString = _prefs.getString(_cacheTimeKey);
    if (timeString == null) return null;

    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }
}
