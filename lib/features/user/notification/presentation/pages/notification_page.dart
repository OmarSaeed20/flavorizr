import 'package:fast_golden_taxi/features/user/notification/presentation/providers/notification_providers.dart';
import 'package:fast_golden_taxi/features/user/notification/presentation/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load notifications when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationControllerProvider.notifier).refresh();
    });

    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationControllerProvider.notifier).loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notificationState.unreadCount > 0)
            TextButton.icon(
              onPressed: () {
                ref.read(notificationControllerProvider.notifier).markAllAsRead();
              },
              icon: const Icon(Icons.mark_email_read),
              label: const Text('Mark all read'),
            ),
        ],
      ),
      body: notificationState.isLoading && notificationState.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : notificationState.hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${notificationState.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(notificationControllerProvider.notifier).refresh();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(notificationControllerProvider.notifier).refresh();
              },
              child: notificationState.notifications.isEmpty
                  ? const Center(child: Text('No notifications'))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          notificationState.notifications.length +
                          (notificationState.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < notificationState.notifications.length) {
                          final notification = notificationState.notifications[index];
                          return NotificationItem(
                            notification: notification,
                            onTap: () {
                              ref
                                  .read(notificationControllerProvider.notifier)
                                  .markAsRead(notification.id);
                            },
                          );
                        } else {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
            ),
    );
  }
}
