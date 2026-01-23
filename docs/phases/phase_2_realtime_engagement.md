# Phase 2 — Real-time & Engagement

> **Duration:** 3-4 weeks  
> **Priority:** High  
> **Dependencies:** Phase 1 (Essential UX)

---

## 📋 Overview

Phase 2 introduces real-time features that drive user engagement. This phase focuses on messaging, notifications, and search functionality to create a dynamic, interactive experience.

**Key Deliverables:**
- Real-time messaging (1:1 and group chats)
- Push notifications with in-app inbox
- Full-text search with filters
- Presence indicators (online/offline)
- Deep link handling

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| Messaging | Users can send/receive messages in real-time |
| Chat Features | Typing indicators, read receipts, media sharing |
| Notifications | Push notifications work; inbox shows all notifications |
| Search | Users can find content and other users quickly |
| Engagement | Real-time presence updates work |

---

## 📁 Tasks Breakdown

### Task 2.1: Real-time Infrastructure Setup

**Estimated Time:** 2-3 days

#### Objectives
- Set up WebSocket connection manager
- Implement reconnection logic
- Create event dispatching system
- Add connection state monitoring

#### Implementation Steps

1. **Create `lib/core/network/websocket/websocket_client.dart`**
   ```dart
   import 'dart:async';
   import 'dart:convert';
   
   import 'package:web_socket_channel/web_socket_channel.dart';
   
   import '../../../config/app_config.dart';
   import '../../logger/app_logger.dart';
   
   /// WebSocket connection states.
   enum WebSocketState {
     /// Initial state, not connected.
     disconnected,
     
     /// Attempting to connect.
     connecting,
     
     /// Connected and ready.
     connected,
     
     /// Connection lost, attempting to reconnect.
     reconnecting,
     
     /// Permanently closed.
     closed,
   }
   
   /// Configuration for WebSocket connection.
   class WebSocketConfig {
     /// The WebSocket server URL.
     final String url;
     
     /// Initial reconnection delay in milliseconds.
     final int initialReconnectDelay;
     
     /// Maximum reconnection delay in milliseconds.
     final int maxReconnectDelay;
     
     /// Maximum number of reconnection attempts.
     final int maxReconnectAttempts;
     
     /// Ping interval in seconds to keep connection alive.
     final int pingIntervalSeconds;
     
     const WebSocketConfig({
       required this.url,
       this.initialReconnectDelay = 1000,
       this.maxReconnectDelay = 30000,
       this.maxReconnectAttempts = 10,
       this.pingIntervalSeconds = 30,
     });
   }
   
   /// WebSocket event received from the server.
   class WebSocketEvent {
     /// Event type (e.g., 'message', 'typing', 'presence').
     final String type;
     
     /// Event payload data.
     final Map<String, dynamic> data;
     
     /// Timestamp when the event was received.
     final DateTime receivedAt;
     
     const WebSocketEvent({
       required this.type,
       required this.data,
       required this.receivedAt,
     });
     
     /// Creates an event from a JSON map.
     factory WebSocketEvent.fromJson(Map<String, dynamic> json) {
       return WebSocketEvent(
         type: json['type'] as String? ?? 'unknown',
         data: json['data'] as Map<String, dynamic>? ?? {},
         receivedAt: DateTime.now(),
       );
     }
   }
   
   /// Manages WebSocket connections with automatic reconnection.
   /// 
   /// Features:
   /// - Automatic reconnection with exponential backoff
   /// - Connection state monitoring
   /// - Event dispatching
   /// - Keep-alive pings
   /// - Message queuing during reconnection
   class WebSocketClient {
     final WebSocketConfig _config;
     
     WebSocketChannel? _channel;
     StreamSubscription? _subscription;
     Timer? _pingTimer;
     Timer? _reconnectTimer;
     
     int _reconnectAttempts = 0;
     bool _isManualClose = false;
     String? _authToken;
     
     final _stateController = StreamController<WebSocketState>.broadcast();
     final _eventController = StreamController<WebSocketEvent>.broadcast();
     final _messageQueue = <Map<String, dynamic>>[];
     
     WebSocketState _state = WebSocketState.disconnected;
     
     /// Creates a WebSocket client with the given configuration.
     WebSocketClient({WebSocketConfig? config})
         : _config = config ??
               WebSocketConfig(url: AppConfig.instance.wsBaseUrl);
     
     /// Current connection state.
     WebSocketState get state => _state;
     
     /// Stream of connection state changes.
     Stream<WebSocketState> get stateChanges => _stateController.stream;
     
     /// Stream of events received from the server.
     Stream<WebSocketEvent> get events => _eventController.stream;
     
     /// Whether the connection is currently active.
     bool get isConnected => _state == WebSocketState.connected;
     
     /// Connects to the WebSocket server.
     /// 
     /// [authToken] - JWT token for authentication.
     Future<void> connect({required String authToken}) async {
       if (_state == WebSocketState.connected ||
           _state == WebSocketState.connecting) {
         AppLogger.debug('WebSocket already connected or connecting');
         return;
       }
       
       _authToken = authToken;
       _isManualClose = false;
       
       await _connect();
     }
     
     Future<void> _connect() async {
       _setState(WebSocketState.connecting);
       
       try {
         final uri = Uri.parse(_config.url).replace(
           queryParameters: {'token': _authToken},
         );
         
         _channel = WebSocketChannel.connect(uri);
         
         // Wait for connection to be established
         await _channel!.ready;
         
         _setState(WebSocketState.connected);
         _reconnectAttempts = 0;
         
         // Start listening to messages
         _subscription = _channel!.stream.listen(
           _onMessage,
           onError: _onError,
           onDone: _onDone,
         );
         
         // Start keep-alive pings
         _startPingTimer();
         
         // Send queued messages
         _flushMessageQueue();
         
         AppLogger.info('WebSocket connected');
       } catch (e, s) {
         AppLogger.error('WebSocket connection failed', error: e, stackTrace: s);
         _scheduleReconnect();
       }
     }
     
     void _setState(WebSocketState newState) {
       if (_state != newState) {
         _state = newState;
         _stateController.add(newState);
         AppLogger.debug('WebSocket state: $newState');
       }
     }
     
     void _onMessage(dynamic data) {
       try {
         final json = jsonDecode(data as String) as Map<String, dynamic>;
         final event = WebSocketEvent.fromJson(json);
         
         // Handle ping/pong internally
         if (event.type == 'pong') {
           return;
         }
         
         _eventController.add(event);
       } catch (e, s) {
         AppLogger.error('Failed to parse WebSocket message', error: e, stackTrace: s);
       }
     }
     
     void _onError(Object error) {
       AppLogger.error('WebSocket error', error: error);
       
       if (!_isManualClose) {
         _scheduleReconnect();
       }
     }
     
     void _onDone() {
       AppLogger.info('WebSocket connection closed');
       
       _cleanup();
       
       if (!_isManualClose) {
         _scheduleReconnect();
       } else {
         _setState(WebSocketState.closed);
       }
     }
     
     void _scheduleReconnect() {
       if (_isManualClose || _reconnectAttempts >= _config.maxReconnectAttempts) {
         _setState(WebSocketState.closed);
         AppLogger.warning('WebSocket max reconnect attempts reached');
         return;
       }
       
       _setState(WebSocketState.reconnecting);
       
       // Exponential backoff with jitter
       final delay = _calculateReconnectDelay();
       _reconnectAttempts++;
       
       AppLogger.info(
         'WebSocket reconnecting in ${delay}ms (attempt $_reconnectAttempts)',
       );
       
       _reconnectTimer = Timer(Duration(milliseconds: delay), _connect);
     }
     
     int _calculateReconnectDelay() {
       final exponentialDelay =
           _config.initialReconnectDelay * (1 << _reconnectAttempts);
       final cappedDelay = exponentialDelay.clamp(
         _config.initialReconnectDelay,
         _config.maxReconnectDelay,
       );
       
       // Add jitter (±20%)
       final jitter = (cappedDelay * 0.2 * (DateTime.now().millisecond / 500 - 1))
           .round();
       
       return cappedDelay + jitter;
     }
     
     void _startPingTimer() {
       _pingTimer?.cancel();
       _pingTimer = Timer.periodic(
         Duration(seconds: _config.pingIntervalSeconds),
         (_) => _sendPing(),
       );
     }
     
     void _sendPing() {
       send(type: 'ping', data: {});
     }
     
     void _flushMessageQueue() {
       while (_messageQueue.isNotEmpty && isConnected) {
         final message = _messageQueue.removeAt(0);
         _sendRaw(message);
       }
     }
     
     void _cleanup() {
       _pingTimer?.cancel();
       _pingTimer = null;
       _subscription?.cancel();
       _subscription = null;
       _channel = null;
     }
     
     /// Sends a message through the WebSocket.
     /// 
     /// If not connected, the message is queued and sent when connected.
     void send({
       required String type,
       required Map<String, dynamic> data,
     }) {
       final message = {
         'type': type,
         'data': data,
         'timestamp': DateTime.now().toIso8601String(),
       };
       
       if (isConnected) {
         _sendRaw(message);
       } else {
         _messageQueue.add(message);
         AppLogger.debug('Message queued (connection not ready)');
       }
     }
     
     void _sendRaw(Map<String, dynamic> message) {
       try {
         _channel?.sink.add(jsonEncode(message));
       } catch (e) {
         AppLogger.error('Failed to send WebSocket message', error: e);
         _messageQueue.insert(0, message);
       }
     }
     
     /// Disconnects from the WebSocket server.
     Future<void> disconnect() async {
       _isManualClose = true;
       _reconnectTimer?.cancel();
       _reconnectTimer = null;
       
       _cleanup();
       
       await _channel?.sink.close();
       _setState(WebSocketState.disconnected);
       
       AppLogger.info('WebSocket disconnected');
     }
     
     /// Disposes resources.
     void dispose() {
       disconnect();
       _stateController.close();
       _eventController.close();
     }
   }
   ```

