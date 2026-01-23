// lib/core/network/websocket/websocket.dart
/// WebSocket module for real-time communication.
///
/// This module provides:
/// - [WebSocketClient] - Low-level WebSocket connection management
/// - [WebSocketEventHandler] - Event subscription and dispatching
/// - [WebSocketManager] - High-level lifecycle management
///
/// Usage:
/// ```dart
/// // Initialize the manager
/// await WebSocketManager.instance.initialize(authToken: token);
///
/// // Register event handlers
/// WebSocketManager.instance.eventHandler.on('message.new', (data) {
///   print('New message: $data');
/// });
///
/// // Send messages
/// WebSocketManager.instance.send('chat.typing', {'conversationId': '123'});
/// ```
library;

import 'package:flavorizr/core/network/websocket/websocket.dart'
    show WebSocketClient, WebSocketEventHandler, WebSocketManager;
import 'package:flavorizr/core/network/websocket/websocket_client.dart' show WebSocketClient;
import 'package:flavorizr/core/network/websocket/websocket_event_handler.dart'
    show WebSocketEventHandler;
import 'package:flavorizr/core/network/websocket/websocket_manager.dart' show WebSocketManager;

export 'websocket_client.dart';
export 'websocket_event_handler.dart';
export 'websocket_manager.dart';
