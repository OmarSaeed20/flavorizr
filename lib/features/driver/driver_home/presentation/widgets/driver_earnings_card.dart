import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_earnings.dart';
import 'package:flutter/material.dart';

/// Widget displaying driver earnings
class DriverEarningsCard extends StatelessWidget {
  final DriverEarnings earnings;

  const DriverEarningsCard({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        earnings.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _EarningsRow(
              label: 'Today',
              amount: earnings.todayEarnings,
              trips: earnings.todayTrips,
              isHighlighted: true,
            ),
            const Divider(height: 24),
            _EarningsRow(
              label: 'This Week',
              amount: earnings.weeklyEarnings,
              trips: earnings.weeklyTrips,
            ),
            const Divider(height: 24),
            _EarningsRow(
              label: 'This Month',
              amount: earnings.monthlyEarnings,
              trips: earnings.monthlyTrips,
            ),
            const Divider(height: 24),
            _EarningsRow(
              label: 'Total',
              amount: earnings.totalEarnings,
              trips: earnings.totalTrips,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _EarningsRow extends StatelessWidget {
  final String label;
  final double amount;
  final int trips;
  final bool isHighlighted;
  final bool isTotal;

  const _EarningsRow({
    required this.label,
    required this.amount,
    required this.trips,
    this.isHighlighted = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted ? Theme.of(context).primaryColor : null,
          ),
        ),
        Row(
          children: [
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: isTotal ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: isHighlighted
                    ? Theme.of(context).primaryColor
                    : isTotal
                    ? Colors.green
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('$trips trips', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ],
        ),
      ],
    );
  }
}
