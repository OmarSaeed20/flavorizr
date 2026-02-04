import 'package:flutter/material.dart';
import 'package:flavorizr/features/driver_profile/domain/entities/driver_vehicle.dart';

/// Widget for displaying driver vehicle information.
class DriverVehicleCard extends StatelessWidget {
  final DriverVehicle vehicle;

  const DriverVehicleCard({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.directions_car,
                  size: 32,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                const Text(
                  'My Vehicle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (vehicle.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Vehicle', vehicle.displayName),
            const SizedBox(height: 8),
            _buildInfoRow('Color', vehicle.color),
            const SizedBox(height: 8),
            _buildInfoRow('License Plate', vehicle.licensePlate),
            const SizedBox(height: 8),
            _buildInfoRow('Type', vehicle.vehicleType),
            if (vehicle.capacity != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Capacity', '${vehicle.capacity} passengers'),
            ],
            if (vehicle.registrationNumber != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Registration', vehicle.registrationNumber!),
            ],
            if (vehicle.registrationExpiry != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Registration Expiry',
                '${vehicle.registrationExpiry!.day}/${vehicle.registrationExpiry!.month}/${vehicle.registrationExpiry!.year}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}