2. **Create `lib/core/network/websocket/websocket_event_handler.dart`**
   ```dart
   import 'dart:async';
   
   import '../../logger/app_logger.dart';
   import 'websocket_client.dart';
   
   /// Callback type for WebSocket event handlers.
   typedef WebSocketEventCallback = void Function(Map<String, dynamic> data);
   
   /// Manages WebSocket event subscriptions and dispatching.
   /// 
   /// Allows registering handlers for specific event types and
   /// automatically dispatches events to the appropriate handlers.
   /// 
   /// Usage:
   /// ```dart
   /// final handler = WebSocketEventHandler(client);
   /// 
   /// // Register handlers
   /// handler.on('message.new', (data) {
   ///   print('New message: ${data['content']}');
   /// });
   /// 
   /// handler.on('typing.start', (data) {
   ///   print('${data['userId']} is typing...');
   /// });
   /// 
   /// // Clean up
   /// handler.dispose();
   /// ```
   class WebSocketEventHandler {
     final WebSocketClient _client;
     final Map<String, List<WebSocketEventCallback>> _handlers = {};
     
     StreamSubscription? _subscription;
     
     WebSocketEventHandler(this._client) {
       _subscription = _client.events.listen(_dispatchEvent);
     }
     
     /// Registers a handler for the specified event type.
     /// 
     /// Multiple handlers can be registered for the same event type.
     /// Returns a function that can be called to unregister the handler.
     VoidCallback on(String eventType, WebSocketEventCallback callback) {
       _handlers.putIfAbsent(eventType, () => []);
       _handlers[eventType]!.add(callback);
       
       AppLogger.debug('Registered handler for event: $eventType');
       
       return () => off(eventType, callback);
     }
     
     /// Unregisters a handler for the specified event type.
     void off(String eventType, WebSocketEventCallback callback) {
       _handlers[eventType]?.remove(callback);
       
       if (_handlers[eventType]?.isEmpty ?? false) {
         _handlers.remove(eventType);
       }
     }
     
     /// Registers a one-time handler that automatically unregisters after firing.
     void once(String eventType, WebSocketEventCallback callback) {
       late VoidCallback unregister;
       
       unregister = on(eventType, (data) {
         callback(data);
         unregister();
       });
     }
     
     /// Clears all handlers for the specified event type.
     void clearHandlers(String eventType) {
       _handlers.remove(eventType);
     }
     
     /// Clears all registered handlers.
     void clearAllHandlers() {
       _handlers.clear();
     }
     
     void _dispatchEvent(WebSocketEvent event) {
       final handlers = _handlers[event.type];
       
       if (handlers == null || handlers.isEmpty) {
         AppLogger.debug('No handlers for event: ${event.type}');
         return;
       }
       
       for (final handler in handlers) {
         try {
           handler(event.data);
         } catch (e, s) {
           AppLogger.error(
             'Error in handler for ${event.type}',
             error: e,
             stackTrace: s,
           );
         }
       }
     }
     
     /// Disposes resources.
     void dispose() {
       _subscription?.cancel();
       _handlers.clear();
     }
   }
   ```

#### Acceptance Criteria
- [ ] WebSocket connects with authentication
- [ ] Automatic reconnection works
- [ ] Events are dispatched to handlers
- [ ] Keep-alive pings prevent timeout
- [ ] Message queue works during reconnection

---

### Task 2.2: Messaging - Domain Layer

**Estimated Time:** 2-3 days

#### Objectives
- Define messaging entities
- Create repository interfaces
- Implement use cases

#### Implementation Steps

1. **Create `lib/features/chat/domain/entities/conversation.dart`**
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';
   
   import '../../../auth/domain/entities/user.dart';
   import 'message.dart';
   
   part 'conversation.freezed.dart';
   
   /// Type of conversation.
   enum ConversationType {
     /// One-on-one private conversation.
     direct,
     
     /// Group conversation with multiple participants.
     group,
     
     /// Channel-style conversation (many readers, few writers).
     channel,
   }
   
   /// Represents a chat conversation.
   /// 
   /// A conversation contains participants and messages.
   /// It can be a direct (1:1) chat or a group chat.
   @freezed
   class Conversation with _$Conversation {
     const Conversation._();
     
     const factory Conversation({
       /// Unique identifier for the conversation.
       required String id,
       
       /// Type of conversation (direct, group, channel).
       required ConversationType type,
       
       /// Conversation name (for groups/channels).
       /// Null for direct conversations.
       String? name,
       
       /// Conversation description (for groups/channels).
       String? description,
       
       /// URL to the conversation image/avatar.
       String? imageUrl,
       
       /// List of participant user IDs.
       required List<String> participantIds,
       
       /// Expanded participant details (may be partially loaded).
       @Default([]) List<User> participants,
       
       /// The most recent message in the conversation.
       Message? lastMessage,
       
       /// Number of unread messages for the current user.
       @Default(0) int unreadCount,
       
       /// Whether the conversation is muted.
       @Default(false) bool isMuted,
       
       /// Whether the conversation is pinned.
       @Default(false) bool isPinned,
       
       /// Whether the conversation is archived.
       @Default(false) bool isArchived,
       
       /// User ID of the conversation creator.
       String? createdBy,
       
       /// When the conversation was created.
       required DateTime createdAt,
       
       /// When the conversation was last updated.
       required DateTime updatedAt,
       
       /// Custom metadata.
       @Default({}) Map<String, dynamic> metadata,
     }) = _Conversation;
     
     /// Returns true if this is a direct (1:1) conversation.
     bool get isDirect => type == ConversationType.direct;
     
     /// Returns true if this is a group conversation.
     bool get isGroup => type == ConversationType.group;
     
     /// Gets the display name for the conversation.
     /// For direct chats, this is the other participant's name.
     String displayName(String currentUserId) {
       if (name != null && name!.isNotEmpty) {
         return name!;
       }
       
       if (isDirect && participants.isNotEmpty) {
         final other = participants.firstWhere(
           (p) => p.id != currentUserId,
           orElse: () => participants.first,
         );
         return other.displayName ?? other.email;
       }
       
       return 'Conversation';
     }
     
     /// Gets the avatar URL for the conversation.
     /// For direct chats, this is the other participant's avatar.
     String? displayImage(String currentUserId) {
       if (imageUrl != null) {
         return imageUrl;
       }
       
       if (isDirect && participants.isNotEmpty) {
         final other = participants.firstWhere(
           (p) => p.id != currentUserId,
           orElse: () => participants.first,
         );
         return other.avatarUrl;
       }
       
       return null;
     }
     
     /// Returns the other participant in a direct conversation.
     User? otherParticipant(String currentUserId) {
       if (!isDirect || participants.isEmpty) return null;
       
       return participants.firstWhere(
         (p) => p.id != currentUserId,
         orElse: () => participants.first,
       );
     }
   }
   ```

