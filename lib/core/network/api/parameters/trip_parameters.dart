import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting trip types by location
@immutable
class GetTripTypesParameters extends Parameters {
  final String? _latitude;
  final String? _longitude;
  final CancelToken? _cancelToken;

  const GetTripTypesParameters._({
    String? latitude,
    String? longitude,
    CancelToken? cancelToken,
  }) : _latitude = latitude,
       _longitude = longitude,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (_latitude != null) json['latitude'] = _latitude;
    if (_longitude != null) json['longitude'] = _longitude;
    return json;
  }

  String? get latitude => _latitude;
  String? get longitude => _longitude;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetTripTypesParametersBuilder builder() =>
      GetTripTypesParametersBuilder();
}

/// Builder for GetTripTypesParameters
class GetTripTypesParametersBuilder
    extends ParametersBuilder<GetTripTypesParameters> {
  String? _latitude;
  String? _longitude;
  CancelToken? _cancelToken;

  /// Set the latitude
  GetTripTypesParametersBuilder withLatitude(String latitude) {
    _latitude = latitude;
    return this;
  }

  /// Set the longitude
  GetTripTypesParametersBuilder withLongitude(String longitude) {
    _longitude = longitude;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<GetTripTypesParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetTripTypesParameters
  @override
  GetTripTypesParameters build() {
    return GetTripTypesParameters._(
      latitude: _latitude,
      longitude: _longitude,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for getting captain trip detail
@immutable
class GetCaptainTripDetailParameters extends Parameters {
  final int _tripId;
  final CancelToken? _cancelToken;

  const GetCaptainTripDetailParameters._({
    required int tripId,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'trip_id': _tripId};
  }

  int get tripId => _tripId;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetCaptainTripDetailParametersBuilder builder() =>
      GetCaptainTripDetailParametersBuilder();
}

/// Builder for GetCaptainTripDetailParameters
class GetCaptainTripDetailParametersBuilder
    extends ParametersBuilder<GetCaptainTripDetailParameters> {
  int? _tripId;
  CancelToken? _cancelToken;

  /// Set the trip ID
  GetCaptainTripDetailParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<GetCaptainTripDetailParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetCaptainTripDetailParameters
  @override
  GetCaptainTripDetailParameters build() {
    assert(_tripId != null, 'Trip ID is required');

    return GetCaptainTripDetailParameters._(
      tripId: _tripId!,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for storing a public trip
@immutable
class StorePublicTripParameters extends Parameters {
  final String _pickupLocation;
  final String _dropoffLocation;
  final String _pickupLatitude;
  final String _pickupLongitude;
  final String _dropoffLatitude;
  final String _dropoffLongitude;
  final int _vehicleTypeId;
  final String? _scheduledDate;
  final String? _scheduledTime;
  final String? _notes;
  final CancelToken? _cancelToken;

  const StorePublicTripParameters._({
    required String pickupLocation,
    required String dropoffLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required int vehicleTypeId,
    String? scheduledDate,
    String? scheduledTime,
    String? notes,
    CancelToken? cancelToken,
  }) : _pickupLocation = pickupLocation,
       _dropoffLocation = dropoffLocation,
       _pickupLatitude = pickupLatitude,
       _pickupLongitude = pickupLongitude,
       _dropoffLatitude = dropoffLatitude,
       _dropoffLongitude = dropoffLongitude,
       _vehicleTypeId = vehicleTypeId,
       _scheduledDate = scheduledDate,
       _scheduledTime = scheduledTime,
       _notes = notes,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'pickup_location': _pickupLocation,
      'dropoff_location': _dropoffLocation,
      'pickup_latitude': _pickupLatitude,
      'pickup_longitude': _pickupLongitude,
      'dropoff_latitude': _dropoffLatitude,
      'dropoff_longitude': _dropoffLongitude,
      'vehicle_type_id': _vehicleTypeId,
    };
    if (_scheduledDate != null) json['scheduled_date'] = _scheduledDate;
    if (_scheduledTime != null) json['scheduled_time'] = _scheduledTime;
    if (_notes != null) json['notes'] = _notes;
    return json;
  }

  String get pickupLocation => _pickupLocation;
  String get dropoffLocation => _dropoffLocation;
  String get pickupLatitude => _pickupLatitude;
  String get pickupLongitude => _pickupLongitude;
  String get dropoffLatitude => _dropoffLatitude;
  String get dropoffLongitude => _dropoffLongitude;
  int get vehicleTypeId => _vehicleTypeId;
  String? get scheduledDate => _scheduledDate;
  String? get scheduledTime => _scheduledTime;
  String? get notes => _notes;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static StorePublicTripParametersBuilder builder() =>
      StorePublicTripParametersBuilder();
}

/// Builder for StorePublicTripParameters
class StorePublicTripParametersBuilder
    extends ParametersBuilder<StorePublicTripParameters> {
  String? _pickupLocation;
  String? _dropoffLocation;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropoffLatitude;
  String? _dropoffLongitude;
  int? _vehicleTypeId;
  String? _scheduledDate;
  String? _scheduledTime;
  String? _notes;
  CancelToken? _cancelToken;

  /// Set the pickup location
  StorePublicTripParametersBuilder withPickupLocation(String pickupLocation) {
    _pickupLocation = pickupLocation;
    return this;
  }

  /// Set the dropoff location
  StorePublicTripParametersBuilder withDropoffLocation(String dropoffLocation) {
    _dropoffLocation = dropoffLocation;
    return this;
  }

  /// Set the pickup latitude
  StorePublicTripParametersBuilder withPickupLatitude(String pickupLatitude) {
    _pickupLatitude = pickupLatitude;
    return this;
  }

  /// Set the pickup longitude
  StorePublicTripParametersBuilder withPickupLongitude(String pickupLongitude) {
    _pickupLongitude = pickupLongitude;
    return this;
  }

  /// Set the dropoff latitude
  StorePublicTripParametersBuilder withDropoffLatitude(String dropoffLatitude) {
    _dropoffLatitude = dropoffLatitude;
    return this;
  }

  /// Set the dropoff longitude
  StorePublicTripParametersBuilder withDropoffLongitude(
    String dropoffLongitude,
  ) {
    _dropoffLongitude = dropoffLongitude;
    return this;
  }

  /// Set the vehicle type ID
  StorePublicTripParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the scheduled date (format: YYYY-MM-DD)
  StorePublicTripParametersBuilder withScheduledDate(String scheduledDate) {
    _scheduledDate = scheduledDate;
    return this;
  }

  /// Set the scheduled time (format: HH:MM)
  StorePublicTripParametersBuilder withScheduledTime(String scheduledTime) {
    _scheduledTime = scheduledTime;
    return this;
  }

  /// Set the notes
  StorePublicTripParametersBuilder withNotes(String notes) {
    _notes = notes;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<StorePublicTripParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the StorePublicTripParameters
  @override
  StorePublicTripParameters build() {
    assert(
      _pickupLocation != null && _pickupLocation!.isNotEmpty,
      'Pickup location is required',
    );
    assert(
      _dropoffLocation != null && _dropoffLocation!.isNotEmpty,
      'Dropoff location is required',
    );
    assert(
      _pickupLatitude != null && _pickupLatitude!.isNotEmpty,
      'Pickup latitude is required',
    );
    assert(
      _pickupLongitude != null && _pickupLongitude!.isNotEmpty,
      'Pickup longitude is required',
    );
    assert(
      _dropoffLatitude != null && _dropoffLatitude!.isNotEmpty,
      'Dropoff latitude is required',
    );
    assert(
      _dropoffLongitude != null && _dropoffLongitude!.isNotEmpty,
      'Dropoff longitude is required',
    );
    assert(_vehicleTypeId != null, 'Vehicle type ID is required');

    return StorePublicTripParameters._(
      pickupLocation: _pickupLocation!,
      dropoffLocation: _dropoffLocation!,
      pickupLatitude: _pickupLatitude!,
      pickupLongitude: _pickupLongitude!,
      dropoffLatitude: _dropoffLatitude!,
      dropoffLongitude: _dropoffLongitude!,
      vehicleTypeId: _vehicleTypeId!,
      scheduledDate: _scheduledDate,
      scheduledTime: _scheduledTime,
      notes: _notes,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for storing a private trip
@immutable
class StorePrivateTripParameters extends Parameters {
  final String _pickupLocation;
  final String _dropoffLocation;
  final String _pickupLatitude;
  final String _pickupLongitude;
  final String _dropoffLatitude;
  final String _dropoffLongitude;
  final int _vehicleTypeId;
  final String _scheduledDate;
  final String _scheduledTime;
  final String? _notes;
  final CancelToken? _cancelToken;

  const StorePrivateTripParameters._({
    required String pickupLocation,
    required String dropoffLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required int vehicleTypeId,
    required String scheduledDate,
    required String scheduledTime,
    String? notes,
    CancelToken? cancelToken,
  }) : _pickupLocation = pickupLocation,
       _dropoffLocation = dropoffLocation,
       _pickupLatitude = pickupLatitude,
       _pickupLongitude = pickupLongitude,
       _dropoffLatitude = dropoffLatitude,
       _dropoffLongitude = dropoffLongitude,
       _vehicleTypeId = vehicleTypeId,
       _scheduledDate = scheduledDate,
       _scheduledTime = scheduledTime,
       _notes = notes,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'pickup_location': _pickupLocation,
      'dropoff_location': _dropoffLocation,
      'pickup_latitude': _pickupLatitude,
      'pickup_longitude': _pickupLongitude,
      'dropoff_latitude': _dropoffLatitude,
      'dropoff_longitude': _dropoffLongitude,
      'vehicle_type_id': _vehicleTypeId,
      'scheduled_date': _scheduledDate,
      'scheduled_time': _scheduledTime,
    };
    if (_notes != null) json['notes'] = _notes;
    return json;
  }

  String get pickupLocation => _pickupLocation;
  String get dropoffLocation => _dropoffLocation;
  String get pickupLatitude => _pickupLatitude;
  String get pickupLongitude => _pickupLongitude;
  String get dropoffLatitude => _dropoffLatitude;
  String get dropoffLongitude => _dropoffLongitude;
  int get vehicleTypeId => _vehicleTypeId;
  String get scheduledDate => _scheduledDate;
  String get scheduledTime => _scheduledTime;
  String? get notes => _notes;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static StorePrivateTripParametersBuilder builder() =>
      StorePrivateTripParametersBuilder();
}

/// Builder for StorePrivateTripParameters
class StorePrivateTripParametersBuilder
    extends ParametersBuilder<StorePrivateTripParameters> {
  String? _pickupLocation;
  String? _dropoffLocation;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropoffLatitude;
  String? _dropoffLongitude;
  int? _vehicleTypeId;
  String? _scheduledDate;
  String? _scheduledTime;
  String? _notes;
  CancelToken? _cancelToken;

  /// Set the pickup location
  StorePrivateTripParametersBuilder withPickupLocation(String pickupLocation) {
    _pickupLocation = pickupLocation;
    return this;
  }

  /// Set the dropoff location
  StorePrivateTripParametersBuilder withDropoffLocation(
    String dropoffLocation,
  ) {
    _dropoffLocation = dropoffLocation;
    return this;
  }

  /// Set the pickup latitude
  StorePrivateTripParametersBuilder withPickupLatitude(String pickupLatitude) {
    _pickupLatitude = pickupLatitude;
    return this;
  }

  /// Set the pickup longitude
  StorePrivateTripParametersBuilder withPickupLongitude(
    String pickupLongitude,
  ) {
    _pickupLongitude = pickupLongitude;
    return this;
  }

  /// Set the dropoff latitude
  StorePrivateTripParametersBuilder withDropoffLatitude(
    String dropoffLatitude,
  ) {
    _dropoffLatitude = dropoffLatitude;
    return this;
  }

  /// Set the dropoff longitude
  StorePrivateTripParametersBuilder withDropoffLongitude(
    String dropoffLongitude,
  ) {
    _dropoffLongitude = dropoffLongitude;
    return this;
  }

  /// Set the vehicle type ID
  StorePrivateTripParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the scheduled date (format: YYYY-MM-DD)
  StorePrivateTripParametersBuilder withScheduledDate(String scheduledDate) {
    _scheduledDate = scheduledDate;
    return this;
  }

  /// Set the scheduled time (format: HH:MM)
  StorePrivateTripParametersBuilder withScheduledTime(String scheduledTime) {
    _scheduledTime = scheduledTime;
    return this;
  }

  /// Set the notes
  StorePrivateTripParametersBuilder withNotes(String notes) {
    _notes = notes;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<StorePrivateTripParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the StorePrivateTripParameters
  @override
  StorePrivateTripParameters build() {
    assert(
      _pickupLocation != null && _pickupLocation!.isNotEmpty,
      'Pickup location is required',
    );
    assert(
      _dropoffLocation != null && _dropoffLocation!.isNotEmpty,
      'Dropoff location is required',
    );
    assert(
      _pickupLatitude != null && _pickupLatitude!.isNotEmpty,
      'Pickup latitude is required',
    );
    assert(
      _pickupLongitude != null && _pickupLongitude!.isNotEmpty,
      'Pickup longitude is required',
    );
    assert(
      _dropoffLatitude != null && _dropoffLatitude!.isNotEmpty,
      'Dropoff latitude is required',
    );
    assert(
      _dropoffLongitude != null && _dropoffLongitude!.isNotEmpty,
      'Dropoff longitude is required',
    );
    assert(_vehicleTypeId != null, 'Vehicle type ID is required');
    assert(
      _scheduledDate != null && _scheduledDate!.isNotEmpty,
      'Scheduled date is required',
    );
    assert(
      _scheduledTime != null && _scheduledTime!.isNotEmpty,
      'Scheduled time is required',
    );

    return StorePrivateTripParameters._(
      pickupLocation: _pickupLocation!,
      dropoffLocation: _dropoffLocation!,
      pickupLatitude: _pickupLatitude!,
      pickupLongitude: _pickupLongitude!,
      dropoffLatitude: _dropoffLatitude!,
      dropoffLongitude: _dropoffLongitude!,
      vehicleTypeId: _vehicleTypeId!,
      scheduledDate: _scheduledDate!,
      scheduledTime: _scheduledTime!,
      notes: _notes,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for editing a private trip
@immutable
class EditPrivateTripParameters extends Parameters {
  final int _tripId;
  final String? _pickupLocation;
  final String? _dropoffLocation;
  final String? _pickupLatitude;
  final String? _pickupLongitude;
  final String? _dropoffLatitude;
  final String? _dropoffLongitude;
  final int? _vehicleTypeId;
  final String? _scheduledDate;
  final String? _scheduledTime;
  final String? _notes;
  final CancelToken? _cancelToken;

  const EditPrivateTripParameters._({
    required int tripId,
    String? pickupLocation,
    String? dropoffLocation,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropoffLatitude,
    String? dropoffLongitude,
    int? vehicleTypeId,
    String? scheduledDate,
    String? scheduledTime,
    String? notes,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
       _pickupLocation = pickupLocation,
       _dropoffLocation = dropoffLocation,
       _pickupLatitude = pickupLatitude,
       _pickupLongitude = pickupLongitude,
       _dropoffLatitude = dropoffLatitude,
       _dropoffLongitude = dropoffLongitude,
       _vehicleTypeId = vehicleTypeId,
       _scheduledDate = scheduledDate,
       _scheduledTime = scheduledTime,
       _notes = notes,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'trip_id': _tripId};
    if (_pickupLocation != null) json['pickup_location'] = _pickupLocation;
    if (_dropoffLocation != null) json['dropoff_location'] = _dropoffLocation;
    if (_pickupLatitude != null) json['pickup_latitude'] = _pickupLatitude;
    if (_pickupLongitude != null) json['pickup_longitude'] = _pickupLongitude;
    if (_dropoffLatitude != null) json['dropoff_latitude'] = _dropoffLatitude;
    if (_dropoffLongitude != null)
      json['dropoff_longitude'] = _dropoffLongitude;
    if (_vehicleTypeId != null) json['vehicle_type_id'] = _vehicleTypeId;
    if (_scheduledDate != null) json['scheduled_date'] = _scheduledDate;
    if (_scheduledTime != null) json['scheduled_time'] = _scheduledTime;
    if (_notes != null) json['notes'] = _notes;
    return json;
  }

  int get tripId => _tripId;
  String? get pickupLocation => _pickupLocation;
  String? get dropoffLocation => _dropoffLocation;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropoffLatitude => _dropoffLatitude;
  String? get dropoffLongitude => _dropoffLongitude;
  int? get vehicleTypeId => _vehicleTypeId;
  String? get scheduledDate => _scheduledDate;
  String? get scheduledTime => _scheduledTime;
  String? get notes => _notes;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static EditPrivateTripParametersBuilder builder() =>
      EditPrivateTripParametersBuilder();
}

/// Builder for EditPrivateTripParameters
class EditPrivateTripParametersBuilder
    extends ParametersBuilder<EditPrivateTripParameters> {
  int? _tripId;
  String? _pickupLocation;
  String? _dropoffLocation;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropoffLatitude;
  String? _dropoffLongitude;
  int? _vehicleTypeId;
  String? _scheduledDate;
  String? _scheduledTime;
  String? _notes;
  CancelToken? _cancelToken;

  /// Set the trip ID
  EditPrivateTripParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the pickup location
  EditPrivateTripParametersBuilder withPickupLocation(String pickupLocation) {
    _pickupLocation = pickupLocation;
    return this;
  }

  /// Set the dropoff location
  EditPrivateTripParametersBuilder withDropoffLocation(String dropoffLocation) {
    _dropoffLocation = dropoffLocation;
    return this;
  }

  /// Set the pickup latitude
  EditPrivateTripParametersBuilder withPickupLatitude(String pickupLatitude) {
    _pickupLatitude = pickupLatitude;
    return this;
  }

  /// Set the pickup longitude
  EditPrivateTripParametersBuilder withPickupLongitude(String pickupLongitude) {
    _pickupLongitude = pickupLongitude;
    return this;
  }

  /// Set the dropoff latitude
  EditPrivateTripParametersBuilder withDropoffLatitude(String dropoffLatitude) {
    _dropoffLatitude = dropoffLatitude;
    return this;
  }

  /// Set the dropoff longitude
  EditPrivateTripParametersBuilder withDropoffLongitude(
    String dropoffLongitude,
  ) {
    _dropoffLongitude = dropoffLongitude;
    return this;
  }

  /// Set the vehicle type ID
  EditPrivateTripParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the scheduled date (format: YYYY-MM-DD)
  EditPrivateTripParametersBuilder withScheduledDate(String scheduledDate) {
    _scheduledDate = scheduledDate;
    return this;
  }

  /// Set the scheduled time (format: HH:MM)
  EditPrivateTripParametersBuilder withScheduledTime(String scheduledTime) {
    _scheduledTime = scheduledTime;
    return this;
  }

  /// Set the notes
  EditPrivateTripParametersBuilder withNotes(String notes) {
    _notes = notes;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<EditPrivateTripParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the EditPrivateTripParameters
  @override
  EditPrivateTripParameters build() {
    assert(_tripId != null, 'Trip ID is required');

    return EditPrivateTripParameters._(
      tripId: _tripId!,
      pickupLocation: _pickupLocation,
      dropoffLocation: _dropoffLocation,
      pickupLatitude: _pickupLatitude,
      pickupLongitude: _pickupLongitude,
      dropoffLatitude: _dropoffLatitude,
      dropoffLongitude: _dropoffLongitude,
      vehicleTypeId: _vehicleTypeId,
      scheduledDate: _scheduledDate,
      scheduledTime: _scheduledTime,
      notes: _notes,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for booking a trip now
@immutable
class BookNowOrderParameters extends Parameters {
  final String _pickupLocation;
  final String _dropoffLocation;
  final String _pickupLatitude;
  final String _pickupLongitude;
  final String _dropoffLatitude;
  final String _dropoffLongitude;
  final int _vehicleTypeId;
  final String? _notes;
  final CancelToken? _cancelToken;

  const BookNowOrderParameters._({
    required String pickupLocation,
    required String dropoffLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required int vehicleTypeId,
    String? notes,
    CancelToken? cancelToken,
  }) : _pickupLocation = pickupLocation,
       _dropoffLocation = dropoffLocation,
       _pickupLatitude = pickupLatitude,
       _pickupLongitude = pickupLongitude,
       _dropoffLatitude = dropoffLatitude,
       _dropoffLongitude = dropoffLongitude,
       _vehicleTypeId = vehicleTypeId,
       _notes = notes,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'pickup_location': _pickupLocation,
      'dropoff_location': _dropoffLocation,
      'pickup_latitude': _pickupLatitude,
      'pickup_longitude': _pickupLongitude,
      'dropoff_latitude': _dropoffLatitude,
      'dropoff_longitude': _dropoffLongitude,
      'vehicle_type_id': _vehicleTypeId,
    };
    if (_notes != null) json['notes'] = _notes;
    return json;
  }

  String get pickupLocation => _pickupLocation;
  String get dropoffLocation => _dropoffLocation;
  String get pickupLatitude => _pickupLatitude;
  String get pickupLongitude => _pickupLongitude;
  String get dropoffLatitude => _dropoffLatitude;
  String get dropoffLongitude => _dropoffLongitude;
  int get vehicleTypeId => _vehicleTypeId;
  String? get notes => _notes;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static BookNowOrderParametersBuilder builder() =>
      BookNowOrderParametersBuilder();
}

/// Builder for BookNowOrderParameters
class BookNowOrderParametersBuilder
    extends ParametersBuilder<BookNowOrderParameters> {
  String? _pickupLocation;
  String? _dropoffLocation;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropoffLatitude;
  String? _dropoffLongitude;
  int? _vehicleTypeId;
  String? _notes;
  CancelToken? _cancelToken;

  /// Set the pickup location
  BookNowOrderParametersBuilder withPickupLocation(String pickupLocation) {
    _pickupLocation = pickupLocation;
    return this;
  }

  /// Set the dropoff location
  BookNowOrderParametersBuilder withDropoffLocation(String dropoffLocation) {
    _dropoffLocation = dropoffLocation;
    return this;
  }

  /// Set the pickup latitude
  BookNowOrderParametersBuilder withPickupLatitude(String pickupLatitude) {
    _pickupLatitude = pickupLatitude;
    return this;
  }

  /// Set the pickup longitude
  BookNowOrderParametersBuilder withPickupLongitude(String pickupLongitude) {
    _pickupLongitude = pickupLongitude;
    return this;
  }

  /// Set the dropoff latitude
  BookNowOrderParametersBuilder withDropoffLatitude(String dropoffLatitude) {
    _dropoffLatitude = dropoffLatitude;
    return this;
  }

  /// Set the dropoff longitude
  BookNowOrderParametersBuilder withDropoffLongitude(String dropoffLongitude) {
    _dropoffLongitude = dropoffLongitude;
    return this;
  }

  /// Set the vehicle type ID
  BookNowOrderParametersBuilder withVehicleTypeId(int vehicleTypeId) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the notes
  BookNowOrderParametersBuilder withNotes(String notes) {
    _notes = notes;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<BookNowOrderParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the BookNowOrderParameters
  @override
  BookNowOrderParameters build() {
    assert(
      _pickupLocation != null && _pickupLocation!.isNotEmpty,
      'Pickup location is required',
    );
    assert(
      _dropoffLocation != null && _dropoffLocation!.isNotEmpty,
      'Dropoff location is required',
    );
    assert(
      _pickupLatitude != null && _pickupLatitude!.isNotEmpty,
      'Pickup latitude is required',
    );
    assert(
      _pickupLongitude != null && _pickupLongitude!.isNotEmpty,
      'Pickup longitude is required',
    );
    assert(
      _dropoffLatitude != null && _dropoffLatitude!.isNotEmpty,
      'Dropoff latitude is required',
    );
    assert(
      _dropoffLongitude != null && _dropoffLongitude!.isNotEmpty,
      'Dropoff longitude is required',
    );
    assert(_vehicleTypeId != null, 'Vehicle type ID is required');

    return BookNowOrderParameters._(
      pickupLocation: _pickupLocation!,
      dropoffLocation: _dropoffLocation!,
      pickupLatitude: _pickupLatitude!,
      pickupLongitude: _pickupLongitude!,
      dropoffLatitude: _dropoffLatitude!,
      dropoffLongitude: _dropoffLongitude!,
      vehicleTypeId: _vehicleTypeId!,
      notes: _notes,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for getting trip history
@immutable
class GetTripHistoryParameters extends Parameters {
  final int _page;
  final int _pageSize;
  final String? _status;
  final CancelToken? _cancelToken;

  const GetTripHistoryParameters._({
    required int page,
    required int pageSize,
    String? status,
    CancelToken? cancelToken,
  }) : _page = page,
       _pageSize = pageSize,
       _status = status,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'page': _page, 'page_size': _pageSize};
    if (_status != null) json['status'] = _status;
    return json;
  }

  int get page => _page;
  int get pageSize => _pageSize;
  String? get status => _status;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetTripHistoryParametersBuilder builder() =>
      GetTripHistoryParametersBuilder();
}

/// Builder for GetTripHistoryParameters
class GetTripHistoryParametersBuilder
    extends ParametersBuilder<GetTripHistoryParameters> {
  int _page = 1;
  int _pageSize = 20;
  String? _status;
  CancelToken? _cancelToken;

  /// Set the page number
  GetTripHistoryParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the page size
  GetTripHistoryParametersBuilder withPageSize(int pageSize) {
    _pageSize = pageSize;
    return this;
  }

  /// Set the status filter
  GetTripHistoryParametersBuilder withStatus(String status) {
    _status = status;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<GetTripHistoryParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetTripHistoryParameters
  @override
  GetTripHistoryParameters build() {
    return GetTripHistoryParameters._(
      page: _page,
      pageSize: _pageSize,
      status: _status,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for getting my orders
@immutable
class GetMyOrdersParameters extends Parameters {
  final int _page;
  final int _pageSize;
  final String? _status;
  final CancelToken? _cancelToken;

  const GetMyOrdersParameters._({
    required int page,
    required int pageSize,
    String? status,
    CancelToken? cancelToken,
  }) : _page = page,
       _pageSize = pageSize,
       _status = status,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'page': _page, 'page_size': _pageSize};
    if (_status != null) json['status'] = _status;
    return json;
  }

  int get page => _page;
  int get pageSize => _pageSize;
  String? get status => _status;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetMyOrdersParametersBuilder builder() =>
      GetMyOrdersParametersBuilder();
}

/// Builder for GetMyOrdersParameters
class GetMyOrdersParametersBuilder
    extends ParametersBuilder<GetMyOrdersParameters> {
  int _page = 1;
  int _pageSize = 20;
  String? _status;
  CancelToken? _cancelToken;

  /// Set the page number
  GetMyOrdersParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the page size
  GetMyOrdersParametersBuilder withPageSize(int pageSize) {
    _pageSize = pageSize;
    return this;
  }

  /// Set the status filter
  GetMyOrdersParametersBuilder withStatus(String status) {
    _status = status;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<GetMyOrdersParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetMyOrdersParameters
  @override
  GetMyOrdersParameters build() {
    return GetMyOrdersParameters._(
      page: _page,
      pageSize: _pageSize,
      status: _status,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for getting available public trips
@immutable
class GetAvailablePublicTripsParameters extends Parameters {
  final String _pickupLatitude;
  final String _pickupLongitude;
  final String _dropoffLatitude;
  final String _dropoffLongitude;
  final int _vehicleTypeId;
  final CancelToken? _cancelToken;

  const GetAvailablePublicTripsParameters._({
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required int vehicleTypeId,
    CancelToken? cancelToken,
  }) : _pickupLatitude = pickupLatitude,
       _pickupLongitude = pickupLongitude,
       _dropoffLatitude = dropoffLatitude,
       _dropoffLongitude = dropoffLongitude,
       _vehicleTypeId = vehicleTypeId,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {
      'pickup_latitude': _pickupLatitude,
      'pickup_longitude': _pickupLongitude,
      'dropoff_latitude': _dropoffLatitude,
      'dropoff_longitude': _dropoffLongitude,
      'vehicle_type_id': _vehicleTypeId,
    };
  }

  String get pickupLatitude => _pickupLatitude;
  String get pickupLongitude => _pickupLongitude;
  String get dropoffLatitude => _dropoffLatitude;
  String get dropoffLongitude => _dropoffLongitude;
  int get vehicleTypeId => _vehicleTypeId;

  @override
  CancelToken? get cancelToken => _cancelToken;

  GetAvailablePublicTripsParametersBuilder builder() =>
      GetAvailablePublicTripsParametersBuilder();
}

/// Builder for GetAvailablePublicTripsParameters
class GetAvailablePublicTripsParametersBuilder
    extends ParametersBuilder<GetAvailablePublicTripsParameters> {
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropoffLatitude;
  String? _dropoffLongitude;
  int? _vehicleTypeId;
  CancelToken? _cancelToken;

  /// Set the pickup latitude
  GetAvailablePublicTripsParametersBuilder withPickupLatitude(
    String pickupLatitude,
  ) {
    _pickupLatitude = pickupLatitude;
    return this;
  }

  /// Set the pickup longitude
  GetAvailablePublicTripsParametersBuilder withPickupLongitude(
    String pickupLongitude,
  ) {
    _pickupLongitude = pickupLongitude;
    return this;
  }

  /// Set the dropoff latitude
  GetAvailablePublicTripsParametersBuilder withDropoffLatitude(
    String dropoffLatitude,
  ) {
    _dropoffLatitude = dropoffLatitude;
    return this;
  }

  /// Set the dropoff longitude
  GetAvailablePublicTripsParametersBuilder withDropoffLongitude(
    String dropoffLongitude,
  ) {
    _dropoffLongitude = dropoffLongitude;
    return this;
  }

  /// Set the vehicle type ID
  GetAvailablePublicTripsParametersBuilder withVehicleTypeId(
    int vehicleTypeId,
  ) {
    _vehicleTypeId = vehicleTypeId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<GetAvailablePublicTripsParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetAvailablePublicTripsParameters
  @override
  GetAvailablePublicTripsParameters build() {
    assert(
      _pickupLatitude != null && _pickupLatitude!.isNotEmpty,
      'Pickup latitude is required',
    );
    assert(
      _pickupLongitude != null && _pickupLongitude!.isNotEmpty,
      'Pickup longitude is required',
    );
    assert(
      _dropoffLatitude != null && _dropoffLatitude!.isNotEmpty,
      'Dropoff latitude is required',
    );
    assert(
      _dropoffLongitude != null && _dropoffLongitude!.isNotEmpty,
      'Dropoff longitude is required',
    );
    assert(_vehicleTypeId != null, 'Vehicle type ID is required');

    return GetAvailablePublicTripsParameters._(
      pickupLatitude: _pickupLatitude!,
      pickupLongitude: _pickupLongitude!,
      dropoffLatitude: _dropoffLatitude!,
      dropoffLongitude: _dropoffLongitude!,
      vehicleTypeId: _vehicleTypeId!,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for confirming a trip
@immutable
class ConfirmTripParameters extends Parameters {
  final int _tripId;
  final CancelToken? _cancelToken;

  const ConfirmTripParameters._({required int tripId, CancelToken? cancelToken})
    : _tripId = tripId,
      _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'trip_id': _tripId};
  }

  int get tripId => _tripId;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static ConfirmTripParametersBuilder builder() =>
      ConfirmTripParametersBuilder();
}

/// Builder for ConfirmTripParameters
class ConfirmTripParametersBuilder
    extends ParametersBuilder<ConfirmTripParameters> {
  int? _tripId;
  CancelToken? _cancelToken;

  /// Set the trip ID
  ConfirmTripParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<ConfirmTripParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the ConfirmTripParameters
  @override
  ConfirmTripParameters build() {
    assert(_tripId != null, 'Trip ID is required');

    return ConfirmTripParameters._(tripId: _tripId!, cancelToken: _cancelToken);
  }
}

/// Parameters for canceling a trip
@immutable
class CancelTripParameters extends Parameters {
  final int _tripId;
  final String? _reason;
  final CancelToken? _cancelToken;

  const CancelTripParameters._({
    required int tripId,
    String? reason,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
       _reason = reason,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'trip_id': _tripId};
    if (_reason != null) json['reason'] = _reason;
    return json;
  }

  int get tripId => _tripId;
  String? get reason => _reason;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static CancelTripParametersBuilder builder() => CancelTripParametersBuilder();
}

/// Builder for CancelTripParameters
class CancelTripParametersBuilder
    extends ParametersBuilder<CancelTripParameters> {
  int? _tripId;
  String? _reason;
  CancelToken? _cancelToken;

  /// Set the trip ID
  CancelTripParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancellation reason
  CancelTripParametersBuilder withReason(String reason) {
    _reason = reason;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<CancelTripParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the CancelTripParameters
  @override
  CancelTripParameters build() {
    assert(_tripId != null, 'Trip ID is required');

    return CancelTripParameters._(
      tripId: _tripId!,
      reason: _reason,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for reporting a trip
@immutable
class ReportTripParameters extends Parameters {
  final int _tripId;
  final String _reason;
  final String? _description;
  final CancelToken? _cancelToken;

  const ReportTripParameters._({
    required int tripId,
    required String reason,
    String? description,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
       _reason = reason,
       _description = description,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'trip_id': _tripId, 'reason': _reason};
    if (_description != null) json['description'] = _description;
    return json;
  }

  int get tripId => _tripId;
  String get reason => _reason;
  String? get description => _description;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static ReportTripParametersBuilder builder() => ReportTripParametersBuilder();
}

/// Builder for ReportTripParameters
class ReportTripParametersBuilder
    extends ParametersBuilder<ReportTripParameters> {
  int? _tripId;
  String? _reason;
  String? _description;
  CancelToken? _cancelToken;

  /// Set the trip ID
  ReportTripParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the report reason
  ReportTripParametersBuilder withReason(String reason) {
    _reason = reason;
    return this;
  }

  /// Set the report description
  ReportTripParametersBuilder withDescription(String description) {
    _description = description;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<ReportTripParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the ReportTripParameters
  @override
  ReportTripParameters build() {
    assert(_tripId != null, 'Trip ID is required');
    assert(_reason != null && _reason!.isNotEmpty, 'Reason is required');

    return ReportTripParameters._(
      tripId: _tripId!,
      reason: _reason!,
      description: _description,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for trip evaluation
@immutable
class TripEvaluationParameters extends Parameters {
  final int _tripId;
  final int _rating;
  final String? _comment;
  final CancelToken? _cancelToken;

  const TripEvaluationParameters._({
    required int tripId,
    required int rating,
    String? comment,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
       _rating = rating,
       _comment = comment,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'trip_id': _tripId, 'rating': _rating};
    if (_comment != null) json['comment'] = _comment;
    return json;
  }

  int get tripId => _tripId;
  int get rating => _rating;
  String? get comment => _comment;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static TripEvaluationParametersBuilder builder() =>
      TripEvaluationParametersBuilder();
}

/// Builder for TripEvaluationParameters
class TripEvaluationParametersBuilder
    extends ParametersBuilder<TripEvaluationParameters> {
  int? _tripId;
  int? _rating;
  String? _comment;
  CancelToken? _cancelToken;

  /// Set the trip ID
  TripEvaluationParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the rating (1-5)
  TripEvaluationParametersBuilder withRating(int rating) {
    _rating = rating;
    return this;
  }

  /// Set the evaluation comment
  TripEvaluationParametersBuilder withComment(String comment) {
    _comment = comment;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<TripEvaluationParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the TripEvaluationParameters
  @override
  TripEvaluationParameters build() {
    assert(_tripId != null, 'Trip ID is required');
    assert(
      _rating != null && _rating! >= 1 && _rating! <= 5,
      'Rating must be between 1 and 5',
    );

    return TripEvaluationParameters._(
      tripId: _tripId!,
      rating: _rating!,
      comment: _comment,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for getting trip detail
@immutable
class GetTripDetailParameters extends Parameters {
  final int _tripId;
  final CancelToken? _cancelToken;

  const GetTripDetailParameters._({
    required int tripId,
    CancelToken? cancelToken,
  }) : _tripId = tripId,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'trip_id': _tripId};
  }

  int get tripId => _tripId;

  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetTripDetailParametersBuilder builder() =>
      GetTripDetailParametersBuilder();
}

/// Builder for GetTripDetailParameters
class GetTripDetailParametersBuilder
    extends ParametersBuilder<GetTripDetailParameters> {
  int? _tripId;
  CancelToken? _cancelToken;

  /// Set the trip ID
  GetTripDetailParametersBuilder withTripId(int tripId) {
    _tripId = tripId;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  ParametersBuilder<GetTripDetailParameters> withCancelToken(
    CancelToken? cancelToken,
  ) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetTripDetailParameters
  @override
  GetTripDetailParameters build() {
    assert(_tripId != null, 'Trip ID is required');

    return GetTripDetailParameters._(
      tripId: _tripId!,
      cancelToken: _cancelToken,
    );
  }
}
