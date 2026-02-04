import 'package:dio/dio.dart';
import 'package:flavorizr/features/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting chat messages by order
@immutable
class GetChatByOrderParameters extends Parameters {
  final int _orderId;
  final int _page;
  final int _pageSize;
  final CancelToken? _cancelToken;

  const GetChatByOrderParameters._({
    required int orderId,
    int page = 1,
    int pageSize = 20,
    CancelToken? cancelToken,
  }) : _orderId = orderId,
       _page = page,
       _pageSize = pageSize,
       _cancelToken = cancelToken;

  /// Convert to query parameters for API request
  @override
  Map<String, dynamic> toQueryParameters() {
    return {'page': _page, 'per_page': _pageSize};
  }

  int get orderId => _orderId;
  int get page => _page;
  int get pageSize => _pageSize;
  @override
  CancelToken? get cancelToken => _cancelToken;

  static GetChatByOrderParametersBuilder builder() => GetChatByOrderParametersBuilder();

  @override
  Map<String, dynamic> toJson() {
    return {'order_id': _orderId};
  }
}

/// Builder for GetChatByOrderParameters
class GetChatByOrderParametersBuilder extends ParametersBuilder<GetChatByOrderParameters> {
  int? _orderId;
  int _page = 1;
  int _pageSize = 20;
  CancelToken? _cancelToken;

  /// Set the order ID
  GetChatByOrderParametersBuilder withOrderId(int orderId) {
    _orderId = orderId;
    return this;
  }

  /// Set the page number
  GetChatByOrderParametersBuilder withPage(int page) {
    _page = page;
    return this;
  }

  /// Set the page size
  GetChatByOrderParametersBuilder withPageSize(int pageSize) {
    _pageSize = pageSize;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetChatByOrderParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters
  @override
  GetChatByOrderParameters build() {
    if (_orderId == null) {
      throw ArgumentError('orderId is required');
    }
    return GetChatByOrderParameters._(
      orderId: _orderId!,
      page: _page,
      pageSize: _pageSize,
      cancelToken: _cancelToken,
    );
  }
}

/// Parameters for saving a message
@immutable
class SaveMessageParameters extends Parameters {
  final int _orderId;
  final int _driverId;
  final String _message;
  final CancelToken? _cancelToken;

  const SaveMessageParameters._({
    required int orderId,
    required int driverId,
    required String message,
    CancelToken? cancelToken,
  }) : _orderId = orderId,
       _driverId = driverId,
       _message = message,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'order_id': _orderId, 'driver_id': _driverId, 'message': _message};
  }

  int get orderId => _orderId;
  int get driverId => _driverId;
  String get message => _message;
  @override
  CancelToken? get cancelToken => _cancelToken;

  SaveMessageParametersBuilder builder() => SaveMessageParametersBuilder();
}

/// Builder for SaveMessageParameters
class SaveMessageParametersBuilder extends ParametersBuilder<SaveMessageParameters> {
  int? _orderId;
  int? _driverId;
  String? _message;
  CancelToken? _cancelToken;

  /// Set the order ID
  SaveMessageParametersBuilder withOrderId(int orderId) {
    _orderId = orderId;
    return this;
  }

  /// Set the driver ID
  SaveMessageParametersBuilder withDriverId(int driverId) {
    _driverId = driverId;
    return this;
  }

  /// Set the message
  SaveMessageParametersBuilder withMessage(String message) {
    _message = message;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  SaveMessageParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the parameters
  @override
  SaveMessageParameters build() {
    if (_orderId == null) {
      throw ArgumentError('orderId is required');
    }
    if (_driverId == null) {
      throw ArgumentError('driverId is required');
    }
    if (_message == null || _message!.isEmpty) {
      throw ArgumentError('message is required');
    }
    return SaveMessageParameters._(
      orderId: _orderId!,
      driverId: _driverId!,
      message: _message!,
      cancelToken: _cancelToken,
    );
  }
}