2. **Create `lib/features/chat/domain/entities/message.dart`**
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';
   
   part 'message.freezed.dart';
   
   /// Type of message content.
   enum MessageType {
     /// Plain text message.
     text,
     
     /// Image attachment.
     image,
     
     /// Video attachment.
     video,
     
     /// Audio/voice message.
     audio,
     
     /// File attachment.
     file,
     
     /// Location sharing.
     location,
     
     /// System message (user joined, left, etc.).
     system,
   }
   
   /// Message delivery/read status.
   enum MessageStatus {
     /// Message is being sent.
     sending,
     
     /// Message sent to server.
     sent,
     
     /// Message delivered to recipient(s).
     delivered,
     
     /// Message read by recipient(s).
     read,
     
     /// Message failed to send.
     failed,
   }
   
   /// Attachment metadata.
   @freezed
   class MessageAttachment with _$MessageAttachment {
     const factory MessageAttachment({
       /// Unique attachment ID.
       required String id,
       
       /// Attachment type (image, video, file, etc.).
       required String type,
       
       /// URL to the attachment.
       required String url,
       
       /// Thumbnail URL for images/videos.
       String? thumbnailUrl,
       
       /// Original filename.
       String? fileName,
       
       /// File size in bytes.
       int? fileSize,
       
       /// MIME type.
       String? mimeType,
       
       /// Image/video width.
       int? width,
       
       /// Image/video height.
       int? height,
       
       /// Duration for audio/video in seconds.
       int? duration,
     }) = _MessageAttachment;
   }
   
   /// Represents a chat message.
   @freezed
   class Message with _$Message {
     const Message._();
     
     const factory Message({
       /// Unique message ID.
       required String id,
       
       /// Conversation this message belongs to.
       required String conversationId,
       
       /// User ID of the sender.
       required String senderId,
       
       /// Message type.
       required MessageType type,
       
       /// Text content (for text messages).
       String? content,
       
       /// Attachments (for media messages).
       @Default([]) List<MessageAttachment> attachments,
       
       /// Message this is replying to.
       String? replyToId,
       
       /// Message this is replying to (expanded).
       Message? replyTo,
       
       /// Delivery/read status.
       @Default(MessageStatus.sending) MessageStatus status,
       
       /// List of user IDs who have read this message.
       @Default([]) List<String> readBy,
       
       /// When the message was sent.
       required DateTime sentAt,
       
       /// When the message was delivered.
       DateTime? deliveredAt,
       
       /// When the message was edited.
       DateTime? editedAt,
       
       /// Whether the message has been edited.
       @Default(false) bool isEdited,
       
       /// Whether the message has been deleted.
       @Default(false) bool isDeleted,
       
       /// Reactions on this message.
       @Default({}) Map<String, List<String>> reactions,
       
       /// Custom metadata.
       @Default({}) Map<String, dynamic> metadata,
       
       /// Local ID for optimistic updates.
       String? localId,
     }) = _Message;
     
     /// Returns true if the message is from the specified user.
     bool isFromUser(String userId) => senderId == userId;
     
     /// Returns true if the message has been read by the specified user.
     bool isReadBy(String userId) => readBy.contains(userId);
     
     /// Returns true if this is a text message.
     bool get isText => type == MessageType.text;
     
     /// Returns true if this is a media message.
     bool get isMedia =>
         type == MessageType.image ||
         type == MessageType.video ||
         type == MessageType.audio;
     
     /// Returns true if this is a system message.
     bool get isSystem => type == MessageType.system;
     
     /// Returns the total reaction count.
     int get totalReactions =>
         reactions.values.fold(0, (sum, list) => sum + list.length);
     
     /// Returns the display text for preview.
     String get previewText {
       if (isDeleted) return 'Message deleted';
       
       switch (type) {
         case MessageType.text:
           return content ?? '';
         case MessageType.image:
           return '📷 Photo';
         case MessageType.video:
           return '🎥 Video';
         case MessageType.audio:
           return '🎤 Voice message';
         case MessageType.file:
           return '📎 ${attachments.firstOrNull?.fileName ?? 'File'}';
         case MessageType.location:
           return '📍 Location';
         case MessageType.system:
           return content ?? 'System message';
       }
     }
   }
   ```

3. **Create `lib/features/chat/domain/entities/typing_indicator.dart`**
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';
   
   part 'typing_indicator.freezed.dart';
   
   /// Represents a user's typing status in a conversation.
   @freezed
   class TypingIndicator with _$TypingIndicator {
     const factory TypingIndicator({
       /// The conversation where typing is happening.
       required String conversationId,
       
       /// The user who is typing.
       required String userId,
       
       /// User's display name (for convenience).
       String? userName,
       
       /// When the typing started.
       required DateTime startedAt,
       
       /// When this indicator should expire.
       required DateTime expiresAt,
     }) = _TypingIndicator;
     
     /// Creates a typing indicator with default expiration (10 seconds).
     factory TypingIndicator.create({
       required String conversationId,
       required String userId,
       String? userName,
     }) {
       final now = DateTime.now();
       return TypingIndicator(
         conversationId: conversationId,
         userId: userId,
         userName: userName,
         startedAt: now,
         expiresAt: now.add(const Duration(seconds: 10)),
       );
     }
   }
   
   /// Represents online/offline presence status.
   @freezed
   class PresenceStatus with _$PresenceStatus {
     const factory PresenceStatus({
       /// The user's ID.
       required String userId,
       
       /// Whether the user is currently online.
       required bool isOnline,
       
       /// When the user was last seen (if offline).
       DateTime? lastSeenAt,
       
       /// Current status message.
       String? statusMessage,
     }) = _PresenceStatus;
   }
   ```

