import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/create_booking_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/get_nearby_drivers_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/booking_response.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/driver.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/vehicle_type.dart';

/// Repository interface for direct booking operations.
abstract class DirectBookingRepository {
  /// Creates a new booking.
  Future<ApiResult<BookingResponse>> createBooking(CreateBookingParameters params);

  /// Gets nearby drivers based on location.
  Future<ApiResult<List<TaxiDriver>>> getNearbyDrivers(GetNearbyDriversParameters params);

  /// Gets available vehicle types.
  Future<ApiResult<List<VehicleType>>> getVehicleTypes();

  /// Cancels a booking.
  Future<ApiResult<void>> cancelBooking(String bookingId);
}
