// ignore_for_file: unreachable_from_main

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flavorizr/core/logger/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Constants for notification configuration.
abstract final class NotificationConstants {
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'This channel is used for important notifications.';

  // Data keys
  static const String deepLinkKey = 'deep_link';
  static const String typeKey = 'type';
}

/// Notification payload structure.
final class NotificationPayload {
  const NotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.data,
    required this.receivedAt,
  });

  /// Creates a payload from a Firebase RemoteMessage.
  factory NotificationPayload.fromRemoteMessage(RemoteMessage message) {
    final notification = message.notification;
    return NotificationPayload(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: notification?.title ?? '',
      body: notification?.body ?? '',
      imageUrl:
          notification?.android?.imageUrl ?? notification?.apple?.imageUrl,
      data: Map<String, dynamic>.unmodifiable(message.data),
      receivedAt: message.sentTime ?? DateTime.now(),
    );
  }

  /// Creates from JSON map with validation.
  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final body = json['body'];
    final receivedAt = json['receivedAt'];

    if (id is! String ||
        title is! String ||
        body is! String ||
        receivedAt is! String) {
      throw const FormatException('Invalid notification payload format');
    }

    return NotificationPayload(
      id: id,
      title: title,
      body: body,
      imageUrl: json['imageUrl'] as String?,
      data: Map<String, dynamic>.unmodifiable(
        json['data'] as Map<String, dynamic>? ?? const {},
      ),
      receivedAt: DateTime.parse(receivedAt),
    );
  }

  /// Unique notification ID.
  final String id;

  /// Notification title.
  final String title;

  /// Notification body.
  final String body;

  /// Optional image URL.
  final String? imageUrl;

  /// Additional data payload (unmodifiable).
  final Map<String, dynamic> data;

  /// When the notification was received.
  final DateTime receivedAt;

  /// Gets the deep link route from notification data.
  String? get deepLink => data[NotificationConstants.deepLinkKey] as String?;

  /// Gets the notification type.
  String? get type => data[NotificationConstants.typeKey] as String?;

  /// Whether this notification has a deep link.
  bool get hasDeepLink => deepLink != null && deepLink!.isNotEmpty;

  /// Converts to JSON map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    if (imageUrl != null) 'imageUrl': imageUrl,
    'data': data,
    'receivedAt': receivedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPayload &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NotificationPayload(id: $id, title: $title)';
}

/// Service for handling push and local notifications.
///
/// Features:
/// - Firebase Cloud Messaging integration
/// - Local notification display
/// - Deep link handling
/// - Foreground/background/terminated handling
/// - Memory-efficient stream management
/// - Automatic subscription cleanup
final class NotificationService {
  NotificationService._();
  static NotificationService? _instance;

  // Lazy initialization of heavy objects
  late final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Stream controllers with broadcast capability
  StreamController<NotificationPayload>? _notificationController;
  StreamController<String>? _tokenController;

  // Subscription management to prevent memory leaks
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  String? _fcmToken;
  bool _isInitialized = false;
  AuthorizationStatus? _authorizationStatus;

  // Cached notification details for reuse
  static const _androidNotificationDetails = AndroidNotificationDetails(
    NotificationConstants.channelId,
    NotificationConstants.channelName,
    channelDescription: NotificationConstants.channelDescription,
    importance: Importance.high,
    priority: Priority.high,
  );

