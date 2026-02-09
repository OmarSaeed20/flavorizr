// lib/features/chat/presentation/providers/chat_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/core/network/websocket/websocket.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:fast_golden_taxi/features/user/chat/data/datasources/chat_local_datasource.dart';
import 'package:fast_golden_taxi/features/user/chat/data/datasources/chat_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/chat/data/repositories/chat_repository_impl.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/entities/entities.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/repositories/chat_repository.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/usecases/create_conversation.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/usecases/get_conversations.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/usecases/get_messages.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/usecases/message_actions.dart';
import 'package:fast_golden_taxi/features/user/chat/domain/usecases/send_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== State Classes ====================

class ConversationsState {
  const ConversationsState({
    this.conversations = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.nextCursor,
  });
  final List<Conversation> conversations;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final String? nextCursor;

  ConversationsState copyWith({
    List<Conversation>? conversations,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    String? nextCursor,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }
}

class MessagesState {
  const MessagesState({
    this.messages = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.nextCursor,
    this.typingUsers = const {},
    this.presenceMap = const {},
  });
  final List<Message> messages;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final String? nextCursor;
  final Set<String> typingUsers;
  final Map<String, PresenceStatus> presenceMap;

  MessagesState copyWith({
    List<Message>? messages,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    String? nextCursor,
    Set<String>? typingUsers,
    Map<String, PresenceStatus>? presenceMap,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      typingUsers: typingUsers ?? this.typingUsers,
      presenceMap: presenceMap ?? this.presenceMap,
    );
  }
}

// ==================== Notifiers ====================

class ConversationsNotifier extends Notifier<ConversationsState> {
  @override
  ConversationsState build() {
    return const ConversationsState();
  }

