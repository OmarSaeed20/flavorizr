/// Parameters for updating driver vehicle.
class UpdateDriverVehicleParameters {
  final String? make;
  final String? model;
  final int? year;
  final String? color;
  final String? licensePlate;
  final String? vehicleType;
  final int? capacity;
  final String? vin;
  final String? registrationNumber;
  final DateTime? registrationExpiry;

  UpdateDriverVehicleParameters({
    this.make,
    this.model,
    this.year,
    this.color,
    this.licensePlate,
    this.vehicleType,
    this.capacity,
    this.vin,
    this.registrationNumber,
    this.registrationExpiry,
  });

  Map<String, dynamic> toJson() {
    return {
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (color != null) 'color': color,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (capacity != null) 'capacity': capacity,
      if (vin != null) 'vin': vin,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (registrationExpiry != null)
        'registration_expiry': registrationExpiry!.toIso8601String(),
    };
  }
}