import 'package:fast_golden_taxi/features/user/schedule_trip/domain/entities/scheduled_trip.dart';
import 'package:flutter/material.dart';

/// Widget for displaying a scheduled trip card.
class ScheduledTripCard extends StatelessWidget {
  final ScheduledTrip trip;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final bool isCancelling;

  const ScheduledTripCard({
    super.key,
    required this.trip,
    required this.onTap,
    required this.onCancel,
    this.isCancelling = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getStatusIcon(), color: _getStatusColor(), size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trip.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  Text(
                    trip.estimatedFare,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildLocationRow(
                icon: Icons.location_on,
                label: 'Pickup',
                location: trip.pickupLocation,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              _buildLocationRow(
                icon: Icons.flag,
                label: 'Dropoff',
                location: trip.dropoffLocation,
                color: Colors.red,
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scheduled Time',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        Text(
                          _formatDateTime(trip.scheduledTime),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.directions_car, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    trip.vehicleType,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              if (trip.status.toLowerCase() == 'pending') ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isCancelling ? null : onCancel,
                    icon: isCancelling
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cancel),
                    label: Text(isCancelling ? 'Cancelling...' : 'Cancel Trip'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String location,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(location, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  IconData _getStatusIcon() {
    switch (trip.status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'confirmed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.directions_car;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor() {
    switch (trip.status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'in_progress':
        return Colors.green;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
