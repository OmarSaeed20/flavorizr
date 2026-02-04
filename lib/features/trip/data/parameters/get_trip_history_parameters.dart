// lib/features/trip/data/parameters/get_trip_history_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting trip history.
@immutable
class GetTripHistoryParameters extends Parameters {
  const GetTripHistoryParameters._({
    this.page = 1,
    this.perPage = 10,
    this.cancelToken,
  });

  @override
  Map<String, dynamic> toJson() => {
    'page': page,
    'per_page': perPage,
  };

  final int page;
  final int perPage;

  @override
  final CancelToken? cancelToken;

  static GetTripHistoryParametersBuilder builder() => GetTripHistoryParametersBuilder();
}

/// Builder for GetTripHistoryParameters.
class GetTripHistoryParametersBuilder extends ParametersBuilder<GetTripHistoryParameters> {
  int _page = 1;
  int _perPage = 10;
  CancelToken? _cancelToken;

  GetTripHistoryParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  GetTripHistoryParametersBuilder withPerPage(int perPage) {
    _perPage = perPage;
    return this;
  }

  @override
  GetTripHistoryParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  GetTripHistoryParameters build() {
    return GetTripHistoryParameters._(
      page: _page,
      perPage: _perPage,
      cancelToken: _cancelToken,
    );
  }
}
