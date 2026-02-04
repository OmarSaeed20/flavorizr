// lib/features/trip/data/parameters/trip_evaluation_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for evaluating a trip.
@immutable
class TripEvaluationParameters extends Parameters {
  const TripEvaluationParameters._({
    required this.orderId,
    required this.driverId,
    required this.rate,
    required this.comment,
    this.anotherNote,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'driver_id': driverId,
    'rate': rate,
    'comment': comment,
    if (anotherNote != null) 'another_note': anotherNote,
  };

  final int orderId;
  final int driverId;
  final double rate;
  final String comment;
  final String? anotherNote;

  @override
  final CancelToken? cancelToken;

  static TripEvaluationParametersBuilder builder() => TripEvaluationParametersBuilder();
}

/// Builder for TripEvaluationParameters.
class TripEvaluationParametersBuilder extends ParametersBuilder<TripEvaluationParameters> {
  int? _orderId;
  int? _driverId;
  double? _rate;
  String? _comment;
  String? _anotherNote;
  CancelToken? _cancelToken;

  TripEvaluationParametersBuilder withOrderId(int orderId) {
    _orderId = orderId;
    return this;
  }

  TripEvaluationParametersBuilder withDriverId(int driverId) {
    _driverId = driverId;
    return this;
  }

  TripEvaluationParametersBuilder withRate(double rate) {
    _rate = rate;
    return this;
  }

  TripEvaluationParametersBuilder withComment(String comment) {
    _comment = comment;
    return this;
  }

  TripEvaluationParametersBuilder withAnotherNote(String? anotherNote) {
    _anotherNote = anotherNote;
    return this;
  }

  @override
  TripEvaluationParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  TripEvaluationParameters build() {
    return TripEvaluationParameters._(
      orderId: _orderId!,
      driverId: _driverId!,
      rate: _rate!,
      comment: _comment!,
      anotherNote: _anotherNote,
      cancelToken: _cancelToken,
    );
  }
}
