// lib/features/company/company_auth/data/parameters/company_logout_parameters.dart
import 'package:dio/dio.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/base_parameters.dart';

/// Company Logout API parameters
///
/// Used to logout company account.
/// Based on API_DOCUMENTATION.md
class CompanyLogoutParameters extends Parameters {
  @override
  final CancelToken? cancelToken;

  const CompanyLogoutParameters({this.cancelToken});

  /// Convert to JSON for API request
  @override
  Map<String, dynamic> toJson() => {};

  /// Create a builder for this parameters type
  CompanyLogoutParametersBuilder builder() => CompanyLogoutParametersBuilder();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyLogoutParameters && other.cancelToken == cancelToken;
  }

  @override
  int get hashCode => cancelToken.hashCode;

  @override
  String toString() => 'CompanyLogoutParameters(cancelToken: $cancelToken)';
}

/// Builder for CompanyLogoutParameters
class CompanyLogoutParametersBuilder extends ParametersBuilder<CompanyLogoutParameters> {
  CancelToken? _cancelToken;

  /// Set the cancel token for request cancellation
  CompanyLogoutParametersBuilder cancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  ParametersBuilder<CompanyLogoutParameters> withCancelToken(CancelToken? cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  CompanyLogoutParameters build() {
    return CompanyLogoutParameters(cancelToken: _cancelToken);
  }
}
