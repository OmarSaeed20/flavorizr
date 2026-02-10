import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting frequently asked questions.
///
/// Based on FAST App API documentation for GET /setting/questions
@immutable
class GetQuestionsParameters extends Parameters {
  final String? _category;
  final CancelToken? _cancelToken;

  const GetQuestionsParameters._({String? category, CancelToken? cancelToken})
    : _category = category,
      _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (_category != null) {
      json['category'] = _category;
    }
    return json;
  }

  String? get category => _category;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static GetQuestionsParametersBuilder builder() =>
      GetQuestionsParametersBuilder();
}

/// Builder for GetQuestionsParameters
class GetQuestionsParametersBuilder
    extends ParametersBuilder<GetQuestionsParameters> {
  String? _category;
  CancelToken? _cancelToken;

  /// Set the category filter (optional)
  GetQuestionsParametersBuilder withCategory(String category) {
    _category = category;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  GetQuestionsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the GetQuestionsParameters
  @override
  GetQuestionsParameters build() {
    return GetQuestionsParameters._(
      category: _category,
      cancelToken: _cancelToken,
    );
  }
}
