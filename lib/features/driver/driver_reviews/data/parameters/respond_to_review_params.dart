import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for responding to a review
@immutable
class RespondToReviewParams extends Parameters {
  final String _reviewId;
  final String _response;
  final CancelToken? _cancelToken;

  const RespondToReviewParams._({
    required String reviewId,
    required String response,
    CancelToken? cancelToken,
  }) : _reviewId = reviewId,
       _response = response,
       _cancelToken = cancelToken;

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() {
    return {'reviewId': _reviewId, 'response': _response};
  }

  String get reviewId => _reviewId;
  String get response => _response;
  @override
  CancelToken? get cancelToken => _cancelToken;

  /// Static builder factory
  static RespondToReviewParamsBuilder builder() => RespondToReviewParamsBuilder();
}

/// Builder for RespondToReviewParams
class RespondToReviewParamsBuilder extends ParametersBuilder<RespondToReviewParams> {
  String? _reviewId;
  String? _response;
  CancelToken? _cancelToken;

  /// Set the review ID
  RespondToReviewParamsBuilder withReviewId(String reviewId) {
    _reviewId = reviewId;
    return this;
  }

  /// Set the response
  RespondToReviewParamsBuilder withResponse(String response) {
    _response = response;
    return this;
  }

  /// Set the cancel token for request cancellation
  @override
  RespondToReviewParamsBuilder withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  /// Build the RespondToReviewParams
  @override
  RespondToReviewParams build() {
    if (_reviewId == null) {
      throw ArgumentError('Review ID is required');
    }
    if (_response == null) {
      throw ArgumentError('Response is required');
    }
    return RespondToReviewParams._(
      reviewId: _reviewId!,
      response: _response!,
      cancelToken: _cancelToken,
    );
  }
}
