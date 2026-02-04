import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/driver_home_controller.dart';
import '../providers/driver_home_providers.dart';
import '../widgets/driver_stats_card.dart';
import '../widgets/driver_earnings_card.dart';
import '../widgets/driver_trip_card.dart';
import '../widgets/online_status_switch.dart';

/// Driver home page
class DriverHomePage extends ConsumerStatefulWidget {
  const DriverHomePage({super.key});

  @override
  ConsumerState<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends ConsumerState<DriverHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    ref.read(driverHomeControllerProvider.notifier).loadHomeData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(driverHomeControllerProvider.notifier).loadTrips();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(driverHomeControllerProvider.notifier).loadHomeData();
    await ref.read(driverHomeControllerProvider.notifier).loadTrips(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverHomeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: state.isLoading && state.homeData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Online Status Switch
                    const OnlineStatusSwitch(),
                    const SizedBox(height: 16),

                    // Stats Card
                    if (state.stats != null) ...[
                      DriverStatsCard(stats: state.stats!),
                      const SizedBox(height: 16),
                    ],

                    // Earnings Card
                    if (state.earnings != null) ...[
                      DriverEarningsCard(earnings: state.earnings!),
                      const SizedBox(height: 16),
                    ],

                    // Recent Trips Section
                    const Text(
                      'Recent Trips',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Trips List
                    if (state.trips.isEmpty && !state.isLoadingTrips)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No trips yet'),
                        ),
                      )
                    else
                      ...state.trips.map((trip) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DriverTripCard(trip: trip),
                          )),

                    // Loading indicator for pagination
                    if (state.isLoadingTrips)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),

                    // Error message
                    if (state.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}