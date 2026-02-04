import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_general.freezed.dart';
part 'api_general.g.dart';

/// API About Us model
/// Represents about us information
@freezed
abstract class ApiAboutUs with _$ApiAboutUs {
  const factory ApiAboutUs({
    /// About us content/description
    String? description,

    /// Company name
    String? companyName,

    /// Company logo URL
    String? logo,

    /// Contact email
    String? email,

    /// Contact phone
    String? phone,

    /// Website URL
    String? website,

    /// Address
    String? address,

    /// Social media links
    Map<String, String>? socialMedia,
  }) = _ApiAboutUs;

  factory ApiAboutUs.fromJson(Map<String, dynamic> json) =>
      _$ApiAboutUsFromJson(json);
}

/// API Question/FAQ model
/// Represents a frequently asked question
@freezed
abstract class ApiQuestion with _$ApiQuestion {
  const factory ApiQuestion({
    /// Question ID
    required int id,

    /// Question text
    required String question,

    /// Answer text
    required String answer,

    /// Question category (optional)
    String? category,

    /// Order/priority
    int? order,
  }) = _ApiQuestion;

  factory ApiQuestion.fromJson(Map<String, dynamic> json) =>
      _$ApiQuestionFromJson(json);
}

/// API Policies model
/// Represents terms and conditions, privacy policy, etc.
@freezed
abstract class ApiPolicies with _$ApiPolicies {
  const factory ApiPolicies({
    /// Terms and conditions content
    String? termsAndConditions,

    /// Privacy policy content
    String? privacyPolicy,

    /// Refund policy content
    String? refundPolicy,

    /// Last updated timestamp
    String? lastUpdated,
  }) = _ApiPolicies;

  factory ApiPolicies.fromJson(Map<String, dynamic> json) =>
      _$ApiPoliciesFromJson(json);
}

/// API General Settings model
/// Represents general app settings and configuration
@freezed
abstract class ApiGeneralSettings with _$ApiGeneralSettings {
  const factory ApiGeneralSettings({
    /// App name
    String? appName,

    /// App version
    String? appVersion,

    /// App logo URL
    String? appLogo,

    /// Support email
    String? supportEmail,

    /// Support phone
    String? supportPhone,

    /// Website URL
    String? website,

    /// Currency code
    String? currency,

    /// Currency symbol
    String? currencySymbol,

    /// Default language
    String? defaultLanguage,

    /// Available languages
    List<String>? availableLanguages,

    /// Social media links
    Map<String, String>? socialMedia,

    /// App store URL
    String? appStoreUrl,

    /// Play store URL
    String? playStoreUrl,

    /// Minimum required app version
    String? minAppVersion,

    /// Force update flag
    @Default(false) bool forceUpdate,

    /// Maintenance mode flag
    @Default(false) bool maintenanceMode,

    /// Maintenance message
    String? maintenanceMessage,
  }) = _ApiGeneralSettings;

  factory ApiGeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$ApiGeneralSettingsFromJson(json);
}
