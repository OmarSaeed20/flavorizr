import 'package:flavorizr/features/driver/driver_profile/presentation/providers/driver_profile_providers.dart';
import 'package:flavorizr/features/driver/driver_profile/presentation/widgets/driver_documents_list.dart';
import 'package:flavorizr/features/driver/driver_profile/presentation/widgets/driver_profile_header.dart';
import 'package:flavorizr/features/driver/driver_profile/presentation/widgets/driver_vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for managing driver profile.
class DriverProfilePage extends ConsumerStatefulWidget {
  const DriverProfilePage({super.key});

  @override
  ConsumerState<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends ConsumerState<DriverProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    ref.read(driverProfileControllerProvider.notifier).getDriverProfile();
    ref.read(driverProfileControllerProvider.notifier).getDriverVehicle();
    ref.read(driverProfileControllerProvider.notifier).getDriverDocuments();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: state.isLoading
                ? null
                : () {
                    Navigator.pushNamed(context, '/driver/profile/edit');
                  },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _loadData();
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  if (state.profile != null)
                    DriverProfileHeader(profile: state.profile!),
                  const SizedBox(height: 16),
                  if (state.vehicle != null)
                    DriverVehicleCard(vehicle: state.vehicle!),
                  const SizedBox(height: 16),
                  DriverDocumentsList(
                    documents: state.documents,
                    isLoading: state.isUpdating,
                    onDelete: (documentId) {
                      ref
                          .read(driverProfileControllerProvider.notifier)
                          .deleteDriverDocument(documentId);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
