// lib/features/chat/data/repositories/chat_repository_impl.dart
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flavorizr/core/error/failures.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:flavorizr/core/network/exception/network_exceptions.dart';
import 'package:flavorizr/core/network/websocket/websocket.dart';
import 'package:flavorizr/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:flavorizr/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:flavorizr/features/chat/domain/entities/conversation.dart';
import 'package:flavorizr/features/chat/domain/entities/message.dart';
import 'package:flavorizr/features/chat/domain/entities/typing_indicator.dart';
import 'package:flavorizr/features/chat/domain/repositories/chat_repository.dart';
import 'package:path_provider/path_provider.dart';

/// Implementation of [ChatRepository].
///
/// Combines remote and local data sources with real-time WebSocket events.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatRemoteDataSource remoteDataSource,
    required ChatLocalDataSource localDataSource,
    required WebSocketManager webSocketManager,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _webSocketManager = webSocketManager {
    _setupWebSocketListeners();
  }
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

  void _updateConversationLastMessage(Message message) {
    // Update the conversation's last message in cache
    final conversations = _localDataSource.getCachedConversations();
    if (conversations != null) {
      final index = conversations.indexWhere((c) => c.id == message.conversationId);
      if (index >= 0) {
        final updated = conversations[index].copyWith(
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
  Future<Either<Failure, PaginatedResult<Conversation>>> getConversations({
    String? cursor,
    int limit = 20,
    bool includeArchived = false,
  }) async {
    try {
      // Try to get cached data first (only for first page)
      if (cursor == null) {
        final cached = _localDataSource.getCachedConversations();
        if (cached != null && cached.isNotEmpty) {
          // Return cached data and fetch fresh data in background
          _fetchAndCacheConversations(limit: limit, includeArchived: includeArchived);
          return Right(
            PaginatedResult(items: cached.take(limit).toList(), hasMore: cached.length > limit),
          );
        }
      }

      final result = await _remoteDataSource.getConversations(
        cursor: cursor,
        limit: limit,
        includeArchived: includeArchived,
      );

      // Cache if first page
      if (cursor == null) {
        _localDataSource.cacheConversations(result.items);
      }

      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get conversations',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to load conversations'));
    }
  }

  Future<void> _fetchAndCacheConversations({
    required int limit,
    required bool includeArchived,
  }) async {
    try {
      final result = await _remoteDataSource.getConversations(
        limit: limit,
        includeArchived: includeArchived,
      );
      _localDataSource.cacheConversations(result.items);
    } catch (e) {
      AppLogger.instance.logWarning('Failed to refresh conversations cache');
    }
  }

  @override
  Future<Either<Failure, Conversation>> getConversation(String id) async {
    try {
      final result = await _remoteDataSource.getConversation(id);
      _localDataSource.updateCachedConversation(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get conversation',
        data: {'id': id, 'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to load conversation'));
    }
  }

  @override
  Future<Either<Failure, Conversation>> createDirectConversation({
    required String otherUserId,
  }) async {
    try {
      final result = await _remoteDataSource.createDirectConversation(otherUserId: otherUserId);
      _localDataSource.updateCachedConversation(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to create direct conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to create conversation'));
    }
  }

  @override
  Future<Either<Failure, Conversation>> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await _remoteDataSource.createGroupConversation(
        name: name,
        participantIds: participantIds,
        description: description,
        imageUrl: imageUrl,
      );
      _localDataSource.updateCachedConversation(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to create group conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to create group'));
    }
  }

  @override
  Future<Either<Failure, Conversation>> updateConversation({
    required String conversationId,
    String? name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await _remoteDataSource.updateConversation(
        conversationId: conversationId,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
      _localDataSource.updateCachedConversation(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to update conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to update conversation'));
    }
  }

  @override
  Future<Either<Failure, Conversation>> addParticipants({
    required String conversationId,
    required List<String> userIds,
  }) async {
    try {
      final result = await _remoteDataSource.addParticipants(
        conversationId: conversationId,
        userIds: userIds,
      );
      _localDataSource.updateCachedConversation(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to add participants',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to add participants'));
    }
  }

  @override
  Future<Either<Failure, void>> removeParticipant({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _remoteDataSource.removeParticipant(conversationId: conversationId, userId: userId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to remove participant',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to remove participant'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveConversation(String conversationId) async {
    try {
      await _remoteDataSource.leaveConversation(conversationId);
      _localDataSource.removeCachedConversation(conversationId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to leave conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to leave conversation'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String conversationId) async {
    try {
      await _remoteDataSource.deleteConversation(conversationId);
      _localDataSource.removeCachedConversation(conversationId);
      _localDataSource.clearMessagesCache(conversationId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to delete conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to delete conversation'));
    }
  }

  @override
  Future<Either<Failure, void>> muteConversation({
    required String conversationId,
    required bool mute,
    Duration? duration,
  }) async {
    try {
      await _remoteDataSource.muteConversation(
        conversationId: conversationId,
        mute: mute,
        duration: duration,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to mute conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to update mute settings'));
    }
  }

  @override
  Future<Either<Failure, void>> pinConversation({
    required String conversationId,
    required bool pin,
  }) async {
    try {
      await _remoteDataSource.pinConversation(conversationId: conversationId, pin: pin);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to pin conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to update pin settings'));
    }
  }

  @override
  Future<Either<Failure, void>> archiveConversation({
    required String conversationId,
    required bool archive,
  }) async {
    try {
      await _remoteDataSource.archiveConversation(conversationId: conversationId, archive: archive);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to archive conversation',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to update archive settings'));
    }
  }

  // ==================== Messages ====================

  @override
  Future<Either<Failure, PaginatedResult<Message>>> getMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
    String direction = 'before',
  }) async {
    try {
      // Try cache first (only for first page)
      if (cursor == null) {
        final cached = _localDataSource.getCachedMessages(conversationId);
        if (cached != null && cached.isNotEmpty) {
          _fetchAndCacheMessages(conversationId, limit: limit);
          return Right(
            PaginatedResult(items: cached.take(limit).toList(), hasMore: cached.length > limit),
          );
        }
      }

      final result = await _remoteDataSource.getMessages(
        conversationId: conversationId,
        cursor: cursor,
        limit: limit,
        direction: direction,
      );

      // Cache if first page
      if (cursor == null) {
        _localDataSource.cacheMessages(conversationId, result.items);
      }

      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to load messages'));
    }
  }

  Future<void> _fetchAndCacheMessages(String conversationId, {required int limit}) async {
    try {
      final result = await _remoteDataSource.getMessages(
        conversationId: conversationId,
        limit: limit,
      );
      _localDataSource.cacheMessages(conversationId, result.items);
    } catch (e) {
      AppLogger.instance.logWarning('Failed to refresh messages cache');
    }
  }

  @override
  Future<Either<Failure, Message>> getMessage(String messageId) async {
    try {
      final result = await _remoteDataSource.getMessage(messageId);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to load message'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
    List<String>? mentions,
    String? localId,
  }) async {
    try {
      final result = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
        replyToId: replyToId,
        mentions: mentions,
        localId: localId,
      );
      _localDataSource.addMessageToCache(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to send message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to send message'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMediaMessage({
    required String conversationId,
    required String filePath,
    required String type,
    String? caption,
    String? replyToId,
    String? localId,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final result = await _remoteDataSource.sendMediaMessage(
        conversationId: conversationId,
        filePath: filePath,
        type: type,
        caption: caption,
        replyToId: replyToId,
        localId: localId,
        onProgress: onProgress,
      );
      _localDataSource.addMessageToCache(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to send media message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to send message'));
    }
  }

  @override
  Future<Either<Failure, Message>> forwardMessage({
    required String messageId,
    required String toConversationId,
  }) async {
    try {
      final result = await _remoteDataSource.forwardMessage(
        messageId: messageId,
        toConversationId: toConversationId,
      );
      _localDataSource.addMessageToCache(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to forward message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to forward message'));
    }
  }

  @override
  Future<Either<Failure, Message>> editMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final result = await _remoteDataSource.editMessage(messageId: messageId, content: content);
      _localDataSource.updateCachedMessage(result);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to edit message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to edit message'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage({
    required String messageId,
    bool forEveryone = false,
  }) async {
    try {
      await _remoteDataSource.deleteMessage(messageId: messageId, forEveryone: forEveryone);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to delete message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to delete message'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String conversationId,
    String? upToMessageId,
  }) async {
    try {
      await _remoteDataSource.markAsRead(
        conversationId: conversationId,
        upToMessageId: upToMessageId,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to mark as read',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to mark as read'));
    }
  }

  @override
  Future<Either<Failure, void>> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    try {
      await _remoteDataSource.addReaction(messageId: messageId, reaction: reaction);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to add reaction',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to add reaction'));
    }
  }

  @override
  Future<Either<Failure, void>> removeReaction({
    required String messageId,
    required String reaction,
  }) async {
    try {
      await _remoteDataSource.removeReaction(messageId: messageId, reaction: reaction);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to remove reaction',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to remove reaction'));
    }
  }

  @override
  Future<Either<Failure, void>> pinMessage({required String messageId, required bool pin}) async {
    try {
      await _remoteDataSource.pinMessage(messageId: messageId, pin: pin);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to pin message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to pin message'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getPinnedMessages(String conversationId) async {
    try {
      final result = await _remoteDataSource.getPinnedMessages(conversationId);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to get pinned messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to load pinned messages'));
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
  Future<Either<Failure, PaginatedResult<Message>>> searchMessages({
    required String conversationId,
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final result = await _remoteDataSource.searchMessages(
        conversationId: conversationId,
        query: query,
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to search messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Search failed'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Message>>> searchAllMessages({
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final result = await _remoteDataSource.searchAllMessages(
        query: query,
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to search all messages',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Search failed'));
    }
  }

  // ==================== Media ====================

  @override
  Future<Either<Failure, String>> uploadAttachment({
    required String filePath,
    required String conversationId,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final result = await _remoteDataSource.uploadAttachment(
        filePath: filePath,
        conversationId: conversationId,
        onProgress: onProgress,
      );
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to upload attachment',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to upload file'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadAttachment({
    required String url,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/downloads/$fileName';

      final result = await _remoteDataSource.downloadAttachment(
        url: url,
        savePath: savePath,
        onProgress: onProgress,
      );
      return Right(result);
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to download attachment',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      return const Left(ServerFailure(message: 'Failed to download file'));
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
