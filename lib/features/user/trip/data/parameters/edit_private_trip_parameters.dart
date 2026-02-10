// lib/features/trip/data/parameters/edit_private_trip_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for editing a private trip.
@immutable
class EditPrivateTripParameters extends Parameters {
  const EditPrivateTripParameters._({
    required this.orderId,
    required this.pickUpLongitude,
    required this.pickUpLatitude,
    required this.destinationLongitude,
    required this.destinationLatitude,
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
    'order_id': orderId,
    'pick_up_longitude': pickUpLongitude,
    'pick_up_latitude': pickUpLatitude,
    'destination_longitude': destinationLongitude,
    'destination_latitude': destinationLatitude,
    'date': date,
    'pick_up_time': pickUpTime,
    'drop_up_time': dropUpTime,
    'smoker': smoker,
    'pet': pet,
    'luggage': luggage,
    'vehicle_type_id': vehicleTypeId,
  };

  final int orderId;
  final String pickUpLongitude;
  final String pickUpLatitude;
  final String destinationLongitude;
  final String destinationLatitude;
  final String date;
  final String pickUpTime;
  final String dropUpTime;
  final bool smoker;
  final bool pet;
  final bool luggage;
  final int vehicleTypeId;

  @override
  final CancelToken? cancelToken;

  static EditPrivateTripParametersBuilder builder() =>
      EditPrivateTripParametersBuilder();
}

/// Builder for EditPrivateTripParameters.
class EditPrivateTripParametersBuilder
    extends ParametersBuilder<EditPrivateTripParameters> {
  int? _orderId;
  String? _pickUpLongitude;
  String? _pickUpLatitude;
  String? _destinationLongitude;
  String? _destinationLatitude;
  String? _date;
  String? _pickUpTime;
  String? _dropUpTime;
  bool? _smoker;
  bool? _pet;
  bool? _luggage;
  int? _vehicleTypeId;
  CancelToken? _cancelToken;

  EditPrivateTripParametersBuilder withOrderId(int orderId) {
    _orderId = orderId;
    return this;
  }

  EditPrivateTripParametersBuilder withPickUpLocation(
    String longitude,
    String latitude,
  ) {
    _pickUpLongitude = longitude;
    _pickUpLatitude = latitude;
    return this;
  }

  EditPrivateTripParametersBuilder withDestinationLocation(
    String longitude,
    String latitude,
  ) {
    _destinationLongitude = longitude;
    _destinationLatitude = latitude;
    return this;
  }

  EditPrivateTripParametersBuilder withDate(String date) {
    _date = date;
    return this;
  }

  EditPrivateTripParametersBuilder withPickUpTime(String pickUpTime) {
    _pickUpTime = pickUpTime;
    return this;
  }

  EditPrivateTripParametersBuilder withDropUpTime(String dropUpTime) {
    _dropUpTime = dropUpTime;
    return this;
  }

  EditPrivateTripParametersBuilder withSmoker(bool smoker) {
    _smoker = smoker;
    return this;
  }

  EditPrivateTripParametersBuilder withPet(bool pet) {
    _pet = pet;
    return this;
  }

  EditPrivateTripParametersBuilder withLuggage(bool luggage) {
    _luggage = luggage;
    return this;
  }

  EditPrivateTripParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  @override
  EditPrivateTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  EditPrivateTripParameters build() {
    return EditPrivateTripParameters._(
      orderId: _orderId!,
      pickUpLongitude: _pickUpLongitude!,
      pickUpLatitude: _pickUpLatitude!,
      destinationLongitude: _destinationLongitude!,
      destinationLatitude: _destinationLatitude!,
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
