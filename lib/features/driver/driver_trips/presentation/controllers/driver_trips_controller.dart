import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/driver_trip.dart';
import '../../domain/usecases/get_driver_trips.dart';
import '../../domain/usecases/get_driver_trip_by_id.dart';
import '../../domain/usecases/get_pending_trips.dart';
import '../../domain/usecases/accept_trip.dart';
import '../../domain/usecases/reject_trip.dart';
import '../../domain/usecases/start_trip.dart';
import '../../domain/usecases/complete_trip.dart';
import '../../domain/usecases/cancel_trip.dart';
import '../../domain/usecases/update_trip_location.dart';
import '../../domain/usecases/get_trip_stats.dart';

/// State for driver trips
class DriverTripsState {
  final bool isLoading;
  final bool isLoadingPending;
  final bool isUpdatingTrip;
  final List<DriverTrip> trips;
  final List<DriverTrip> pendingTrips;
  final DriverTrip? currentTrip;
  final Map<String, dynamic>? tripStats;
  final int currentPage;
  final bool hasMoreTrips;
  final String? selectedStatus;
  final String? errorMessage;

  const DriverTripsState({
    this.isLoading = false,
    this.isLoadingPending = false,
    this.isUpdatingTrip = false,
    this.trips = const [],
    this.pendingTrips = const [],
    this.currentTrip,
    this.tripStats,
    this.currentPage = 1,
    this.hasMoreTrips = true,
    this.selectedStatus,
    this.errorMessage,
  });

  DriverTripsState copyWith({
    bool? isLoading,
    bool? isLoadingPending,
    bool? isUpdatingTrip,
    List<DriverTrip>? trips,
    List<DriverTrip>? pendingTrips,
    DriverTrip? currentTrip,
    Map<String, dynamic>? tripStats,
    int? currentPage,
    bool? hasMoreTrips,
    String? selectedStatus,
    String? errorMessage,
  }) {
    return DriverTripsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingPending: isLoadingPending ?? this.isLoadingPending,
      isUpdatingTrip: isUpdatingTrip ?? this.isUpdatingTrip,
      trips: trips ?? this.trips,
      pendingTrips: pendingTrips ?? this.pendingTrips,
      currentTrip: currentTrip ?? this.currentTrip,
      tripStats: tripStats ?? this.tripStats,
      currentPage: currentPage ?? this.currentPage,
      hasMoreTrips: hasMoreTrips ?? this.hasMoreTrips,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      errorMessage: errorMessage,
    );
  }
}

/// Controller for driver trips
class DriverTripsController extends StateNotifier<DriverTripsState> {
  final GetDriverTrips getDriverTrips;
  final GetDriverTripById getDriverTripById;
  final GetPendingTrips getPendingTrips;
  final AcceptTrip acceptTrip;
  final RejectTrip rejectTrip;
  final StartTrip startTrip;
  final CompleteTrip completeTrip;
  final CancelTrip cancelTrip;
  final UpdateTripLocation updateTripLocation;
  final GetTripStats getTripStats;

  DriverTripsController({
    required this.getDriverTrips,
    required this.getDriverTripById,
    required this.getPendingTrips,
    required this.acceptTrip,
    required this.rejectTrip,
    required this.startTrip,
    required this.completeTrip,
    required this.cancelTrip,
    required this.updateTripLocation,
    required this.getTripStats,
  }) : super(const DriverTripsState());

  /// Load driver trips with pagination
  Future<void> loadTrips({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        currentPage: 1,
        trips: [],
        hasMoreTrips: true,
        selectedStatus: null,
      );
    }

    if (state.isLoading || !state.hasMoreTrips) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final trips = await getDriverTrips(
        page: state.currentPage,
        limit: 10,
        status: state.selectedStatus,
      );
      state = state.copyWith(
        isLoading: false,
        trips: refresh ? trips : [...state.trips, ...trips],
        currentPage: state.currentPage + 1,
        hasMoreTrips: trips.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Load a specific trip by ID
  Future<DriverTrip?> loadTripById(String tripId) async {
    try {
      final trip = await getDriverTripById(tripId);
      state = state.copyWith(currentTrip: trip);
      return trip;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  /// Load pending trips
  Future<void> loadPendingTrips() async {
    state = state.copyWith(isLoadingPending: true, errorMessage: null);
    try {
      final pendingTrips = await getPendingTrips();
      state = state.copyWith(
        isLoadingPending: false,
        pendingTrips: pendingTrips,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingPending: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Accept a trip
  Future<DriverTrip?> acceptTripRequest(String tripId) async {
    state = state.copyWith(isUpdatingTrip: true, errorMessage: null);
    try {
      final trip = await acceptTrip(tripId);
      state = state.copyWith(
        isUpdatingTrip: false,
        currentTrip: trip,
        pendingTrips: state.pendingTrips.where((t) => t.id != tripId).toList(),
      );
      return trip;
    } catch (e) {
      state = state.copyWith(
        isUpdatingTrip: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Reject a trip
  Future<bool> rejectTripRequest(String tripId, String? reason) async {
    state = state.copyWith(isUpdatingTrip: true, errorMessage: null);
    try {
      final success = await rejectTrip(tripId, reason);
      state = state.copyWith(
        isUpdatingTrip: false,
        pendingTrips: state.pendingTrips.where((t) => t.id != tripId).toList(),
      );
      return success;
    } catch (e) {
      state = state.copyWith(
        isUpdatingTrip: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Start a trip
  Future<DriverTrip?> startTripRequest(String tripId) async {
    state = state.copyWith(isUpdatingTrip: true, errorMessage: null);
    try {
      final trip = await startTrip(tripId);
      state = state.copyWith(
        isUpdatingTrip: false,
        currentTrip: trip,
      );
      return trip;
    } catch (e) {
      state = state.copyWith(
        isUpdatingTrip: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Complete a trip
  Future<DriverTrip?> completeTripRequest(String tripId, double actualFare) async {
    state = state.copyWith(isUpdatingTrip: true, errorMessage: null);
    try {
      final trip = await completeTrip(tripId, actualFare);
      state = state.copyWith(
        isUpdatingTrip: false,
        currentTrip: trip,
      );
      return trip;
    } catch (e) {
      state = state.copyWith(
        isUpdatingTrip: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Cancel a trip
  Future<bool> cancelTripRequest(String tripId, String reason) async {
    state = state.copyWith(isUpdatingTrip: true, errorMessage: null);
    try {
      final success = await cancelTrip(tripId, reason);
      if (success && state.currentTrip?.id == tripId) {
        state = state.copyWith(
          isUpdatingTrip: false,
          currentTrip: state.currentTrip?.copyWith(
            status: 'cancelled',
            cancelledAt: DateTime.now(),
            cancellationReason: reason,
          ),
        );
      } else {
        state = state.copyWith(isUpdatingTrip: false);
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isUpdatingTrip: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update trip location
  Future<bool> updateCurrentTripLocation(String tripId, double latitude, double longitude) async {
    try {
      return await updateTripLocation(tripId, latitude, longitude);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Load trip statistics
  Future<void> loadTripStats() async {
    try {
      final stats = await getTripStats();
      state = state.copyWith(tripStats: stats);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Filter trips by status
  void filterByStatus(String? status) {
    state = state.copyWith(selectedStatus: status);
    loadTrips(refresh: true);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}