// lib/features/chat/data/endpoints/chat_endpoints.dart
/// Defines all API endpoints for chat operations.
abstract class ChatEndpoints {
  const ChatEndpoints._();

  /// Gets all conversations.
  static const String conversations = '/conversations';

  /// Gets a specific conversation by ID.
  static String conversationById(String conversationId) =>
      '/conversations/$conversationId';

  /// Creates a direct conversation.
  static const String directConversation = '/conversations/direct';

  /// Creates a direct conversation (alias for backward compatibility).
  static const String createDirectConversation = directConversation;

  /// Creates a group conversation.
  static const String groupConversation = '/conversations/group';

  /// Creates a group conversation (alias for backward compatibility).
  static const String createGroupConversation = groupConversation;

  /// Updates a conversation.
  static String updateConversation(String conversationId) =>
      '/conversations/$conversationId';

  /// Adds participants to a conversation.
  static String addParticipants(String conversationId) =>
      '/conversations/$conversationId/participants';

  /// Removes a participant from a conversation.
  static String removeParticipant(String conversationId, String userId) =>
      '/conversations/$conversationId/participants/$userId';

  /// Leaves a conversation.
  static String leaveConversation(String conversationId) =>
      '/conversations/$conversationId/leave';

  /// Mutes or unmutes a conversation.
  static String muteConversation(String conversationId) =>
      '/conversations/$conversationId/mute';

  /// Pins or unpins a conversation.
  static String pinConversation(String conversationId) =>
      '/conversations/$conversationId/pin';

  /// Deletes a conversation.
  static String deleteConversation(String conversationId) =>
      '/conversations/$conversationId';

  /// Archives a conversation.
  static String archiveConversation(String conversationId) =>
      '/conversations/$conversationId/archive';

  /// Unarchives a conversation.
  static String unarchiveConversation(String conversationId) =>
      '/conversations/$conversationId/unarchive';

  /// Gets messages for a conversation.
  static String messages(String conversationId) =>
      '/conversations/$conversationId/messages';

  /// Gets messages for a conversation (alias for backward compatibility).
  static String getMessages(String conversationId) =>
      '/conversations/$conversationId/messages';

  /// Sends a message.
  static String sendMessage(String conversationId) =>
      '/conversations/$conversationId/messages';

  /// Sends a media message.
  static String sendMediaMessage(String conversationId) =>
      '/conversations/$conversationId/messages/media';

  /// Gets a specific message.
  static String messageById(String conversationId, String messageId) =>
      '/conversations/$conversationId/messages/$messageId';

  /// Gets a specific message by ID (global endpoint).
  static String getMessage(String messageId) => '/messages/$messageId';

  /// Updates a message.
  static String updateMessage(String conversationId, String messageId) =>
      '/conversations/$conversationId/messages/$messageId';

  /// Updates a message by ID (alias for backward compatibility).
  static String editMessage(String messageId) => '/messages/$messageId';

  /// Deletes a message.
  static String deleteMessage(String messageId) => '/messages/$messageId';

  /// Marks messages as read.
  static String markAsRead(String conversationId) =>
      '/conversations/$conversationId/messages/read';

  /// Marks messages as read (alias for backward compatibility).
  static String markConversationAsRead(String conversationId) =>
      '/conversations/$conversationId/messages/read';

  /// Marks messages as delivered.
  static String markAsDelivered(String conversationId) =>
      '/conversations/$conversationId/messages/delivered';

  /// Gets typing status.
  static String typingStatus(String conversationId) =>
      '/conversations/$conversationId/typing';

  /// Sets typing status.
  static String setTypingStatus(String conversationId) =>
      '/conversations/$conversationId/typing';

  /// Gets online status.
  static String onlineStatus(String userId) => '/users/$userId/online-status';

  /// Uploads file attachment.
  static const String uploadFile = '/chat/upload';

  /// Uploads file attachment (alias for backward compatibility).
  static const String uploadAttachment = uploadFile;

  /// Forwards a message.
  static String forwardMessage(String messageId) =>
      '/messages/$messageId/forward';

  /// Adds a reaction to a message.
  static String addReaction(String messageId) =>
      '/messages/$messageId/reactions';

  /// Removes a reaction from a message.
  static String removeReaction(String messageId, String reaction) =>
      '/messages/$messageId/reactions/$reaction';

  /// Pins or unpins a message.
  static String pinMessage(String messageId) => '/messages/$messageId/pin';

  /// Gets pinned messages for a conversation.
  static String getPinnedMessages(String conversationId) =>
      '/conversations/$conversationId/messages/pinned';

  /// Searches messages within a conversation.
  static String searchMessages(String conversationId) =>
      '/conversations/$conversationId/messages/search';

  /// Searches messages across all conversations.
  static const String searchAllMessages = '/messages/search';

  /// Gets unread message count.
  static const String unreadCount = '/chat/unread-count';
}
