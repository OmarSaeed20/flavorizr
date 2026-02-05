import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting countries.
///
/// Based on FAST App API documentation for GET /select/countries
@immutable
class GetCountriesParameters extends Parameters {
  final String? _search;
  final CancelToken? _cancelToken;

  const GetCountriesParameters._({String? search, CancelToken? cancelToken})
    : _search = search,
      _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (_search != null) {
      json['search'] = _search;
    }
    return json;
  }

  String? get search => _search;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetCountriesParametersBuilder builder() =>
      GetCountriesParametersBuilder();
}

/// Builder for GetCountriesParameters
class GetCountriesParametersBuilder
    extends ParametersBuilder<GetCountriesParameters> {
  String? _search;
  CancelToken? _cancelToken;

  /// Set the search query (optional)
  GetCountriesParametersBuilder withSearch(String search) {
    _search = search;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetCountriesParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetCountriesParameters
  @override
  GetCountriesParameters build() {
    return GetCountriesParameters._(search: _search, cancelToken: _cancelToken);
  }
}
