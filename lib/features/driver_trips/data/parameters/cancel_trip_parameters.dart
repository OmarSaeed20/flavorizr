/// Parameters for cancelling a trip
class CancelTripParameters {
  final String tripId;
  final String reason;

  CancelTripParameters({
    required this.tripId,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'reason': reason,
    };
  }
}