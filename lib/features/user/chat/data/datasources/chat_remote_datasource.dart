// lib/features/chat/data/datasources/chat_remote_datasource.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/features/user/chat/data/endpoints/chat_endpoints.dart';
import 'package:flavorizr/features/user/chat/domain/entities/conversation.dart';
import 'package:flavorizr/features/user/chat/domain/entities/message.dart';
import 'package:flavorizr/features/user/chat/domain/repositories/chat_repository.dart';

/// Remote data source for chat operations.
///
/// Handles all REST API calls for chat functionality.
class ChatRemoteDataSource with BaseRemoteDataSource {
  ChatRemoteDataSource(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  // ==================== Conversations ====================

  Future<PaginatedResult<Conversation>> getConversations({
    String? cursor,
    int limit = 20,
    bool includeArchived = false,
  }) async {
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.conversations,
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        'include_archived': includeArchived,
      },
    );

    if (result.isError) {
      throw result.error!;
    }

    final data = result.data!;
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
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.conversationById(id),
    );
    if (result.isError) {
      throw result.error!;
    }
    return Conversation.fromMap(result.data!);
  }

  Future<Conversation> createDirectConversation({
    required String otherUserId,
  }) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.createDirectConversation,
      data: {'other_user_id': otherUserId},
    );
    if (result.isError) {
      throw result.error!;
    }
    return Conversation.fromMap(result.data!);
  }

  Future<Conversation> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  }) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.createGroupConversation,
      data: {
        'name': name,
        'participant_ids': participantIds,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
      },
    );
    if (result.isError) {
      throw result.error!;
    }
    return Conversation.fromMap(result.data!);
  }

  Future<Conversation> updateConversation({
    required String conversationId,
    String? name,
    String? description,
    String? imageUrl,
  }) async {
    final result = await patch<Map<String, dynamic>>(
      path: ChatEndpoints.updateConversation(conversationId),
      data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
      },
    );
    if (result.isError) {
      throw result.error!;
    }
    return Conversation.fromMap(result.data!);
  }

  Future<Conversation> addParticipants({
    required String conversationId,
    required List<String> userIds,
  }) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.addParticipants(conversationId),
      data: {'user_ids': userIds},
    );
    if (result.isError) {
      throw result.error!;
    }
    return Conversation.fromMap(result.data!);
  }

  Future<void> removeParticipant({
    required String conversationId,
    required String userId,
  }) async {
    final result = await delete<void>(
      path: ChatEndpoints.removeParticipant(conversationId, userId),
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> leaveConversation(String conversationId) async {
    final result = await post<void>(
      path: ChatEndpoints.leaveConversation(conversationId),
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    final result = await delete<void>(
      path: ChatEndpoints.deleteConversation(conversationId),
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> muteConversation({
    required String conversationId,
    required bool mute,
    Duration? duration,
  }) async {
    final result = await post<void>(
      path: ChatEndpoints.muteConversation(conversationId),
      data: {
        'mute': mute,
        if (duration != null) 'duration_seconds': duration.inSeconds,
      },
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> pinConversation({
    required String conversationId,
    required bool pin,
  }) async {
    final result = await post<void>(
      path: ChatEndpoints.pinConversation(conversationId),
      data: {'pin': pin},
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> archiveConversation({
    required String conversationId,
    required bool archive,
  }) async {
    final result = await post<void>(
      path: ChatEndpoints.archiveConversation(conversationId),
      data: {'archive': archive},
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  // ==================== Messages ====================

  Future<PaginatedResult<Message>> getMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
    String direction = 'before',
  }) async {
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.getMessages(conversationId),
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        'direction': direction,
      },
    );

    if (result.isError) {
      throw result.error!;
    }

    final data = result.data!;
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
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.getMessage(messageId),
    );
    if (result.isError) {
      throw result.error!;
    }
    return Message.fromMap(result.data!);
  }

  Future<Message> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
    List<String>? mentions,
    String? localId,
  }) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.sendMessage(conversationId),
      data: {
        'content': content,
        if (replyToId != null) 'reply_to_id': replyToId,
        if (mentions != null) 'mentions': mentions,
        if (localId != null) 'local_id': localId,
      },
    );
    if (result.isError) {
      throw result.error!;
    }
    return Message.fromMap(result.data!);
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
    final formData = createFormData(
      fields: {
        'type': type,
        if (caption != null) 'caption': caption,
        if (replyToId != null) 'reply_to_id': replyToId,
        if (localId != null) 'local_id': localId,
      },
      files: [FileInfo(field: 'file', path: filePath)],
    );

    final result = await upload<Map<String, dynamic>>(
      path: ChatEndpoints.sendMediaMessage(conversationId),
      formData: formData,
      onSendProgress: onProgress != null
          ? (int sent, int total) => onProgress(sent / total)
          : null,
    );
    if (result.isError) {
      throw result.error!;
    }
    return Message.fromMap(result.data!);
  }

  Future<Message> forwardMessage({
    required String messageId,
    required String toConversationId,
  }) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.forwardMessage(messageId),
      data: {'to_conversation_id': toConversationId},
    );
    if (result.isError) {
      throw result.error!;
    }
    return Message.fromMap(result.data!);
  }

  Future<Message> editMessage({
    required String messageId,
    required String content,
  }) async {
    final result = await patch<Map<String, dynamic>>(
      path: ChatEndpoints.editMessage(messageId),
      data: {'content': content},
    );
    if (result.isError) {
      throw result.error!;
    }
    return Message.fromMap(result.data!);
  }

  Future<void> deleteMessage({
    required String messageId,
    bool forEveryone = false,
  }) async {
    final result = await delete<void>(
      path: ChatEndpoints.deleteMessage(messageId),
      queryParameters: {'for_everyone': forEveryone},
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> markAsRead({
    required String conversationId,
    String? upToMessageId,
  }) async {
    final result = await post<void>(
      path: ChatEndpoints.markConversationAsRead(conversationId),
      data: {if (upToMessageId != null) 'up_to_message_id': upToMessageId},
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    final result = await post<void>(
      path: ChatEndpoints.addReaction(messageId),
      data: {'reaction': reaction},
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> removeReaction({
    required String messageId,
    required String reaction,
  }) async {
    final result = await delete<void>(
      path: ChatEndpoints.removeReaction(messageId, reaction),
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<void> pinMessage({
    required String messageId,
    required bool pin,
  }) async {
    final result = await post<void>(
      path: ChatEndpoints.pinMessage(messageId),
      data: {'pin': pin},
    );
    if (result.isError) {
      throw result.error!;
    }
  }

  Future<List<Message>> getPinnedMessages(String conversationId) async {
    final result = await get<List<dynamic>>(
      path: ChatEndpoints.getPinnedMessages(conversationId),
    );
    if (result.isError) {
      throw result.error!;
    }
    return result.data!
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
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.searchMessages(conversationId),
      queryParameters: {
        'q': query,
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
      },
    );

    if (result.isError) {
      throw result.error!;
    }

    final data = result.data!;
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
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.searchAllMessages,
      queryParameters: {
        'q': query,
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
      },
    );

    if (result.isError) {
      throw result.error!;
    }

    final data = result.data!;
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
    final formData = createFormData(
      fields: {'conversation_id': conversationId},
      files: [FileInfo(field: 'file', path: filePath)],
    );

    final result = await upload<Map<String, dynamic>>(
      path: ChatEndpoints.uploadAttachment,
      formData: formData,
      onSendProgress: onProgress != null
          ? (int sent, int total) => onProgress(sent / total)
          : null,
    );

    if (result.isError) {
      throw result.error!;
    }

    return result.data!['url'] as String;
  }

  Future<String> downloadAttachment({
    required String url,
    required String savePath,
    void Function(double progress)? onProgress,
  }) async {
    final result = await download(
      urlPath: url,
      savePath: savePath,
      onReceiveProgress: onProgress != null
          ? (int received, int total) => onProgress(received / total)
          : null,
    );

    if (result.isError) {
      throw result.error!;
    }

    return result.data!;
  }
}
