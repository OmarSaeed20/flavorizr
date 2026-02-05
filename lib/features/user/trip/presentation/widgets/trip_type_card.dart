// lib/features/trip/presentation/widgets/trip_type_card.dart
import 'package:flavorizr/features/user/trip/domain/entities/trip_type.dart';
import 'package:flutter/material.dart';

/// Card widget displaying trip type information.
class TripTypeCard extends StatelessWidget {
  const TripTypeCard({super.key, required this.tripType, this.onTap});

  final TripType tripType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTripTypeIcon(tripType.name),
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripType.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tripType.description ?? 'Standard ride',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tripType.capacity} passengers',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.attach_money,
                          size: 16,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Base \$${tripType.basePrice}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTripTypeIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('economy')) {
      return Icons.directions_car;
    } else if (lowerName.contains('premium') || lowerName.contains('luxury')) {
      return Icons.airport_shuttle;
    } else if (lowerName.contains('van') || lowerName.contains('xl')) {
      return Icons.airport_shuttle;
    } else if (lowerName.contains('bike') || lowerName.contains('scooter')) {
      return Icons.electric_scooter;
    } else {
      return Icons.directions_car;
    }
  }
}
