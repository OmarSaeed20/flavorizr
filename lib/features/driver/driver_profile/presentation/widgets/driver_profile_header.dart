import 'package:flutter/material.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_profile.dart';

/// Widget for displaying driver profile header.
class DriverProfileHeader extends StatelessWidget {
  final DriverProfile profile;

  const DriverProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profile.profileImage != null
                      ? NetworkImage(profile.profileImage!)
                      : null,
                  child: profile.profileImage == null
                      ? Text(
                          profile.firstName[0] + profile.lastName[0],
                          style: const TextStyle(fontSize: 24),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (profile.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  'Rating',
                  '${profile.rating.toStringAsFixed(1)} ⭐',
                ),
                _buildStat(
                  'Trips',
                  '${profile.totalTrips}',
                ),
                _buildStat(
                  'Joined',
                  '${DateTime.now().difference(profile.createdAt).inDays}d',
                ),
              ],
            ),
            if (profile.bio != null) ...[
              const SizedBox(height: 16),
              Text(
                profile.bio!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}