  Future<void> loadConversations({bool refresh = false}) async {
    if (state.isLoading) return;

    final getConversations = ref.read(getConversationsUseCaseProvider);

    if (refresh) {
      state = state.copyWith(isLoading: true, hasMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await getConversations();

    result.when(
      exception: (error) => state = state.copyWith(isLoading: false, error: error.message),
      success: (paginatedResult, _) => state = state.copyWith(
        isLoading: false,
        conversations: paginatedResult.items,
        hasMore: paginatedResult.hasMore,
        nextCursor: paginatedResult.nextCursor,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.nextCursor == null) {
      return;
    }

    final getConversations = ref.read(getConversationsUseCaseProvider);

    state = state.copyWith(isLoadingMore: true);

    final result = await getConversations(cursor: state.nextCursor);

    result.when(
      exception: (error) => state = state.copyWith(isLoadingMore: false, error: error.message),
      success: (paginatedResult, _) => state = state.copyWith(
        isLoadingMore: false,
        conversations: [...state.conversations, ...paginatedResult.items],
        hasMore: paginatedResult.hasMore,
        nextCursor: paginatedResult.nextCursor,
      ),
    );
  }

  Future<Conversation?> createDirectConversation(String participantId) async {
    final createConversation = ref.read(createDirectConversationUseCaseProvider);

    final result = await createConversation(otherUserId: participantId);

    return result.when(
      exception: (error) {
        state = state.copyWith(error: error.message);
        return null;
      },
      success: (conversation, _) {
        state = state.copyWith(conversations: [conversation, ...state.conversations]);
        return conversation;
      },
    );
  }

  Future<Conversation?> createGroupConversation({
    required String name,
    required List<String> participantIds,
    String? description,
    String? imageUrl,
  }) async {
    final createConversation = ref.read(createGroupConversationUseCaseProvider);

    final result = await createConversation(
      name: name,
      participantIds: participantIds,
      description: description,
      imageUrl: imageUrl,
    );

    return result.when(
      exception: (error) {
        state = state.copyWith(error: error.message);
        return null;
      },
      success: (conversation, _) {
        state = state.copyWith(conversations: [conversation, ...state.conversations]);
        return conversation;
      },
    );
  }

  void updateConversation(Conversation conversation) {
    final index = state.conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      final updated = List<Conversation>.from(state.conversations);
      updated[index] = conversation;
      state = state.copyWith(conversations: updated);
    }
  }

  void addConversation(Conversation conversation) {
    if (!state.conversations.any((c) => c.id == conversation.id)) {
      state = state.copyWith(conversations: [conversation, ...state.conversations]);
    }
  }

  void removeConversation(String conversationId) {
    state = state.copyWith(
      conversations: state.conversations.where((c) => c.id != conversationId).toList(),
    );
  }

  void clearError() {
    state = state.copyWith();
  }
}

/// Messages notifier for a specific conversation.
class MessagesNotifier {
  MessagesNotifier(this.conversationId, this._ref);
  final String conversationId;
  final Ref _ref;
  MessagesState _state = const MessagesState();

  MessagesState get state => _state;

  void _updateState(MessagesState newState) {
    _state = newState;
  }

  Future<void> loadMessages({bool refresh = false}) async {
    if (_state.isLoading) return;

    final getMessages = _ref.read(getMessagesUseCaseProvider);

    if (refresh) {
      _updateState(_state.copyWith(isLoading: true, hasMore: true));
    } else {
      _updateState(_state.copyWith(isLoading: true));
    }

    final result = await getMessages(conversationId: conversationId);

    result.when(
      exception: (error) => _updateState(_state.copyWith(isLoading: false, error: error.message)),
      success: (paginatedResult, _) => _updateState(
        _state.copyWith(
          isLoading: false,
          messages: paginatedResult.items,
          hasMore: paginatedResult.hasMore,
          nextCursor: paginatedResult.nextCursor,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (_state.isLoadingMore || !_state.hasMore || _state.nextCursor == null) {
      return;
    }

    final getMessages = _ref.read(getMessagesUseCaseProvider);

    _updateState(_state.copyWith(isLoadingMore: true));

    final result = await getMessages(conversationId: conversationId, cursor: _state.nextCursor);

    result.when(
      exception: (error) =>
          _updateState(_state.copyWith(isLoadingMore: false, error: error.message)),
      success: (paginatedResult, _) => _updateState(
        _state.copyWith(
          isLoadingMore: false,
          messages: [..._state.messages, ...paginatedResult.items],
          hasMore: paginatedResult.hasMore,
          nextCursor: paginatedResult.nextCursor,
        ),
      ),
    );
  }

  Future<Message?> sendTextMessage(String content, {String? replyToId}) async {
    final sendMessage = _ref.read(sendMessageUseCaseProvider);

    final result = await sendMessage(
      conversationId: conversationId,
      content: content,
      replyToId: replyToId,
    );

    return result.when(
      exception: (error) {
        _updateState(_state.copyWith(error: error.message));
        return null;
      },
      success: (message, _) {
        _updateState(_state.copyWith(messages: [message, ..._state.messages]));
        return message;
      },
    );
  }

  Future<bool> editMessage(String messageId, String newContent) async {
    final editMessage = _ref.read(editMessageUseCaseProvider);

    final result = await editMessage(messageId: messageId, content: newContent);

    return result.when(
      exception: (error) {
        _updateState(_state.copyWith(error: error.message));
        return false;
      },
      success: (updatedMessage, _) {
        final index = _state.messages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          final updated = List<Message>.from(_state.messages);
          updated[index] = updatedMessage;
          _updateState(_state.copyWith(messages: updated));
        }
        return true;
      },
    );
  }

  Future<bool> deleteMessage(String messageId, {bool forEveryone = false}) async {
    final deleteMessage = _ref.read(deleteMessageUseCaseProvider);

    final result = await deleteMessage(messageId: messageId, forEveryone: forEveryone);

    return result.when(
      exception: (error) {
        _updateState(_state.copyWith(error: error.message));
        return false;
      },
      success: (_, __) {
        _updateState(
          _state.copyWith(messages: _state.messages.where((m) => m.id != messageId).toList()),
        );
        return true;
      },
    );
  }

  Future<bool> addReaction(String messageId, String reaction) async {
    final addReactionUseCase = _ref.read(addReactionUseCaseProvider);

    final result = await addReactionUseCase(messageId: messageId, reaction: reaction);

    return result.when(
      exception: (error) {
        _updateState(_state.copyWith(error: error.message));
        return false;
      },
      success: (_, __) => true,
    );
  }

  void addMessage(Message message) {
    if (!_state.messages.any((m) => m.id == message.id)) {
      _updateState(_state.copyWith(messages: [message, ..._state.messages]));
    }
  }

  void updateMessage(Message message) {
    final index = _state.messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      final updated = List<Message>.from(_state.messages);
      updated[index] = message;
      _updateState(_state.copyWith(messages: updated));
    }
  }

  void removeMessage(String messageId) {
    _updateState(
      _state.copyWith(messages: _state.messages.where((m) => m.id != messageId).toList()),
    );
  }

  void setTypingUser(String userId, bool isTyping) {
    final typingUsers = Set<String>.from(_state.typingUsers);
    if (isTyping) {
      typingUsers.add(userId);
    } else {
      typingUsers.remove(userId);
    }
    _updateState(_state.copyWith(typingUsers: typingUsers));
  }

  void updatePresence(String userId, PresenceStatus status) {
    final presenceMap = Map<String, PresenceStatus>.from(_state.presenceMap);
    presenceMap[userId] = status;
    _updateState(_state.copyWith(presenceMap: presenceMap));
  }

  void clearError() {
    _updateState(_state.copyWith());
  }
}

// ==================== Dependency Providers ====================

/// Provider for WebSocket manager singleton.
final webSocketManagerProvider = Provider<WebSocketManager>((ref) {
  return WebSocketManager.instance;
});

/// Provider for remote data source.
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatRemoteDataSource(apiClient);
});

/// Provider for local data source.
final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ChatLocalDataSourceImpl(prefs: prefs);
});

