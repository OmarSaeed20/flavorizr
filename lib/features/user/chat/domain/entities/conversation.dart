// lib/features/chat/domain/entities/conversation.dart
import 'package:fast_golden_taxi/features/user/auth/domain/entities/user.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/message.dart';

/// Type of conversation.
enum ConversationType {
  /// One-on-one private conversation.
  direct,

  /// Group conversation with multiple participants.
  group,

  /// Channel-style conversation (many readers, few writers).
  channel,
}

/// Mute settings for a conversation.
enum MuteStatus {
  /// Not muted.
  unmuted,

  /// Muted for a duration.
  mutedTemporarily,

  /// Muted indefinitely.
  mutedForever,
}

/// Represents a chat conversation.
///
/// A conversation contains participants and messages.
/// It can be a direct (1:1) chat or a group chat.
class Conversation {
  const Conversation({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.imageUrl,
    this.participants = const [],
    this.participantIds = const [],
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.adminIds = const [],
    this.muteStatus = MuteStatus.unmuted,
    this.muteUntil,
    this.isPinned = false,
    this.isArchived = false,
    this.isReadOnly = false,
    this.settings = const {},
    this.metadata = const {},
  });

  /// Creates a conversation from a map.
  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      type: ConversationType.values.byName(map['type'] as String? ?? 'direct'),
      name: map['name'] as String?,
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String? ?? map['imageUrl'] as String?,
      participants:
          (map['participants'] as List<dynamic>?)
              ?.map((p) => User.fromMap(p as Map<String, dynamic>))
              .toList() ??
          [],
      participantIds:
          (map['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (map['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      lastMessage: map['last_message'] != null
          ? Message.fromMap(map['last_message'] as Map<String, dynamic>)
          : map['lastMessage'] != null
          ? Message.fromMap(map['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount:
          map['unread_count'] as int? ?? map['unreadCount'] as int? ?? 0,
      createdAt: DateTime.parse(
        map['created_at'] as String? ?? map['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] as String? ?? map['updatedAt'] as String,
      ),
      createdBy: map['created_by'] as String? ?? map['createdBy'] as String?,
      adminIds:
          (map['admin_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (map['adminIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      muteStatus: MuteStatus.values.byName(
        map['mute_status'] as String? ??
            map['muteStatus'] as String? ??
            'unmuted',
      ),
      muteUntil: map['mute_until'] != null
          ? DateTime.parse(map['mute_until'] as String)
          : map['muteUntil'] != null
          ? DateTime.parse(map['muteUntil'] as String)
          : null,
      isPinned: map['is_pinned'] as bool? ?? map['isPinned'] as bool? ?? false,
      isArchived:
          map['is_archived'] as bool? ?? map['isArchived'] as bool? ?? false,
      isReadOnly:
          map['is_read_only'] as bool? ?? map['isReadOnly'] as bool? ?? false,
      settings: Map<String, dynamic>.from(map['settings'] as Map? ?? {}),
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }

  /// Unique identifier for the conversation.
  final String id;

  /// Type of conversation (direct, group, or channel).
  final ConversationType type;

  /// Optional name for group conversations.
  final String? name;

  /// Optional description for the conversation.
  final String? description;

  /// Optional image URL for group avatar.
  final String? imageUrl;

  /// List of participants in the conversation.
  final List<User> participants;

  /// IDs of participants (useful when full User objects aren't loaded).
  final List<String> participantIds;

  /// The most recent message in the conversation.
  final Message? lastMessage;

  /// Number of unread messages.
  final int unreadCount;

  /// When the conversation was created.
  final DateTime createdAt;

  /// When the conversation was last updated.
  final DateTime updatedAt;

  /// ID of the user who created the conversation.
  final String? createdBy;

  /// IDs of conversation admins.
  final List<String> adminIds;

  /// Whether the conversation is muted.
  final MuteStatus muteStatus;

  /// When the mute expires (for temporary mutes).
  final DateTime? muteUntil;

  /// Whether the conversation is pinned.
  final bool isPinned;

  /// Whether the conversation is archived.
  final bool isArchived;

  /// Whether the conversation is read-only.
  final bool isReadOnly;

  /// Custom settings for this conversation.
  final Map<String, dynamic> settings;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Returns true if this is a direct (1:1) conversation.
  bool get isDirect => type == ConversationType.direct;

  /// Returns true if this is a group conversation.
  bool get isGroup => type == ConversationType.group;

  /// Returns true if this is a channel.
  bool get isChannel => type == ConversationType.channel;

  /// Returns true if the conversation is currently muted.
  bool get isMuted {
    if (muteStatus == MuteStatus.unmuted) return false;
    if (muteStatus == MuteStatus.mutedForever) return true;
    if (muteUntil != null && muteUntil!.isAfter(DateTime.now())) return true;
    return false;
  }

  /// Returns true if the user is an admin.
  bool isAdmin(String userId) => adminIds.contains(userId);

  /// Gets the display name for the conversation.
  /// For direct chats, this is the other participant's name.
  String displayName(String currentUserId) {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }

    if (isDirect) {
      final other = otherParticipant(currentUserId);
      return other?.displayName ?? other?.email ?? 'Unknown User';
    }

    if (participants.isNotEmpty) {
      final names = participants
          .take(3)
          .map((u) => u.displayName ?? u.email.split('@').first)
          .join(', ');
      if (participants.length > 3) {
        return '$names +${participants.length - 3}';
      }
      return names;
    }

    return 'Conversation';
  }

  /// Gets the avatar URL for the conversation.
  /// For direct chats, this is the other participant's avatar.
  String? displayImage(String currentUserId) {
    if (imageUrl != null) {
      return imageUrl;
    }

    if (isDirect) {
      return otherParticipant(currentUserId)?.photoUrl;
    }

    return null;
  }

  /// Returns the other participant in a direct conversation.
  User? otherParticipant(String currentUserId) {
    if (!isDirect || participants.isEmpty) return null;

    try {
      return participants.firstWhere((p) => p.id != currentUserId);
    } catch (_) {
      return participants.isNotEmpty ? participants.first : null;
    }
  }

  /// Returns the initials for the conversation avatar.
  String displayInitials(String currentUserId) {
    final displayNameStr = displayName(currentUserId);
    if (displayNameStr.isEmpty) return '?';

    final parts = displayNameStr.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return displayNameStr
        .substring(0, displayNameStr.length >= 2 ? 2 : 1)
        .toUpperCase();
  }

  /// Creates a copy with modified values.
  Conversation copyWith({
    String? id,
    ConversationType? type,
    String? name,
    String? description,
    String? imageUrl,
    List<User>? participants,
    List<String>? participantIds,
    Message? lastMessage,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    List<String>? adminIds,
    MuteStatus? muteStatus,
    DateTime? muteUntil,
    bool? isPinned,
    bool? isArchived,
    bool? isReadOnly,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? metadata,
  }) {
    return Conversation(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      participants: participants ?? this.participants,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      adminIds: adminIds ?? this.adminIds,
      muteStatus: muteStatus ?? this.muteStatus,
      muteUntil: muteUntil ?? this.muteUntil,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      settings: settings ?? this.settings,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts the conversation to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'participant_ids': participantIds,
      'unread_count': unreadCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'admin_ids': adminIds,
      'mute_status': muteStatus.name,
      'mute_until': muteUntil?.toIso8601String(),
      'is_pinned': isPinned,
      'is_archived': isArchived,
      'is_read_only': isReadOnly,
      'settings': settings,
      'metadata': metadata,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Conversation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Conversation(id: $id, type: $type, name: $name, participants: ${participants.length})';
}
