import 'package:fast_golden_taxi/core/network/base/repo/base_repository.dart';
import 'package:fast_golden_taxi/core/network/network_info.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/datasources/direct_booking_remote_datasource.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/create_booking_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/data/parameters/get_nearby_drivers_parameters.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/booking_response.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/driver.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/vehicle_type.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Implementation of [DirectBookingRepository].
class DirectBookingRepositoryImpl extends BaseRepository
    implements DirectBookingRepository {
  final DirectBookingRemoteDataSource _remoteDataSource;

  DirectBookingRepositoryImpl({
    required DirectBookingRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<BookingResponse>> createBooking(
    CreateBookingParameters params,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.createBooking(params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.toEntity()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<List<TaxiDriver>>> getNearbyDrivers(
    GetNearbyDriversParameters params,
  ) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.getNearbyDrivers(params),
    );
    return result.map(
      success: (data) =>
          ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<List<VehicleType>>> getVehicleTypes() async {
    final result = await executeRemoteRequest(
      request: _remoteDataSource.getVehicleTypes,
    );
    return result.map(
      success: (data) =>
          ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }

  @override
  Future<ApiResult<void>> cancelBooking(String bookingId) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.cancelBooking(bookingId),
    );
    return result.map(
      success: (data) => const ApiResult.success(null),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }
}
