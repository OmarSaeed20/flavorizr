// lib/core/network/websocket/websocket_manager.dart
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/websocket/websocket_client.dart';
import 'package:fast_golden_taxi/core/network/websocket/websocket_event_handler.dart';

/// Manages the WebSocket connection lifecycle.
///
/// Features:
/// - Automatic reconnection on network changes
/// - App lifecycle management (pause/resume)
/// - Centralized event handling
/// - Connection health monitoring
///
/// Usage:
/// ```dart
/// final manager = WebSocketManager.instance;
/// await manager.initialize(authToken: 'your-token');
///
/// manager.eventHandler.on('message.new', (data) {
///   print('New message: $data');
/// });
///
/// manager.send('chat.message', {'text': 'Hello'});
/// ```
class WebSocketManager {
  /// Private constructor.
  WebSocketManager._() : _client = WebSocketClient() {
    _eventHandler = WebSocketEventHandler(_client);
  }
  static WebSocketManager? _instance;

  final WebSocketClient _client;
  late final WebSocketEventHandler _eventHandler;

  StreamSubscription? _connectivitySubscription;
  bool _initialized = false;
  bool _appInForeground = true;
  String? _authToken;

  /// Gets the singleton instance.
  static WebSocketManager get instance {
    _instance ??= WebSocketManager._();
    return _instance!;
  }

  /// The underlying WebSocket client.
  WebSocketClient get client => _client;

  /// The event handler for registering callbacks.
  WebSocketEventHandler get eventHandler => _eventHandler;

  /// Current connection state.
  WebSocketState get state => _client.state;

  /// Whether the connection is active.
  bool get isConnected => _client.isConnected;

  /// Stream of connection state changes.
  Stream<WebSocketState> get stateChanges => _client.stateChanges;

  /// Initializes the WebSocket manager.
  ///
  /// [authToken] - JWT token for authentication.
  /// [autoReconnectOnNetworkChange] - Whether to automatically reconnect when network changes.
  Future<void> initialize({
    required String authToken,
    bool autoReconnectOnNetworkChange = true,
  }) async {
    if (_initialized) {
      AppLogger.instance.logWarning('WebSocketManager already initialized');
      return;
    }

    _authToken = authToken;

    if (autoReconnectOnNetworkChange) {
      _setupConnectivityListener();
    }

    await _client.connect(authToken: authToken);
    _initialized = true;

    AppLogger.instance.logInfo('WebSocketManager initialized');
  }

  /// Updates the auth token and reconnects.
  Future<void> updateAuthToken(String authToken) async {
    _authToken = authToken;
    if (_initialized && _appInForeground) {
      await _client.reconnect();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) => result != ConnectivityResult.none);

    AppLogger.instance.logDebug(
      'Connectivity changed',
      data: {'hasConnection': hasConnection, 'results': results.map((e) => e.name).toList()},
    );

    if (hasConnection && !_client.isConnected && _appInForeground && _authToken != null) {
      AppLogger.instance.logInfo('Network restored, reconnecting WebSocket');
      _client.reconnect();
    }
  }

  /// Called when the app enters the foreground.
  void onAppResumed() {
    _appInForeground = true;
    AppLogger.instance.logDebug('App resumed');

    if (_initialized && !_client.isConnected && _authToken != null) {
      _client.reconnect();
    }
  }

  /// Called when the app enters the background.
  void onAppPaused() {
    _appInForeground = false;
    AppLogger.instance.logDebug('App paused');
    // Optionally disconnect to save battery
    // _client.disconnect();
  }

  /// Sends a message through the WebSocket.
  ///
  /// [type] - The event type.
  /// [data] - The payload data.
  void send(String type, Map<String, dynamic> data) {
    _client.send(type: type, data: data);
  }

  /// Disconnects and resets the manager.
  Future<void> disconnect() async {
    await _client.disconnect();
    _eventHandler.clearAllHandlers();
  }

  /// Disposes all resources.
  ///
  /// Should be called when the app is shutting down.
  void dispose() {
    _connectivitySubscription?.cancel();
    _eventHandler.dispose();
    _client.dispose();
    _instance = null;
    _initialized = false;
  }
}
