// lib/features/chat/data/datasources/chat_local_datasource.dart
import 'dart:convert';

import 'package:flavorizr/core/network/base/datasource/base_local_data_source.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/chat/domain/entities/conversation.dart';
import 'package:flavorizr/features/user/chat/domain/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching chat data.
///
/// Uses SharedPreferences for simple caching.
/// For production, consider using a proper database like Drift or Isar.
abstract class ChatLocalDataSource {
  /// Gets cached conversations.
  Future<ApiResult<List<Conversation>>> getCachedConversations();

  /// Caches conversations.
  Future<ApiResult<void>> cacheConversations(List<Conversation> conversations);

  /// Updates a single cached conversation.
  Future<ApiResult<void>> updateCachedConversation(Conversation conversation);

  /// Removes a conversation from cache.
  Future<ApiResult<void>> removeCachedConversation(String conversationId);

  /// Gets cached messages for a conversation.
  Future<ApiResult<List<Message>>> getCachedMessages(String conversationId);

  /// Caches messages for a conversation.
  Future<ApiResult<void>> cacheMessages(String conversationId, List<Message> messages);

  /// Adds a message to the cache.
  Future<ApiResult<void>> addMessageToCache(Message message);

  /// Updates a cached message.
  Future<ApiResult<void>> updateCachedMessage(Message message);

  /// Removes a message from cache.
  Future<ApiResult<void>> removeCachedMessage(String conversationId, String messageId);

  /// Clears messages cache for a conversation.
  Future<ApiResult<void>> clearMessagesCache(String conversationId);

  /// Gets the last sync timestamp.
  Future<ApiResult<DateTime?>> getLastSyncTime();

  /// Updates the last sync timestamp.
  Future<ApiResult<void>> updateLastSyncTime();

  /// Clears all chat cache.
  Future<ApiResult<void>> clearAll();
}

/// Implementation of [ChatLocalDataSource] using BaseLocalDataSource.
class ChatLocalDataSourceImpl with BaseLocalDataSource implements ChatLocalDataSource {
  ChatLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _conversationsKey = 'cached_conversations';
  static const String _messagesKeyPrefix = 'cached_messages_';
  static const String _lastSyncKey = 'chat_last_sync';

  final SharedPreferences _prefs;

  // ==================== Conversations ====================

