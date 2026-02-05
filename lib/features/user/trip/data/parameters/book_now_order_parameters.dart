// lib/features/trip/data/parameters/book_now_order_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for booking a trip now.
@immutable
class BookNowOrderParameters extends Parameters {
  const BookNowOrderParameters._({
    required this.orderId,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {
    'order_id': orderId,
  };

  final int orderId;

  @override
  final CancelToken? cancelToken;

  static BookNowOrderParametersBuilder builder() => BookNowOrderParametersBuilder();
}

/// Builder for BookNowOrderParameters.
class BookNowOrderParametersBuilder extends ParametersBuilder<BookNowOrderParameters> {
  int? _orderId;
  CancelToken? _cancelToken;

  BookNowOrderParametersBuilder withOrderId(int orderId) {
    _orderId = orderId;
    return this;
  }

  @override
  BookNowOrderParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  BookNowOrderParameters build() {
    return BookNowOrderParameters._(
      orderId: _orderId!,
      cancelToken: _cancelToken,
    );
  }
}