  static const _darwinNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _darwinNotificationDetails,
    macOS: _darwinNotificationDetails,
  );

  /// Gets the singleton instance.
  static NotificationService get instance =>
      _instance ??= NotificationService._();

  /// Current FCM token.
  String? get fcmToken => _fcmToken;

  /// Whether the service is initialized.
  bool get isInitialized => _isInitialized;

  /// Current authorization status.
  AuthorizationStatus? get authorizationStatus => _authorizationStatus;

  /// Whether notifications are authorized.
  bool get isAuthorized =>
      _authorizationStatus == AuthorizationStatus.authorized ||
      _authorizationStatus == AuthorizationStatus.provisional;

  /// Stream of received notifications (lazy initialized).
  Stream<NotificationPayload> get notifications {
    _notificationController ??=
        StreamController<NotificationPayload>.broadcast();
    return _notificationController!.stream;
  }

  /// Stream of FCM token changes (lazy initialized).
  Stream<String> get tokenChanges {
    _tokenController ??= StreamController<String>.broadcast();
    return _tokenController!.stream;
  }

  /// Initializes the notification service.
  ///
  /// Should be called during app startup.
  /// Returns `true` if initialization was successful.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request permission
      final settings = await _fcm.requestPermission();

      _authorizationStatus = settings.authorizationStatus;
      AppLogger.i('Notification permission status: $_authorizationStatus');

      if (!isAuthorized) {
        AppLogger.w('Notification permission not granted');
        return false;
      }

      // Initialize in parallel where possible
      await Future.wait([
        _initializeLocalNotifications(),
        _initializeFcmToken(),
      ]);

      // Set up message listeners
      _setupMessageListeners();

      // Check for initial message (app opened from terminated state)
      await _handleInitialMessage();

      _isInitialized = true;
      AppLogger.i('NotificationService initialized successfully');
      return true;
    } catch (e, s) {
      AppLogger.e('Failed to initialize NotificationService', e, s);
      return false;
    }
  }

  Future<void> _initializeFcmToken() async {
    _fcmToken = await _fcm.getToken();
    AppLogger.i('FCM Token obtained: ${_fcmToken?.substring(0, 20)}...');

    // Listen for token refresh
    final tokenSubscription = _fcm.onTokenRefresh.listen((token) {
      _fcmToken = token;
      _tokenController?.add(token);
      AppLogger.i('FCM Token refreshed');
    }, onError: (Object e) => AppLogger.e('Token refresh error', e));
    _subscriptions.add(tokenSubscription);
  }

  void _setupMessageListeners() {
    // Handle foreground messages
    final foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
      onError: (Object e) => AppLogger.e('Foreground message error', e),
    );
    _subscriptions.add(foregroundSubscription);

    // Handle message opened app
    final openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleMessageOpenedApp,
      onError: (Object e) => AppLogger.e('Message opened app error', e),
    );
    _subscriptions.add(openedAppSubscription);
  }

  Future<void> _handleInitialMessage() async {
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      // Delay to ensure app is ready to handle navigation
      await Future<void>.delayed(const Duration(milliseconds: 500));
      _handleMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        NotificationConstants.channelId,
        NotificationConstants.channelName,
        description: NotificationConstants.channelDescription,
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.d('Foreground message received: ${message.messageId}');

    final payload = NotificationPayload.fromRemoteMessage(message);
    _notificationController?.add(payload);

    // Show local notification
    _showLocalNotification(payload);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    AppLogger.d('Message opened app: ${message.messageId}');

    final payload = NotificationPayload.fromRemoteMessage(message);
    _notificationController?.add(payload);
  }

  void _handleNotificationResponse(NotificationResponse response) {
    AppLogger.d('Notification response received');

    final payloadString = response.payload;
    if (payloadString == null || payloadString.isEmpty) return;

    try {
      final data = jsonDecode(payloadString) as Map<String, dynamic>;
      final payload = NotificationPayload.fromJson(data);
      _notificationController?.add(payload);
    } on FormatException catch (e) {
      AppLogger.e('Failed to parse notification payload', e);
    }
  }

  /// Shows a local notification.
  Future<void> _showLocalNotification(NotificationPayload payload) async {
    try {
      await _localNotifications.show(
        payload.id.hashCode,
        payload.title,
        payload.body,
        _notificationDetails,
        payload: jsonEncode(payload.toJson()),
      );
    } catch (e) {
      AppLogger.e('Failed to show local notification', e);
    }
  }

  /// Shows a custom local notification.
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final payload = NotificationPayload(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      data: data ?? const {},
      receivedAt: DateTime.now(),
    );

    await _showLocalNotification(payload);
  }

  /// Subscribes to a topic for receiving targeted notifications.
  Future<bool> subscribeToTopic(String topic) async {
    if (topic.isEmpty) {
      AppLogger.w('Cannot subscribe to empty topic');
      return false;
    }

    try {
      await _fcm.subscribeToTopic(topic);
      AppLogger.i('Subscribed to topic: $topic');
      return true;
    } catch (e) {
      AppLogger.e('Failed to subscribe to topic: $topic', e);
      return false;
    }
  }

  /// Unsubscribes from a topic.
  Future<bool> unsubscribeFromTopic(String topic) async {
    if (topic.isEmpty) {
      AppLogger.w('Cannot unsubscribe from empty topic');
      return false;
    }

    try {
      await _fcm.unsubscribeFromTopic(topic);
      AppLogger.i('Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      AppLogger.e('Failed to unsubscribe from topic: $topic', e);
      return false;
    }
  }

  /// Sets the foreground notification presentation options (iOS).
  Future<void> setForegroundNotificationPresentationOptions({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  }) async {
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
  }

  /// Gets the APNs token (iOS only).
  Future<String?> getAPNsToken() async {
    if (!Platform.isIOS) return null;
    return _fcm.getAPNSToken();
  }

  /// Clears the app badge count (iOS only).
  Future<void> clearBadge() async {
    if (!Platform.isIOS) return;

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(badge: true);
  }

  /// Cancels a specific notification by its ID.
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancels a notification by payload ID.
  Future<void> cancelNotificationByPayloadId(String payloadId) async {
    await _localNotifications.cancel(payloadId.hashCode);
  }

  /// Cancels all notifications.
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Gets pending notifications.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _localNotifications.pendingNotificationRequests();
  }

  /// Gets the count of pending notifications.
  Future<int> getPendingNotificationCount() async {
    final pending = await _localNotifications.pendingNotificationRequests();
    return pending.length;
  }

  /// Gets active notifications (Android only).
  Future<List<ActiveNotification>> getActiveNotifications() async {
    if (!Platform.isAndroid) return const [];

    return await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.getActiveNotifications() ??
        const [];
  }

  /// Resets the singleton instance (useful for testing).
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }

  /// Disposes resources and cancels all subscriptions.
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Close stream controllers
    _notificationController?.close();
    _notificationController = null;

    _tokenController?.close();
    _tokenController = null;

    _isInitialized = false;
    AppLogger.d('NotificationService disposed');
  }
}

/// Background message handler (must be top-level function).
///
/// This is called when a message is received while the app is in background
/// or terminated. Runs in a separate isolate with limited app state access.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  // Note: This runs in a separate isolate, so you have limited access
  // to app state. Store data for later processing if needed.
  AppLogger.d('Background message received: ${message.messageId}');
}

/// Background notification response handler (must be top-level function).
///
/// Called when user taps a notification while app is in background.
@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) {
  // Handle background notification tap
  // Note: Limited access to app state in background context
  AppLogger.d('Background notification response: ${response.id}');
}
