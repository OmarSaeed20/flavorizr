import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/core/network/api_client.dart';
import 'package:fast_golden_taxi/core/network/base/datasource/base_data_source.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/endpoints/direct_booking_endpoints.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/models/booking_response_model.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/models/driver_model.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/models/vehicle_type_model.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/create_booking_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/get_nearby_drivers_parameters.dart';

/// Remote data source for direct booking operations.
///
/// Handles all HTTP requests related to bookings.
/// Returns ApiResult with success or error data.
abstract class DirectBookingRemoteDataSource {
  /// Creates a new booking.
  Future<ApiResult<BookingResponseModel>> createBooking(CreateBookingParameters parameters);

  /// Gets nearby drivers based on location.
  Future<ApiResult<List<DriverModel>>> getNearbyDrivers(GetNearbyDriversParameters parameters);

  /// Gets available vehicle types.
  Future<ApiResult<List<VehicleTypeModel>>> getVehicleTypes();

  /// Cancels a booking.
  Future<ApiResult<void>> cancelBooking(String bookingId);
}

/// Implementation of [DirectBookingRemoteDataSource] using BaseRemoteDataSource.
class DirectBookingRemoteDataSourceImpl
    with BaseRemoteDataSource
    implements DirectBookingRemoteDataSource {
  const DirectBookingRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Dio get dio => _apiClient.dio;

  @override
  String get baseUrl => _apiClient.dio.options.baseUrl;

  @override
  Future<ApiResult<BookingResponseModel>> createBooking(CreateBookingParameters parameters) async {
    return post<BookingResponseModel>(
      path: DirectBookingEndpoints.createBooking,
      data: parameters.toJson(),
      decoder: (data) => BookingResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<List<DriverModel>>> getNearbyDrivers(
    GetNearbyDriversParameters parameters,
  ) async {
    return get<List<DriverModel>>(
      path: DirectBookingEndpoints.nearbyDrivers,
      queryParameters: parameters.toJson(),
      decoder: (data) => (data as List<dynamic>)
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<List<VehicleTypeModel>>> getVehicleTypes() async {
    return get<List<VehicleTypeModel>>(
      path: DirectBookingEndpoints.vehicleTypes,
      decoder: (data) => (data as List<dynamic>)
          .map((e) => VehicleTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResult<void>> cancelBooking(String bookingId) async {
    return post<void>(path: DirectBookingEndpoints.cancelBooking(bookingId), decoder: (data) {});
  }
}
