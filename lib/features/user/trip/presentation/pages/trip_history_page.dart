// lib/features/trip/presentation/pages/trip_history_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/user/trip/presentation/controllers/trip_history_controller.dart';
import 'package:fast_golden_taxi/features/user/trip/presentation/providers/trip_providers.dart';
import 'package:fast_golden_taxi/features/user/trip/presentation/widgets/trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Trip history page showing past trips.
///
/// Features:
/// - Display list of past trips
/// - Filter by status
/// - Pagination support
/// - Pull to refresh
class TripHistoryPage extends ConsumerStatefulWidget {
  const TripHistoryPage({super.key});

  @override
  ConsumerState<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends ConsumerState<TripHistoryPage> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Load trip history when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripHistoryControllerProvider.notifier).loadTripHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripHistoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              setState(() {
                _selectedStatus = status == 'all' ? null : status;
              });
              ref
                  .read(tripHistoryControllerProvider.notifier)
                  .loadTripHistory(status: _selectedStatus);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Trips')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
              const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
              const PopupMenuItem(value: 'failed', child: Text('Failed')),
            ],
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, state)),
    );
  }

  Widget _buildBody(BuildContext context, TripHistoryState state) {
    if (state.isLoading && state.trips.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No trip history',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your completed trips will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
          ref.read(tripHistoryControllerProvider.notifier).loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tripHistoryControllerProvider.notifier).refresh();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.trips.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.trips.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final trip = state.trips[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TripCard(
                trip: trip,
                onTap: () {
                  context.push('${Routes.tripDetail}/${trip.id}');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
