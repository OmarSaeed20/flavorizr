// lib/core/network/websocket/websocket_client.dart
import 'dart:async';
import 'dart:convert';

import 'package:flavorizr/config/app_config.dart';
import 'package:flavorizr/core/logger/advanced_app_logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  const WebSocketConfig({
    required this.url,
    this.initialReconnectDelay = 1000,
    this.maxReconnectDelay = 30000,
    this.maxReconnectAttempts = 10,
    this.pingIntervalSeconds = 30,
    this.connectionTimeoutSeconds = 10,
  });

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

  /// Connection timeout in seconds.
  final int connectionTimeoutSeconds;

  /// Creates a copy with modified values.
  WebSocketConfig copyWith({
    String? url,
    int? initialReconnectDelay,
    int? maxReconnectDelay,
    int? maxReconnectAttempts,
    int? pingIntervalSeconds,
    int? connectionTimeoutSeconds,
  }) {
    return WebSocketConfig(
      url: url ?? this.url,
      initialReconnectDelay: initialReconnectDelay ?? this.initialReconnectDelay,
      maxReconnectDelay: maxReconnectDelay ?? this.maxReconnectDelay,
      maxReconnectAttempts: maxReconnectAttempts ?? this.maxReconnectAttempts,
      pingIntervalSeconds: pingIntervalSeconds ?? this.pingIntervalSeconds,
      connectionTimeoutSeconds: connectionTimeoutSeconds ?? this.connectionTimeoutSeconds,
    );
  }
}

/// WebSocket event received from the server.
class WebSocketEvent {
  const WebSocketEvent({
    required this.type,
    required this.data,
    required this.receivedAt,
    this.eventId,
  });

  /// Creates an event from a JSON map.
  factory WebSocketEvent.fromJson(Map<String, dynamic> json) {
    return WebSocketEvent(
      type: json['type'] as String? ?? 'unknown',
      data: json['data'] as Map<String, dynamic>? ?? json,
      receivedAt: DateTime.now(),
      eventId: json['event_id'] as String? ?? json['id'] as String?,
    );
  }

  /// Event type (e.g., 'message', 'typing', 'presence').
  final String type;

  /// Event payload data.
  final Map<String, dynamic> data;

  /// Timestamp when the event was received.
  final DateTime receivedAt;

  /// Optional event ID for deduplication.
  final String? eventId;

  /// Converts the event to a JSON map.
  Map<String, dynamic> toJson() => {
    'type': type,
    'data': data,
    'event_id': eventId,
    'received_at': receivedAt.toIso8601String(),
  };

  @override
  String toString() => 'WebSocketEvent(type: $type, eventId: $eventId)';
}

/// Manages WebSocket connections with automatic reconnection.
///
/// Features:
/// - Automatic reconnection with exponential backoff
/// - Connection state monitoring
/// - Event dispatching
/// - Keep-alive pings
/// - Message queuing during reconnection
/// - Connection timeout handling
///
/// Usage:
/// ```dart
/// final client = WebSocketClient();
/// await client.connect(authToken: 'your-token');
///
/// client.events.listen((event) {
///   print('Received: ${event.type}');
/// });
///
/// client.send(type: 'message', data: {'text': 'Hello'});
/// ```
class WebSocketClient {
  /// Creates a WebSocket client with the given configuration.
  WebSocketClient({WebSocketConfig? config})
    : _config = config ?? WebSocketConfig(url: AppConfig.instance.wsBaseUrl);
  final WebSocketConfig _config;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _connectionTimer;

  int _reconnectAttempts = 0;
  bool _isManualClose = false;
  String? _authToken;

  final _stateController = StreamController<WebSocketState>.broadcast();
  final _eventController = StreamController<WebSocketEvent>.broadcast();
  final _errorController = StreamController<Object>.broadcast();
  final _messageQueue = <Map<String, dynamic>>[];

  WebSocketState _state = WebSocketState.disconnected;

  /// Current connection state.
  WebSocketState get state => _state;

