// lib/features/trip/presentation/widgets/trip_card.dart
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip.dart';
import 'package:flutter/material.dart';

/// Card widget displaying trip information.
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, this.onTap});

  final Trip trip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(context, trip.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trip #${trip.id.substring(0, 8)}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(trip.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Route information
              _buildRouteRow(
                context,
                Icons.location_on,
                trip.origin.address ?? 'Unknown pickup',
                Colors.green,
              ),
              const SizedBox(height: 8),
              _buildRouteRow(
                context,
                Icons.location_on,
                trip.destination.address ?? 'Unknown dropoff',
                Colors.red,
              ),
              const SizedBox(height: 12),

              // Footer with date and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(trip.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  if (trip.price != null)
                    Text(
                      '\$${trip.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteRow(BuildContext context, IconData icon, String address, Color color) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address,
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return Colors.orange;
      case TripStatus.searching:
        return Colors.blue;
      case TripStatus.confirmed:
        return Colors.green;
      case TripStatus.inProgress:
        return Colors.purple;
      case TripStatus.completed:
        return Colors.teal;
      case TripStatus.cancelled:
        return Colors.grey;
      case TripStatus.failed:
        return Colors.red;
    }
  }

  String _getStatusText(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return 'Pending';
      case TripStatus.searching:
        return 'Searching';
      case TripStatus.confirmed:
        return 'Confirmed';
      case TripStatus.inProgress:
        return 'In Progress';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.cancelled:
        return 'Cancelled';
      case TripStatus.failed:
        return 'Failed';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
