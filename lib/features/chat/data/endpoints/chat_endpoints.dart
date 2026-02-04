// lib/features/chat/data/endpoints/chat_endpoints.dart
/// Defines all API endpoints for chat operations.
abstract class ChatEndpoints {
  const ChatEndpoints._();

  /// Gets all conversations.
  static const String conversations = '/conversations';

  /// Gets a specific conversation by ID.
  static String conversationById(String conversationId) => '/conversations/$conversationId';

  /// Creates a direct conversation.
  static const String directConversation = '/conversations/direct';

  /// Creates a group conversation.
  static const String groupConversation = '/conversations/group';

  /// Updates a conversation.
  static String updateConversation(String conversationId) => '/conversations/$conversationId';

  /// Deletes a conversation.
  static String deleteConversation(String conversationId) => '/conversations/$conversationId';

  /// Archives a conversation.
  static String archiveConversation(String conversationId) =>
      '/conversations/$conversationId/archive';

  /// Unarchives a conversation.
  static String unarchiveConversation(String conversationId) =>
      '/conversations/$conversationId/unarchive';

  /// Gets messages for a conversation.
  static String messages(String conversationId) => '/conversations/$conversationId/messages';

  /// Sends a message.
  static String sendMessage(String conversationId) => '/conversations/$conversationId/messages';

  /// Gets a specific message.
  static String messageById(String conversationId, String messageId) =>
      '/conversations/$conversationId/messages/$messageId';

  /// Updates a message.
  static String updateMessage(String conversationId, String messageId) =>
      '/conversations/$conversationId/messages/$messageId';

  /// Deletes a message.
  static String deleteMessage(String conversationId, String messageId) =>
      '/conversations/$conversationId/messages/$messageId';

  /// Marks messages as read.
  static String markAsRead(String conversationId) => '/conversations/$conversationId/messages/read';

  /// Marks messages as delivered.
  static String markAsDelivered(String conversationId) =>
      '/conversations/$conversationId/messages/delivered';

  /// Gets typing status.
  static String typingStatus(String conversationId) => '/conversations/$conversationId/typing';

  /// Sets typing status.
  static String setTypingStatus(String conversationId) => '/conversations/$conversationId/typing';

  /// Gets online status.
  static String onlineStatus(String userId) => '/users/$userId/online-status';

  /// Uploads file attachment.
  static const String uploadFile = '/chat/upload';

  /// Gets unread message count.
  static const String unreadCount = '/chat/unread-count';
}
