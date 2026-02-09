// lib/features/trip/data/parameters/store_public_trip_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for creating a public trip.
@immutable
class StorePublicTripParameters extends Parameters {
  const StorePublicTripParameters._({
    required this.pickUpLongitude,
    required this.pickUpLatitude,
    required this.destinationLongitude,
    required this.destinationLatitude,
    required this.pickupName,
    required this.destinationName,
    required this.date,
    required this.pickUpTime,
    required this.dropUpTime,
    required this.smoker,
    required this.pet,
    required this.luggage,
    required this.vehicleTypeId,
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
    'date': date,
    'pick_up_time': pickUpTime,
    'drop_up_time': dropUpTime,
    'smoker': smoker,
    'pet': pet,
    'luggage': luggage,
    'vehicle_type_id': vehicleTypeId,
  };

  final String pickUpLongitude;
  final String pickUpLatitude;
  final String destinationLongitude;
  final String destinationLatitude;
  final String pickupName;
  final String destinationName;
  final String date;
  final String pickUpTime;
  final String dropUpTime;
  final bool smoker;
  final bool pet;
  final bool luggage;
  final int vehicleTypeId;

  @override
  final CancelToken? cancelToken;

  static StorePublicTripParametersBuilder builder() => StorePublicTripParametersBuilder();
}

/// Builder for StorePublicTripParameters.
class StorePublicTripParametersBuilder extends ParametersBuilder<StorePublicTripParameters> {
  String? _pickUpLongitude;
  String? _pickUpLatitude;
  String? _destinationLongitude;
  String? _destinationLatitude;
  String? _pickupName;
  String? _destinationName;
  String? _date;
  String? _pickUpTime;
  String? _dropUpTime;
  bool? _smoker;
  bool? _pet;
  bool? _luggage;
  int? _vehicleTypeId;
  CancelToken? _cancelToken;

  StorePublicTripParametersBuilder withPickUpLocation(String longitude, String latitude) {
    _pickUpLongitude = longitude;
    _pickUpLatitude = latitude;
    return this;
  }

  StorePublicTripParametersBuilder withDestinationLocation(String longitude, String latitude) {
    _destinationLongitude = longitude;
    _destinationLatitude = latitude;
    return this;
  }

  StorePublicTripParametersBuilder withPickupName(String pickupName) {
    _pickupName = pickupName;
    return this;
  }

  StorePublicTripParametersBuilder withDestinationName(String destinationName) {
    _destinationName = destinationName;
    return this;
  }

  StorePublicTripParametersBuilder withDate(String date) {
    _date = date;
    return this;
  }

  StorePublicTripParametersBuilder withPickUpTime(String pickUpTime) {
    _pickUpTime = pickUpTime;
    return this;
  }

  StorePublicTripParametersBuilder withDropUpTime(String dropUpTime) {
    _dropUpTime = dropUpTime;
    return this;
  }

  StorePublicTripParametersBuilder withSmoker(bool smoker) {
    _smoker = smoker;
    return this;
  }

  StorePublicTripParametersBuilder withPet(bool pet) {
    _pet = pet;
    return this;
  }

  StorePublicTripParametersBuilder withLuggage(bool luggage) {
    _luggage = luggage;
    return this;
  }

  StorePublicTripParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  @override
  StorePublicTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  StorePublicTripParameters build() {
    return StorePublicTripParameters._(
      pickUpLongitude: _pickUpLongitude!,
      pickUpLatitude: _pickUpLatitude!,
      destinationLongitude: _destinationLongitude!,
      destinationLatitude: _destinationLatitude!,
      pickupName: _pickupName!,
      destinationName: _destinationName!,
      date: _date!,
      pickUpTime: _pickUpTime!,
      dropUpTime: _dropUpTime!,
      smoker: _smoker!,
      pet: _pet!,
      luggage: _luggage!,
      vehicleTypeId: _vehicleTypeId!,
      cancelToken: _cancelToken,
    );
  }
}
