// lib/features/chat/domain/entities/message.dart

/// Type of message content.
enum MessageType {
  /// Plain text message.
  text,

  /// Image attachment.
  image,

  /// Video attachment.
  video,

  /// Audio/voice message.
  audio,

  /// File attachment.
  file,

  /// Location sharing.
  location,

  /// System message (user joined, left, etc.).
  system,

  /// Reply to another message.
  reply,

  /// Forwarded message.
  forwarded,
}

/// Message delivery/read status.
enum MessageStatus {
  /// Message is being sent.
  sending,

  /// Message sent to server.
  sent,

  /// Message delivered to recipient(s).
  delivered,

  /// Message read by recipient(s).
  read,

  /// Message failed to send.
  failed,
}

/// Attachment metadata.
class MessageAttachment {
  const MessageAttachment({
    required this.id,
    required this.type,
    required this.url,
    this.fileName,
    this.mimeType,
    this.fileSize,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.duration,
    this.blurHash,
  });

  /// Creates an attachment from a map.
  factory MessageAttachment.fromMap(Map<String, dynamic> map) {
    return MessageAttachment(
      id: map['id'] as String,
      type: map['type'] as String,
      url: map['url'] as String,
      fileName: map['file_name'] as String? ?? map['fileName'] as String?,
      mimeType: map['mime_type'] as String? ?? map['mimeType'] as String?,
      fileSize: map['file_size'] as int? ?? map['fileSize'] as int?,
      thumbnailUrl:
          map['thumbnail_url'] as String? ?? map['thumbnailUrl'] as String?,
      width: map['width'] as int?,
      height: map['height'] as int?,
      duration: map['duration'] as int?,
      blurHash: map['blur_hash'] as String? ?? map['blurHash'] as String?,
    );
  }

  /// Unique attachment ID.
  final String id;

  /// Type of attachment (image, video, audio, file).
  final String type;

  /// URL to the attachment.
  final String url;

  /// Original filename.
  final String? fileName;

  /// MIME type.
  final String? mimeType;

  /// File size in bytes.
  final int? fileSize;

  /// Thumbnail URL for images/videos.
  final String? thumbnailUrl;

  /// Width for images/videos.
  final int? width;

  /// Height for images/videos.
  final int? height;

  /// Duration in seconds for audio/video.
  final int? duration;

  /// Blur hash for progressive loading.
  final String? blurHash;

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'file_name': fileName,
      'mime_type': mimeType,
      'file_size': fileSize,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'duration': duration,
      'blur_hash': blurHash,
    };
  }

  /// Creates a copy with modified values.
  MessageAttachment copyWith({
    String? id,
    String? type,
    String? url,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? thumbnailUrl,
    int? width,
    int? height,
    int? duration,
    String? blurHash,
  }) {
    return MessageAttachment(
      id: id ?? this.id,
      type: type ?? this.type,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      duration: duration ?? this.duration,
      blurHash: blurHash ?? this.blurHash,
    );
  }

  /// Returns true if this is an image attachment.
  bool get isImage => type == 'image';

  /// Returns true if this is a video attachment.
  bool get isVideo => type == 'video';

  /// Returns true if this is an audio attachment.
  bool get isAudio => type == 'audio';

  /// Returns formatted file size string.
  String get formattedSize {
    if (fileSize == null) return '';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    }
    if (fileSize! < 1024 * 1024 * 1024) {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(fileSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAttachment &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Location data for location messages.
class MessageLocation {
  const MessageLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
  });

  factory MessageLocation.fromMap(Map<String, dynamic> map) {
    return MessageLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: map['address'] as String?,
      name: map['name'] as String?,
    );
  }

  /// Latitude.
  final double latitude;

  /// Longitude.
  final double longitude;

  /// Address string.
  final String? address;

  /// Place name.
  final String? name;

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'name': name,
    };
  }
}

