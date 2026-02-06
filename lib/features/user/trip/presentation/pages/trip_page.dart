// lib/features/trip/presentation/pages/trip_page.dart
import 'package:flavorizr/core/router/routes.dart';
import 'package:flavorizr/features/user/trip/presentation/controllers/trip_controller.dart';
import 'package:flavorizr/features/user/trip/presentation/providers/trip_providers.dart';
import 'package:flavorizr/features/user/trip/presentation/widgets/trip_type_card.dart';
import 'package:flavorizr/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Main trip page for booking rides.
///
/// Features:
/// - Display available trip types
/// - Create new trips
/// - View current trip status
class TripPage extends ConsumerStatefulWidget {
  const TripPage({super.key});

  @override
  ConsumerState<TripPage> createState() => _TripPageState();
}

class _TripPageState extends ConsumerState<TripPage> {
  @override
  void initState() {
    super.initState();
    // Load trip types when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripControllerProvider.notifier).loadTripTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.push(Routes.tripHistory);
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              context.push(Routes.tripOrders);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Current trip section
            if (state.currentTrip != null) _buildCurrentTrip(context, state.currentTrip!),

            // Trip types section
            Expanded(child: _buildTripTypes(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTrip(BuildContext context, dynamic trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Current Trip',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Status: ${trip.status.toString().split('.').last}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          if (trip.pickupLocation != null)
            Text(
              'From: ${trip.pickupLocation?.address ?? ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (trip.dropoffLocation != null)
            Text(
              'To: ${trip.dropoffLocation?.address ?? ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () {
                    context.push('${Routes.tripDetail}/${trip.id}');
                  },
                  variant: AppButtonVariant.outlined,
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onPressed: () {
                    _showCancelDialog(trip.id);
                  },
                  variant: AppButtonVariant.text,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypes(BuildContext context, TripState state) {
    if (state.isLoading && state.tripTypes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.tripTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('No trip types available', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(tripControllerProvider.notifier).loadTripTypes();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.tripTypes.length,
        itemBuilder: (context, index) {
          final tripType = state.tripTypes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TripTypeCard(
              tripType: tripType,
              onTap: () {
                _showBookingDialog(tripType);
              },
            ),
          );
        },
      ),
    );
  }

  void _showBookingDialog(dynamic tripType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book ${tripType.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Base Price: \$${tripType.basePrice}'),
            Text('Price per km: \$${tripType.pricePerKm}'),
            Text('Price per min: \$${tripType.pricePerMinute}'),
            Text('Capacity: ${tripType.capacity} passengers'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to booking page
              context.push('${Routes.tripBooking}/${tripType.id}');
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(String tripId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Trip'),
        content: const Text('Are you sure you want to cancel this trip?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final trip = ref.read(tripControllerProvider).currentTrip;
              if (trip?.userId == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to cancel trip: User ID not found')),
                  );
                }
                return;
              }
              final success = await ref
                  .read(tripControllerProvider.notifier)
                  .cancelTrip(orderId: tripId, userId: trip!.userId!);
              if (success && mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Trip cancelled successfully')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
