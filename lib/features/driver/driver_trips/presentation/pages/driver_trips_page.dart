import 'package:fast_golden_taxi/features/driver/driver_trips/presentation/controllers/driver_trips_controller.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/presentation/providers/driver_trips_providers.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/presentation/widgets/pending_trip_card.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/presentation/widgets/trip_card.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/presentation/widgets/trip_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Driver trips page
class DriverTripsPage extends ConsumerStatefulWidget {
  const DriverTripsPage({super.key});

  @override
  ConsumerState<DriverTripsPage> createState() => _DriverTripsPageState();
}

class _DriverTripsPageState extends ConsumerState<DriverTripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    ref.read(driverTripsControllerProvider.notifier).loadTrips();
    ref.read(driverTripsControllerProvider.notifier).loadPendingTrips();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(driverTripsControllerProvider.notifier).loadTrips();
    }
  }

  Future<void> _onRefresh() async {
    await ref
        .read(driverTripsControllerProvider.notifier)
        .loadTrips(refresh: true);
    await ref.read(driverTripsControllerProvider.notifier).loadPendingTrips();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverTripsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Trips'),
            Tab(text: 'Pending Requests'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _onRefresh),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAllTripsTab(state), _buildPendingTripsTab(state)],
      ),
    );
  }

  Widget _buildAllTripsTab(DriverTripsState state) {
    return Column(
      children: [
        // Status filter chips
        Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TripFilterChip(
                  label: 'All',
                  isSelected: state.selectedStatus == null,
                  onTap: () {
                    ref
                        .read(driverTripsControllerProvider.notifier)
                        .filterByStatus(null);
                  },
                ),
                const SizedBox(width: 8),
                TripFilterChip(
                  label: 'Pending',
                  isSelected: state.selectedStatus == 'pending',
                  onTap: () {
                    ref
                        .read(driverTripsControllerProvider.notifier)
                        .filterByStatus('pending');
                  },
                ),
                const SizedBox(width: 8),
                TripFilterChip(
                  label: 'In Progress',
                  isSelected: state.selectedStatus == 'in_progress',
                  onTap: () {
                    ref
                        .read(driverTripsControllerProvider.notifier)
                        .filterByStatus('in_progress');
                  },
                ),
                const SizedBox(width: 8),
                TripFilterChip(
                  label: 'Completed',
                  isSelected: state.selectedStatus == 'completed',
                  onTap: () {
                    ref
                        .read(driverTripsControllerProvider.notifier)
                        .filterByStatus('completed');
                  },
                ),
                const SizedBox(width: 8),
                TripFilterChip(
                  label: 'Cancelled',
                  isSelected: state.selectedStatus == 'cancelled',
                  onTap: () {
                    ref
                        .read(driverTripsControllerProvider.notifier)
                        .filterByStatus('cancelled');
                  },
                ),
              ],
            ),
          ),
        ),

        // Trips list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: state.isLoading && state.trips.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.trips.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No trips found'),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                        state.trips.length + (state.hasMoreTrips ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.trips.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TripCard(trip: state.trips[index]),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingTripsTab(DriverTripsState state) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: state.isLoadingPending
          ? const Center(child: CircularProgressIndicator())
          : state.pendingTrips.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No pending trip requests',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.pendingTrips.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PendingTripCard(trip: state.pendingTrips[index]),
                );
              },
            ),
    );
  }
}
