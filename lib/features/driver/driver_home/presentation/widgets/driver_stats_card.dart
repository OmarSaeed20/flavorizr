import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_stats.dart';
import 'package:flutter/material.dart';

/// Widget displaying driver statistics
class DriverStatsCard extends StatelessWidget {
  final DriverStats stats;

  const DriverStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total Trips',
                    value: stats.totalTrips.toString(),
                    icon: Icons.directions_car,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Completed',
                    value: stats.completedTrips.toString(),
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Cancelled',
                    value: stats.cancelledTrips.toString(),
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Completion Rate',
                    value: '${stats.completionRate.toStringAsFixed(1)}%',
                    icon: Icons.trending_up,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Avg Rating',
                    value: stats.averageRating.toStringAsFixed(1),
                    icon: Icons.star,
                    color: Colors.amber,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Reviews',
                    value: stats.totalReviews.toString(),
                    icon: Icons.rate_review,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Acceptance Rate',
                    value: '${stats.acceptanceRate.toStringAsFixed(1)}%',
                    icon: Icons.thumb_up,
                    color: Colors.teal,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Hours Online',
                    value: '${stats.totalHoursOnline}h',
                    icon: Icons.access_time,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatItem({required this.label, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color ?? Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
