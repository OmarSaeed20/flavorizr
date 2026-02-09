import 'package:fast_golden_taxi/core/network/api/models/api_trip.dart';
import 'package:fast_golden_taxi/core/network/api/parameters/trip_parameters.dart';
import 'package:fast_golden_taxi/core/network/api_response.dart';
import 'package:fast_golden_taxi/core/network/resluts/dio_reslut.dart';

/// Trip Repository Interface
/// Defines all trip-related operations
abstract class TripRepository {
  /// Get trip types by location
  Future<ApiResult<ApiResponse<List<ApiTripType>>>> getTripTypes(GetTripTypesParameters parameters);

  /// Get captain trip detail by trip ID
  Future<ApiResult<ApiResponse<ApiTrip>>> getCaptainTripDetail(
    GetCaptainTripDetailParameters parameters,
  );

  /// Store a public trip
  Future<ApiResult<ApiResponse<ApiTrip>>> storePublicTrip(StorePublicTripParameters parameters);

  /// Store a private trip
  Future<ApiResult<ApiResponse<ApiTrip>>> storePrivateTrip(StorePrivateTripParameters parameters);

  /// Edit a private trip
  Future<ApiResult<ApiResponse<ApiTrip>>> editPrivateTrip(EditPrivateTripParameters parameters);

  /// Book a trip now
  Future<ApiResult<ApiResponse<ApiTripOrder>>> bookNowOrder(BookNowOrderParameters parameters);

  /// Get trip history
  Future<ApiResult<ApiResponse<List<ApiTrip>>>> getTripHistory(GetTripHistoryParameters parameters);

  /// Get my orders
  Future<ApiResult<ApiResponse<List<ApiTripOrder>>>> getMyOrders(GetMyOrdersParameters parameters);

  /// Get available public trips
  Future<ApiResult<ApiResponse<List<ApiTrip>>>> getAvailablePublicTrips(
    GetAvailablePublicTripsParameters parameters,
  );

  /// Confirm a trip
  Future<ApiResult<ApiResponse<ApiTrip>>> confirmTrip(ConfirmTripParameters parameters);

  /// Cancel a trip
  Future<ApiResult<ApiResponse<void>>> cancelTrip(CancelTripParameters parameters);

  /// Report a trip
  Future<ApiResult<ApiResponse<void>>> reportTrip(ReportTripParameters parameters);

  /// Evaluate a trip
  Future<ApiResult<ApiResponse<ApiTripEvaluation>>> tripEvaluation(
    TripEvaluationParameters parameters,
  );

  /// Get trip detail
  Future<ApiResult<ApiResponse<ApiTrip>>> getTripDetail(GetTripDetailParameters parameters);
}
