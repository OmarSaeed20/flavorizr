// lib/features/feed/domain/entities/post.dart
import 'package:flutter/foundation.dart';

/// Represents a post in the feed.
///
/// Posts are the main content items in the feed system.
/// They can contain text, images, and receive reactions.
@immutable
class Post {
  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.authorPhotoUrl,
    this.content,
    this.imageUrls = const [],
    this.reactions = const [],
    this.reactionCounts = const {},
    this.userReaction,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.isEdited = false,
    this.isPinned = false,
    this.isPublic = true,
    this.tags = const [],
    this.metadata = const {},
    this.updatedAt,
  });

  /// Unique post identifier.
  final String id;

  /// ID of the post author.
  final String authorId;

  /// Display name of the author.
  final String authorName;

  /// Author's profile photo URL.
  final String? authorPhotoUrl;

  /// Text content of the post.
  final String? content;

  /// List of image URLs attached to the post.
  final List<String> imageUrls;

  /// List of reactions on this post.
  final List<Reaction> reactions;

  /// Count of each reaction type.
  final Map<ReactionType, int> reactionCounts;

  /// Current user's reaction (null if none).
  final ReactionType? userReaction;

  /// Number of comments on this post.
  final int commentsCount;

  /// Number of times this post was shared.
  final int sharesCount;

  /// Number of views.
  final int viewsCount;

  /// Whether the post has been edited.
  final bool isEdited;

  /// Whether the post is pinned.
  final bool isPinned;

  /// Whether the post is public.
  final bool isPublic;

  /// Tags/hashtags associated with the post.
  final List<String> tags;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// When the post was created.
  final DateTime createdAt;

  /// When the post was last updated.
  final DateTime? updatedAt;

  /// Returns total reaction count.
  int get totalReactions => reactionCounts.values.fold(0, (sum, count) => sum + count);

  /// Returns whether the post has any content.
  bool get hasContent => content != null && content!.trim().isNotEmpty;

  /// Returns whether the post has images.
  bool get hasImages => imageUrls.isNotEmpty;

  /// Returns whether the current user has reacted.
  bool get hasUserReacted => userReaction != null;

  /// Returns formatted relative time (e.g., "2h ago").
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  /// Creates a copy with updated fields.
  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorPhotoUrl,
    String? content,
    List<String>? imageUrls,
    List<Reaction>? reactions,
    Map<ReactionType, int>? reactionCounts,
    ReactionType? userReaction,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
    bool? isEdited,
    bool? isPinned,
    bool? isPublic,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearUserReaction = false,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorPhotoUrl: authorPhotoUrl ?? this.authorPhotoUrl,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      reactions: reactions ?? this.reactions,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      userReaction: clearUserReaction ? null : userReaction ?? this.userReaction,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isEdited: isEdited ?? this.isEdited,
      isPinned: isPinned ?? this.isPinned,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Post && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Types of reactions that can be added to posts.
enum ReactionType {
  like('👍', 'Like'),
  love('❤️', 'Love'),
  haha('😄', 'Haha'),
  wow('😮', 'Wow'),
  sad('😢', 'Sad'),
  angry('😠', 'Angry');

  const ReactionType(this.emoji, this.label);

  final String emoji;
  final String label;
}

/// Represents a reaction on a post.
@immutable
class Reaction {
  const Reaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final ReactionType type;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reaction && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Represents a paginated list of posts.
@immutable
class PostPage {
  const PostPage({required this.posts, required this.hasMore, this.nextCursor, this.totalCount});

  /// List of posts in this page.
  final List<Post> posts;

  /// Whether there are more posts to load.
  final bool hasMore;

  /// Cursor for loading the next page.
  final String? nextCursor;

  /// Total number of posts (if known).
  final int? totalCount;
}
