// lib/features/trip/domain/usecases/trip_usecases.dart
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
import 'package:fast_golden_taxi/features/user/trip/domain/repositories/trip_repository.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';

/// Use case for getting trip types.
class GetTripTypesUseCase
    extends UseCase<List<TripType>, GetTripTypesParameters> {
  GetTripTypesUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<List<TripType>>> call(GetTripTypesParameters params) {
    return _repository.getTripTypes(params);
  }
}

/// Use case for getting trip details.
class GetTripDetailUseCase extends UseCase<Trip, GetTripDetailParameters> {
  GetTripDetailUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<Trip>> call(GetTripDetailParameters params) {
    return _repository.getTripDetail(params);
  }
}

/// Use case for getting captain's trip details.
class GetCaptainTripDetailUseCase
    extends UseCase<Trip, GetCaptainTripDetailParameters> {
  GetCaptainTripDetailUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<Trip>> call(GetCaptainTripDetailParameters params) {
    return _repository.getCaptainTripDetail(params);
  }
}

/// Use case for getting trip history.
class GetTripHistoryUseCase
    extends UseCase<List<Trip>, GetTripHistoryParameters> {
  GetTripHistoryUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<List<Trip>>> call(GetTripHistoryParameters params) {
    return _repository.getTripHistory(params);
  }
}

/// Use case for getting available public trips.
class GetAvailablePublicTripsUseCase
    extends UseCase<List<Trip>, GetAvailablePublicTripsParameters> {
  GetAvailablePublicTripsUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<List<Trip>>> call(GetAvailablePublicTripsParameters params) {
    return _repository.getAvailablePublicTrips(params);
  }
}

/// Use case for creating a public trip.
class StorePublicTripUseCase extends UseCase<Trip, StorePublicTripParameters> {
  StorePublicTripUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<Trip>> call(StorePublicTripParameters params) {
    return _repository.storePublicTrip(params);
  }
}

/// Use case for creating a private trip.
class StorePrivateTripUseCase
    extends UseCase<Trip, StorePrivateTripParameters> {
  StorePrivateTripUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<Trip>> call(StorePrivateTripParameters params) {
    return _repository.storePrivateTrip(params);
  }
}

/// Use case for editing a private trip.
class EditPrivateTripUseCase extends UseCase<Trip, EditPrivateTripParameters> {
  EditPrivateTripUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<Trip>> call(EditPrivateTripParameters params) {
    return _repository.editPrivateTrip(params);
  }
}

/// Use case for confirming a trip.
class ConfirmTripUseCase extends UseCase<Trip, ConfirmTripParameters> {
  ConfirmTripUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<Trip>> call(ConfirmTripParameters params) {
    return _repository.confirmTrip(params);
  }
}

/// Use case for cancelling a trip.
class CancelTripUseCase extends UseCase<void, CancelTripParameters> {
  CancelTripUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<void>> call(CancelTripParameters params) {
    return _repository.cancelTrip(params);
  }
}

/// Use case for reporting a trip.
class ReportTripUseCase extends UseCase<void, ReportTripParameters> {
  ReportTripUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<void>> call(ReportTripParameters params) {
    return _repository.reportTrip(params);
  }
}

/// Use case for evaluating a trip.
class TripEvaluationUseCase
    extends UseCase<TripEvaluation, TripEvaluationParameters> {
  TripEvaluationUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<TripEvaluation>> call(TripEvaluationParameters params) {
    return _repository.tripEvaluation(params);
  }
}

/// Use case for booking a trip now.
class BookNowOrderUseCase extends UseCase<TripOrder, BookNowOrderParameters> {
  BookNowOrderUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<TripOrder>> call(BookNowOrderParameters params) {
    return _repository.bookNowOrder(params);
  }
}

/// Use case for getting user's orders.
class GetMyOrdersUseCase
    extends UseCase<List<TripOrder>, GetMyOrdersParameters> {
  GetMyOrdersUseCase(this._repository);

  final TripRepository _repository;

  @override
  Future<ApiResult<List<TripOrder>>> call(GetMyOrdersParameters params) {
    return _repository.getMyOrders(params);
  }
}
