import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/driver_home_data.dart';
import '../../domain/entities/driver_earnings.dart';
import '../../domain/entities/driver_stats.dart';
import '../../domain/entities/driver_trip.dart';
import '../../domain/usecases/get_driver_home_data.dart';
import '../../domain/usecases/get_driver_earnings.dart';
import '../../domain/usecases/get_driver_stats.dart';
import '../../domain/usecases/get_driver_trips.dart';
import '../../domain/usecases/get_driver_trip_by_id.dart';
import '../../domain/usecases/update_online_status.dart';
import '../../domain/usecases/update_availability_status.dart';

/// State for driver home
class DriverHomeState {
  final bool isLoading;
  final bool isLoadingTrips;
  final DriverHomeData? homeData;
  final DriverEarnings? earnings;
  final DriverStats? stats;
  final List<DriverTrip> trips;
  final int currentPage;
  final bool hasMoreTrips;
  final String? errorMessage;
  final bool isUpdatingStatus;

  const DriverHomeState({
    this.isLoading = false,
    this.isLoadingTrips = false,
    this.homeData,
    this.earnings,
    this.stats,
    this.trips = const [],
    this.currentPage = 1,
    this.hasMoreTrips = true,
    this.errorMessage,
    this.isUpdatingStatus = false,
  });

  DriverHomeState copyWith({
    bool? isLoading,
    bool? isLoadingTrips,
    DriverHomeData? homeData,
    DriverEarnings? earnings,
    DriverStats? stats,
    List<DriverTrip>? trips,
    int? currentPage,
    bool? hasMoreTrips,
    String? errorMessage,
    bool? isUpdatingStatus,
  }) {
    return DriverHomeState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingTrips: isLoadingTrips ?? this.isLoadingTrips,
      homeData: homeData ?? this.homeData,
      earnings: earnings ?? this.earnings,
      stats: stats ?? this.stats,
      trips: trips ?? this.trips,
      currentPage: currentPage ?? this.currentPage,
      hasMoreTrips: hasMoreTrips ?? this.hasMoreTrips,
      errorMessage: errorMessage,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
    );
  }
}

/// Controller for driver home
class DriverHomeController extends StateNotifier<DriverHomeState> {
  final GetDriverHomeData getDriverHomeData;
  final GetDriverEarnings getDriverEarnings;
  final GetDriverStats getDriverStats;
  final GetDriverTrips getDriverTrips;
  final GetDriverTripById getDriverTripById;
  final UpdateOnlineStatus updateOnlineStatus;
  final UpdateAvailabilityStatus updateAvailabilityStatus;

  DriverHomeController({
    required this.getDriverHomeData,
    required this.getDriverEarnings,
    required this.getDriverStats,
    required this.getDriverTrips,
    required this.getDriverTripById,
    required this.updateOnlineStatus,
    required this.updateAvailabilityStatus,
  }) : super(const DriverHomeState());

  /// Load complete driver home data
  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final homeData = await getDriverHomeData();
      state = state.copyWith(
        isLoading: false,
        homeData: homeData,
        earnings: homeData.earnings,
        stats: homeData.stats,
        trips: homeData.recentTrips,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Load driver earnings
  Future<void> loadEarnings() async {
    try {
      final earnings = await getDriverEarnings();
      state = state.copyWith(earnings: earnings);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Load driver statistics
  Future<void> loadStats() async {
    try {
      final stats = await getDriverStats();
      state = state.copyWith(stats: stats);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Load driver trips with pagination
  Future<void> loadTrips({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        currentPage: 1,
        trips: [],
        hasMoreTrips: true,
      );
    }

    if (state.isLoadingTrips || !state.hasMoreTrips) return;

    state = state.copyWith(isLoadingTrips: true);
    try {
      final trips = await getDriverTrips(
        page: state.currentPage,
        limit: 10,
      );
      state = state.copyWith(
        isLoadingTrips: false,
        trips: refresh ? trips : [...state.trips, ...trips],
        currentPage: state.currentPage + 1,
        hasMoreTrips: trips.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTrips: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Load a specific trip by ID
  Future<DriverTrip?> loadTripById(String tripId) async {
    try {
      return await getDriverTripById(tripId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  /// Update online status
  Future<bool> toggleOnlineStatus(bool isOnline) async {
    state = state.copyWith(isUpdatingStatus: true);
    try {
      final success = await updateOnlineStatus(isOnline);
      if (success && state.homeData != null) {
        state = state.copyWith(
          isUpdatingStatus: false,
          homeData: state.homeData!.copyWith(isOnline: isOnline),
        );
      } else {
        state = state.copyWith(isUpdatingStatus: false);
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isUpdatingStatus: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update availability status
  Future<bool> toggleAvailabilityStatus(bool isAvailable) async {
    state = state.copyWith(isUpdatingStatus: true);
    try {
      final success = await updateAvailabilityStatus(isAvailable);
      if (success && state.homeData != null) {
        state = state.copyWith(
          isUpdatingStatus: false,
          homeData: state.homeData!.copyWith(isAvailable: isAvailable),
        );
      } else {
        state = state.copyWith(isUpdatingStatus: false);
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isUpdatingStatus: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}