4. **Create `lib/features/chat/domain/repositories/chat_repository.dart`**
   ```dart
   import 'package:dartz/dartz.dart';
   
   import '../../../../core/error/failures.dart';
   import '../entities/conversation.dart';
   import '../entities/message.dart';
   import '../entities/typing_indicator.dart';
   
   /// Repository interface for chat operations.
   /// 
   /// Handles both REST API calls for persistent data
   /// and WebSocket events for real-time updates.
   abstract class ChatRepository {
     // ==================== Conversations ====================
     
     /// Gets all conversations for the current user.
     /// 
     /// Supports pagination with cursor-based approach.
     Future<Either<Failure, List<Conversation>>> getConversations({
       String? cursor,
       int limit = 20,
     });
     
     /// Gets a single conversation by ID.
     Future<Either<Failure, Conversation>> getConversation(String id);
     
     /// Creates a new direct conversation with another user.
     /// 
     /// Returns existing conversation if one already exists.
     Future<Either<Failure, Conversation>> createDirectConversation({
       required String otherUserId,
     });
     
     /// Creates a new group conversation.
     Future<Either<Failure, Conversation>> createGroupConversation({
       required String name,
       required List<String> participantIds,
       String? description,
       String? imageUrl,
     });
     
     /// Updates a conversation's details.
     Future<Either<Failure, Conversation>> updateConversation({
       required String conversationId,
       String? name,
       String? description,
       String? imageUrl,
     });
     
     /// Adds participants to a group conversation.
     Future<Either<Failure, Conversation>> addParticipants({
       required String conversationId,
       required List<String> userIds,
     });
     
     /// Removes a participant from a group conversation.
     Future<Either<Failure, void>> removeParticipant({
       required String conversationId,
       required String userId,
     });
     
     /// Leaves a group conversation.
     Future<Either<Failure, void>> leaveConversation(String conversationId);
     
     /// Deletes a conversation (local only or for everyone if admin).
     Future<Either<Failure, void>> deleteConversation(String conversationId);
     
     /// Mutes/unmutes a conversation.
     Future<Either<Failure, void>> muteConversation({
       required String conversationId,
       required bool mute,
       Duration? duration,
     });
     
     /// Pins/unpins a conversation.
     Future<Either<Failure, void>> pinConversation({
       required String conversationId,
       required bool pin,
     });
     
     /// Archives/unarchives a conversation.
     Future<Either<Failure, void>> archiveConversation({
       required String conversationId,
       required bool archive,
     });
     
     // ==================== Messages ====================
     
     /// Gets messages for a conversation.
     /// 
     /// Supports pagination with cursor-based approach.
     Future<Either<Failure, List<Message>>> getMessages({
       required String conversationId,
       String? beforeId,
       String? afterId,
       int limit = 50,
     });
     
     /// Sends a text message.
     Future<Either<Failure, Message>> sendMessage({
       required String conversationId,
       required String content,
       String? replyToId,
       String? localId,
     });
     
     /// Sends a media message.
     Future<Either<Failure, Message>> sendMediaMessage({
       required String conversationId,
       required MessageType type,
       required List<MessageAttachment> attachments,
       String? content,
       String? replyToId,
       String? localId,
     });
     
     /// Edits a message.
     Future<Either<Failure, Message>> editMessage({
       required String messageId,
       required String content,
     });
     
     /// Deletes a message.
     Future<Either<Failure, void>> deleteMessage({
       required String messageId,
       bool forEveryone = false,
     });
     
     /// Marks messages as read.
     Future<Either<Failure, void>> markAsRead({
       required String conversationId,
       String? upToMessageId,
     });
     
     /// Adds a reaction to a message.
     Future<Either<Failure, void>> addReaction({
       required String messageId,
       required String reaction,
     });
     
     /// Removes a reaction from a message.
     Future<Either<Failure, void>> removeReaction({
       required String messageId,
       required String reaction,
     });
     
     // ==================== Real-time ====================
     
     /// Sends typing indicator.
     void sendTypingIndicator(String conversationId);
     
     /// Stops typing indicator.
     void stopTypingIndicator(String conversationId);
     
     /// Stream of new messages.
     Stream<Message> get newMessages;
     
     /// Stream of message updates (edits, deletions, reactions).
     Stream<Message> get messageUpdates;
     
     /// Stream of typing indicators.
     Stream<TypingIndicator> get typingIndicators;
     
     /// Stream of presence updates.
     Stream<PresenceStatus> get presenceUpdates;
     
     /// Stream of conversation updates.
     Stream<Conversation> get conversationUpdates;
     
     // ==================== Search ====================
     
     /// Searches messages in a conversation.
     Future<Either<Failure, List<Message>>> searchMessages({
       required String conversationId,
       required String query,
       int limit = 20,
     });
     
     // ==================== Media ====================
     
     /// Uploads a file attachment.
     /// 
     /// Returns the URL of the uploaded file.
     Future<Either<Failure, String>> uploadAttachment({
       required String filePath,
       required String mimeType,
       void Function(double progress)? onProgress,
     });
   }
   ```

