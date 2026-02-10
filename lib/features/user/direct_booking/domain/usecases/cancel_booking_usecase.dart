import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/direct_booking/domain/repositories/direct_booking_repository.dart';

/// Use case for cancelling a booking.
class CancelBookingUseCase {
  final DirectBookingRepository _repository;

  CancelBookingUseCase(this._repository);

  Future<ApiResult<void>> call(String bookingId) {
    return _repository.cancelBooking(bookingId);
  }
}
