import 'package:flavorizr/features/driver/driver_reviews/domain/entities/review_stats.dart';
import 'package:flutter/material.dart';

/// Widget for displaying review statistics
class ReviewStatsCard extends StatelessWidget {
  final ReviewStats? stats;
  final bool isLoading;
  final String? error;

  const ReviewStatsCard({
    super.key,
    this.stats,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(error!)),
            ],
          ),
        ),
      );
    }

    if (stats == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Average Rating
            Row(
              children: [
                Text(
                  stats!.averageRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 8),
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < stats!.averageRating.round()
                        ? Icons.star
                        : Icons.star_border,
                    size: 24,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${stats!.totalReviews} reviews)',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rating Distribution
            ...List.generate(5, (index) {
              final starCount = 5 - index;
              final count = _getStarCount(starCount);
              final percentage = stats!.totalReviews > 0
                  ? (count / stats!.totalReviews * 100)
                  : 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Text('$starCount'),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($count)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Response Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Responded',
                    stats!.respondedCount,
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Pending',
                    stats!.pendingResponseCount,
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getStarCount(int stars) {
    switch (stars) {
      case 5:
        return stats!.fiveStarCount;
      case 4:
        return stats!.fourStarCount;
      case 3:
        return stats!.threeStarCount;
      case 2:
        return stats!.twoStarCount;
      case 1:
        return stats!.oneStarCount;
      default:
        return 0;
    }
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