#### Acceptance Criteria
- [ ] All messaging entities defined
- [ ] Repository interface covers all operations
- [ ] Real-time streams defined
- [ ] Typing indicators supported
- [ ] Presence status supported

---

### Task 2.3: Messaging - Data & Presentation

**Estimated Time:** 5-6 days

#### Objectives
- Implement chat data sources
- Build chat UI components
- Implement real-time updates

*(Detailed implementation with message bubbles, chat input, conversations list)*

---

### Task 2.4: Push Notifications

**Estimated Time:** 3-4 days

#### Objectives
- Set up Firebase Cloud Messaging
- Implement notification handling
- Create in-app notification inbox
- Add notification preferences

#### Implementation Steps

1. **Create `lib/core/services/notification_service.dart`**
   ```dart
   import 'dart:async';
   import 'dart:convert';
   import 'dart:io';
   
   import 'package:firebase_messaging/firebase_messaging.dart';
   import 'package:flutter_local_notifications/flutter_local_notifications.dart';
   
   import '../logger/app_logger.dart';
   
   /// Notification payload structure.
   class NotificationPayload {
     final String id;
     final String title;
     final String body;
     final String? imageUrl;
     final Map<String, dynamic> data;
     final DateTime receivedAt;
     
     const NotificationPayload({
       required this.id,
       required this.title,
       required this.body,
       this.imageUrl,
       this.data = const {},
       required this.receivedAt,
     });
     
     factory NotificationPayload.fromRemoteMessage(RemoteMessage message) {
       return NotificationPayload(
         id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
         title: message.notification?.title ?? '',
         body: message.notification?.body ?? '',
         imageUrl: message.notification?.android?.imageUrl ??
             message.notification?.apple?.imageUrl,
         data: message.data,
         receivedAt: message.sentTime ?? DateTime.now(),
       );
     }
     
     /// Gets the deep link route from notification data.
     String? get deepLink => data['deep_link'] as String?;
     
     /// Gets the notification type.
     String? get type => data['type'] as String?;
   }
   
   /// Service for handling push and local notifications.
   /// 
   /// Features:
   /// - Firebase Cloud Messaging integration
   /// - Local notification display
   /// - Deep link handling
   /// - Foreground/background/terminated handling
   class NotificationService {
     static NotificationService? _instance;
     
     final FirebaseMessaging _fcm = FirebaseMessaging.instance;
     final FlutterLocalNotificationsPlugin _localNotifications =
         FlutterLocalNotificationsPlugin();
     
     final _notificationController = StreamController<NotificationPayload>.broadcast();
     final _tokenController = StreamController<String>.broadcast();
     
     String? _fcmToken;
     
     NotificationService._();
     
     /// Gets the singleton instance.
     static NotificationService get instance {
       _instance ??= NotificationService._();
       return _instance!;
     }
     
     /// Current FCM token.
     String? get fcmToken => _fcmToken;
     
     /// Stream of received notifications.
     Stream<NotificationPayload> get notifications => _notificationController.stream;
     
     /// Stream of FCM token changes.
     Stream<String> get tokenChanges => _tokenController.stream;
     
     /// Initializes the notification service.
     /// 
     /// Should be called during app startup.
     Future<void> initialize() async {
       // Request permission
       final settings = await _fcm.requestPermission(
         alert: true,
         badge: true,
         sound: true,
         provisional: false,
         announcement: true,
         carPlay: true,
         criticalAlert: false,
       );
       
       AppLogger.info('Notification permission: ${settings.authorizationStatus}');
       
       if (settings.authorizationStatus != AuthorizationStatus.authorized &&
           settings.authorizationStatus != AuthorizationStatus.provisional) {
         AppLogger.warning('Notifications not authorized');
         return;
       }
       
       // Initialize local notifications
       await _initializeLocalNotifications();
       
       // Get initial token
       _fcmToken = await _fcm.getToken();
       if (_fcmToken != null) {
         AppLogger.info('FCM Token: $_fcmToken');
         _tokenController.add(_fcmToken!);
       }
       
       // Listen for token refresh
       _fcm.onTokenRefresh.listen((token) {
         _fcmToken = token;
         _tokenController.add(token);
         AppLogger.info('FCM Token refreshed: $token');
       });
       
       // Handle foreground messages
       FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
       
       // Handle background message taps
       FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
       
       // Check for initial message (app opened from terminated state)
       final initialMessage = await _fcm.getInitialMessage();
       if (initialMessage != null) {
         _handleMessageOpenedApp(initialMessage);
       }
     }
     
     Future<void> _initializeLocalNotifications() async {
       const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
       
       const iosSettings = DarwinInitializationSettings(
         requestAlertPermission: false,
         requestBadgePermission: false,
         requestSoundPermission: false,
       );
       
       const settings = InitializationSettings(
         android: androidSettings,
         iOS: iosSettings,
       );
       
       await _localNotifications.initialize(
         settings,
         onDidReceiveNotificationResponse: _handleNotificationResponse,
       );
       
       // Create notification channel for Android
       if (Platform.isAndroid) {
         const channel = AndroidNotificationChannel(
           'default_channel',
           'Default Notifications',
           description: 'Default notification channel',
           importance: Importance.high,
         );
         
         await _localNotifications
             .resolvePlatformSpecificImplementation<
                 AndroidFlutterLocalNotificationsPlugin>()
             ?.createNotificationChannel(channel);
       }
     }
     
     void _handleForegroundMessage(RemoteMessage message) {
       AppLogger.info('Foreground message received: ${message.messageId}');
       
       final payload = NotificationPayload.fromRemoteMessage(message);
       _notificationController.add(payload);
       
       // Show local notification
       _showLocalNotification(payload);
     }
     
     void _handleMessageOpenedApp(RemoteMessage message) {
       AppLogger.info('Message opened app: ${message.messageId}');
       
       final payload = NotificationPayload.fromRemoteMessage(message);
       _notificationController.add(payload);
     }
     
     void _handleNotificationResponse(NotificationResponse response) {
       AppLogger.info('Notification response: ${response.payload}');
       
       if (response.payload != null) {
         try {
           final data = jsonDecode(response.payload!) as Map<String, dynamic>;
           final payload = NotificationPayload(
             id: data['id'] as String? ?? '',
             title: data['title'] as String? ?? '',
             body: data['body'] as String? ?? '',
             data: data,
             receivedAt: DateTime.now(),
           );
           _notificationController.add(payload);
         } catch (e) {
           AppLogger.error('Failed to parse notification payload', error: e);
         }
       }
     }
     
     /// Shows a local notification.
     Future<void> _showLocalNotification(NotificationPayload payload) async {
       const androidDetails = AndroidNotificationDetails(
         'default_channel',
         'Default Notifications',
         channelDescription: 'Default notification channel',
         importance: Importance.high,
         priority: Priority.high,
         showWhen: true,
       );
       
       const iosDetails = DarwinNotificationDetails(
         presentAlert: true,
         presentBadge: true,
         presentSound: true,
       );
       
       const details = NotificationDetails(
         android: androidDetails,
         iOS: iosDetails,
       );
       
       await _localNotifications.show(
         payload.id.hashCode,
         payload.title,
         payload.body,
         details,
         payload: jsonEncode({
           'id': payload.id,
           'title': payload.title,
           'body': payload.body,
           ...payload.data,
         }),
       );
     }
     
     /// Subscribes to a topic for receiving targeted notifications.
     Future<void> subscribeToTopic(String topic) async {
       await _fcm.subscribeToTopic(topic);
       AppLogger.info('Subscribed to topic: $topic');
     }
     
     /// Unsubscribes from a topic.
     Future<void> unsubscribeFromTopic(String topic) async {
       await _fcm.unsubscribeFromTopic(topic);
       AppLogger.info('Unsubscribed from topic: $topic');
     }
     
     /// Clears the app badge count.
     Future<void> clearBadge() async {
       await _localNotifications
           .resolvePlatformSpecificImplementation<
               IOSFlutterLocalNotificationsPlugin>()
           ?.cancelAll();
     }
     
     /// Disposes resources.
     void dispose() {
       _notificationController.close();
       _tokenController.close();
     }
   }
   
   /// Background message handler (must be top-level function).
   /// 
   /// This is called when a message is received while the app is in background
   /// or terminated.
   @pragma('vm:entry-point')
   Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
     // Handle background message
     // Note: This runs in a separate isolate, so you have limited access
     // to app state. Store data for later processing if needed.
     print('Background message: ${message.messageId}');
   }
   ```

