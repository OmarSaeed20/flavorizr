import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/vehicle_type.dart';
import 'package:flutter/material.dart';

/// Widget for displaying a vehicle type card.
class VehicleTypeCard extends StatelessWidget {
  final VehicleType vehicleType;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleTypeCard({
    super.key,
    required this.vehicleType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      child: InkWell(
        onTap: vehicleType.isAvailable ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (vehicleType.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    vehicleType.imageUrl!,
                    width: 80,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.directions_car, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleType.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (vehicleType.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        vehicleType.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${vehicleType.capacity} seats',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Base: \$${vehicleType.baseFare.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
