import 'package:flavorizr/features/user/schedule_trip/data/parameters/create_scheduled_trip_parameters.dart';
import 'package:flavorizr/features/user/schedule_trip/data/parameters/get_scheduled_trips_parameters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/schedule_trip/domain/entities/scheduled_trip.dart';
import 'package:flavorizr/features/user/schedule_trip/domain/usecases/cancel_scheduled_trip_usecase.dart';
import 'package:flavorizr/features/user/schedule_trip/domain/usecases/create_scheduled_trip_usecase.dart';
import 'package:flavorizr/features/user/schedule_trip/domain/usecases/get_scheduled_trip_by_id_usecase.dart';
import 'package:flavorizr/features/user/schedule_trip/domain/usecases/get_scheduled_trips_usecase.dart';
import 'package:flavorizr/features/user/schedule_trip/domain/usecases/update_scheduled_trip_usecase.dart';

/// State for schedule trip operations.
class ScheduleTripState {
  final List<ScheduledTrip> scheduledTrips;
  final ScheduledTrip? currentTrip;
  final bool isLoadingTrips;
  final bool isCreatingTrip;
  final bool isUpdatingTrip;
  final bool isCancellingTrip;
  final int currentPage;
  final bool hasMore;
  final String? error;

  const ScheduleTripState({
    this.scheduledTrips = const [],
    this.currentTrip,
    this.isLoadingTrips = false,
    this.isCreatingTrip = false,
    this.isUpdatingTrip = false,
    this.isCancellingTrip = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
  });

