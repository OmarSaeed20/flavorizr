// lib/core/network/websocket/websocket_event_handler.dart
import 'dart:async';
import 'dart:ui';

import 'package:fast_golden_taxi/core/logger/advanced_app_logger.dart';
import 'package:fast_golden_taxi/core/network/websocket/websocket_client.dart';

/// Callback type for WebSocket event handlers.
typedef WebSocketEventCallback = void Function(Map<String, dynamic> data);

/// Manages WebSocket event subscriptions and dispatching.
///
/// Allows registering handlers for specific event types and
/// automatically dispatches events to the appropriate handlers.
///
/// Supports:
/// - Multiple handlers per event type
/// - One-time handlers
/// - Wildcard handlers for all events
/// - Handler priority levels
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
/// // One-time handler
/// handler.once('user.connected', (data) {
///   print('User connected');
/// });
///
/// // Clean up
/// handler.dispose();
/// ```
class WebSocketEventHandler {
  /// Creates a new event handler for the given WebSocket client.
  WebSocketEventHandler(this._client) {
    _subscription = _client.events.listen(_dispatchEvent);
  }
  final WebSocketClient _client;
  final Map<String, List<_HandlerEntry>> _handlers = {};
  final List<_WildcardHandler> _wildcardHandlers = [];

  StreamSubscription? _subscription;

  /// Registers a handler for the specified event type.
  ///
  /// Multiple handlers can be registered for the same event type.
  /// Handlers are called in the order they were registered.
  ///
  /// [eventType] - The event type to listen for (e.g., 'message.new').
  /// [callback] - The function to call when the event is received.
  /// [priority] - Optional priority (higher = called first). Default is 0.
  ///
  /// Returns a function that can be called to unregister the handler.
  VoidCallback on(String eventType, WebSocketEventCallback callback, {int priority = 0}) {
    _handlers.putIfAbsent(eventType, () => []);

    final entry = _HandlerEntry(callback: callback, priority: priority);
    _handlers[eventType]!.add(entry);

    // Sort by priority (higher first)
    _handlers[eventType]!.sort((a, b) => b.priority.compareTo(a.priority));

    AppLogger.instance.logDebug(
      'Registered handler for event: $eventType',
      data: {'priority': priority},
    );

    return () => off(eventType, callback);
  }

  /// Registers a handler that listens to all events.
  ///
  /// Wildcard handlers are called for every event received.
  /// Useful for logging, analytics, or debugging.
  ///
  /// Returns a function that can be called to unregister the handler.
  VoidCallback onAny(WebSocketEventCallback callback) {
    final handler = _WildcardHandler(callback);
    _wildcardHandlers.add(handler);

    AppLogger.instance.logDebug('Registered wildcard handler');

    return () => _wildcardHandlers.remove(handler);
  }

  /// Unregisters a handler for the specified event type.
  void off(String eventType, WebSocketEventCallback callback) {
    _handlers[eventType]?.removeWhere((entry) => entry.callback == callback);

    if (_handlers[eventType]?.isEmpty ?? false) {
      _handlers.remove(eventType);
    }
  }

  /// Registers a one-time handler that automatically unregisters after firing.
  ///
  /// The handler will only be called once and then removed.
  VoidCallback once(String eventType, WebSocketEventCallback callback) {
    late VoidCallback unregister;

    unregister = on(eventType, (data) {
      callback(data);
      unregister();
    });

    return unregister;
  }

  /// Waits for a specific event and returns its data.
  ///
  /// [eventType] - The event type to wait for.
  /// [timeout] - Optional timeout duration. Throws TimeoutException if exceeded.
  /// [predicate] - Optional function to filter events.
  Future<Map<String, dynamic>> waitFor(
    String eventType, {
    Duration? timeout,
    bool Function(Map<String, dynamic> data)? predicate,
  }) async {
    final completer = Completer<Map<String, dynamic>>();

    VoidCallback? unregister;
    Timer? timeoutTimer;

    unregister = on(eventType, (data) {
      if (predicate == null || predicate(data)) {
        timeoutTimer?.cancel();
        unregister?.call();
        if (!completer.isCompleted) {
          completer.complete(data);
        }
      }
    });

    if (timeout != null) {
      timeoutTimer = Timer(timeout, () {
        unregister?.call();
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Timeout waiting for event: $eventType'));
        }
      });
    }

    return completer.future;
  }

  /// Clears all handlers for the specified event type.
  void clearHandlers(String eventType) {
    _handlers.remove(eventType);
    AppLogger.instance.logDebug('Cleared handlers for event: $eventType');
  }

  /// Clears all registered handlers.
  void clearAllHandlers() {
    _handlers.clear();
    _wildcardHandlers.clear();
    AppLogger.instance.logDebug('Cleared all handlers');
  }

  /// Returns true if there are handlers registered for the event type.
  bool hasHandlers(String eventType) {
    return _handlers[eventType]?.isNotEmpty ?? false;
  }

  /// Returns the number of handlers registered for the event type.
  int handlerCount(String eventType) {
    return _handlers[eventType]?.length ?? 0;
  }

  /// Returns all registered event types.
  List<String> get registeredEventTypes => _handlers.keys.toList();

  void _dispatchEvent(WebSocketEvent event) {
    // Call wildcard handlers first
    for (final handler in _wildcardHandlers) {
      try {
        handler.callback(event.data);
      } catch (e, s) {
        AppLogger.instance.logError(
          'Wildcard handler error',
          data: {'eventType': event.type, 'error': e.toString()},
          stackTrace: s.toString(),
        );
      }
    }

    // Call specific handlers
    final handlers = _handlers[event.type];

    if (handlers == null || handlers.isEmpty) {
      AppLogger.instance.logDebug('No handlers for event: ${event.type}', data: event.data);
      return;
    }

    for (final entry in handlers) {
      try {
        entry.callback(event.data);
      } catch (e, s) {
        AppLogger.instance.logError(
          'Event handler error',
          data: {'eventType': event.type, 'error': e.toString()},
          stackTrace: s.toString(),
        );
      }
    }
  }

  /// Disposes resources.
  ///
  /// After calling dispose, the handler cannot be reused.
  void dispose() {
    _subscription?.cancel();
    _handlers.clear();
    _wildcardHandlers.clear();
  }
}

/// Internal class to store handler with priority.
class _HandlerEntry {
  _HandlerEntry({required this.callback, required this.priority});
  final WebSocketEventCallback callback;
  final int priority;
}

/// Internal class for wildcard handlers.
class _WildcardHandler {
  _WildcardHandler(this.callback);
  final WebSocketEventCallback callback;
}
