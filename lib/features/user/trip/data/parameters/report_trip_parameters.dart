// lib/features/trip/data/parameters/report_trip_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for reporting a trip.
@immutable
class ReportTripParameters extends Parameters {
  const ReportTripParameters._({
    required this.orderId,
    required this.comment,
    this.anotherNote,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'comment': comment,
    if (anotherNote != null) 'another_note': anotherNote,
  };

  final int orderId;
  final String comment;
  final String? anotherNote;

  @override
  final CancelToken? cancelToken;

  static ReportTripParametersBuilder builder() => ReportTripParametersBuilder();
}

/// Builder for ReportTripParameters.
class ReportTripParametersBuilder
    extends ParametersBuilder<ReportTripParameters> {
  int? _orderId;
  String? _comment;
  String? _anotherNote;
  CancelToken? _cancelToken;

  ReportTripParametersBuilder withOrderId(int orderId) {
    _orderId = orderId;
    return this;
  }

  ReportTripParametersBuilder withComment(String comment) {
    _comment = comment;
    return this;
  }

  ReportTripParametersBuilder withAnotherNote(String anotherNote) {
    _anotherNote = anotherNote;
    return this;
  }

  @override
  ReportTripParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ReportTripParameters build() {
    return ReportTripParameters._(
      orderId: _orderId!,
      comment: _comment!,
      anotherNote: _anotherNote,
      cancelToken: _cancelToken,
    );
  }
}