/// Provider for chat repository.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  final localDataSource = ref.watch(chatLocalDataSourceProvider);
  final webSocketManager = ref.watch(webSocketManagerProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return ChatRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    webSocketManager: webSocketManager,
    networkInfo: networkInfo,
  );
});

// ==================== Use Case Providers ====================

final getConversationsUseCaseProvider = Provider<GetConversations>((ref) {
  return GetConversations(ref.watch(chatRepositoryProvider));
});

final getMessagesUseCaseProvider = Provider<GetMessages>((ref) {
  return GetMessages(ref.watch(chatRepositoryProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessage>((ref) {
  return SendMessage(ref.watch(chatRepositoryProvider));
});

final createDirectConversationUseCaseProvider = Provider<CreateDirectConversation>((ref) {
  return CreateDirectConversation(ref.watch(chatRepositoryProvider));
});

final createGroupConversationUseCaseProvider = Provider<CreateGroupConversation>((ref) {
  return CreateGroupConversation(ref.watch(chatRepositoryProvider));
});

final editMessageUseCaseProvider = Provider<EditMessage>((ref) {
  return EditMessage(ref.watch(chatRepositoryProvider));
});

final deleteMessageUseCaseProvider = Provider<DeleteMessage>((ref) {
  return DeleteMessage(ref.watch(chatRepositoryProvider));
});

final addReactionUseCaseProvider = Provider<AddReaction>((ref) {
  return AddReaction(ref.watch(chatRepositoryProvider));
});

// ==================== State Providers ====================

/// Provider for conversations state and notifier.
final conversationsProvider = NotifierProvider<ConversationsNotifier, ConversationsState>(
  ConversationsNotifier.new,
);

/// Provider for messages notifier (per conversation).
final messagesNotifierProvider = Provider.family<MessagesNotifier, String>((ref, conversationId) {
  return MessagesNotifier(conversationId, ref);
});

/// Provider for typing users in a conversation.
final typingUsersProvider = Provider.family<Set<String>, String>((ref, conversationId) {
  return ref.watch(messagesNotifierProvider(conversationId)).state.typingUsers;
});

/// Provider to check if any user is online in a conversation.
final isUserOnlineProvider = Provider.family<bool, String>((ref, conversationId) {
  final presenceMap = ref.watch(messagesNotifierProvider(conversationId)).state.presenceMap;
  return presenceMap.values.any((status) => status.isOnline);
});
