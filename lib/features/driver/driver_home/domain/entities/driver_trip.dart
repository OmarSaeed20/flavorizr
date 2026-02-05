/// Driver trip entity representing a completed or ongoing trip
class DriverTrip {
  final String id;
  final String passengerName;
  final String? passengerImage;
  final String pickupLocation;
  final String dropoffLocation;
  final double distance;
  final double fare;
  final String status; // completed, cancelled, in_progress
  final DateTime startTime;
  final DateTime? endTime;
  final double? rating;
  final String? ratingComment;
  final String paymentMethod;
  final double duration; // in minutes

  const DriverTrip({
    required this.id,
    required this.passengerName,
    this.passengerImage,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.fare,
    required this.status,
    required this.startTime,
    this.endTime,
    this.rating,
    this.ratingComment,
    required this.paymentMethod,
    required this.duration,
  });

  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isInProgress => status == 'in_progress';

  DriverTrip copyWith({
    String? id,
    String? passengerName,
    String? passengerImage,
    String? pickupLocation,
    String? dropoffLocation,
    double? distance,
    double? fare,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    double? rating,
    String? ratingComment,
    String? paymentMethod,
    double? duration,
  }) {
    return DriverTrip(
      id: id ?? this.id,
      passengerName: passengerName ?? this.passengerName,
      passengerImage: passengerImage ?? this.passengerImage,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      distance: distance ?? this.distance,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      rating: rating ?? this.rating,
      ratingComment: ratingComment ?? this.ratingComment,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      duration: duration ?? this.duration,
    );
  }
}
