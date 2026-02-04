import 'package:flutter/material.dart';

class AvailableTripCard extends StatelessWidget {
  final dynamic trip;

  const AvailableTripCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver info
            if (trip.driverName != null)
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: trip.driverImage != null
                        ? NetworkImage(trip.driverImage)
                        : null,
                    child: trip.driverImage == null
                        ? Text(trip.driverName[0])
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.driverName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (trip.vehicleType != null)
                          Text(
                            trip.vehicleType,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            // Route info
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.pickupAddress,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.dropoffAddress,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Trip details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (trip.estimatedPrice != null)
                  Text(
                    '${trip.estimatedPrice} ${trip.currency ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                if (trip.availableSeats != null)
                  Row(
                    children: [
                      const Icon(Icons.event_seat, size: 20),
                      const SizedBox(width: 4),
                      Text('${trip.availableSeats} seats'),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle booking
                },
                child: const Text('Book Trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}