  ScheduleTripState copyWith({
    List<ScheduledTrip>? scheduledTrips,
    ScheduledTrip? currentTrip,
    bool? isLoadingTrips,
    bool? isCreatingTrip,
    bool? isUpdatingTrip,
    bool? isCancellingTrip,
    int? currentPage,
    bool? hasMore,
    String? error,
  }) {
    return ScheduleTripState(
      scheduledTrips: scheduledTrips ?? this.scheduledTrips,
      currentTrip: currentTrip ?? this.currentTrip,
      isLoadingTrips: isLoadingTrips ?? this.isLoadingTrips,
      isCreatingTrip: isCreatingTrip ?? this.isCreatingTrip,
      isUpdatingTrip: isUpdatingTrip ?? this.isUpdatingTrip,
      isCancellingTrip: isCancellingTrip ?? this.isCancellingTrip,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

/// Controller for managing schedule trip operations.
class ScheduleTripController extends StateNotifier<ScheduleTripState> {
  final GetScheduledTripsUseCase _getScheduledTripsUseCase;
  final GetScheduledTripByIdUseCase _getScheduledTripByIdUseCase;
  final CreateScheduledTripUseCase _createScheduledTripUseCase;
  final UpdateScheduledTripUseCase _updateScheduledTripUseCase;
  final CancelScheduledTripUseCase _cancelScheduledTripUseCase;

  ScheduleTripController(
    this._getScheduledTripsUseCase,
    this._getScheduledTripByIdUseCase,
    this._createScheduledTripUseCase,
    this._updateScheduledTripUseCase,
    this._cancelScheduledTripUseCase,
  ) : super(const ScheduleTripState());

  /// Gets scheduled trips with pagination.
  Future<void> getScheduledTrips({
    int page = 1,
    int limit = 20,
    String? status,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(scheduledTrips: [], currentPage: 1, hasMore: true);
    }

    state = state.copyWith(isLoadingTrips: true, error: null);

    final result = await _getScheduledTripsUseCase(
      GetScheduledTripsParameters(page: page, limit: limit, status: status),
    );

    result.when(
      success: (data, _) {
        final newTrips = data;
        state = state.copyWith(
          scheduledTrips: page == 1 ? newTrips : [...state.scheduledTrips, ...newTrips],
          isLoadingTrips: false,
          currentPage: page,
          hasMore: newTrips.length >= limit,
        );
      },
      exception: (error) {
        state = state.copyWith(isLoadingTrips: false, error: error.message);
      },
    );
  }

  /// Gets a specific scheduled trip by ID.
  Future<void> getScheduledTripById(String tripId) async {
    state = state.copyWith(isLoadingTrips: true, error: null);

    final result = await _getScheduledTripByIdUseCase(tripId);

    result.when(
      success: (data, _) {
        state = state.copyWith(currentTrip: data, isLoadingTrips: false);
      },
      exception: (error) {
        state = state.copyWith(isLoadingTrips: false, error: error.message);
      },
    );
  }

  /// Creates a new scheduled trip.
  Future<void> createScheduledTrip({
    required String pickupLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLocation,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required String vehicleType,
    required DateTime scheduledTime,
    String? paymentMethod,
    String? notes,
    String? promoCode,
  }) async {
    state = state.copyWith(isCreatingTrip: true, error: null);

    final result = await _createScheduledTripUseCase(
      CreateScheduledTripParameters(
        pickupLocation: pickupLocation,
        pickupLatitude: pickupLatitude,
        pickupLongitude: pickupLongitude,
        dropoffLocation: dropoffLocation,
        dropoffLatitude: dropoffLatitude,
        dropoffLongitude: dropoffLongitude,
        vehicleType: vehicleType,
        scheduledTime: scheduledTime,
        paymentMethod: paymentMethod,
        notes: notes,
        promoCode: promoCode,
      ),
    );

    result.when(
      success: (data, _) {
        state = state.copyWith(
          currentTrip: data,
          scheduledTrips: [data, ...state.scheduledTrips],
          isCreatingTrip: false,
        );
      },
      exception: (error) {
        state = state.copyWith(isCreatingTrip: false, error: error.message);
      },
    );
  }

  /// Updates a scheduled trip.
  Future<void> updateScheduledTrip(
    String tripId, {
    required String pickupLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLocation,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required String vehicleType,
    required DateTime scheduledTime,
    String? paymentMethod,
    String? notes,
    String? promoCode,
  }) async {
    state = state.copyWith(isUpdatingTrip: true, error: null);

    final result = await _updateScheduledTripUseCase(
      tripId,
      CreateScheduledTripParameters(
        pickupLocation: pickupLocation,
        pickupLatitude: pickupLatitude,
        pickupLongitude: pickupLongitude,
        dropoffLocation: dropoffLocation,
        dropoffLatitude: dropoffLatitude,
        dropoffLongitude: dropoffLongitude,
        vehicleType: vehicleType,
        scheduledTime: scheduledTime,
        paymentMethod: paymentMethod,
        notes: notes,
        promoCode: promoCode,
      ),
    );

    result.when(
      success: (data, _) {
        final updatedTrips = state.scheduledTrips.map((trip) {
          return trip.id == tripId ? data : trip;
        }).toList();
        state = state.copyWith(
          currentTrip: data,
          scheduledTrips: updatedTrips,
          isUpdatingTrip: false,
        );
      },
      exception: (error) {
        state = state.copyWith(isUpdatingTrip: false, error: error.message);
      },
    );
  }

  /// Cancels a scheduled trip.
  Future<void> cancelScheduledTrip(String tripId) async {
    state = state.copyWith(isCancellingTrip: true, error: null);

    final result = await _cancelScheduledTripUseCase(tripId);

    result.when(
      success: (data, _) {
        final updatedTrips = state.scheduledTrips.where((trip) => trip.id != tripId).toList();
        state = state.copyWith(
          scheduledTrips: updatedTrips,
          currentTrip: state.currentTrip?.id == tripId ? null : state.currentTrip,
          isCancellingTrip: false,
        );
      },
      exception: (error) {
        state = state.copyWith(isCancellingTrip: false, error: error.message);
      },
    );
  }

  /// Loads more trips.
  Future<void> loadMoreTrips({String? status}) async {
    if (state.hasMore && !state.isLoadingTrips) {
      await getScheduledTrips(page: state.currentPage + 1, status: status);
    }
  }

  /// Clears the current state.
  void clear() {
    state = const ScheduleTripState();
  }
}
