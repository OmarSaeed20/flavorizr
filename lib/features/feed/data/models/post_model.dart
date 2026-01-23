// lib/features/feed/data/models/post_model.dart
import 'package:flavorizr/features/feed/domain/entities/post.dart';

/// Data model for Post with JSON serialization.
class PostModel {
  const PostModel({
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

  /// Creates a model from JSON.
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      authorId: json['author_id'] as String? ?? json['authorId'] as String,
      authorName: json['author_name'] as String? ?? json['authorName'] as String,
      authorPhotoUrl: json['author_photo_url'] as String? ?? json['authorPhotoUrl'] as String?,
      content: json['content'] as String?,
      imageUrls: List<String>.from(json['image_urls'] as List? ?? json['imageUrls'] as List? ?? []),
      reactions:
          (json['reactions'] as List?)
              ?.map((e) => ReactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reactionCounts: Map<String, int>.from(
        json['reaction_counts'] as Map? ?? json['reactionCounts'] as Map? ?? {},
      ),
      userReaction: json['user_reaction'] as String? ?? json['userReaction'] as String?,
      commentsCount: json['comments_count'] as int? ?? json['commentsCount'] as int? ?? 0,
      sharesCount: json['shares_count'] as int? ?? json['sharesCount'] as int? ?? 0,
      viewsCount: json['views_count'] as int? ?? json['viewsCount'] as int? ?? 0,
      isEdited: json['is_edited'] as bool? ?? json['isEdited'] as bool? ?? false,
      isPinned: json['is_pinned'] as bool? ?? json['isPinned'] as bool? ?? false,
      isPublic: json['is_public'] as bool? ?? json['isPublic'] as bool? ?? true,
      tags: List<String>.from(json['tags'] as List? ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
      createdAt: DateTime.parse(json['created_at'] as String? ?? json['createdAt'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Creates a model from domain entity.
  factory PostModel.fromEntity(Post entity) {
    return PostModel(
      id: entity.id,
      authorId: entity.authorId,
      authorName: entity.authorName,
      authorPhotoUrl: entity.authorPhotoUrl,
      content: entity.content,
      imageUrls: entity.imageUrls,
      reactions: entity.reactions.map(ReactionModel.fromEntity).toList(),
      reactionCounts: entity.reactionCounts.map((k, v) => MapEntry(k.name, v)),
      userReaction: entity.userReaction?.name,
      commentsCount: entity.commentsCount,
      sharesCount: entity.sharesCount,
      viewsCount: entity.viewsCount,
      isEdited: entity.isEdited,
      isPinned: entity.isPinned,
      isPublic: entity.isPublic,
      tags: entity.tags,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String? content;
  final List<String> imageUrls;
  final List<ReactionModel> reactions;
  final Map<String, int> reactionCounts;
  final String? userReaction;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isEdited;
  final bool isPinned;
  final bool isPublic;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'author_name': authorName,
      'author_photo_url': authorPhotoUrl,
      'content': content,
      'image_urls': imageUrls,
      'reactions': reactions.map((e) => e.toJson()).toList(),
      'reaction_counts': reactionCounts,
      'user_reaction': userReaction,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'views_count': viewsCount,
      'is_edited': isEdited,
      'is_pinned': isPinned,
      'is_public': isPublic,
      'tags': tags,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Converts to domain entity.
  Post toEntity() {
    return Post(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorPhotoUrl: authorPhotoUrl,
      content: content,
      imageUrls: imageUrls,
      reactions: reactions.map((e) => e.toEntity()).toList(),
      reactionCounts: _parseReactionCounts(reactionCounts),
      userReaction: _parseReactionType(userReaction),
      commentsCount: commentsCount,
      sharesCount: sharesCount,
      viewsCount: viewsCount,
      isEdited: isEdited,
      isPinned: isPinned,
      isPublic: isPublic,
      tags: tags,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<ReactionType, int> _parseReactionCounts(Map<String, int> counts) {
    final result = <ReactionType, int>{};
    for (final entry in counts.entries) {
      final type = _parseReactionType(entry.key);
      if (type != null) {
        result[type] = entry.value;
      }
    }
    return result;
  }

  ReactionType? _parseReactionType(String? value) {
    if (value == null) return null;
    return ReactionType.values.firstWhere((e) => e.name == value, orElse: () => ReactionType.like);
  }
}

/// Data model for Reaction with JSON serialization.
class ReactionModel {
  const ReactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? json['userId'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String? ?? json['createdAt'] as String),
    );
  }

  factory ReactionModel.fromEntity(Reaction entity) {
    return ReactionModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type.name,
      createdAt: entity.createdAt,
    );
  }

  final String id;
  final String userId;
  final String type;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {'id': id, 'user_id': userId, 'type': type, 'created_at': createdAt.toIso8601String()};
  }

  Reaction toEntity() {
    return Reaction(
      id: id,
      userId: userId,
      type: ReactionType.values.firstWhere((e) => e.name == type, orElse: () => ReactionType.like),
      createdAt: createdAt,
    );
  }
}

/// Data model for paginated posts.
class PostPageModel {
  const PostPageModel({
    required this.posts,
    required this.hasMore,
    this.nextCursor,
    this.totalCount,
  });

  factory PostPageModel.fromJson(Map<String, dynamic> json) {
    return PostPageModel(
      posts: (json['posts'] as List? ?? json['data'] as List? ?? [])
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool? ?? json['hasMore'] as bool? ?? false,
      nextCursor: json['next_cursor'] as String? ?? json['nextCursor'] as String?,
      totalCount: json['total_count'] as int? ?? json['totalCount'] as int?,
    );
  }

  final List<PostModel> posts;
  final bool hasMore;
  final String? nextCursor;
  final int? totalCount;

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((e) => e.toJson()).toList(),
      'has_more': hasMore,
      'next_cursor': nextCursor,
      'total_count': totalCount,
    };
  }

  PostPage toEntity() {
    return PostPage(
      posts: posts.map((e) => e.toEntity()).toList(),
      hasMore: hasMore,
      nextCursor: nextCursor,
      totalCount: totalCount,
    );
  }
}
