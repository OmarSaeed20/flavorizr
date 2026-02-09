/* import 'package:fast_golden_taxi/core/network/api/models/api_trip.dart';
import 'package:fast_golden_taxi/core/network/api/parameters/trip_parameters.dart';
import 'package:fast_golden_taxi/core/network/api/repositories/trip_repository.dart';
import 'package:fast_golden_taxi/core/network/api_response.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';

/// Trip Service
/// Business logic layer for trip operations
class TripService {
  final TripRepository _repository;

  TripService({required TripRepository repository}) : _repository = repository;

  /// Get trip types by location
  /// Returns NetworkResult with List<ApiTripType> on success
  Future<ApiResult<ApiResponse<List<ApiTripType>>>> getTripTypes({
    String? latitude,
    String? longitude,
  }) async {
    final parameters = GetTripTypesParameters.builder()
        .withLatitude(latitude)
        .withLongitude(longitude)
        .build();

    return _repository.getTripTypes(parameters);
  }

  /// Get captain trip detail by trip ID
  /// Returns NetworkResult with ApiTrip on success
  Future<ApiResult<ApiResponse<ApiTrip>>> getCaptainTripDetail({required int tripId}) async {
    final parameters = GetCaptainTripDetailParameters.builder().withTripId(tripId).build();

    return _repository.getCaptainTripDetail(parameters);
  }

  /// Store a public trip
  /// Returns NetworkResult with ApiTrip on success
  Future<ApiResult<ApiResponse<ApiTrip>>> storePublicTrip({
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
  }) async {
    final parameters = StorePublicTripParameters.builder()
        .withPickupLocation(pickupLocation)
        .withDropoffLocation(dropoffLocation)
        .withPickupLatitude(pickupLatitude)
        .withPickupLongitude(pickupLongitude)
        .withDropoffLatitude(dropoffLatitude)
        .withDropoffLongitude(dropoffLongitude)
        .withVehicleTypeId(vehicleTypeId)
        .withScheduledDate(scheduledDate)
        .withScheduledTime(scheduledTime)
        .withNotes(notes)
        .build();

    return _repository.storePublicTrip(parameters);
  }

  /// Store a private trip
  /// Returns NetworkResult with ApiTrip on success
  Future<ApiResult<ApiResponse<ApiTrip>>> storePrivateTrip({
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
  }) async {
    final parameters = StorePrivateTripParameters.builder()
        .withPickupLocation(pickupLocation)
        .withDropoffLocation(dropoffLocation)
        .withPickupLatitude(pickupLatitude)
        .withPickupLongitude(pickupLongitude)
        .withDropoffLatitude(dropoffLatitude)
        .withDropoffLongitude(dropoffLongitude)
        .withVehicleTypeId(vehicleTypeId)
        .withScheduledDate(scheduledDate)
        .withScheduledTime(scheduledTime)
        .withNotes(notes)
        .build();

    return _repository.storePrivateTrip(parameters);
  }

  /// Edit a private trip
  /// Returns NetworkResult with ApiTrip on success
  Future<ApiResult<ApiResponse<ApiTrip>>> editPrivateTrip({
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
  }) async {
    final parameters = EditPrivateTripParameters.builder()
        .withTripId(tripId)
        .withPickupLocation(pickupLocation)
        .withDropoffLocation(dropoffLocation)
        .withPickupLatitude(pickupLatitude)
        .withPickupLongitude(pickupLongitude)
        .withDropoffLatitude(dropoffLatitude)
        .withDropoffLongitude(dropoffLongitude)
        .withVehicleTypeId(vehicleTypeId)
        .withScheduledDate(scheduledDate)
        .withScheduledTime(scheduledTime)
        .withNotes(notes)
        .build();

    return _repository.editPrivateTrip(parameters);
  }

  /// Book a trip now
  /// Returns NetworkResult with ApiTripOrder on success
  Future<ApiResult<ApiResponse<ApiTripOrder>>> bookNowOrder({
    required String pickupLocation,
    required String dropoffLocation,
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required int vehicleTypeId,
    String? notes,
  }) async {
    final parameters = BookNowOrderParameters.builder()
        .withPickupLocation(pickupLocation)
        .withDropoffLocation(dropoffLocation)
        .withPickupLatitude(pickupLatitude)
        .withPickupLongitude(pickupLongitude)
        .withDropoffLatitude(dropoffLatitude)
        .withDropoffLongitude(dropoffLongitude)
        .withVehicleTypeId(vehicleTypeId)
        .withNotes(notes)
        .build();

    return _repository.bookNowOrder(parameters);
  }

  /// Get trip history
  /// Returns NetworkResult with List<ApiTrip> on success
  Future<ApiResult<ApiResponse<List<ApiTrip>>>> getTripHistory({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final parameters = GetTripHistoryParameters.builder()
        .withPage(page)
        .withPageSize(pageSize)
        .withStatus(status)
        .build();

    return _repository.getTripHistory(parameters);
  }

  /// Get my orders
  /// Returns NetworkResult with List<ApiTripOrder> on success
  Future<ApiResult<ApiResponse<List<ApiTripOrder>>>> getMyOrders({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final parameters = GetMyOrdersParameters.builder()
        .withPage(page)
        .withPageSize(pageSize)
        .withStatus(status)
        .build();

    return _repository.getMyOrders(parameters);
  }

  /// Get available public trips
  /// Returns NetworkResult with List<ApiTrip> on success
  Future<ApiResult<ApiResponse<List<ApiTrip>>>> getAvailablePublicTrips({
    required String pickupLatitude,
    required String pickupLongitude,
    required String dropoffLatitude,
    required String dropoffLongitude,
    required int vehicleTypeId,
  }) async {
    final parameters = GetAvailablePublicTripsParameters.builder()
        .withPickupLatitude(pickupLatitude)
        .withPickupLongitude(pickupLongitude)
        .withDropoffLatitude(dropoffLatitude)
        .withDropoffLongitude(dropoffLongitude)
        .withVehicleTypeId(vehicleTypeId)
        .build();

    return _repository.getAvailablePublicTrips(parameters);
  }

  /// Confirm a trip
  /// Returns NetworkResult with ApiTrip on success
  Future<ApiResult<ApiResponse<ApiTrip>>> confirmTrip({required int tripId}) async {
    final parameters = ConfirmTripParameters.builder().withTripId(tripId).build();

    return _repository.confirmTrip(parameters);
  }

  /// Cancel a trip
  /// Returns NetworkResult with void on success
  Future<ApiResult<ApiResponse<void>>> cancelTrip({required int tripId, String? reason}) async {
    final parameters = CancelTripParameters.builder().withTripId(tripId).withReason(reason).build();

    return _repository.cancelTrip(parameters);
  }

  /// Report a trip
  /// Returns NetworkResult with void on success
  Future<ApiResult<ApiResponse<void>>> reportTrip({
    required int tripId,
    required String reason,
    String? description,
  }) async {
    final parameters = ReportTripParameters.builder()
        .withTripId(tripId)
        .withReason(reason)
        .withDescription(description)
        .build();

    return _repository.reportTrip(parameters);
  }

  /// Evaluate a trip
  /// Returns NetworkResult with ApiTripEvaluation on success
  Future<ApiResult<ApiResponse<ApiTripEvaluation>>> tripEvaluation({
    required int tripId,
    required int rating,
    String? comment,
  }) async {
    final parameters = TripEvaluationParameters.builder()
        .withTripId(tripId)
        .withRating(rating)
        .withComment(comment)
        .build();

    return _repository.tripEvaluation(parameters);
  }

  /// Get trip detail
  /// Returns NetworkResult with ApiTrip on success
  Future<ApiResult<ApiResponse<ApiTrip>>> getTripDetail({required int tripId}) async {
    final parameters = GetTripDetailParameters.builder().withTripId(tripId).build();

    return _repository.getTripDetail(parameters);
  }
}
 */
