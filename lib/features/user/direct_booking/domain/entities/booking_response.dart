/// Entity representing a booking response.
class BookingResponse {
  final String bookingId;
  final String status;
  final String estimatedArrivalTime;
  final String estimatedFare;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? driverPhoto;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? vehicleColor;
  final DateTime createdAt;

  const BookingResponse({
    required this.bookingId,
    required this.status,
    required this.estimatedArrivalTime,
    required this.estimatedFare,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
    this.vehicleNumber,
    this.vehicleModel,
    this.vehicleColor,
    required this.createdAt,
  });
}
