import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/create_booking_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/get_nearby_drivers_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/booking_response.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/driver.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/vehicle_type.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/create_booking_usecase.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/get_nearby_drivers_usecase.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/usecases/get_vehicle_types_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for direct booking operations.
class DirectBookingState {
  final List<VehicleType> vehicleTypes;
  final List<TaxiDriver> nearbyDrivers;
  final BookingResponse? currentBooking;
  final VehicleType? selectedVehicleType;
  final bool isLoadingVehicleTypes;
  final bool isLoadingDrivers;
  final bool isCreatingBooking;
  final bool isCancellingBooking;
  final String? error;

  const DirectBookingState({
    this.vehicleTypes = const [],
    this.nearbyDrivers = const [],
    this.currentBooking,
    this.selectedVehicleType,
    this.isLoadingVehicleTypes = false,
    this.isLoadingDrivers = false,
    this.isCreatingBooking = false,
    this.isCancellingBooking = false,
    this.error,
  });

  DirectBookingState copyWith({
    List<VehicleType>? vehicleTypes,
    List<TaxiDriver>? nearbyDrivers,
    bool? removeCurrentBooking,
    BookingResponse? currentBooking,
    VehicleType? selectedVehicleType,
    bool? isLoadingVehicleTypes,
    bool? isLoadingDrivers,
    bool? isCreatingBooking,
    bool? isCancellingBooking,
    String? error,
  }) {
    return DirectBookingState(
      vehicleTypes: vehicleTypes ?? this.vehicleTypes,
      nearbyDrivers: nearbyDrivers ?? this.nearbyDrivers,
      currentBooking: removeCurrentBooking ?? false
          ? null
          : (currentBooking ?? this.currentBooking),
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      isLoadingVehicleTypes: isLoadingVehicleTypes ?? this.isLoadingVehicleTypes,
      isLoadingDrivers: isLoadingDrivers ?? this.isLoadingDrivers,
      isCreatingBooking: isCreatingBooking ?? this.isCreatingBooking,
      isCancellingBooking: isCancellingBooking ?? this.isCancellingBooking,
      error: error,
    );
  }
}

/// Controller for managing direct booking operations.
class DirectBookingController extends StateNotifier<DirectBookingState> {
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;
  final GetNearbyDriversUseCase _getNearbyDriversUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;

  DirectBookingController(
    this._getVehicleTypesUseCase,
    this._getNearbyDriversUseCase,
    this._createBookingUseCase,
    this._cancelBookingUseCase,
  ) : super(const DirectBookingState());

  /// Gets available vehicle types.
  Future<void> getVehicleTypes() async {
    state = state.copyWith(isLoadingVehicleTypes: true);

    final result = await _getVehicleTypesUseCase();

    result.when(
      success: (data, _) {
        state = state.copyWith(vehicleTypes: data, isLoadingVehicleTypes: false);
      },
      exception: (error) {
        state = state.copyWith(isLoadingVehicleTypes: false, error: error.message);
      },
    );
  }

  /// Gets nearby drivers based on location.
  Future<void> getNearbyDrivers({
    required String latitude,
    required String longitude,
    String? vehicleType,
    int? radius,
  }) async {
    state = state.copyWith(isLoadingDrivers: true);

    final result = await _getNearbyDriversUseCase(
      GetNearbyDriversParameters(
        latitude: latitude,
        longitude: longitude,
        vehicleType: vehicleType,
        radius: radius,
      ),
    );

    result.when(
      success: (data, _) {
        state = state.copyWith(nearbyDrivers: data, isLoadingDrivers: false);
      },
      exception: (error) {
        state = state.copyWith(isLoadingDrivers: false, error: error.message);
      },
    );
  }

  /// Creates a new booking.
  Future<void> createBooking({
    required String pickupLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    String? dropoffLocation,
    String? dropoffLatitude,
    String? dropoffLongitude,
    required String vehicleType,
    String? paymentMethod,
    String? notes,
    String? promoCode,
  }) async {
    state = state.copyWith(isCreatingBooking: true);

    final result = await _createBookingUseCase(
      CreateBookingParameters(
        pickupLocation: pickupLocation,
        pickupLatitude: pickupLatitude,
        pickupLongitude: pickupLongitude,
        dropoffLocation: dropoffLocation,
        dropoffLatitude: dropoffLatitude,
        dropoffLongitude: dropoffLongitude,
        vehicleType: vehicleType,
        paymentMethod: paymentMethod,
        notes: notes,
        promoCode: promoCode,
      ),
    );

    result.when(
      success: (data, _) {
        state = state.copyWith(currentBooking: data, isCreatingBooking: false);
      },
      exception: (error) {
        state = state.copyWith(isCreatingBooking: false, error: error.message);
      },
    );
  }

  /// Cancels a booking.
  Future<void> cancelBooking(String bookingId) async {
    state = state.copyWith(isCancellingBooking: true);

    final result = await _cancelBookingUseCase(bookingId);

    result.when(
      success: (data, _) {
        state = state.copyWith(isCancellingBooking: false);
      },
      exception: (error) {
        state = state.copyWith(isCancellingBooking: false, error: error.message);
      },
    );
  }

  /// Selects a vehicle type.
  void selectVehicleType(VehicleType vehicleType) {
    state = state.copyWith(selectedVehicleType: vehicleType);
  }

  /// Clears the current state.
  void clear() {
    state = const DirectBookingState();
  }
}
