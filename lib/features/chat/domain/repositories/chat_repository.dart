// lib/features/chat/domain/repositories/chat_repository.dart
import 'package:dartz/dartz.dart';

import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/features/chat/domain/entities/conversation.dart';
import 'package:flavorizr/features/chat/domain/entities/message.dart';
import 'package:flavorizr/features/chat/domain/entities/typing_indicator.dart';

/// Result type for paginated data.
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
    this.totalCount,
  });

  /// The list of items.
  final List<T> items;

  /// Cursor for the next page (null if no more pages).
  final String? nextCursor;

  /// Whether there are more items to load.
  final bool hasMore;

  /// Total count if available.
  final int? totalCount;

  /// Returns true if there are no items.
  bool get isEmpty => items.isEmpty;

  /// Returns true if there are items.
  bool get isNotEmpty => items.isNotEmpty;
}

/// Repository interface for chat operations.
///
/// Handles both REST API calls for persistent data
/// and WebSocket events for real-time updates.
abstract class ChatRepository {
  // ==================== Conversations ====================

  /// Gets all conversations for the current user.
  ///
  /// Supports pagination with cursor-based approach.
  /// [cursor] - The cursor from the previous page.
  /// [limit] - Maximum number of conversations to return.
  /// [includeArchived] - Whether to include archived conversations.
  Future<Either<Failure, PaginatedResult<Conversation>>> getConversations({
    String? cursor,
    int limit = 20,
    bool includeArchived = false,
  });

  /// Gets a single conversation by ID.
  Future<Either<Failure, Conversation>> getConversation(String id);

  /// Creates a new direct conversation with another user.
  ///
  /// Returns existing conversation if one already exists.
  Future<Either<Failure, Conversation>> createDirectConversation({required String otherUserId});

  /// Creates a new group conversation.
  Future<Either<Failure, Conversation>> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  });

  /// Updates a conversation's details.
  Future<Either<Failure, Conversation>> updateConversation({
    required String conversationId,
    String? name,
    String? description,
    String? imageUrl,
  });

  /// Adds participants to a group conversation.
  Future<Either<Failure, Conversation>> addParticipants({
    required String conversationId,
    required List<String> userIds,
  });

  /// Removes a participant from a group conversation.
  Future<Either<Failure, void>> removeParticipant({
    required String conversationId,
    required String userId,
  });

  /// Leaves a group conversation.
  Future<Either<Failure, void>> leaveConversation(String conversationId);

  /// Deletes a conversation (local only or for everyone if admin).
  Future<Either<Failure, void>> deleteConversation(String conversationId);

  /// Mutes/unmutes a conversation.
  Future<Either<Failure, void>> muteConversation({
    required String conversationId,
    required bool mute,
    Duration? duration,
  });

  /// Pins/unpins a conversation.
  Future<Either<Failure, void>> pinConversation({
    required String conversationId,
    required bool pin,
  });

  /// Archives/unarchives a conversation.
  Future<Either<Failure, void>> archiveConversation({
    required String conversationId,
    required bool archive,
  });

  // ==================== Messages ====================

  /// Gets messages for a conversation.
  ///
  /// Supports pagination with cursor-based approach.
  /// [cursor] - The cursor from the previous page (usually a message ID).
  /// [limit] - Maximum number of messages to return.
  /// [direction] - 'before' or 'after' the cursor.
  Future<Either<Failure, PaginatedResult<Message>>> getMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
    String direction = 'before',
  });

  /// Gets a single message by ID.
  Future<Either<Failure, Message>> getMessage(String messageId);

  /// Sends a text message.
  ///
  /// [localId] - Optional local ID for optimistic updates.
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
    List<String>? mentions,
    String? localId,
  });

  /// Sends a media message.
  ///
  /// [filePath] - Path to the local file.
  /// [type] - Type of media (image, video, audio, file).
  Future<Either<Failure, Message>> sendMediaMessage({
    required String conversationId,
    required String filePath,
    required String type,
    String? caption,
    String? replyToId,
    String? localId,
    void Function(double progress)? onProgress,
  });

  /// Forwards a message to another conversation.
  Future<Either<Failure, Message>> forwardMessage({
    required String messageId,
    required String toConversationId,
  });

  /// Edits a message.
  Future<Either<Failure, Message>> editMessage({
    required String messageId,
    required String content,
  });

  /// Deletes a message.
  ///
  /// [forEveryone] - If true, deletes for all users.
  Future<Either<Failure, void>> deleteMessage({
    required String messageId,
    bool forEveryone = false,
  });

  /// Marks messages as read.
  ///
  /// [upToMessageId] - Mark all messages up to this ID as read.
  Future<Either<Failure, void>> markAsRead({required String conversationId, String? upToMessageId});

  /// Adds a reaction to a message.
  Future<Either<Failure, void>> addReaction({required String messageId, required String reaction});

  /// Removes a reaction from a message.
  Future<Either<Failure, void>> removeReaction({
    required String messageId,
    required String reaction,
  });

  /// Pins a message in the conversation.
  Future<Either<Failure, void>> pinMessage({required String messageId, required bool pin});

  /// Gets pinned messages in a conversation.
  Future<Either<Failure, List<Message>>> getPinnedMessages(String conversationId);

  // ==================== Real-time ====================

  /// Sends typing indicator.
  void sendTypingIndicator(String conversationId);

  /// Stops typing indicator.
  void stopTypingIndicator(String conversationId);

  /// Updates the user's presence status.
  void updatePresence(PresenceState state, {String? statusMessage});

  /// Stream of new messages.
  Stream<Message> get newMessages;

  /// Stream of message updates (edits, deletions, reactions).
  Stream<Message> get messageUpdates;

  /// Stream of typing indicators.
  Stream<TypingIndicator> get typingIndicators;

  /// Stream of presence updates.
  Stream<PresenceStatus> get presenceUpdates;

  /// Stream of conversation updates.
  Stream<Conversation> get conversationUpdates;

  // ==================== Search ====================

  /// Searches messages in a conversation.
  Future<Either<Failure, PaginatedResult<Message>>> searchMessages({
    required String conversationId,
    required String query,
    String? cursor,
    int limit = 20,
  });

  /// Searches across all conversations.
  Future<Either<Failure, PaginatedResult<Message>>> searchAllMessages({
    required String query,
    String? cursor,
    int limit = 20,
  });

  // ==================== Media ====================

  /// Uploads a file attachment.
  ///
  /// Returns the URL of the uploaded file.
  Future<Either<Failure, String>> uploadAttachment({
    required String filePath,
    required String conversationId,
    void Function(double progress)? onProgress,
  });

  /// Downloads an attachment to local storage.
  ///
  /// Returns the local file path.
  Future<Either<Failure, String>> downloadAttachment({
    required String url,
    required String fileName,
    void Function(double progress)? onProgress,
  });

  // ==================== Cleanup ====================

  /// Disposes resources.
  void dispose();
}
