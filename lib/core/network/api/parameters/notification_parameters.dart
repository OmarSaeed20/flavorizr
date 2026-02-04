import 'package:dio/dio.dart';
import 'package:flavorizr/features/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting notifications
@immutable
class GetNotificationsParameters extends Parameters {
  final int _page;
  final int _pageSize;
  final CancelToken? _cancelToken;

  const GetNotificationsParameters._({int page = 1, int pageSize = 20, CancelToken? cancelToken})
    : _page = page,
      _pageSize = pageSize,
      _cancelToken = cancelToken;

  /// Convert to query parameters for API request
  @override
  Map<String, dynamic> toQueryParameters() {
    return {'page': _page, 'page_size': _pageSize};
  }

  @override
  Map<String, dynamic> toJson() {
    return toQueryParameters();
  }

  int get page => _page;
  int get pageSize => _pageSize;
  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetNotificationsParametersBuilder builder() => GetNotificationsParametersBuilder();
}

/// Builder for GetNotificationsParameters
class GetNotificationsParametersBuilder extends ParametersBuilder<GetNotificationsParameters> {
  int _page = 1;
  int _pageSize = 20;
  CancelToken? _cancelToken;

  /// Set the page number
  GetNotificationsParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the page size
  GetNotificationsParametersBuilder withPageSize(int pageSize) {
    _pageSize = pageSize;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetNotificationsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters
  @override
  GetNotificationsParameters build() {
    return GetNotificationsParameters._(
      page: _page,
      pageSize: _pageSize,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for getting notification count
/// No parameters required for this endpoint
@immutable
class GetNotificationCountParameters extends Parameters {
  const GetNotificationCountParameters._();

  @override
  Map<String, dynamic> toJson() => const {};

  @override
  CancelToken? get cancelToken => null;

  GetNotificationCountParametersBuilder builder() => GetNotificationCountParametersBuilder();
}

/// Builder for GetNotificationCountParameters
class GetNotificationCountParametersBuilder
    extends ParametersBuilder<GetNotificationCountParameters> {
  @override
  GetNotificationCountParameters build() {
    return const GetNotificationCountParameters._();
  }

  @override
  GetNotificationCountParametersBuilder withCancelToken(CancelToken? cancelToken) {
    // No-op since this parameters class doesn't support cancel tokens
    return this;
  }
}
