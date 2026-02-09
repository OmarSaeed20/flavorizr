// lib/features/chat/data/datasources/chat_remote_datasource.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flavorizr/core/network/api_client.dart';
import 'package:flavorizr/core/network/base/datasource/base_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
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

  Future<ApiResult<R>> _mapResult<T, R>(ApiResult<T> result, R Function(T data) mapper) async {
    return await result.mapDataAsync(mapper: (data) => ApiResult.success(mapper(data)));
  }

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  // ==================== Conversations ====================

  Future<ApiResult<PaginatedResult<Conversation>>> getConversations({
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

    return _mapResult(result, (data) {
      final items = (data['items'] as List<dynamic>)
          .map((e) => Conversation.fromMap(e as Map<String, dynamic>))
          .toList();

      return PaginatedResult(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? false,
        totalCount: data['total_count'] as int?,
      );
    });
  }

  Future<ApiResult<Conversation>> getConversation(String id) async {
    final result = await get<Map<String, dynamic>>(path: ChatEndpoints.conversationById(id));
    return _mapResult(result, Conversation.fromMap);
  }

  Future<ApiResult<Conversation>> createDirectConversation({required String otherUserId}) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.createDirectConversation,
      data: {'other_user_id': otherUserId},
    );
    return _mapResult(result, Conversation.fromMap);
  }

  Future<ApiResult<Conversation>> createGroupConversation({
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
    return _mapResult(result, Conversation.fromMap);
  }

  Future<ApiResult<Conversation>> updateConversation({
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
    return _mapResult(result, Conversation.fromMap);
  }

  Future<ApiResult<Conversation>> addParticipants({
    required String conversationId,
    required List<String> userIds,
  }) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.addParticipants(conversationId),
      data: {'user_ids': userIds},
    );
    return _mapResult(result, Conversation.fromMap);
  }

  Future<ApiResult<void>> removeParticipant({
    required String conversationId,
    required String userId,
  }) async {
    return delete<void>(path: ChatEndpoints.removeParticipant(conversationId, userId));
  }

  Future<ApiResult<void>> leaveConversation(String conversationId) async {
    return post<void>(path: ChatEndpoints.leaveConversation(conversationId));
  }

  Future<ApiResult<void>> deleteConversation(String conversationId) async {
    return delete<void>(path: ChatEndpoints.deleteConversation(conversationId));
  }

  Future<ApiResult<void>> muteConversation({
    required String conversationId,
    required bool mute,
    Duration? duration,
  }) async {
    return post<void>(
      path: ChatEndpoints.muteConversation(conversationId),
      data: {'mute': mute, if (duration != null) 'duration_seconds': duration.inSeconds},
    );
  }

  Future<ApiResult<void>> pinConversation({
    required String conversationId,
    required bool pin,
  }) async {
    return post<void>(path: ChatEndpoints.pinConversation(conversationId), data: {'pin': pin});
  }

  Future<ApiResult<void>> archiveConversation({
    required String conversationId,
    required bool archive,
  }) async {
    return post<void>(
      path: ChatEndpoints.archiveConversation(conversationId),
      data: {'archive': archive},
    );
  }

  // ==================== Messages ====================

  Future<ApiResult<PaginatedResult<Message>>> getMessages({
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

    return _mapResult(result, (data) {
      final items = (data['items'] as List<dynamic>)
          .map((e) => Message.fromMap(e as Map<String, dynamic>))
          .toList();

      return PaginatedResult(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? false,
      );
    });
  }

  Future<ApiResult<Message>> getMessage(String messageId) async {
    final result = await get<Map<String, dynamic>>(path: ChatEndpoints.getMessage(messageId));
    return _mapResult(result, Message.fromMap);
  }

  Future<ApiResult<Message>> sendMessage({
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
    return _mapResult(result, Message.fromMap);
  }

  Future<ApiResult<Message>> sendMediaMessage({
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
      onSendProgress: onProgress != null ? (int sent, int total) => onProgress(sent / total) : null,
    );
    return _mapResult(result, Message.fromMap);
  }

  Future<ApiResult<Message>> forwardMessage({
    required String messageId,
    required String toConversationId,
  }) async {
    final result = await post<Map<String, dynamic>>(
      path: ChatEndpoints.forwardMessage(messageId),
      data: {'to_conversation_id': toConversationId},
    );
    return _mapResult(result, Message.fromMap);
  }

  Future<ApiResult<Message>> editMessage({
    required String messageId,
    required String content,
  }) async {
    final result = await patch<Map<String, dynamic>>(
      path: ChatEndpoints.editMessage(messageId),
      data: {'content': content},
    );
    return _mapResult(result, Message.fromMap);
  }

  Future<ApiResult<void>> deleteMessage({
    required String messageId,
    bool forEveryone = false,
  }) async {
    return delete<void>(
      path: ChatEndpoints.deleteMessage(messageId),
      queryParameters: {'for_everyone': forEveryone},
    );
  }

  Future<ApiResult<void>> markAsRead({
    required String conversationId,
    String? upToMessageId,
  }) async {
    return post<void>(
      path: ChatEndpoints.markConversationAsRead(conversationId),
      data: {if (upToMessageId != null) 'up_to_message_id': upToMessageId},
    );
  }

  Future<ApiResult<void>> addReaction({required String messageId, required String reaction}) async {
    return post<void>(path: ChatEndpoints.addReaction(messageId), data: {'reaction': reaction});
  }

  Future<ApiResult<void>> removeReaction({
    required String messageId,
    required String reaction,
  }) async {
    return delete<void>(path: ChatEndpoints.removeReaction(messageId, reaction));
  }

  Future<ApiResult<void>> pinMessage({required String messageId, required bool pin}) async {
    return post<void>(path: ChatEndpoints.pinMessage(messageId), data: {'pin': pin});
  }

  Future<ApiResult<List<Message>>> getPinnedMessages(String conversationId) async {
    final result = await get<List<dynamic>>(path: ChatEndpoints.getPinnedMessages(conversationId));
    return _mapResult(
      result,
      (data) => data.map((e) => Message.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  // ==================== Search ====================

  Future<ApiResult<PaginatedResult<Message>>> searchMessages({
    required String conversationId,
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.searchMessages(conversationId),
      queryParameters: {'q': query, if (cursor != null) 'cursor': cursor, 'limit': limit},
    );

    return _mapResult(result, (data) {
      final items = (data['items'] as List<dynamic>)
          .map((e) => Message.fromMap(e as Map<String, dynamic>))
          .toList();

      return PaginatedResult(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? false,
      );
    });
  }

  Future<ApiResult<PaginatedResult<Message>>> searchAllMessages({
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    final result = await get<Map<String, dynamic>>(
      path: ChatEndpoints.searchAllMessages,
      queryParameters: {'q': query, if (cursor != null) 'cursor': cursor, 'limit': limit},
    );

    return _mapResult(result, (data) {
      final items = (data['items'] as List<dynamic>)
          .map((e) => Message.fromMap(e as Map<String, dynamic>))
          .toList();

      return PaginatedResult(
        items: items,
        nextCursor: data['next_cursor'] as String?,
        hasMore: data['has_more'] as bool? ?? false,
      );
    });
  }

  // ==================== Media ====================

  Future<ApiResult<String>> uploadAttachment({
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
      onSendProgress: onProgress != null ? (int sent, int total) => onProgress(sent / total) : null,
    );

    return _mapResult(result, (data) => data['url'] as String);
  }

  Future<ApiResult<String>> downloadAttachment({
    required String url,
    required String savePath,
    void Function(double progress)? onProgress,
  }) async {
    return download(
      urlPath: url,
      savePath: savePath,
      onReceiveProgress: onProgress != null
          ? (int received, int total) => onProgress(received / total)
          : null,
    );
  }
}