  @override
  Future<ApiResult<List<Conversation>>> getCachedConversations() async {
    return getLocalDataList<Conversation>(
      key: _conversationsKey,
      fetcher: () async {
        final json = _prefs.getString(_conversationsKey);
        if (json == null) return null;

        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list.map((e) => Conversation.fromMap(e as Map<String, dynamic>)).toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheConversations(List<Conversation> conversations) async {
    return saveLocalDataList<Conversation>(
      key: _conversationsKey,
      data: conversations,
      saver: (data) async {
        final json = jsonEncode(data.map((c) => c.toMap()).toList());
        await _prefs.setString(_conversationsKey, json);
      },
    );
  }

  @override
  Future<ApiResult<Conversation>> updateCachedConversation(Conversation conversation) async {
    return saveLocalData<Conversation>(
      key: _conversationsKey,
      data: conversation,
      saver: (data) async {
        final conversationsResult = await getCachedConversations();
        final conversations = conversationsResult.data ?? [];
        final index = conversations.indexWhere((c) => c.id == conversation.id);

        if (index >= 0) {
          conversations[index] = conversation;
        } else {
          conversations.insert(0, conversation);
        }

        final json = jsonEncode(conversations.map((c) => c.toMap()).toList());
        await _prefs.setString(_conversationsKey, json);
      },
    );
  }

  @override
  Future<ApiResult<String>> removeCachedConversation(String conversationId) async {
    return saveLocalData<String>(
      key: _conversationsKey,
      data: conversationId,
      saver: (data) async {
        final conversationsResult = await getCachedConversations();
        final conversations = conversationsResult.data ?? [];
        conversations.removeWhere((c) => c.id == conversationId);
        final json = jsonEncode(conversations.map((c) => c.toMap()).toList());
        await _prefs.setString(_conversationsKey, json);
      },
    );
  }

  // ==================== Messages ====================

  @override
  Future<ApiResult<List<Message>>> getCachedMessages(String conversationId) async {
    return getLocalDataList<Message>(
      key: '$_messagesKeyPrefix$conversationId',
      fetcher: () async {
        final json = _prefs.getString('$_messagesKeyPrefix$conversationId');
        if (json == null) return null;

        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list.map((e) => Message.fromMap(e as Map<String, dynamic>)).toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheMessages(String conversationId, List<Message> messages) async {
    return saveLocalDataList<Message>(
      key: '$_messagesKeyPrefix$conversationId',
      data: messages,
      saver: (data) async {
        final json = jsonEncode(data.map((m) => m.toMap()).toList());
        await _prefs.setString('$_messagesKeyPrefix$conversationId', json);
      },
    );
  }

  @override
  Future<ApiResult<Message>> addMessageToCache(Message message) async {
    return saveLocalData<Message>(
      key: '$_messagesKeyPrefix${message.conversationId}',
      data: message,
      saver: (data) async {
        final messagesResult = await getCachedMessages(message.conversationId);
        final messages = messagesResult.data ?? [];

        // Check for duplicates
        final existingIndex = messages.indexWhere((m) => m.id == message.id);
        if (existingIndex >= 0) {
          messages[existingIndex] = message;
        } else {
          // Add at the beginning (newest first)
          messages.insert(0, message);
        }

        // Keep only the latest 100 messages
        if (messages.length > 100) {
          messages.removeRange(100, messages.length);
        }

        final json = jsonEncode(messages.map((m) => m.toMap()).toList());
        await _prefs.setString('$_messagesKeyPrefix${message.conversationId}', json);
      },
    );
  }

  @override
  Future<ApiResult<Message>> updateCachedMessage(Message message) async {
    return saveLocalData<Message>(
      key: '$_messagesKeyPrefix${message.conversationId}',
      data: message,
      saver: (data) async {
        final messagesResult = await getCachedMessages(message.conversationId);
        final messages = messagesResult.data ?? [];
        final index = messages.indexWhere((m) => m.id == message.id);

        if (index >= 0) {
          messages[index] = message;
          final json = jsonEncode(messages.map((m) => m.toMap()).toList());
          await _prefs.setString('$_messagesKeyPrefix${message.conversationId}', json);
        }
      },
    );
  }

  @override
  Future<ApiResult<String>> removeCachedMessage(String conversationId, String messageId) async {
    return saveLocalData<String>(
      key: '$_messagesKeyPrefix$conversationId',
      data: messageId,
      saver: (data) async {
        final messagesResult = await getCachedMessages(conversationId);
        final messages = messagesResult.data ?? [];
        messages.removeWhere((m) => m.id == messageId);
        final json = jsonEncode(messages.map((m) => m.toMap()).toList());
        await _prefs.setString('$_messagesKeyPrefix$conversationId', json);
      },
    );
  }

  @override
  Future<ApiResult<void>> clearMessagesCache(String conversationId) async {
    return deleteLocalData(
      key: '$_messagesKeyPrefix$conversationId',
      deleter: () => _prefs.remove('$_messagesKeyPrefix$conversationId'),
    );
  }

  // ==================== Sync ====================

  @override
  Future<ApiResult<DateTime?>> getLastSyncTime() async {
    return getLocalData<DateTime?>(
      key: _lastSyncKey,
      fetcher: () async {
        final timestamp = _prefs.getInt(_lastSyncKey);
        if (timestamp == null) return null;
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      },
    );
  }

  @override
  Future<ApiResult<DateTime>> updateLastSyncTime() async {
    return saveLocalData<DateTime>(
      key: _lastSyncKey,
      data: DateTime.now(),
      saver: (data) async {
        await _prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      },
    );
  }

  // ==================== Clear ====================

  @override
  Future<ApiResult<void>> clearAll() async {
    return clearAllLocalData(
      clearer: () async {
        await _prefs.remove(_conversationsKey);
        await _prefs.remove(_lastSyncKey);

        // Clear all message caches
        final keys = _prefs.getKeys();
        for (final key in keys) {
          if (key.startsWith(_messagesKeyPrefix)) {
            await _prefs.remove(key);
          }
        }
      },
    );
  }
}
