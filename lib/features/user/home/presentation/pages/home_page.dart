import 'package:fast_golden_taxi/features/user/home/presentation/providers/home_providers.dart';
import 'package:fast_golden_taxi/features/user/home/presentation/widgets/advertisement_banner.dart';
import 'package:fast_golden_taxi/features/user/home/presentation/widgets/available_trip_card.dart';
import 'package:fast_golden_taxi/features/user/home/presentation/widgets/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load home data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Notification badge
          if (homeState.notificationCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Badge(
                label: Text(homeState.notificationCount.toString()),
                child: const Icon(Icons.notifications),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications_outlined),
            ),
        ],
      ),
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeState.hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${homeState.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(homeControllerProvider.notifier).refresh();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(homeControllerProvider.notifier).refresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banners Carousel
                    if (homeState.banners.isNotEmpty) BannerCarousel(banners: homeState.banners),

                    // Advertisements
                    if (homeState.advertisements.isNotEmpty)
                      AdvertisementBanner(advertisements: homeState.advertisements),

                    // Featured Trips Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Featured Trips',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          if (homeState.featuredTrips.isEmpty)
                            const Center(child: Text('No featured trips available'))
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: homeState.featuredTrips.length,
                              itemBuilder: (context, index) {
                                final trip = homeState.featuredTrips[index];
                                return AvailableTripCard(trip: trip);
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
