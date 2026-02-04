import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavorizr/features/direct_booking/presentation/controllers/direct_booking_controller.dart';
import 'package:flavorizr/features/direct_booking/presentation/providers/direct_booking_providers.dart';
import 'package:flavorizr/features/direct_booking/presentation/widgets/vehicle_type_card.dart';
import 'package:flavorizr/features/direct_booking/presentation/widgets/driver_info_card.dart';
import 'package:flavorizr/features/direct_booking/presentation/widgets/booking_status_card.dart';

/// Page for direct booking operations.
class DirectBookingPage extends ConsumerStatefulWidget {
  const DirectBookingPage({super.key});

  @override
  ConsumerState<DirectBookingPage> createState() => _DirectBookingPageState();
}

class _DirectBookingPageState extends ConsumerState<DirectBookingPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    ref.read(directBookingControllerProvider.notifier).getVehicleTypes();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(directBookingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride'),
      ),
      body: state.currentBooking != null
          ? BookingStatusCard(
              booking: state.currentBooking!,
              onCancel: () {
                ref
                    .read(directBookingControllerProvider.notifier)
                    .cancelBooking(state.currentBooking!.bookingId);
              },
              isCancelling: state.isCancellingBooking,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Input Section
                  _buildLocationSection(),
                  const SizedBox(height: 24),

                  // Vehicle Types Section
                  _buildVehicleTypesSection(state),
                  const SizedBox(height: 24),

                  // Nearby Drivers Section
                  _buildNearbyDriversSection(state),
                ],
              ),
            ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pickup Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter pickup location',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dropoff Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter dropoff location',
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypesSection(DirectBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Vehicle Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        state.isLoadingVehicleTypes
            ? const Center(child: CircularProgressIndicator())
            : state.vehicleTypes.isEmpty
                ? const Text('No vehicle types available')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.vehicleTypes.length,
                    itemBuilder: (context, index) {
                      final vehicleType = state.vehicleTypes[index];
                      return VehicleTypeCard(
                        vehicleType: vehicleType,
                        isSelected:
                            state.selectedVehicleType?.id == vehicleType.id,
                        onTap: () {
                          ref
                              .read(directBookingControllerProvider.notifier)
                              .selectVehicleType(vehicleType);
                        },
                      );
                    },
                  ),
      ],
    );
  }

  Widget _buildNearbyDriversSection(DirectBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby Drivers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        state.isLoadingDrivers
            ? const Center(child: CircularProgressIndicator())
            : state.nearbyDrivers.isEmpty
                ? const Text('No drivers nearby')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.nearbyDrivers.length,
                    itemBuilder: (context, index) {
                      final driver = state.nearbyDrivers[index];
                      return DriverInfoCard(driver: driver);
                    },
                  ),
      ],
    );
  }
}