/// Parameters for rejecting a trip
class RejectTripParameters {
  final String tripId;
  final String? reason;

  RejectTripParameters({
    required this.tripId,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      if (reason != null) 'reason': reason,
    };
  }
}