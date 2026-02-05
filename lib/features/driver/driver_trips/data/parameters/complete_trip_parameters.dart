/// Parameters for completing a trip
class CompleteTripParameters {
  final String tripId;
  final double actualFare;

  CompleteTripParameters({
    required this.tripId,
    required this.actualFare,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'actualFare': actualFare,
    };
  }
}