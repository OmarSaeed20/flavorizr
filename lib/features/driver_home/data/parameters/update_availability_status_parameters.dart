/// Parameters for updating driver availability status
class UpdateAvailabilityStatusParameters {
  final bool isAvailable;

  UpdateAvailabilityStatusParameters({
    required this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
    };
  }
}