/// Represents a chat message.
class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.type,
    this.content,
    this.attachments = const [],
    this.location,
    this.status = MessageStatus.sent,
    required this.createdAt,
    this.updatedAt,
    this.deliveredAt,
    this.readAt,
    this.readBy = const [],
    this.reactions = const {},
    this.replyToId,
    this.replyTo,
    this.forwardedFromId,
    this.isEdited = false,
    this.isDeleted = false,
    this.isPinned = false,
    this.mentions = const [],
    this.metadata = const {},
    this.localId,
  });

  /// Creates a message from a map.
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      conversationId:
          map['conversation_id'] as String? ?? map['conversationId'] as String,
      senderId: map['sender_id'] as String? ?? map['senderId'] as String,
      senderName: map['sender_name'] as String? ?? map['senderName'] as String?,
      senderAvatar:
          map['sender_avatar'] as String? ?? map['senderAvatar'] as String?,
      type: MessageType.values.byName(map['type'] as String? ?? 'text'),
      content: map['content'] as String?,
      attachments:
          (map['attachments'] as List<dynamic>?)
              ?.map((a) => MessageAttachment.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
      location: map['location'] != null
          ? MessageLocation.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      status: MessageStatus.values.byName(map['status'] as String? ?? 'sent'),
      createdAt: DateTime.parse(
        map['created_at'] as String? ?? map['createdAt'] as String,
      ),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      deliveredAt: map['delivered_at'] != null
          ? DateTime.parse(map['delivered_at'] as String)
          : map['deliveredAt'] != null
          ? DateTime.parse(map['deliveredAt'] as String)
          : null,
      readAt: map['read_at'] != null
          ? DateTime.parse(map['read_at'] as String)
          : map['readAt'] != null
          ? DateTime.parse(map['readAt'] as String)
          : null,
      readBy:
          (map['read_by'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (map['readBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      reactions:
          (map['reactions'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>).map((e) => e as String).toList(),
            ),
          ) ??
          {},
      replyToId: map['reply_to_id'] as String? ?? map['replyToId'] as String?,
      replyTo: map['reply_to'] != null
          ? Message.fromMap(map['reply_to'] as Map<String, dynamic>)
          : map['replyTo'] != null
          ? Message.fromMap(map['replyTo'] as Map<String, dynamic>)
          : null,
      forwardedFromId:
          map['forwarded_from_id'] as String? ??
          map['forwardedFromId'] as String?,
      isEdited: map['is_edited'] as bool? ?? map['isEdited'] as bool? ?? false,
      isDeleted:
          map['is_deleted'] as bool? ?? map['isDeleted'] as bool? ?? false,
      isPinned: map['is_pinned'] as bool? ?? map['isPinned'] as bool? ?? false,
      mentions:
          (map['mentions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
      localId: map['local_id'] as String? ?? map['localId'] as String?,
    );
  }

  /// Unique message ID.
  final String id;

  /// ID of the conversation this message belongs to.
  final String conversationId;

  /// ID of the sender.
  final String senderId;

  /// Sender's display name (denormalized for efficiency).
  final String? senderName;

  /// Sender's avatar URL (denormalized for efficiency).
  final String? senderAvatar;

  /// Type of message.
  final MessageType type;

  /// Message content (text).
  final String? content;

  /// Attachments (images, videos, files).
  final List<MessageAttachment> attachments;

  /// Location data for location messages.
  final MessageLocation? location;

  /// Message delivery status.
  final MessageStatus status;

  /// When the message was created.
  final DateTime createdAt;

  /// When the message was last updated.
  final DateTime? updatedAt;

  /// When the message was delivered.
  final DateTime? deliveredAt;

  /// When the message was read.
  final DateTime? readAt;

  /// IDs of users who have read the message.
  final List<String> readBy;

  /// Reactions to the message (emoji -> list of user IDs).
  final Map<String, List<String>> reactions;

  /// ID of the message this is replying to.
  final String? replyToId;

  /// Preview of the replied message.
  final Message? replyTo;

  /// ID of the original message if forwarded.
  final String? forwardedFromId;

  /// Whether the message has been edited.
  final bool isEdited;

  /// Whether the message has been deleted.
  final bool isDeleted;

  /// Whether the message is pinned.
  final bool isPinned;

  /// Mentions in the message (user IDs).
  final List<String> mentions;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Local ID for optimistic updates.
  final String? localId;

  /// Returns true if the message is from the specified user.
  bool isFromUser(String userId) => senderId == userId;

  /// Returns true if the message has been read by the specified user.
  bool isReadBy(String userId) => readBy.contains(userId);

  /// Returns true if this is a text message.
  bool get isText => type == MessageType.text;

  /// Returns true if this is a media message.
  bool get isMedia =>
      type == MessageType.image ||
      type == MessageType.video ||
      type == MessageType.audio;

  /// Returns true if this is a system message.
  bool get isSystem => type == MessageType.system;

  /// Returns true if this is a reply.
  bool get isReply => type == MessageType.reply || replyToId != null;

  /// Returns true if this is a forwarded message.
  bool get isForwarded =>
      type == MessageType.forwarded || forwardedFromId != null;

  /// Returns the total reaction count.
  int get totalReactions =>
      reactions.values.fold(0, (sum, list) => sum + list.length);

  /// Returns true if the message has attachments.
  bool get hasAttachments => attachments.isNotEmpty;

  /// Returns true if the message is pending (being sent).
  bool get isPending => status == MessageStatus.sending;

  /// Returns true if the message failed to send.
  bool get hasFailed => status == MessageStatus.failed;

  /// Returns the display text for preview.
  String get previewText {
    if (isDeleted) return 'Message deleted';

    if (content != null && content!.isNotEmpty) {
      return content!.length > 50
          ? '${content!.substring(0, 50)}...'
          : content!;
    }

    if (attachments.isNotEmpty) {
      final attachment = attachments.first;
      switch (attachment.type) {
        case 'image':
          return '📷 Photo';
        case 'video':
          return '🎥 Video';
        case 'audio':
          return '🎵 Audio';
        case 'file':
          return '📎 ${attachment.fileName ?? "File"}';
        default:
          return '📎 Attachment';
      }
    }

    if (location != null) {
      return '📍 Location';
    }

    return '';
  }

  /// Creates a copy with modified values.
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    MessageType? type,
    String? content,
    List<MessageAttachment>? attachments,
    MessageLocation? location,
    MessageStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    List<String>? readBy,
    Map<String, List<String>>? reactions,
    String? replyToId,
    Message? replyTo,
    String? forwardedFromId,
    bool? isEdited,
    bool? isDeleted,
    bool? isPinned,
    List<String>? mentions,
    Map<String, dynamic>? metadata,
    String? localId,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      type: type ?? this.type,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      readBy: readBy ?? this.readBy,
      reactions: reactions ?? this.reactions,
      replyToId: replyToId ?? this.replyToId,
      replyTo: replyTo ?? this.replyTo,
      forwardedFromId: forwardedFromId ?? this.forwardedFromId,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isPinned: isPinned ?? this.isPinned,
      mentions: mentions ?? this.mentions,
      metadata: metadata ?? this.metadata,
      localId: localId ?? this.localId,
    );
  }

  /// Converts to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'type': type.name,
      'content': content,
      'attachments': attachments.map((a) => a.toMap()).toList(),
      'location': location?.toMap(),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'read_by': readBy,
      'reactions': reactions,
      'reply_to_id': replyToId,
      'forwarded_from_id': forwardedFromId,
      'is_edited': isEdited,
      'is_deleted': isDeleted,
      'is_pinned': isPinned,
      'mentions': mentions,
      'metadata': metadata,
      'local_id': localId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Message(id: $id, type: $type, status: $status)';
}
