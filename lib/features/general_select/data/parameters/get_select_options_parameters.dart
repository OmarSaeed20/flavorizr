import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting select options.
///
/// Used for fetching various select options like vehicle types, cities, etc.
@immutable
class GetSelectOptionsParameters extends Parameters {
  final String _type;
  final String? _search;
  final int? _limit;
  final CancelToken? _cancelToken;

  const GetSelectOptionsParameters._({
    required String type,
    String? search,
    int? limit,
    CancelToken? cancelToken,
  }) : _type = type,
       _search = search,
       _limit = limit,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'type': _type};
    if (_search != null) {
      json['search'] = _search;
    }
    if (_limit != null) {
      json['limit'] = _limit;
    }
    return json;
  }

  String get type => _type;
  String? get search => _search;
  int? get limit => _limit;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetSelectOptionsParametersBuilder builder() =>
      GetSelectOptionsParametersBuilder();
}

/// Builder for GetSelectOptionsParameters
class GetSelectOptionsParametersBuilder
    extends ParametersBuilder<GetSelectOptionsParameters> {
  String? _type;
  String? _search;
  int? _limit;
  CancelToken? _cancelToken;

  /// Set the type of select options to fetch
  GetSelectOptionsParametersBuilder withType(String type) {
    _type = type;
    return this;
  }

  /// Set the search query (optional)
  GetSelectOptionsParametersBuilder withSearch(String search) {
    _search = search;
    return this;
  }

  /// Set the limit for results (optional)
  GetSelectOptionsParametersBuilder withLimit(int limit) {
    _limit = limit;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetSelectOptionsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetSelectOptionsParameters
  @override
  GetSelectOptionsParameters build() {
    if (_type == null) {
      throw ArgumentError('Type is required');
    }
    return GetSelectOptionsParameters._(
      type: _type!,
      search: _search,
      limit: _limit,
      cancelToken: _cancelToken,
    );
  }
}
