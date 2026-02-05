import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for creating a schedule trip request.
@immutable
class CreateScheduleRequestParameters extends Parameters {
  final String _pickUpLongitude;
  final String _pickUpLatitude;
  final String _destinationLongitude;
  final String _destinationLatitude;
  final String _pickupName;
  final String _destinationName;
  final String _date;
  final String _pickUpTime;
  final String _dropUpTime;
  final int _vehicleTypeId;
  final CancelToken? _cancelToken;

  const CreateScheduleRequestParameters._({
    required String pickUpLongitude,
    required String pickUpLatitude,
    required String destinationLongitude,
    required String destinationLatitude,
    required String pickupName,
    required String destinationName,
    required String date,
    required String pickUpTime,
    required String dropUpTime,
    required int vehicleTypeId,
    CancelToken? cancelToken,
  }) : _pickUpLongitude = pickUpLongitude,
       _pickUpLatitude = pickUpLatitude,
       _destinationLongitude = destinationLongitude,
       _destinationLatitude = destinationLatitude,
       _pickupName = pickupName,
       _destinationName = destinationName,
       _date = date,
       _pickUpTime = pickUpTime,
       _dropUpTime = dropUpTime,
       _vehicleTypeId = vehicleTypeId,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'pick_up_longitude': _pickUpLongitude,
      'pick_up_latitude': _pickUpLatitude,
      'destination_longitude': _destinationLongitude,
      'destination_latitude': _destinationLatitude,
      'pickup_name': _pickupName,
      'destination_name': _destinationName,
      'date': _date,
      'pick_up_time': _pickUpTime,
      'drop_up_time': _dropUpTime,
      'vehicle_type_id': _vehicleTypeId,
    };
  }

  String get pickUpLongitude => _pickUpLongitude;
  String get pickUpLatitude => _pickUpLatitude;
  String get destinationLongitude => _destinationLongitude;
  String get destinationLatitude => _destinationLatitude;
  String get pickupName => _pickupName;
  String get destinationName => _destinationName;
  String get date => _date;
  String get pickUpTime => _pickUpTime;
  String get dropUpTime => _dropUpTime;
  int get vehicleTypeId => _vehicleTypeId;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static CreateScheduleRequestParametersBuilder builder() =>
      CreateScheduleRequestParametersBuilder();
}

/// Builder for CreateScheduleRequestParameters
class CreateScheduleRequestParametersBuilder
    extends ParametersBuilder<CreateScheduleRequestParameters> {
  String? _pickUpLongitude;
  String? _pickUpLatitude;
  String? _destinationLongitude;
  String? _destinationLatitude;
  String? _pickupName;
  String? _destinationName;
  String? _date;
  String? _pickUpTime;
  String? _dropUpTime;
  int? _vehicleTypeId;
  CancelToken? _cancelToken;

  /// Set the pickup longitude
  CreateScheduleRequestParametersBuilder withPickUpLongitude(String pickUpLongitude) {
    _pickUpLongitude = pickUpLongitude;
    return this;
  }

  /// Set the pickup latitude
  CreateScheduleRequestParametersBuilder withPickUpLatitude(String pickUpLatitude) {
    _pickUpLatitude = pickUpLatitude;
    return this;
  }

  /// Set the destination longitude
  CreateScheduleRequestParametersBuilder withDestinationLongitude(String destinationLongitude) {
    _destinationLongitude = destinationLongitude;
    return this;
  }

  /// Set the destination latitude
  CreateScheduleRequestParametersBuilder withDestinationLatitude(String destinationLatitude) {
    _destinationLatitude = destinationLatitude;
    return this;
  }

  /// Set the pickup name
  CreateScheduleRequestParametersBuilder withPickupName(String pickupName) {
    _pickupName = pickupName;
    return this;
  }

  /// Set the destination name
  CreateScheduleRequestParametersBuilder withDestinationName(String destinationName) {
    _destinationName = destinationName;
    return this;
  }

  /// Set the date
  CreateScheduleRequestParametersBuilder withDate(String date) {
    _date = date;
    return this;
  }

  /// Set the pickup time
  CreateScheduleRequestParametersBuilder withPickUpTime(String pickUpTime) {
    _pickUpTime = pickUpTime;
    return this;
  }

  /// Set the drop-up time
  CreateScheduleRequestParametersBuilder withDropUpTime(String dropUpTime) {
    _dropUpTime = dropUpTime;
    return this;
  }

  /// Set the vehicle type ID
  CreateScheduleRequestParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  CreateScheduleRequestParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the CreateScheduleRequestParameters
  @override
  CreateScheduleRequestParameters build() {
    if (_pickUpLongitude == null) {
      throw ArgumentError('Pickup longitude is required');
    }
    if (_pickUpLatitude == null) {
      throw ArgumentError('Pickup latitude is required');
    }
    if (_destinationLongitude == null) {
      throw ArgumentError('Destination longitude is required');
    }
    if (_destinationLatitude == null) {
      throw ArgumentError('Destination latitude is required');
    }
    if (_pickupName == null) {
      throw ArgumentError('Pickup name is required');
    }
    if (_destinationName == null) {
      throw ArgumentError('Destination name is required');
    }
    if (_date == null) {
      throw ArgumentError('Date is required');
    }
    if (_pickUpTime == null) {
      throw ArgumentError('Pickup time is required');
    }
    if (_dropUpTime == null) {
      throw ArgumentError('Drop-up time is required');
    }
    if (_vehicleTypeId == null) {
      throw ArgumentError('Vehicle type ID is required');
    }
    return CreateScheduleRequestParameters._(
      pickUpLongitude: _pickUpLongitude!,
      pickUpLatitude: _pickUpLatitude!,
      destinationLongitude: _destinationLongitude!,
      destinationLatitude: _destinationLatitude!,
      pickupName: _pickupName!,
      destinationName: _destinationName!,
      date: _date!,
      pickUpTime: _pickUpTime!,
      dropUpTime: _dropUpTime!,
      vehicleTypeId: _vehicleTypeId!,
      cancelToken: _cancelToken,
    );
  }
}
