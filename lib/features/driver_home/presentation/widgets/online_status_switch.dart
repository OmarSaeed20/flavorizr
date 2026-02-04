import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/driver_home_controller.dart';
import '../providers/driver_home_providers.dart';

/// Widget for toggling driver online status
class OnlineStatusSwitch extends ConsumerWidget {
  const OnlineStatusSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driverHomeControllerProvider);
    final controller = ref.watch(driverHomeControllerProvider.notifier);

    final isOnline = state.homeData?.isOnline ?? false;
    final isAvailable = state.homeData?.isAvailable ?? false;
    final isUpdating = state.isUpdatingStatus;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Online Status Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isOnline ? Icons.wifi : Icons.wifi_off,
                      color: isOnline ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Online Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isOnline,
                  onChanged: isUpdating
                      ? null
                      : (value) async {
                          await controller.toggleOnlineStatus(value);
                        },
                  activeColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Availability Status Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isAvailable ? Icons.check_circle : Icons.cancel,
                      color: isAvailable ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Available for Trips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isAvailable,
                  onChanged: isUpdating || !isOnline
                      ? null
                      : (value) async {
                          await controller.toggleAvailabilityStatus(value);
                        },
                  activeColor: Colors.blue,
                ),
              ],
            ),

            // Status message
            if (!isOnline)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'You are currently offline. Go online to receive trip requests.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else if (!isAvailable)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'You are online but not available for new trips.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'You are online and available for trips!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Loading indicator
            if (isUpdating)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}