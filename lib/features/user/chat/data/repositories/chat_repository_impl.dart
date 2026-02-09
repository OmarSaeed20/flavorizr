// lib/features/chat/data/repositories/chat_repository_impl.dart
import 'dart:async';

import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/core/network/websocket/websocket.dart';
import 'package:fast_golden_taxi/features/user/chat/data/datasources/chat_local_datasource.dart';
import 'package:fast_golden_taxi/features/user/chat/data/datasources/chat_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/conversation.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/message.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/typing_indicator.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/repositories/chat_repository.dart';
import 'package:path_provider/path_provider.dart';

/// Implementation of [ChatRepository].
///
/// Combines remote and local data sources with real-time WebSocket events.
class ChatRepositoryImpl extends BaseRepository implements ChatRepository {
  ChatRepositoryImpl({
    required ChatRemoteDataSource remoteDataSource,
    required ChatLocalDataSource localDataSource,
    required WebSocketManager webSocketManager,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _webSocketManager = webSocketManager,
       _networkInfo = networkInfo {
    _setupWebSocketListeners();
  }
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  final ChatRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;
  final WebSocketManager _webSocketManager;

  // Stream controllers for real-time events
  final _newMessagesController = StreamController<Message>.broadcast();
  final _messageUpdatesController = StreamController<Message>.broadcast();
  final _typingIndicatorsController = StreamController<TypingIndicator>.broadcast();
  final _presenceUpdatesController = StreamController<PresenceStatus>.broadcast();
  final _conversationUpdatesController = StreamController<Conversation>.broadcast();

  // Typing indicator management
  Timer? _typingTimer;
  String? _currentTypingConversation;

  void _setupWebSocketListeners() {
    final handler = _webSocketManager.eventHandler;

    // New message received
    handler.on('message.new', (data) {
      final message = Message.fromMap(data);
      _newMessagesController.add(message);
      _localDataSource.addMessageToCache(message);
      _updateConversationLastMessage(message);
    });

    // Message updated (edited, deleted, reactions)
    handler.on('message.updated', (data) {
      final message = Message.fromMap(data);
      _messageUpdatesController.add(message);
      _localDataSource.updateCachedMessage(message);
    });

    // Message deleted
    handler.on('message.deleted', (data) {
      final message = Message.fromMap(data);
      _messageUpdatesController.add(message.copyWith(isDeleted: true));
    });

    // Typing indicator
    handler.on('typing.start', (data) {
      final indicator = TypingIndicator.fromMap(data);
      _typingIndicatorsController.add(indicator);
    });

    handler.on('typing.stop', (data) {
      final indicator = TypingIndicator.fromMap(data);
      _typingIndicatorsController.add(indicator.stop());
    });

    // Presence updates
    handler.on('presence.update', (data) {
      final presence = PresenceStatus.fromMap(data);
      _presenceUpdatesController.add(presence);
    });

    // Conversation updates
    handler.on('conversation.updated', (data) {
      final conversation = Conversation.fromMap(data);
      _conversationUpdatesController.add(conversation);
      _localDataSource.updateCachedConversation(conversation);
    });
  }

  Future<void> _updateConversationLastMessage(Message message) async {
    // Update the conversation's last message in cache
    final conversations = await _localDataSource.getCachedConversations();
    final conversationData = conversations.data;
    if (conversationData != null) {
      final index = conversationData.indexWhere((c) => c.id == message.conversationId);
      if (index >= 0) {
        final updated = conversationData[index].copyWith(
          lastMessage: message,
          updatedAt: message.createdAt,
        );
        _localDataSource.updateCachedConversation(updated);
        _conversationUpdatesController.add(updated);
      }
    }
  }

  // ==================== Conversations ====================

  @override
  Future<ApiResult<PaginatedResult<Conversation>>> getConversations({
    String? cursor,
    int limit = 20,
    bool includeArchived = false,
  }) async {
    try {
      // Try to get cached data first (only for first page)
      if (cursor == null) {
        final cached = await _localDataSource.getCachedConversations();
        if (cached.data != null && (cached.data?.isNotEmpty ?? false)) {
          // Return cached data and fetch fresh data in background
          _fetchAndCacheConversations(limit: limit, includeArchived: includeArchived);
          return ApiResult.success(
            PaginatedResult(
              items: cached.data!.take(limit).toList(),
              hasMore: cached.data!.length > limit,
            ),
          );
        }
      }

      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.getConversations(
          cursor: cursor,
          limit: limit,
          includeArchived: includeArchived,
        ),
      );

      // Cache if first page
      if (cursor == null && result.isSuccess) {
        _localDataSource.cacheConversations(result.data!.items);
      }

      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get conversations',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to load conversations', exception: e),
      );
    }
  }

  Future<void> _fetchAndCacheConversations({
    required int limit,
    required bool includeArchived,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () =>
            _remoteDataSource.getConversations(limit: limit, includeArchived: includeArchived),
      );
      if (result.isSuccess) {
        _localDataSource.cacheConversations(result.data!.items);
      }
    } catch (e) {
      AppLogger.instance.logWarning('Failed to refresh conversations cache');
    }
  }

  @override
  Future<ApiResult<Conversation>> getConversation(String id) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.getConversation(id),
      );
      if (result.isSuccess) {
        _localDataSource.updateCachedConversation(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get conversation',
        data: {'id': id, 'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to load conversation', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<Conversation>> createDirectConversation({required String otherUserId}) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.createDirectConversation(otherUserId: otherUserId),
      );
      if (result.isSuccess) {
        _localDataSource.updateCachedConversation(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to create direct conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to create conversation', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<Conversation>> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.createGroupConversation(
          name: name,
          participantIds: participantIds,
          description: description,
          imageUrl: imageUrl,
        ),
      );
      if (result.isSuccess) {
        _localDataSource.updateCachedConversation(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to create group conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to create group', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<Conversation>> updateConversation({
    required String conversationId,
    String? name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.updateConversation(
          conversationId: conversationId,
          name: name,
          description: description,
          imageUrl: imageUrl,
        ),
      );
      if (result.isSuccess) {
        _localDataSource.updateCachedConversation(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to update conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to update conversation', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<Conversation>> addParticipants({
    required String conversationId,
    required List<String> userIds,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () =>
            _remoteDataSource.addParticipants(conversationId: conversationId, userIds: userIds),
      );
      if (result.isSuccess) {
        _localDataSource.updateCachedConversation(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to add participants',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to add participants', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<void>> removeParticipant({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await executeRemoteRequest(
        request: () =>
            _remoteDataSource.removeParticipant(conversationId: conversationId, userId: userId),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to remove participant',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to remove participant', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<void>> leaveConversation(String conversationId) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.leaveConversation(conversationId),
      );
      _localDataSource.removeCachedConversation(conversationId);
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to leave conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to leave conversation', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteConversation(String conversationId) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.deleteConversation(conversationId),
      );
      _localDataSource.removeCachedConversation(conversationId);
      _localDataSource.clearMessagesCache(conversationId);
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to delete conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to delete conversation', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<void>> muteConversation({
    required String conversationId,
    required bool mute,
    Duration? duration,
  }) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.muteConversation(
          conversationId: conversationId,
          mute: mute,
          duration: duration,
        ),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to mute conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to update mute settings', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<void>> pinConversation({
    required String conversationId,
    required bool pin,
  }) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.pinConversation(conversationId: conversationId, pin: pin),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to pin conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to update pin settings', exception: e),
      );
    }
  }

  @override
  Future<ApiResult<void>> archiveConversation({
    required String conversationId,
    required bool archive,
  }) async {
    try {
      await executeRemoteRequest(
        request: () =>
            _remoteDataSource.archiveConversation(conversationId: conversationId, archive: archive),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to archive conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(
        UnknownNetworkException(message: 'Failed to update archive settings', exception: e),
      );
    }
  }

  // ==================== Messages ====================

  @override
  Future<ApiResult<PaginatedResult<Message>>> getMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
    String direction = 'before',
  }) async {
    try {
      // Try cache first (only for first page)
      if (cursor == null) {
        final cached = await _localDataSource.getCachedMessages(conversationId);
        if (cached.data != null && (cached.data?.isNotEmpty ?? false)) {
          _fetchAndCacheMessages(conversationId, limit: limit);
          return ApiResult.success(
            PaginatedResult(
              items: cached.data!.take(limit).toList(),
              hasMore: cached.data!.length > limit,
            ),
          );
        }
      }

      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.getMessages(
          conversationId: conversationId,
          cursor: cursor,
          limit: limit,
          direction: direction,
        ),
      );

      // Cache if first page
      if (cursor == null && result.isSuccess) {
        _localDataSource.cacheMessages(conversationId, result.data!.items);
      }

      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  Future<void> _fetchAndCacheMessages(String conversationId, {required int limit}) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.getMessages(conversationId: conversationId, limit: limit),
      );
      if (result.isSuccess) {
        _localDataSource.cacheMessages(conversationId, result.data!.items);
      }
    } catch (e) {
      AppLogger.instance.logWarning('Failed to refresh messages cache');
    }
  }

  @override
  Future<ApiResult<Message>> getMessage(String messageId) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.getMessage(messageId),
      );
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<Message>> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
    List<String>? mentions,
    String? localId,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.sendMessage(
          conversationId: conversationId,
          content: content,
          replyToId: replyToId,
          mentions: mentions,
          localId: localId,
        ),
      );
      if (result.isSuccess) {
        _localDataSource.addMessageToCache(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to send message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<Message>> sendMediaMessage({
    required String conversationId,
    required String filePath,
    required String type,
    String? caption,
    String? replyToId,
    String? localId,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.sendMediaMessage(
          conversationId: conversationId,
          filePath: filePath,
          type: type,
          caption: caption,
          replyToId: replyToId,
          localId: localId,
          onProgress: onProgress,
        ),
      );
      if (result.isSuccess) {
        _localDataSource.addMessageToCache(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to send media message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<Message>> forwardMessage({
    required String messageId,
    required String toConversationId,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.forwardMessage(
          messageId: messageId,
          toConversationId: toConversationId,
        ),
      );
      if (result.isSuccess) {
        _localDataSource.addMessageToCache(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to forward message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<Message>> editMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.editMessage(messageId: messageId, content: content),
      );
      if (result.isSuccess) {
        _localDataSource.updateCachedMessage(result.data!);
      }
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to edit message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<void>> deleteMessage({
    required String messageId,
    bool forEveryone = false,
  }) async {
    try {
      await executeRemoteRequest(
        request: () =>
            _remoteDataSource.deleteMessage(messageId: messageId, forEveryone: forEveryone),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to delete message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<void>> markAsRead({
    required String conversationId,
    String? upToMessageId,
  }) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.markAsRead(
          conversationId: conversationId,
          upToMessageId: upToMessageId,
        ),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to mark as read',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<void>> addReaction({required String messageId, required String reaction}) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.addReaction(messageId: messageId, reaction: reaction),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to add reaction',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<void>> removeReaction({
    required String messageId,
    required String reaction,
  }) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.removeReaction(messageId: messageId, reaction: reaction),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to remove reaction',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<void>> pinMessage({required String messageId, required bool pin}) async {
    try {
      await executeRemoteRequest(
        request: () => _remoteDataSource.pinMessage(messageId: messageId, pin: pin),
      );
      return const ApiResult.success(null);
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to pin message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<List<Message>>> getPinnedMessages(String conversationId) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.getPinnedMessages(conversationId),
      );
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get pinned messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  // ==================== Real-time ====================

  @override
  void sendTypingIndicator(String conversationId) {
    // Cancel existing timer
    _typingTimer?.cancel();

    // Send typing event
    _webSocketManager.send('typing.start', {'conversation_id': conversationId});

    _currentTypingConversation = conversationId;

    // Auto-stop after 5 seconds
    _typingTimer = Timer(const Duration(seconds: 5), () {
      stopTypingIndicator(conversationId);
    });
  }

  @override
  void stopTypingIndicator(String conversationId) {
    _typingTimer?.cancel();
    _typingTimer = null;

    if (_currentTypingConversation == conversationId) {
      _webSocketManager.send('typing.stop', {'conversation_id': conversationId});
      _currentTypingConversation = null;
    }
  }

  @override
  void updatePresence(PresenceState state, {String? statusMessage}) {
    _webSocketManager.send('presence.update', {
      'state': state.name,
      if (statusMessage != null) 'status_message': statusMessage,
    });
  }

  @override
  Stream<Message> get newMessages => _newMessagesController.stream;

  @override
  Stream<Message> get messageUpdates => _messageUpdatesController.stream;

  @override
  Stream<TypingIndicator> get typingIndicators => _typingIndicatorsController.stream;

  @override
  Stream<PresenceStatus> get presenceUpdates => _presenceUpdatesController.stream;

  @override
  Stream<Conversation> get conversationUpdates => _conversationUpdatesController.stream;

  // ==================== Search ====================

  @override
  Future<ApiResult<PaginatedResult<Message>>> searchMessages({
    required String conversationId,
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.searchMessages(
          conversationId: conversationId,
          query: query,
          cursor: cursor,
          limit: limit,
        ),
      );
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to search messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<PaginatedResult<Message>>> searchAllMessages({
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () =>
            _remoteDataSource.searchAllMessages(query: query, cursor: cursor, limit: limit),
      );
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to search all messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  // ==================== Media ====================

  @override
  Future<ApiResult<String>> uploadAttachment({
    required String filePath,
    required String conversationId,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.uploadAttachment(
          filePath: filePath,
          conversationId: conversationId,
          onProgress: onProgress,
        ),
      );
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to upload attachment',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  @override
  Future<ApiResult<String>> downloadAttachment({
    required String url,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/downloads/$fileName';

      final result = await executeRemoteRequest(
        request: () => _remoteDataSource.downloadAttachment(
          url: url,
          savePath: savePath,
          onProgress: onProgress,
        ),
      );
      return result;
    } on NetworkException catch (e) {
      return ApiResult.exception(e);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to download attachment',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return ApiResult.exception(NetworkExceptionFactory.mapExceptionToFailure(e, s));
    }
  }

  // ==================== Cleanup ====================

  @override
  void dispose() {
    _typingTimer?.cancel();
    _newMessagesController.close();
    _messageUpdatesController.close();
    _typingIndicatorsController.close();
    _presenceUpdatesController.close();
    _conversationUpdatesController.close();
  }
}
