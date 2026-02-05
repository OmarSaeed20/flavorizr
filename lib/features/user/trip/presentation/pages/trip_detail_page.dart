// lib/features/trip/presentation/pages/trip_detail_page.dart
import 'package:flavorizr/features/user/trip/presentation/controllers/trip_controller.dart';
import 'package:flavorizr/features/user/trip/presentation/providers/trip_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trip detail page showing full trip information.
///
/// Features:
/// - Display complete trip details
/// - Show trip status and progress
/// - Cancel trip if needed
/// - Report trip issues
class TripDetailPage extends ConsumerStatefulWidget {
  const TripDetailPage({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends ConsumerState<TripDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load trip details when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripControllerProvider.notifier).getTripDetail(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(tripControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        actions: [
          if (state.currentTrip != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'cancel':
                    _showCancelDialog();
                    break;
                  case 'report':
                    _showReportDialog();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'cancel',
                  child: ListTile(leading: Icon(Icons.cancel), title: Text('Cancel Trip')),
                ),
                const PopupMenuItem(
                  value: 'report',
                  child: ListTile(leading: Icon(Icons.report), title: Text('Report Issue')),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, state)),
    );
  }

  Widget _buildBody(BuildContext context, TripState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.currentTrip == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Trip not found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    final trip = state.currentTrip!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildStatusCard(context, trip),
          const SizedBox(height: 16),

          // Route information
          _buildRouteCard(context, trip),
          const SizedBox(height: 16),

          // Pricing information
          _buildPricingCard(context, trip),
          const SizedBox(height: 16),

          // Driver information (if available)
          if (trip.driver != null) _buildDriverCard(context, trip.driver!),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, dynamic trip) {
    final status = trip.status.toString().split('.').last;
    final statusColor = _getStatusColor(context, trip.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getStatusIcon(trip.status), color: statusColor),
                const SizedBox(width: 8),
                Text('Trip Status', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, dynamic trip) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.route, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('Route', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            _buildLocationRow(
              context,
              'Pickup',
              trip.pickupLocation?.address ?? 'Unknown',
              Icons.location_on,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildLocationRow(
              context,
              'Dropoff',
              trip.dropoffLocation?.address ?? 'Unknown',
              Icons.location_on,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context,
    String label,
    String address,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              Text(address, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard(BuildContext context, dynamic trip) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('Pricing', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            _buildPriceRow(context, 'Estimated Price', '\$${trip.estimatedPrice ?? '0.00'}'),
            if (trip.finalPrice != null)
              _buildPriceRow(context, 'Final Price', '\$${trip.finalPrice}'),
            if (trip.distance != null) _buildPriceRow(context, 'Distance', '${trip.distance} km'),
            if (trip.duration != null) _buildPriceRow(context, 'Duration', '${trip.duration} min'),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, dynamic driver) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('Driver', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: driver.avatar != null ? NetworkImage(driver.avatar) : null,
                  child: driver.avatar == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driver.name ?? 'Unknown', style: Theme.of(context).textTheme.titleSmall),
                      if (driver.rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              driver.rating.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, dynamic status) {
    switch (status.toString().split('.').last) {
      case 'pending':
        return Colors.orange;
      case 'searching':
        return Colors.blue;
      case 'confirmed':
        return Colors.green;
      case 'inProgress':
        return Colors.purple;
      case 'completed':
        return Colors.teal;
      case 'cancelled':
        return Colors.grey;
      case 'failed':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getStatusIcon(dynamic status) {
    switch (status.toString().split('.').last) {
      case 'pending':
        return Icons.pending;
      case 'searching':
        return Icons.search;
      case 'confirmed':
        return Icons.check_circle;
      case 'inProgress':
        return Icons.directions_car;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      case 'failed':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  void _showCancelDialog() {
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
              final success = await ref
                  .read(tripControllerProvider.notifier)
                  .cancelTrip(widget.tripId);
              if (success && mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Trip cancelled successfully')));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Trip'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason',
            hintText: 'Describe the issue...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Implement report functionality
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Report submitted')));
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
