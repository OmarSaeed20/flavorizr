// lib/features/trip/data/parameters/get_my_orders_parameters.dart
import 'package:dio/dio.dart';
import 'package:flavorizr/features/trip/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting user's orders.
@immutable
class GetMyOrdersParameters extends Parameters {
  const GetMyOrdersParameters._({this.page = 1, this.perPage = 10, this.status, this.cancelToken});

  @override
  Map<String, dynamic> toJson() => {
    'page': page,
    'per_page': perPage,
    if (status != null) 'status': status,
  };

  final int page;
  final int perPage;
  final String? status;

  @override
  final CancelToken? cancelToken;

  static GetMyOrdersParametersBuilder builder() => GetMyOrdersParametersBuilder();
}

/// Builder for GetMyOrdersParameters.
class GetMyOrdersParametersBuilder extends ParametersBuilder<GetMyOrdersParameters> {
  int _page = 1;
  int _perPage = 10;
  String? _status;
  CancelToken? _cancelToken;

  GetMyOrdersParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  GetMyOrdersParametersBuilder withPerPage(int perPage) {
    _perPage = perPage;
    return this;
  }

  GetMyOrdersParametersBuilder withStatus(String status) {
    _status = status;
    return this;
  }

  @override
  GetMyOrdersParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  GetMyOrdersParameters build() {
    return GetMyOrdersParameters._(
      page: _page,
      perPage: _perPage,
      status: _status,
      cancelToken: _cancelToken,
    );
  }
}
