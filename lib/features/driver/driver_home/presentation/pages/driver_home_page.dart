import 'package:flavorizr/features/driver/driver_home/presentation/providers/driver_home_providers.dart';
import 'package:flavorizr/features/driver/driver_home/presentation/widgets/driver_earnings_card.dart';
import 'package:flavorizr/features/driver/driver_home/presentation/widgets/driver_stats_card.dart';
import 'package:flavorizr/features/driver/driver_home/presentation/widgets/driver_trip_card.dart';
import 'package:flavorizr/features/driver/driver_home/presentation/widgets/online_status_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // No pagination needed - all data is loaded at once
  }

  Future<void> _onRefresh() async {
    await ref.read(driverHomeControllerProvider.notifier).loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverHomeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _onRefresh),
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
                    if (state.homeData != null)
                      DriverStatsCard(stats: state.homeData!.stats),
                    const SizedBox(height: 16),

                    // Earnings Card
                    if (state.homeData != null)
                      DriverEarningsCard(earnings: state.homeData!.earnings),
                    const SizedBox(height: 16),

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
                    if (state.homeData != null &&
                        state.homeData!.recentTrips.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No trips yet'),
                        ),
                      )
                    else if (state.homeData != null)
                      ...state.homeData!.recentTrips.map(
                        (trip) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DriverTripCard(trip: trip),
                        ),
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
