// lib/features/trip/data/parameters/store_private_trip_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for creating a private trip.
@immutable
class StorePrivateTripParameters extends Parameters {
  const StorePrivateTripParameters._({
    required this.pickUpLongitude,
    required this.pickUpLatitude,
    required this.destinationLongitude,
    required this.destinationLatitude,
    required this.pickupName,
    required this.destinationName,
    required this.vehicleTypeId,
    required this.smoker,
    required this.pet,
    required this.luggage,
    required this.appointmentType,
    this.date,
    this.pickUpTime,
    this.dropUpTime,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {
    'pick_up_longitude': pickUpLongitude,
    'pick_up_latitude': pickUpLatitude,
    'destination_longitude': destinationLongitude,
    'destination_latitude': destinationLatitude,
    'pickup_name': pickupName,
    'destination_name': destinationName,
    'vehicle_type_id': vehicleTypeId,
    'smoker': smoker,
    'pet': pet,
    'luggage': luggage,
    'appointment_type': appointmentType,
    if (date != null) 'date': date,
    if (pickUpTime != null) 'pick_up_time': pickUpTime,
    if (dropUpTime != null) 'drop_up_time': dropUpTime,
  };

  final String pickUpLongitude;
  final String pickUpLatitude;
  final String destinationLongitude;
  final String destinationLatitude;
  final String pickupName;
  final String destinationName;
  final int vehicleTypeId;
  final bool smoker;
  final bool pet;
  final bool luggage;
  final String appointmentType; // 1=scheduled, 2=instant
  final String? date;
  final String? pickUpTime;
  final String? dropUpTime;

  @override
  final CancelToken? cancelToken;

  static StorePrivateTripParametersBuilder builder() => StorePrivateTripParametersBuilder();
}

/// Builder for StorePrivateTripParameters.
class StorePrivateTripParametersBuilder extends ParametersBuilder<StorePrivateTripParameters> {
  String? _pickUpLongitude;
  String? _pickUpLatitude;
  String? _destinationLongitude;
  String? _destinationLatitude;
  String? _pickupName;
  String? _destinationName;
  int? _vehicleTypeId;
  bool? _smoker;
  bool? _pet;
  bool? _luggage;
  String? _appointmentType;
  String? _date;
  String? _pickUpTime;
  String? _dropUpTime;
  CancelToken? _cancelToken;

  StorePrivateTripParametersBuilder withPickUpLocation(
    String longitude,
    String latitude,
  ) {
    _pickUpLongitude = longitude;
    _pickUpLatitude = latitude;
    return this;
  }

  StorePrivateTripParametersBuilder withDestinationLocation(
    String longitude,
    String latitude,
  ) {
    _destinationLongitude = longitude;
    _destinationLatitude = latitude;
    return this;
  }

  StorePrivateTripParametersBuilder withPickupName(String pickupName) {
    _pickupName = pickupName;
    return this;
  }

  StorePrivateTripParametersBuilder withDestinationName(String destinationName) {
    _destinationName = destinationName;
    return this;
  }

  StorePrivateTripParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  StorePrivateTripParametersBuilder withSmoker(bool smoker) {
    _smoker = smoker;
    return this;
  }

  StorePrivateTripParametersBuilder withPet(bool pet) {
    _pet = pet;
    return this;
  }

  StorePrivateTripParametersBuilder withLuggage(bool luggage) {
    _luggage = luggage;
    return this;
  }

  StorePrivateTripParametersBuilder withAppointmentType(String appointmentType) {
    _appointmentType = appointmentType;
    return this;
  }

  StorePrivateTripParametersBuilder withDate(String? date) {
    _date = date;
    return this;
  }

  StorePrivateTripParametersBuilder withPickUpTime(String? pickUpTime) {
    _pickUpTime = pickUpTime;
    return this;
  }

  StorePrivateTripParametersBuilder withDropUpTime(String? dropUpTime) {
    _dropUpTime = dropUpTime;
    return this;
  }

  @override
  StorePrivateTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  StorePrivateTripParameters build() {
    return StorePrivateTripParameters._(
      pickUpLongitude: _pickUpLongitude!,
      pickUpLatitude: _pickUpLatitude!,
      destinationLongitude: _destinationLongitude!,
      destinationLatitude: _destinationLatitude!,
      pickupName: _pickupName!,
      destinationName: _destinationName!,
      vehicleTypeId: _vehicleTypeId!,
      smoker: _smoker!,
      pet: _pet!,
      luggage: _luggage!,
      appointmentType: _appointmentType!,
      date: _date,
      pickUpTime: _pickUpTime,
      dropUpTime: _dropUpTime,
      cancelToken: _cancelToken,
    );
  }
}
