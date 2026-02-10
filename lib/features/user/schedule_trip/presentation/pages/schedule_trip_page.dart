import 'package:fast_golden_taxi/features/user/schedule_trip/presentation/providers/schedule_trip_providers.dart';
import 'package:fast_golden_taxi/features/user/schedule_trip/presentation/widgets/scheduled_trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for managing scheduled trips.
class ScheduleTripPage extends ConsumerStatefulWidget {
  const ScheduleTripPage({super.key});

  @override
  ConsumerState<ScheduleTripPage> createState() => _ScheduleTripPageState();
}

class _ScheduleTripPageState extends ConsumerState<ScheduleTripPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTrips();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTrips() {
    ref.read(scheduleTripControllerProvider.notifier).getScheduledTrips();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(scheduleTripControllerProvider.notifier).loadMoreTrips();
    }
  }

  void _onRefresh() {
    ref
        .read(scheduleTripControllerProvider.notifier)
        .getScheduledTrips(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleTripControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create scheduled trip page
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _onRefresh();
        },
        child: state.isLoadingTrips && state.scheduledTrips.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(state.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadTrips,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.scheduledTrips.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No scheduled trips',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to create scheduled trip page
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Schedule a Trip'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount:
                    state.scheduledTrips.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < state.scheduledTrips.length) {
                    final trip = state.scheduledTrips[index];
                    return ScheduledTripCard(
                      trip: trip,
                      onTap: () {
                        // Navigate to trip details
                      },
                      onCancel: () {
                        ref
                            .read(scheduleTripControllerProvider.notifier)
                            .cancelScheduledTrip(trip.id);
                      },
                      isCancelling: state.isCancellingTrip,
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
      ),
    );
  }
}