  /// Stream of connection state changes.
  Stream<WebSocketState> get stateChanges => _stateController.stream;

  /// Stream of events received from the server.
  Stream<WebSocketEvent> get events => _eventController.stream;

  /// Stream of connection errors.
  Stream<Object> get errors => _errorController.stream;

  /// Whether the connection is currently active.
  bool get isConnected => _state == WebSocketState.connected;

  /// Whether the client is attempting to connect or reconnect.
  bool get isConnecting =>
      _state == WebSocketState.connecting || _state == WebSocketState.reconnecting;

  /// Current number of reconnection attempts.
  int get reconnectAttempts => _reconnectAttempts;

  /// Number of messages waiting in the queue.
  int get queuedMessageCount => _messageQueue.length;

  /// Connects to the WebSocket server.
  ///
  /// [authToken] - JWT token for authentication.
  /// Returns a Future that completes when connected or throws on failure.
  Future<void> connect({required String authToken}) async {
    if (_state == WebSocketState.connected || _state == WebSocketState.connecting) {
      AppLogger.instance.logDebug('WebSocket already connected or connecting');
      return;
    }

    _authToken = authToken;
    _isManualClose = false;
    _reconnectAttempts = 0;

    await _connect();
  }

  Future<void> _connect() async {
    _setState(WebSocketState.connecting);

    try {
      final uri = Uri.parse(
        _config.url,
      ).replace(queryParameters: {'token': _authToken, 'client': 'flutter', 'version': '1.0.0'});

      AppLogger.instance.logDebug('WebSocket connecting to: ${uri.host}');

      // Set connection timeout
      final completer = Completer<void>();
      _connectionTimer = Timer(Duration(seconds: _config.connectionTimeoutSeconds), () {
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('WebSocket connection timeout'));
        }
      });

      _channel = WebSocketChannel.connect(uri);

      // Wait for the channel to be ready
      await _channel!.ready;

      _connectionTimer?.cancel();
      _connectionTimer = null;

      if (!completer.isCompleted) {
        completer.complete();
      }

      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _reconnectAttempts = 0;
      _setState(WebSocketState.connected);
      _startPingTimer();
      _flushMessageQueue();

