import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting cities.
///
/// Based on FAST App API documentation for GET /select/cities
@immutable
class GetCitiesParameters extends Parameters {
  final int? _countryId;
  final int? _governorateId;
  final String? _search;
  final CancelToken? _cancelToken;

  const GetCitiesParameters._({
    int? countryId,
    int? governorateId,
    String? search,
    CancelToken? cancelToken,
  }) : _countryId = countryId,
       _governorateId = governorateId,
       _search = search,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (_countryId != null) {
      json['country_id'] = _countryId;
    }
    if (_governorateId != null) {
      json['governorate_id'] = _governorateId;
    }
    if (_search != null) {
      json['search'] = _search;
    }
    return json;
  }

  int? get countryId => _countryId;
  int? get governorateId => _governorateId;
  String? get search => _search;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetCitiesParametersBuilder builder() => GetCitiesParametersBuilder();
}

/// Builder for GetCitiesParameters
class GetCitiesParametersBuilder
    extends ParametersBuilder<GetCitiesParameters> {
  int? _countryId;
  int? _governorateId;
  String? _search;
  CancelToken? _cancelToken;

  /// Set the country ID filter (optional)
  GetCitiesParametersBuilder withCountryId(int countryId) {
    _countryId = countryId;
    return this;
  }

  /// Set the governorate ID filter (optional)
  GetCitiesParametersBuilder withGovernorateId(int governorateId) {
    _governorateId = governorateId;
    return this;
  }

  /// Set the search query (optional)
  GetCitiesParametersBuilder withSearch(String search) {
    _search = search;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetCitiesParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetCitiesParameters
  @override
  GetCitiesParameters build() {
    return GetCitiesParameters._(
      countryId: _countryId,
      governorateId: _governorateId,
      search: _search,
      cancelToken: _cancelToken,
    );
  }
}
