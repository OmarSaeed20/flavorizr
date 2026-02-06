// lib/features/trip/presentation/pages/trip_orders_page.dart
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/user/trip/presentation/controllers/trip_order_controller.dart';
import 'package:flavorizr/features/user/trip/presentation/providers/trip_providers.dart';
import 'package:flavorizr/features/user/trip/presentation/widgets/trip_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Trip orders page showing user's booking orders.
///
/// Features:
/// - Display list of trip orders
/// - Filter by status
/// - Pagination support
/// - Pull to refresh
class TripOrdersPage extends ConsumerStatefulWidget {
  const TripOrdersPage({super.key});

  @override
  ConsumerState<TripOrdersPage> createState() => _TripOrdersPageState();
}

class _TripOrdersPageState extends ConsumerState<TripOrdersPage> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Load orders when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripOrderControllerProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripOrderControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              setState(() {
                _selectedStatus = status == 'all' ? null : status;
              });
              ref.read(tripOrderControllerProvider.notifier).loadOrders(status: _selectedStatus);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Orders')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'confirmed', child: Text('Confirmed')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
              const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, state)),
    );
  }

  Widget _buildBody(BuildContext context, TripOrderState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('No orders yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Your trip orders will appear here',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
          ref.read(tripOrderControllerProvider.notifier).loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tripOrderControllerProvider.notifier).refresh();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.orders.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.orders.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final order = state.orders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TripOrderCard(
                order: order,
                onTap: () {
                  context.push('${Routes.tripDetail}/${order.tripId}');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
