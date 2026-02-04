// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_general.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiAboutUs _$ApiAboutUsFromJson(Map<String, dynamic> json) => _ApiAboutUs(
  description: json['description'] as String?,
  companyName: json['companyName'] as String?,
  logo: json['logo'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  website: json['website'] as String?,
  address: json['address'] as String?,
  socialMedia: (json['socialMedia'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$ApiAboutUsToJson(_ApiAboutUs instance) =>
    <String, dynamic>{
      'description': instance.description,
      'companyName': instance.companyName,
      'logo': instance.logo,
      'email': instance.email,
      'phone': instance.phone,
      'website': instance.website,
      'address': instance.address,
      'socialMedia': instance.socialMedia,
    };

_ApiQuestion _$ApiQuestionFromJson(Map<String, dynamic> json) => _ApiQuestion(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  answer: json['answer'] as String,
  category: json['category'] as String?,
  order: (json['order'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApiQuestionToJson(_ApiQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'category': instance.category,
      'order': instance.order,
    };

_ApiPolicies _$ApiPoliciesFromJson(Map<String, dynamic> json) => _ApiPolicies(
  termsAndConditions: json['termsAndConditions'] as String?,
  privacyPolicy: json['privacyPolicy'] as String?,
  refundPolicy: json['refundPolicy'] as String?,
  lastUpdated: json['lastUpdated'] as String?,
);

Map<String, dynamic> _$ApiPoliciesToJson(_ApiPolicies instance) =>
    <String, dynamic>{
      'termsAndConditions': instance.termsAndConditions,
      'privacyPolicy': instance.privacyPolicy,
      'refundPolicy': instance.refundPolicy,
      'lastUpdated': instance.lastUpdated,
    };

_ApiGeneralSettings _$ApiGeneralSettingsFromJson(Map<String, dynamic> json) =>
    _ApiGeneralSettings(
      appName: json['appName'] as String?,
      appVersion: json['appVersion'] as String?,
      appLogo: json['appLogo'] as String?,
      supportEmail: json['supportEmail'] as String?,
      supportPhone: json['supportPhone'] as String?,
      website: json['website'] as String?,
      currency: json['currency'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      defaultLanguage: json['defaultLanguage'] as String?,
      availableLanguages: (json['availableLanguages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      socialMedia: (json['socialMedia'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      appStoreUrl: json['appStoreUrl'] as String?,
      playStoreUrl: json['playStoreUrl'] as String?,
      minAppVersion: json['minAppVersion'] as String?,
      forceUpdate: json['forceUpdate'] as bool? ?? false,
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      maintenanceMessage: json['maintenanceMessage'] as String?,
    );

Map<String, dynamic> _$ApiGeneralSettingsToJson(_ApiGeneralSettings instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'appVersion': instance.appVersion,
      'appLogo': instance.appLogo,
      'supportEmail': instance.supportEmail,
      'supportPhone': instance.supportPhone,
      'website': instance.website,
      'currency': instance.currency,
      'currencySymbol': instance.currencySymbol,
      'defaultLanguage': instance.defaultLanguage,
      'availableLanguages': instance.availableLanguages,
      'socialMedia': instance.socialMedia,
      'appStoreUrl': instance.appStoreUrl,
      'playStoreUrl': instance.playStoreUrl,
      'minAppVersion': instance.minAppVersion,
      'forceUpdate': instance.forceUpdate,
      'maintenanceMode': instance.maintenanceMode,
      'maintenanceMessage': instance.maintenanceMessage,
    };
