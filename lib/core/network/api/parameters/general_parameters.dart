import 'package:dio/dio.dart';
import 'package:flavorizr/features/user/auth/data/parameters/base_parameters.dart';
import 'package:meta/meta.dart';

/// Parameters for getting about us information
/// No parameters required for this endpoint
@immutable
class GetAboutUsParameters extends Parameters {
  const GetAboutUsParameters._();

  @override
  Map<String, dynamic> toJson() => const {};

  @override
  CancelToken? get cancelToken => null;

  static GetAboutUsParametersBuilder builder() => GetAboutUsParametersBuilder();
}

/// Builder for GetAboutUsParameters
class GetAboutUsParametersBuilder extends ParametersBuilder<GetAboutUsParameters> {
  @override
  GetAboutUsParameters build() {
    return const GetAboutUsParameters._();
  }

  @override
  GetAboutUsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    // No-op since this parameters class doesn't support cancel tokens
    return this;
  }
}

/// Parameters for getting questions/FAQ
/// No parameters required for this endpoint
@immutable
class GetQuestionsParameters extends Parameters {
  const GetQuestionsParameters._();

  @override
  Map<String, dynamic> toJson() => const {};

  @override
  CancelToken? get cancelToken => null;

  GetQuestionsParametersBuilder builder() => GetQuestionsParametersBuilder();
}

/// Builder for GetQuestionsParameters
class GetQuestionsParametersBuilder extends ParametersBuilder<GetQuestionsParameters> {
  @override
  GetQuestionsParameters build() {
    return const GetQuestionsParameters._();
  }

  @override
  GetQuestionsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    // No-op since this parameters class doesn't support cancel tokens
    return this;
  }
}

/// Parameters for getting policies
/// No parameters required for this endpoint
@immutable
class GetPoliciesParameters extends Parameters {
  const GetPoliciesParameters._();

  @override
  Map<String, dynamic> toJson() => const {};

  @override
  CancelToken? get cancelToken => null;

  GetPoliciesParametersBuilder builder() => GetPoliciesParametersBuilder();
}

/// Builder for GetPoliciesParameters
class GetPoliciesParametersBuilder extends ParametersBuilder<GetPoliciesParameters> {
  @override
  GetPoliciesParameters build() {
    return const GetPoliciesParameters._();
  }

  @override
  GetPoliciesParametersBuilder withCancelToken(CancelToken? cancelToken) {
    // No-op since this parameters class doesn't support cancel tokens
    return this;
  }
}

/// Parameters for getting general settings
/// No parameters required for this endpoint
@immutable
class GetGeneralSettingsParameters extends Parameters {
  const GetGeneralSettingsParameters._();

  @override
  Map<String, dynamic> toJson() => const {};

  @override
  CancelToken? get cancelToken => null;

  GetGeneralSettingsParametersBuilder builder() => GetGeneralSettingsParametersBuilder();
}

/// Builder for GetGeneralSettingsParameters
class GetGeneralSettingsParametersBuilder extends ParametersBuilder<GetGeneralSettingsParameters> {
  @override
  GetGeneralSettingsParameters build() {
    return const GetGeneralSettingsParameters._();
  }

  @override
  GetGeneralSettingsParametersBuilder withCancelToken(CancelToken? cancelToken) {
    // No-op since this parameters class doesn't support cancel tokens
    return this;
  }
}
