// lib/features/chat/data/datasources/chat_local_datasource.dart
import 'dart:convert';

import 'package:flavorizr/features/chat/domain/entities/conversation.dart';
import 'package:flavorizr/features/chat/domain/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching chat data.
///
/// Uses SharedPreferences for simple caching.
/// For production, consider using a proper database like Drift or Isar.
class ChatLocalDataSource {

  ChatLocalDataSource(this._prefs);
  static const _conversationsKey = 'cached_conversations';
  static const _messagesKeyPrefix = 'cached_messages_';
  static const _lastSyncKey = 'chat_last_sync';

  final SharedPreferences _prefs;

  // ==================== Conversations ====================

  /// Gets cached conversations.
  List<Conversation>? getCachedConversations() {
    final json = _prefs.getString(_conversationsKey);
    if (json == null) return null;

    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => Conversation.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Caches conversations.
  Future<void> cacheConversations(List<Conversation> conversations) async {
    final json = jsonEncode(conversations.map((c) => c.toMap()).toList());
    await _prefs.setString(_conversationsKey, json);
  }

  /// Updates a single cached conversation.
  Future<void> updateCachedConversation(Conversation conversation) async {
    final conversations = getCachedConversations() ?? [];
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    
    if (index >= 0) {
      conversations[index] = conversation;
    } else {
      conversations.insert(0, conversation);
    }

    await cacheConversations(conversations);
  }

  /// Removes a conversation from cache.
  Future<void> removeCachedConversation(String conversationId) async {
    final conversations = getCachedConversations() ?? [];
    conversations.removeWhere((c) => c.id == conversationId);
    await cacheConversations(conversations);
  }

  // ==================== Messages ====================

  /// Gets cached messages for a conversation.
  List<Message>? getCachedMessages(String conversationId) {
    final json = _prefs.getString('$_messagesKeyPrefix$conversationId');
    if (json == null) return null;

    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => Message.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Caches messages for a conversation.
  Future<void> cacheMessages(
    String conversationId,
    List<Message> messages,
  ) async {
    final json = jsonEncode(messages.map((m) => m.toMap()).toList());
    await _prefs.setString('$_messagesKeyPrefix$conversationId', json);
  }

  /// Adds a message to the cache.
  Future<void> addMessageToCache(Message message) async {
    final messages = getCachedMessages(message.conversationId) ?? [];
    
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

    await cacheMessages(message.conversationId, messages);
  }

  /// Updates a cached message.
  Future<void> updateCachedMessage(Message message) async {
    final messages = getCachedMessages(message.conversationId) ?? [];
    final index = messages.indexWhere((m) => m.id == message.id);
    
    if (index >= 0) {
      messages[index] = message;
      await cacheMessages(message.conversationId, messages);
    }
  }

  /// Removes a message from cache.
  Future<void> removeCachedMessage(String conversationId, String messageId) async {
    final messages = getCachedMessages(conversationId) ?? [];
    messages.removeWhere((m) => m.id == messageId);
    await cacheMessages(conversationId, messages);
  }

  /// Clears messages cache for a conversation.
  Future<void> clearMessagesCache(String conversationId) async {
    await _prefs.remove('$_messagesKeyPrefix$conversationId');
  }

  // ==================== Sync ====================

  /// Gets the last sync timestamp.
  DateTime? getLastSyncTime() {
    final timestamp = _prefs.getInt(_lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Updates the last sync timestamp.
  Future<void> updateLastSyncTime() async {
    await _prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
  }

  // ==================== Clear ====================

  /// Clears all chat cache.
  Future<void> clearAll() async {
    await _prefs.remove(_conversationsKey);
    await _prefs.remove(_lastSyncKey);
    
    // Clear all message caches
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_messagesKeyPrefix)) {
        await _prefs.remove(key);
      }
    }
  }
}
