/// Chat API Endpoints
/// Defines all chat-related API endpoint paths
class ChatEndpoints {
  // Base path for chat endpoints
  static const String _basePath = '/user/chat';

  /// Get chat messages by order
  /// GET /user/chat/get-by-order
  static const String getChatByOrder = '$_basePath/get-by-order';

  /// Save a message
  /// POST /user/chat/store
  static const String saveMessage = '$_basePath/store';
}
