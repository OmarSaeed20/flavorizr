import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Use case for cancelling a booking.
class CancelBookingUseCase {
  final DirectBookingRepository _repository;

  CancelBookingUseCase(this._repository);

  Future<ApiResult<void>> call(String bookingId) {
    return _repository.cancelBooking(bookingId);
  }
}
