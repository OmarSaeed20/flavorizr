// lib/features/trip/presentation/controllers/trip_controller.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/trip/data/parameters/cancel_trip_parameters.dart';
import 'package:flavorizr/features/user/trip/data/parameters/confirm_trip_parameters.dart';
import 'package:flavorizr/features/user/trip/data/parameters/get_available_public_trips_parameters.dart';
import 'package:flavorizr/features/user/trip/data/parameters/get_trip_detail_parameters.dart';
import 'package:flavorizr/features/user/trip/data/parameters/get_trip_types_parameters.dart';
import 'package:flavorizr/features/user/trip/data/parameters/store_private_trip_parameters.dart';
import 'package:flavorizr/features/user/trip/data/parameters/store_public_trip_parameters.dart';
import 'package:flavorizr/features/user/trip/domain/entities/trip.dart';
import 'package:flavorizr/features/user/trip/domain/entities/trip_type.dart';
import 'package:flavorizr/features/user/trip/domain/usecases/trip_usecases.dart';
import 'package:flavorizr/features/user/trip/presentation/providers/trip_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for trip operations.
class TripState {
  const TripState({
    this.tripTypes = const [],
    this.availableTrips = const [],
    this.currentTrip,
    this.isLoading = false,
    this.isCreatingTrip = false,
    this.isConfirmingTrip = false,
    this.isCancellingTrip = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  final List<TripType> tripTypes;
  final List<Trip> availableTrips;
  final Trip? currentTrip;
  final bool isLoading;
  final bool isCreatingTrip;
  final bool isConfirmingTrip;
  final bool isCancellingTrip;
  final String? errorMessage;
  final bool isSuccess;

  bool get isAnyLoading =>
      isLoading || isCreatingTrip || isConfirmingTrip || isCancellingTrip;

  TripState copyWith({
    List<TripType>? tripTypes,
    List<Trip>? availableTrips,
    Trip? currentTrip,
    bool? isLoading,
    bool? isCreatingTrip,
    bool? isConfirmingTrip,
    bool? isCancellingTrip,
    String? errorMessage,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return TripState(
      tripTypes: tripTypes ?? this.tripTypes,
      availableTrips: availableTrips ?? this.availableTrips,
      currentTrip: currentTrip ?? this.currentTrip,
      isLoading: isLoading ?? this.isLoading,
      isCreatingTrip: isCreatingTrip ?? this.isCreatingTrip,
      isConfirmingTrip: isConfirmingTrip ?? this.isConfirmingTrip,
      isCancellingTrip: isCancellingTrip ?? this.isCancellingTrip,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Controller for trip operations using Riverpod 3.x Notifier.
class TripController extends AutoDisposeNotifier<TripState> {
  late final GetTripTypesUseCase _getTripTypesUseCase;
  late final GetTripDetailUseCase _getTripDetailUseCase;
  late final GetAvailablePublicTripsUseCase _getAvailablePublicTripsUseCase;
  late final StorePublicTripUseCase _storePublicTripUseCase;
  late final StorePrivateTripUseCase _storePrivateTripUseCase;
  late final ConfirmTripUseCase _confirmTripUseCase;
  late final CancelTripUseCase _cancelTripUseCase;

  @override
  TripState build() {
    _getTripTypesUseCase = ref.watch(getTripTypesUseCaseProvider);
    _getTripDetailUseCase = ref.watch(getTripDetailUseCaseProvider);
    _getAvailablePublicTripsUseCase = ref.watch(
      getAvailablePublicTripsUseCaseProvider,
    );
    _storePublicTripUseCase = ref.watch(storePublicTripUseCaseProvider);
    _storePrivateTripUseCase = ref.watch(storePrivateTripUseCaseProvider);
    _confirmTripUseCase = ref.watch(confirmTripUseCaseProvider);
    _cancelTripUseCase = ref.watch(cancelTripUseCaseProvider);
    return const TripState();
  }

  /// Load trip types.
  Future<void> loadTripTypes() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getTripTypesUseCase(
      GetTripTypesParameters.builder().build(),
    );

    result.when(
      success: (tripTypes, error) {
        state = state.copyWith(tripTypes: tripTypes, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  /// Load available public trips.
  Future<void> loadAvailableTrips({
    required String orderId,
    required String userId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getAvailablePublicTripsUseCase(
      GetAvailablePublicTripsParameters.builder()
          .withOrderId(orderId)
          .withUserId(userId)
          .build(),
    );

    result.when(
      success: (trips, i) {
        state = state.copyWith(availableTrips: trips, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  /// Get trip details.
  Future<Trip?> getTripDetail(int tripId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getTripDetailUseCase(
      GetTripDetailParameters.builder().withTripId(tripId).build(),
    );

    return result.when(
      success: (trip, i) {
        state = state.copyWith(currentTrip: trip, isLoading: false);
        return trip;
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
        return null;
      },
    );
  }

  /// Create a public trip.
  Future<Trip?> createPublicTrip({
    required int vehicleTypeId,
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String dropoffAddress,
    String? notes,
  }) async {
    state = state.copyWith(isCreatingTrip: true, clearError: true);

    final result = await _storePublicTripUseCase(
      StorePublicTripParameters.builder()
          .withVehicleTypeId(vehicleTypeId)
          .withPickUpLocation(
            pickupLongitude.toString(),
            pickupLatitude.toString(),
          )
          .withPickupName(pickupAddress)
          .withDestinationLocation(
            dropoffLongitude.toString(),
            dropoffLatitude.toString(),
          )
          .withDestinationName(dropoffAddress)
          .build(),
    );

    return result.when(
      success: (trip, i) {
        state = state.copyWith(
          currentTrip: trip,
          isCreatingTrip: false,
          isSuccess: true,
        );
        return trip;
      },
      exception: (error) {
        state = state.copyWith(
          isCreatingTrip: false,
          errorMessage: error.message,
        );
        return null;
      },
    );
  }

  /// Create a private trip.
  Future<Trip?> createPrivateTrip({
    required int vehicleTypeId,
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String dropoffAddress,
    required String appointmentType,
    String? date,
    String? pickUpTime,
    String? dropUpTime,
  }) async {
    state = state.copyWith(isCreatingTrip: true, clearError: true);

    final result = await _storePrivateTripUseCase(
      StorePrivateTripParameters.builder()
          .withVehicleTypeId(vehicleTypeId)
          .withPickUpLocation(
            pickupLongitude.toString(),
            pickupLatitude.toString(),
          )
          .withPickupName(pickupAddress)
          .withDestinationLocation(
            dropoffLongitude.toString(),
            dropoffLatitude.toString(),
          )
          .withDestinationName(dropoffAddress)
          .withAppointmentType(appointmentType)
          .withDate(date)
          .withPickUpTime(pickUpTime)
          .withDropUpTime(dropUpTime)
          .build(),
    );

    return result.when(
      success: (trip, i) {
        state = state.copyWith(
          currentTrip: trip,
          isCreatingTrip: false,
          isSuccess: true,
        );
        return trip;
      },
      exception: (error) {
        state = state.copyWith(
          isCreatingTrip: false,
          errorMessage: error.message,
        );
        return null;
      },
    );
  }

  /// Confirm a trip.
  Future<Trip?> confirmTrip({
    required String orderId,
    required String userId,
  }) async {
    state = state.copyWith(isConfirmingTrip: true, clearError: true);

    final result = await _confirmTripUseCase(
      ConfirmTripParameters.builder()
          .withOrderId(orderId)
          .withUserId(userId)
          .build(),
    );

    return result.when(
      success: (trip, i) {
        state = state.copyWith(
          currentTrip: trip,
          isConfirmingTrip: false,
          isSuccess: true,
        );
        return trip;
      },
      exception: (error) {
        state = state.copyWith(
          isConfirmingTrip: false,
          errorMessage: error.message,
        );
        return null;
      },
    );
  }

  /// Cancel a trip.
  Future<bool> cancelTrip({
    required String orderId,
    required String userId,
  }) async {
    state = state.copyWith(isCancellingTrip: true, clearError: true);

    final result = await _cancelTripUseCase(
      CancelTripParameters.builder()
          .withOrderId(orderId)
          .withUserId(userId)
          .build(),
    );

    return result.when(
      success: (_, __) {
        state = state.copyWith(isCancellingTrip: false, isSuccess: true);
        return true;
      },
      exception: (error) {
        state = state.copyWith(
          isCancellingTrip: false,
          errorMessage: error.message,
        );
        return false;
      },
    );
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Reset success state.
  void resetSuccess() {
    state = state.copyWith(isSuccess: false);
  }
}
