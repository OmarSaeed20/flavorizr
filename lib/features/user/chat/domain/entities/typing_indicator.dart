// lib/features/chat/domain/entities/typing_indicator.dart

/// Represents a user's typing status in a conversation.
class TypingIndicator {
  const TypingIndicator({
    required this.conversationId,
    required this.userId,
    this.userName,
    this.userAvatar,
    required this.isTyping,
    required this.startedAt,
    required this.expiresAt,
  });

  /// Creates a typing indicator with default expiration (10 seconds).
  factory TypingIndicator.create({
    required String conversationId,
    required String userId,
    String? userName,
    String? userAvatar,
    bool isTyping = true,
    Duration expiration = const Duration(seconds: 10),
  }) {
    final now = DateTime.now();
    return TypingIndicator(
      conversationId: conversationId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      isTyping: isTyping,
      startedAt: now,
      expiresAt: now.add(expiration),
    );
  }

  /// Creates from a map.
  factory TypingIndicator.fromMap(Map<String, dynamic> map) {
    return TypingIndicator(
      conversationId: map['conversation_id'] as String? ?? map['conversationId'] as String,
      userId: map['user_id'] as String? ?? map['userId'] as String,
      userName: map['user_name'] as String? ?? map['userName'] as String?,
      userAvatar: map['user_avatar'] as String? ?? map['userAvatar'] as String?,
      isTyping: map['is_typing'] as bool? ?? map['isTyping'] as bool? ?? true,
      startedAt: DateTime.parse(map['started_at'] as String? ?? map['startedAt'] as String),
      expiresAt: DateTime.parse(map['expires_at'] as String? ?? map['expiresAt'] as String),
    );
  }

  /// The conversation where typing is happening.
  final String conversationId;

  /// The user who is typing.
  final String userId;

  /// Display name of the user who is typing.
  final String? userName;

  /// Avatar URL of the user who is typing.
  final String? userAvatar;

  /// Whether the user is currently typing.
  final bool isTyping;

  /// When the typing started.
  final DateTime startedAt;

  /// When this indicator expires (auto-clear if no update).
  final DateTime expiresAt;

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'conversation_id': conversationId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'is_typing': isTyping,
      'started_at': startedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  /// Returns true if the typing indicator has expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Returns true if the typing indicator is still valid.
  bool get isValid => isTyping && !isExpired;

  /// Creates a stopped typing indicator.
  TypingIndicator stop() {
    return TypingIndicator(
      conversationId: conversationId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      isTyping: false,
      startedAt: startedAt,
      expiresAt: DateTime.now(),
    );
  }

  /// Refreshes the expiration time.
  TypingIndicator refresh({Duration expiration = const Duration(seconds: 10)}) {
    return TypingIndicator(
      conversationId: conversationId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      isTyping: isTyping,
      startedAt: startedAt,
      expiresAt: DateTime.now().add(expiration),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypingIndicator &&
          runtimeType == other.runtimeType &&
          conversationId == other.conversationId &&
          userId == other.userId;

  @override
  int get hashCode => Object.hash(conversationId, userId);

  @override
  String toString() =>
      'TypingIndicator(conversationId: $conversationId, userId: $userId, isTyping: $isTyping)';
}

/// Online/Offline presence state.
enum PresenceState {
  /// User is online and active.
  online,

  /// User is online but idle/away.
  away,

  /// User is in do-not-disturb mode.
  doNotDisturb,

  /// User is offline.
  offline,

  /// User is invisible (appears offline but is online).
  invisible,
}

/// Represents online/offline presence status.
class PresenceStatus {
  const PresenceStatus({
    required this.userId,
    this.userName,
    this.userAvatar,
    required this.state,
    this.lastSeenAt,
    this.statusMessage,
    this.statusEmoji,
    required this.updatedAt,
  });

  /// Creates from a map.
  factory PresenceStatus.fromMap(Map<String, dynamic> map) {
    return PresenceStatus(
      userId: map['user_id'] as String? ?? map['userId'] as String,
      userName: map['user_name'] as String? ?? map['userName'] as String?,
      userAvatar: map['user_avatar'] as String? ?? map['userAvatar'] as String?,
      state: PresenceState.values.byName(map['state'] as String? ?? 'offline'),
      lastSeenAt: map['last_seen_at'] != null
          ? DateTime.parse(map['last_seen_at'] as String)
          : map['lastSeenAt'] != null
          ? DateTime.parse(map['lastSeenAt'] as String)
          : null,
      statusMessage: map['status_message'] as String? ?? map['statusMessage'] as String?,
      statusEmoji: map['status_emoji'] as String? ?? map['statusEmoji'] as String?,
      updatedAt: DateTime.parse(map['updated_at'] as String? ?? map['updatedAt'] as String),
    );
  }

  /// The user's ID.
  final String userId;

  /// The user's display name.
  final String? userName;

  /// The user's avatar URL.
  final String? userAvatar;

  /// Current presence state.
  final PresenceState state;

  /// When the user was last seen online.
  final DateTime? lastSeenAt;

  /// Custom status message.
  final String? statusMessage;

  /// Custom status emoji.
  final String? statusEmoji;

  /// When the status was last updated.
  final DateTime updatedAt;

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'state': state.name,
      'last_seen_at': lastSeenAt?.toIso8601String(),
      'status_message': statusMessage,
      'status_emoji': statusEmoji,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Returns true if the user is online or away.
  bool get isOnline => state == PresenceState.online || state == PresenceState.away;

  /// Returns true if the user appears offline (offline or invisible).
  bool get isOffline => state == PresenceState.offline || state == PresenceState.invisible;

  /// Returns a human-readable status string.
  String get displayStatus {
    switch (state) {
      case PresenceState.online:
        return statusMessage ?? 'Online';
      case PresenceState.away:
        return statusMessage ?? 'Away';
      case PresenceState.doNotDisturb:
        return statusMessage ?? 'Do not disturb';
      case PresenceState.offline:
      case PresenceState.invisible:
        if (lastSeenAt != null) {
          return 'Last seen ${_formatLastSeen(lastSeenAt!)}';
        }
        return 'Offline';
    }
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final diff = now.difference(lastSeen);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
  }

  /// Creates a copy with modified values.
  PresenceStatus copyWith({
    String? userId,
    String? userName,
    String? userAvatar,
    PresenceState? state,
    DateTime? lastSeenAt,
    String? statusMessage,
    String? statusEmoji,
    DateTime? updatedAt,
  }) {
    return PresenceStatus(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      state: state ?? this.state,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      statusMessage: statusMessage ?? this.statusMessage,
      statusEmoji: statusEmoji ?? this.statusEmoji,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PresenceStatus && runtimeType == other.runtimeType && userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() => 'PresenceStatus(userId: $userId, state: $state)';
}