2. **Create `lib/features/notifications/domain/entities/app_notification.dart`**
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';
   
   part 'app_notification.freezed.dart';
   part 'app_notification.g.dart';
   
   /// Notification types.
   enum NotificationType {
     /// New message received.
     message,
     
     /// Someone followed the user.
     follow,
     
     /// Someone liked a post.
     like,
     
     /// Someone commented on a post.
     comment,
     
     /// Someone mentioned the user.
     mention,
     
     /// System announcement.
     system,
     
     /// Promotional notification.
     promo,
   }
   
   /// In-app notification entity.
   @freezed
   class AppNotification with _$AppNotification {
     const AppNotification._();
     
     @JsonSerializable(fieldRename: FieldRename.snake)
     const factory AppNotification({
       /// Unique notification ID.
       required String id,
       
       /// Notification type.
       required NotificationType type,
       
       /// Notification title.
       required String title,
       
       /// Notification body/content.
       required String body,
       
       /// Image URL for rich notifications.
       String? imageUrl,
       
       /// Deep link to navigate to when tapped.
       String? deepLink,
       
       /// Whether the notification has been read.
       @Default(false) bool isRead,
       
       /// Related entity ID (user, post, etc.).
       String? entityId,
       
       /// Related entity type.
       String? entityType,
       
       /// Sender user ID (for social notifications).
       String? senderId,
       
       /// When the notification was created.
       required DateTime createdAt,
       
       /// Additional metadata.
       @Default({}) Map<String, dynamic> metadata,
     }) = _AppNotification;
     
     factory AppNotification.fromJson(Map<String, dynamic> json) =>
         _$AppNotificationFromJson(json);
     
     /// Gets the icon for this notification type.
     String get icon {
       switch (type) {
         case NotificationType.message:
           return '💬';
         case NotificationType.follow:
           return '👤';
         case NotificationType.like:
           return '❤️';
         case NotificationType.comment:
           return '💭';
         case NotificationType.mention:
           return '@';
         case NotificationType.system:
           return 'ℹ️';
         case NotificationType.promo:
           return '🎉';
       }
     }
   }
   ```

#### Acceptance Criteria
- [ ] Push notifications received on all states
- [ ] Local notifications display correctly
- [ ] Deep links work from notifications
- [ ] Token is sent to backend
- [ ] In-app inbox shows all notifications

---

### Task 2.5: Search System

**Estimated Time:** 3-4 days

#### Objectives
- Implement full-text search
- Add filters and sorting
- Create search UI
- Add recent searches

*(Detailed implementation with search service and UI)*

---

## 📊 Phase 2 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 2.1 Real-time Infrastructure | ⬜ | |
| 2.2 Messaging Domain Layer | ⬜ | |
| 2.3 Messaging Data & Presentation | ⬜ | |
| 2.4 Push Notifications | ⬜ | |
| 2.5 Search System | ⬜ | |

---

## 🔗 Dependencies for Next Phase

Phase 3 requires the following from Phase 2:
- ✅ Real-time infrastructure for payment events
- ✅ Notification system for payment confirmations
- ✅ Messaging for admin communication

---

## 📝 Notes

- WebSocket should reconnect automatically on network changes
- Messages should be sent optimistically
- Notifications should respect user preferences
- Search should work offline with cached results
