import 'package:flavorizr/features/driver_auth/domain/entities/driver_credentials.dart';
import 'driver_model.dart';

/// Model for DriverCredentials entity.
class DriverCredentialsModel extends DriverCredentials {
  DriverCredentialsModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
    required super.driver,
  });

  factory DriverCredentialsModel.fromJson(Map<String, dynamic> json) {
    return DriverCredentialsModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 3600,
      driver: DriverModel.fromJson(json['driver'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'driver': (driver as DriverModel).toJson(),
    };
  }

  DriverCredentials toEntity() {
    return DriverCredentials(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      driver: (driver as DriverModel).toEntity(),
    );
  }
}