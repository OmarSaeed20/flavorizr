import 'package:fast_golden_taxi/features/driver/driver_trips/domain/entities/driver_trip.dart';
import 'package:fast_golden_taxi/features/driver/driver_trips/presentation/providers/driver_trips_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget displaying a pending trip request with accept/reject buttons
class PendingTripCard extends ConsumerWidget {
  final DriverTrip trip;

  const PendingTripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driverTripsControllerProvider);
    final isUpdating = state.isUpdatingTrip;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with passenger info
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: trip.passengerImage != null
                      ? NetworkImage(trip.passengerImage!)
                      : null,
                  child: trip.passengerImage == null
                      ? Text(trip.passengerName[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.passengerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        trip.passengerPhone,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Route information
            _RouteInfo(
              pickupLocation: trip.route.pickupLocation,
              dropoffLocation: trip.route.dropoffLocation,
              distance: trip.route.distance,
              duration: trip.route.duration,
            ),
            const SizedBox(height: 16),

            // Trip details
            Row(
              children: [
                _TripDetail(
                  icon: Icons.straighten,
                  label: '${trip.route.distance.toStringAsFixed(1)} km',
                ),
                const SizedBox(width: 16),
                _TripDetail(
                  icon: Icons.access_time,
                  label: '${trip.route.duration.toInt()} min',
                ),
                const SizedBox(width: 16),
                _TripDetail(icon: Icons.payment, label: trip.paymentMethod),
                const SizedBox(width: 16),
                _TripDetail(
                  icon: Icons.people,
                  label: '${trip.passengerCount} passenger(s)',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fare
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Fare',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${trip.estimatedFare.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Text(
                  trip.vehicleType,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),

            // Special requests
            if (trip.specialRequests != null &&
                trip.specialRequests!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.specialRequests!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isUpdating
                        ? null
                        : () async {
                            final reason = await _showRejectDialog(context);
                            if (reason != null) {
                              await ref
                                  .read(driverTripsControllerProvider.notifier)
                                  .rejectTripRequest(trip.id, reason);
                            }
                          },
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isUpdating
                        ? null
                        : () async {
                            await ref
                                .read(driverTripsControllerProvider.notifier)
                                .acceptTripRequest(trip.id);
                          },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showRejectDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Trip'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Reason for rejection (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

class _RouteInfo extends StatelessWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final double distance;
  final double duration;

  const _RouteInfo({
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(pickupLocation, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: SizedBox(
            height: 20,
            child: VerticalDivider(color: Colors.grey[300], thickness: 2),
          ),
        ),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                dropoffLocation,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TripDetail extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TripDetail({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
