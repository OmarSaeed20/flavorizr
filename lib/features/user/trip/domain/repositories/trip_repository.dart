// lib/features/trip/domain/repositories/trip_repository.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart'
    show
        ConflictException,
        NoInternetException,
        NotFoundException,
        ServerException,
        UnauthorizedException,
        ValidationException;
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/book_now_order_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/cancel_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/confirm_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/edit_private_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_available_public_trips_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_captain_trip_detail_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_my_orders_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_trip_detail_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_trip_history_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/get_trip_types_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/report_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/store_private_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/store_public_trip_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/trip_evaluation_parameters.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip_evaluation.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip_order.dart';
import 'package:fast_golden_taxi/features/user/trip/domain/entities/trip_type.dart';

/// Type alias for ApiResult-based result handling.
typedef TripEither<T> = Future<ApiResult<T>>;

/// Abstract repository defining trip operations.
///
/// This interface lives in the domain layer and defines the contract
/// that the data layer must implement.
abstract class TripRepository {
  // ==================== Trip Types ====================

  /// Get available trip types.
  ///
  /// Returns a list of available trip types (e.g., Economy, Premium).
  ///
  /// Possible failures:
  /// - [NoInternetException] - No internet connection
  /// - [ServerException] - Server error
  TripEither<List<TripType>> getTripTypes(GetTripTypesParameters parameters);

  // ==================== Trip CRUD ====================

  /// Get trip details by ID.
  ///
  /// Returns detailed information about a specific trip.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [UnauthorizedException] - Not authorized to view this trip
  /// - [NoInternetException] - No internet connection
  TripEither<Trip> getTripDetail(GetTripDetailParameters parameters);

  /// Get captain's trip details.
  ///
  /// Returns detailed information about a trip from captain's perspective.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [UnauthorizedException] - Not authorized to view this trip
  /// - [NoInternetException] - No internet connection
  TripEither<Trip> getCaptainTripDetail(
    GetCaptainTripDetailParameters parameters,
  );

  /// Get user's trip history.
  ///
  /// Returns a list of trips for the current user.
  ///
  /// Possible failures:
  /// - [UnauthorizedException] - Not authenticated
  /// - [NoInternetException] - No internet connection
  TripEither<List<Trip>> getTripHistory(GetTripHistoryParameters parameters);

  /// Get available public trips.
  ///
  /// Returns a list of public trips available for booking.
  ///
  /// Possible failures:
  /// - [NoInternetException] - No internet connection
  /// - [ServerException] - Server error
  TripEither<List<Trip>> getAvailablePublicTrips(
    GetAvailablePublicTripsParameters parameters,
  );

  // ==================== Trip Creation ====================

  /// Create a new public trip.
  ///
  /// Creates a trip that can be booked by other users.
  ///
  /// Possible failures:
  /// - [ValidationException] - Invalid trip data
  /// - [UnauthorizedException] - Not authenticated
  /// - [NoInternetException] - No internet connection
  TripEither<Trip> storePublicTrip(StorePublicTripParameters parameters);

  /// Create a new private trip.
  ///
  /// Creates a private trip for the user.
  ///
  /// Possible failures:
  /// - [ValidationException] - Invalid trip data
  /// - [UnauthorizedException] - Not authenticated
  /// - [NoInternetException] - No internet connection
  TripEither<Trip> storePrivateTrip(StorePrivateTripParameters parameters);

  /// Edit an existing private trip.
  ///
  /// Updates details of a private trip.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [ValidationException] - Invalid trip data
  /// - [UnauthorizedException] - Not authorized to edit this trip
  /// - [NoInternetException] - No internet connection
  TripEither<Trip> editPrivateTrip(EditPrivateTripParameters parameters);

  // ==================== Trip Actions ====================

  /// Confirm a trip.
  ///
  /// Confirms a trip and assigns a captain.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [ConflictException] - Trip cannot be confirmed in current state
  /// - [UnauthorizedException] - Not authorized to confirm this trip
  /// - [NoInternetException] - No internet connection
  TripEither<Trip> confirmTrip(ConfirmTripParameters parameters);

  /// Cancel a trip.
  ///
  /// Cancels a trip.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [ConflictException] - Trip cannot be cancelled in current state
  /// - [UnauthorizedException] - Not authorized to cancel this trip
  /// - [NoInternetException] - No internet connection
  TripEither<void> cancelTrip(CancelTripParameters parameters);

  /// Report a trip.
  ///
  /// Reports an issue with a trip.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [ValidationException] - Invalid report data
  /// - [UnauthorizedException] - Not authorized to report this trip
  /// - [NoInternetException] - No internet connection
  TripEither<void> reportTrip(ReportTripParameters parameters);

  /// Evaluate a trip.
  ///
  /// Submits a rating and review for a completed trip.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [ValidationException] - Invalid evaluation data
  /// - [UnauthorizedException] - Not authorized to evaluate this trip
  /// - [ConflictException] - Trip already evaluated
  /// - [NoInternetException] - No internet connection
  TripEither<TripEvaluation> tripEvaluation(
    TripEvaluationParameters parameters,
  );

  // ==================== Orders ====================

  /// Book a trip now.
  ///
  /// Creates an order for immediate trip booking.
  ///
  /// Possible failures:
  /// - [NotFoundException] - Trip not found
  /// - [ValidationException] - Invalid booking data
  /// - [UnauthorizedException] - Not authenticated
  /// - [ConflictException] - Trip not available for booking
  /// - [NoInternetException] - No internet connection
  TripEither<TripOrder> bookNowOrder(BookNowOrderParameters parameters);

  /// Get user's orders.
  ///
  /// Returns a list of orders for the current user.
  ///
  /// Possible failures:
  /// - [UnauthorizedException] - Not authenticated
  /// - [NoInternetException] - No internet connection
  TripEither<List<TripOrder>> getMyOrders(GetMyOrdersParameters parameters);
}