      AppLogger.instance.logInfo('WebSocket connected successfully');
    } on TimeoutException catch (e) {
      AppLogger.instance.logError('WebSocket connection timeout', data: {'error': e.toString()});
      _errorController.add(e);
      _scheduleReconnect();
    } catch (e, s) {
      AppLogger.instance.logError(
        'WebSocket connection failed',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
      _errorController.add(e);
      _scheduleReconnect();
    }
  }

  void _setState(WebSocketState newState) {
    if (_state != newState) {
      final oldState = _state;
      _state = newState;
      _stateController.add(newState);
      AppLogger.instance.logDebug('WebSocket state: $oldState -> $newState');
    }
  }

  void _onMessage(dynamic data) {
    try {
      final json = jsonDecode(data as String) as Map<String, dynamic>;

      // Handle pong response
      if (json['type'] == 'pong') {
        AppLogger.instance.logDebug('WebSocket pong received');
        return;
      }

      // Handle error responses from server
      if (json['type'] == 'error') {
        final errorMessage = json['message'] as String? ?? 'Unknown server error';
        AppLogger.instance.logWarning('WebSocket server error: $errorMessage');
        _errorController.add(Exception(errorMessage));
        return;
      }

      final event = WebSocketEvent.fromJson(json);
      AppLogger.instance.logDebug('WebSocket event received: ${event.type}');
      _eventController.add(event);
    } catch (e, s) {
      AppLogger.instance.logError(
        'Failed to parse WebSocket message',
        data: {'error': e.toString()},
        stackTrace: s.toString(),
      );
    }
  }

  void _onError(Object error) {
    AppLogger.instance.logError('WebSocket error', data: {'error': error.toString()});
    _errorController.add(error);

    if (!_isManualClose) {
      _scheduleReconnect();
    }
  }

  void _onDone() {
    AppLogger.instance.logInfo('WebSocket connection closed');

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
      AppLogger.instance.logWarning(
        'WebSocket reconnection stopped: ${_isManualClose ? "manual close" : "max attempts reached"}',
      );
      return;
    }

    _setState(WebSocketState.reconnecting);

    // Exponential backoff with jitter
    final delay = _calculateReconnectDelay();
    _reconnectAttempts++;

    AppLogger.instance.logInfo(
      'WebSocket reconnecting in ${delay}ms (attempt $_reconnectAttempts/${_config.maxReconnectAttempts})',
    );

    _reconnectTimer = Timer(Duration(milliseconds: delay), _connect);
  }

  int _calculateReconnectDelay() {
    final exponentialDelay = _config.initialReconnectDelay * (1 << _reconnectAttempts);
    final cappedDelay = exponentialDelay.clamp(
      _config.initialReconnectDelay,
      _config.maxReconnectDelay,
    );

    // Add jitter (±20%)
    final jitter = (cappedDelay * 0.2 * (DateTime.now().millisecond / 500 - 1)).round();

    return cappedDelay + jitter;
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: _config.pingIntervalSeconds), (_) => _sendPing());
  }

  void _sendPing() {
    if (isConnected) {
      send(type: 'ping', data: {'timestamp': DateTime.now().millisecondsSinceEpoch});
    }
  }

  void _flushMessageQueue() {
    while (_messageQueue.isNotEmpty && isConnected) {
      final message = _messageQueue.removeAt(0);
      _sendRaw(message);
    }

    if (_messageQueue.isNotEmpty) {
      AppLogger.instance.logDebug('${_messageQueue.length} messages still queued');
    }
  }

  void _cleanup() {
    _pingTimer?.cancel();
    _pingTimer = null;
    _connectionTimer?.cancel();
    _connectionTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _channel = null;
  }

  /// Sends a message through the WebSocket.
  ///
  /// If not connected, the message is queued and sent when connected.
  /// [type] - The event type (e.g., 'message', 'typing').
  /// [data] - The payload data.
  /// [queueIfDisconnected] - Whether to queue the message if disconnected (default: true).
  void send({
    required String type,
    required Map<String, dynamic> data,
    bool queueIfDisconnected = true,
  }) {
    final message = {
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'client_id': _generateClientId(),
    };

    if (isConnected) {
      _sendRaw(message);
    } else if (queueIfDisconnected) {
      _messageQueue.add(message);
      AppLogger.instance.logDebug('Message queued (connection not ready): $type');
    } else {
      AppLogger.instance.logWarning('Message dropped (not connected): $type');
    }
  }

  void _sendRaw(Map<String, dynamic> message) {
    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      AppLogger.instance.logError(
        'Failed to send WebSocket message',
        data: {'error': e.toString()},
      );
      _messageQueue.insert(0, message);
    }
  }

  String _generateClientId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_state.name}';
  }

  /// Manually triggers a reconnection attempt.
  ///
  /// Useful when the app comes back to foreground or network is restored.
  Future<void> reconnect() async {
    if (_authToken == null) {
      throw StateError('Cannot reconnect without auth token. Call connect() first.');
    }

    _isManualClose = false;
    _reconnectAttempts = 0;
    _cleanup();
    await _connect();
  }

  /// Disconnects from the WebSocket server.
  Future<void> disconnect() async {
    _isManualClose = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _cleanup();

    await _channel?.sink.close();
    _setState(WebSocketState.disconnected);

    AppLogger.instance.logInfo('WebSocket disconnected');
  }

  /// Clears the message queue.
  void clearQueue() {
    _messageQueue.clear();
  }

  /// Disposes resources.
  ///
  /// After calling dispose, the client cannot be reused.
  void dispose() {
    disconnect();
    _stateController.close();
    _eventController.close();
    _errorController.close();
    _messageQueue.clear();
  }
}
