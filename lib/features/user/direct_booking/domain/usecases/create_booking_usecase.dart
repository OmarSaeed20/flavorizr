import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/direct_booking/data/parameters/create_booking_parameters.dart';
import 'package:flavorizr/features/user/direct_booking/domain/entities/booking_response.dart';
import 'package:flavorizr/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Use case for creating a booking.
class CreateBookingUseCase {
  final DirectBookingRepository _repository;

  CreateBookingUseCase(this._repository);

  Future<ApiResult<BookingResponse>> call(
    CreateBookingParameters params,
  ) {
    return _repository.createBooking(params);
  }
}