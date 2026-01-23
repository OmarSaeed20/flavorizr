// lib/features/chat/data/datasources/chat_remote_datasource.dart
import 'dart:async';

import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/features/chat/domain/entities/conversation.dart';
import 'package:flavorizr/features/chat/domain/entities/message.dart';
import 'package:flavorizr/features/chat/domain/repositories/chat_repository.dart';

/// Remote data source for chat operations.
///
/// Handles all REST API calls for chat functionality.
class ChatRemoteDataSource {
  ChatRemoteDataSource(this._apiClient);
  final ApiClient _apiClient;

  // ==================== Conversations ====================

  Future<PaginatedResult<Conversation>> getConversations({
    String? cursor,
    int limit = 20,
    bool includeArchived = false,
  }) async {
    final response = await _apiClient.get(
      '/conversations',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        'include_archived': includeArchived,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>)
        .map((e) => Conversation.fromMap(e as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      nextCursor: data['next_cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
      totalCount: data['total_count'] as int?,
    );
  }

  Future<Conversation> getConversation(String id) async {
    final response = await _apiClient.get('/conversations/$id');
    return Conversation.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Conversation> createDirectConversation({required String otherUserId}) async {
    final response = await _apiClient.post(
      '/conversations/direct',
      data: {'other_user_id': otherUserId},
    );
    return Conversation.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Conversation> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  }) async {
    final response = await _apiClient.post(
      '/conversations/group',
      data: {
        'name': name,
        'participant_ids': participantIds,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
      },
    );
    return Conversation.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Conversation> updateConversation({
    required String conversationId,
    String? name,
    String? description,
    String? imageUrl,
  }) async {
    final response = await _apiClient.patch(
      '/conversations/$conversationId',
      data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
      },
    );
    return Conversation.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Conversation> addParticipants({
    required String conversationId,
    required List<String> userIds,
  }) async {
    final response = await _apiClient.post(
      '/conversations/$conversationId/participants',
      data: {'user_ids': userIds},
    );
    return Conversation.fromMap(response.data as Map<String, dynamic>);
  }

  Future<void> removeParticipant({required String conversationId, required String userId}) async {
    await _apiClient.delete('/conversations/$conversationId/participants/$userId');
  }

  Future<void> leaveConversation(String conversationId) async {
    await _apiClient.post('/conversations/$conversationId/leave');
  }

  Future<void> deleteConversation(String conversationId) async {
    await _apiClient.delete('/conversations/$conversationId');
  }

  Future<void> muteConversation({
    required String conversationId,
    required bool mute,
    Duration? duration,
  }) async {
    await _apiClient.post(
      '/conversations/$conversationId/mute',
      data: {'mute': mute, if (duration != null) 'duration_seconds': duration.inSeconds},
    );
  }

  Future<void> pinConversation({required String conversationId, required bool pin}) async {
    await _apiClient.post('/conversations/$conversationId/pin', data: {'pin': pin});
  }

  Future<void> archiveConversation({required String conversationId, required bool archive}) async {
    await _apiClient.post('/conversations/$conversationId/archive', data: {'archive': archive});
  }

  // ==================== Messages ====================

  Future<PaginatedResult<Message>> getMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
    String direction = 'before',
  }) async {
    final response = await _apiClient.get(
      '/conversations/$conversationId/messages',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        'direction': direction,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>)
        .map((e) => Message.fromMap(e as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      nextCursor: data['next_cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  Future<Message> getMessage(String messageId) async {
    final response = await _apiClient.get('/messages/$messageId');
    return Message.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Message> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
    List<String>? mentions,
    String? localId,
  }) async {
    final response = await _apiClient.post(
      '/conversations/$conversationId/messages',
      data: {
        'content': content,
        if (replyToId != null) 'reply_to_id': replyToId,
        if (mentions != null) 'mentions': mentions,
        if (localId != null) 'local_id': localId,
      },
    );
    return Message.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Message> sendMediaMessage({
    required String conversationId,
    required String filePath,
    required String type,
    String? caption,
    String? replyToId,
    String? localId,
    void Function(double progress)? onProgress,
  }) async {
    final response = await _apiClient.uploadFile(
      '/conversations/$conversationId/messages/media',
      filePath: filePath,
      fieldName: 'file',
      additionalData: {
        'type': type,
        if (caption != null) 'caption': caption,
        if (replyToId != null) 'reply_to_id': replyToId,
        if (localId != null) 'local_id': localId,
      },
      onSendProgress: onProgress != null ? (int sent, int total) => onProgress(sent / total) : null,
    );
    return Message.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Message> forwardMessage({
    required String messageId,
    required String toConversationId,
  }) async {
    final response = await _apiClient.post(
      '/messages/$messageId/forward',
      data: {'to_conversation_id': toConversationId},
    );
    return Message.fromMap(response.data as Map<String, dynamic>);
  }

  Future<Message> editMessage({required String messageId, required String content}) async {
    final response = await _apiClient.patch('/messages/$messageId', data: {'content': content});
    return Message.fromMap(response.data as Map<String, dynamic>);
  }

  Future<void> deleteMessage({required String messageId, bool forEveryone = false}) async {
    await _apiClient.delete('/messages/$messageId', queryParameters: {'for_everyone': forEveryone});
  }

  Future<void> markAsRead({required String conversationId, String? upToMessageId}) async {
    await _apiClient.post(
      '/conversations/$conversationId/read',
      data: {if (upToMessageId != null) 'up_to_message_id': upToMessageId},
    );
  }

  Future<void> addReaction({required String messageId, required String reaction}) async {
    await _apiClient.post('/messages/$messageId/reactions', data: {'reaction': reaction});
  }

  Future<void> removeReaction({required String messageId, required String reaction}) async {
    await _apiClient.delete('/messages/$messageId/reactions/$reaction');
  }

  Future<void> pinMessage({required String messageId, required bool pin}) async {
    await _apiClient.post('/messages/$messageId/pin', data: {'pin': pin});
  }

  Future<List<Message>> getPinnedMessages(String conversationId) async {
    final response = await _apiClient.get('/conversations/$conversationId/messages/pinned');
    return (response.data as List<dynamic>)
        .map((e) => Message.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ==================== Search ====================

  Future<PaginatedResult<Message>> searchMessages({
    required String conversationId,
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/conversations/$conversationId/messages/search',
      queryParameters: {'q': query, if (cursor != null) 'cursor': cursor, 'limit': limit},
    );

    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>)
        .map((e) => Message.fromMap(e as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      nextCursor: data['next_cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  Future<PaginatedResult<Message>> searchAllMessages({
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/messages/search',
      queryParameters: {'q': query, if (cursor != null) 'cursor': cursor, 'limit': limit},
    );

    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>)
        .map((e) => Message.fromMap(e as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      nextCursor: data['next_cursor'] as String?,
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  // ==================== Media ====================

  Future<String> uploadAttachment({
    required String filePath,
    required String conversationId,
    void Function(double progress)? onProgress,
  }) async {
    final response = await _apiClient.uploadFile(
      '/attachments/upload',
      filePath: filePath,
      fieldName: 'file',
      additionalData: {'conversation_id': conversationId},
      onSendProgress: onProgress != null ? (int sent, int total) => onProgress(sent / total) : null,
    );

    return response.data['url'] as String;
  }

  Future<String> downloadAttachment({
    required String url,
    required String savePath,
    void Function(double progress)? onProgress,
  }) async {
    // Use Dio directly for download
    await _apiClient.dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress != null
          ? (int received, int total) => onProgress(received / total)
          : null,
    );
    return savePath;
  }
}
