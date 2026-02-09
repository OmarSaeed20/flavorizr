import 'package:fast_golden_taxi/features/user/direct_booking/domain/entities/booking_response.dart';

class BookingResponseModel extends BookingResponse {
  const BookingResponseModel({
    required super.bookingId,
    required super.status,
    required super.estimatedArrivalTime,
    required super.estimatedFare,
    super.driverId,
    super.driverName,
    super.driverPhone,
    super.driverPhoto,
    super.vehicleNumber,
    super.vehicleModel,
    super.vehicleColor,
    required super.createdAt,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      bookingId: json['booking_id'] as String,
      status: json['status'] as String,
      estimatedArrivalTime: json['estimated_arrival_time'] as String,
      estimatedFare: json['estimated_fare'] as String,
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      driverPhoto: json['driver_photo'] as String?,
      vehicleNumber: json['vehicle_number'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
      vehicleColor: json['vehicle_color'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'status': status,
      'estimated_arrival_time': estimatedArrivalTime,
      'estimated_fare': estimatedFare,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'driver_photo': driverPhoto,
      'vehicle_number': vehicleNumber,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'created_at': createdAt.toIso8601String(),
    };
  }

  BookingResponse toEntity() => this;
}
