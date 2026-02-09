import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/notification/data/parameters/get_notifications_parameters.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/entities/notification.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/usecases/get_notification_count_usecase.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:fast_golden_taxi/features/user/notification/domain/usecases/mark_as_read_usecase.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationController extends StateNotifier<NotificationState> {
  NotificationController(
    this._getNotificationsUseCase,
    this._getNotificationCountUseCase,
    this._markAsReadUseCase,
    this._markAllAsReadUseCase,
  ) : super(const NotificationState.initial());

  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetNotificationCountUseCase _getNotificationCountUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  /// Loads notifications
  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      state = const NotificationState.loading();
    } else if (state.isLoading || !_hasMore) {
      return;
    }

    final result = await _getNotificationsUseCase(
      GetNotificationsParameters(page: _currentPage, limit: _pageSize),
    );

    result.when(
      success: (data, _) {
        final newNotifications = data;
        _hasMore = newNotifications.length >= _pageSize;
        _currentPage++;

        if (refresh) {
          state = NotificationState.loaded(notifications: newNotifications, hasMore: _hasMore);
        } else {
          state = NotificationState.loaded(
            notifications: [...state.notifications, ...newNotifications],
            hasMore: _hasMore,
          );
        }
      },
      exception: (error) {
        state = NotificationState.error(error.message);
      },
    );
  }

  /// Loads notification count
  Future<void> loadNotificationCount() async {
    final result = await _getNotificationCountUseCase(const NoParams());
    result.when(
      success: (data, _) {
        state = state.copyWith(unreadCount: data);
      },
      exception: (error) {
        // Handle error silently
      },
    );
  }

  /// Marks a notification as read
  Future<void> markAsRead(int notificationId) async {
    final result = await _markAsReadUseCase(notificationId);
    result.when(
      success: (_, __) {
        final updatedNotifications = state.notifications.map((n) {
          if (n.id == notificationId) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();
        state = state.copyWith(
          notifications: updatedNotifications,
          unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
        );
      },
      exception: (error) {
        // Handle error silently
      },
    );
  }

  /// Marks all notifications as read
  Future<void> markAllAsRead() async {
    final result = await _markAllAsReadUseCase(const NoParams());
    result.when(
      success: (_, __) {
        final updatedNotifications = state.notifications.map((n) {
          return n.copyWith(isRead: true);
        }).toList();
        state = state.copyWith(notifications: updatedNotifications, unreadCount: 0);
      },
      exception: (error) {
        // Handle error silently
      },
    );
  }

  /// Refreshes notifications
  Future<void> refresh() async {
    await loadNotifications(refresh: true);
    await loadNotificationCount();
  }
}

class NotificationState {
  final List<Notification> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.hasMore = true,
    this.errorMessage,
  });

  const NotificationState.initial()
    : notifications = const [],
      unreadCount = 0,
      isLoading = false,
      hasMore = true,
      errorMessage = null;

  const NotificationState.loading()
    : notifications = const [],
      unreadCount = 0,
      isLoading = true,
      hasMore = true,
      errorMessage = null;

  const NotificationState.loaded({
    required this.notifications,
    required this.hasMore,
    this.unreadCount = 0,
  }) : isLoading = false,
       errorMessage = null;

  const NotificationState.error(this.errorMessage)
    : notifications = const [],
      unreadCount = 0,
      isLoading = false,
      hasMore = false;

  bool get isLoaded => notifications.isNotEmpty || !hasMore;
  bool get hasError => errorMessage != null;

  NotificationState copyWith({
    List<Notification>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? hasMore,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
