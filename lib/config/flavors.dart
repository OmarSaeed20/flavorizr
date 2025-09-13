import 'package:flutter/foundation.dart';

enum Flavor { dev, staging, prod }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title => switch (appFlavor) {
    Flavor.dev => 'Flavorizr Dev',
    Flavor.staging => 'Flavorizr Staging',
    Flavor.prod => 'Flavorizr',
  };
}

extension EnvironmentExtension on Flavor {
  bool get isProduction => this == Flavor.prod;
  bool get isStaging => this == Flavor.staging;
  bool get isDevelopment => this == Flavor.dev;

  String get name => switch (this) {
    Flavor.dev => 'dev',
    Flavor.staging => 'staging',
    Flavor.prod => 'prod',
  };
  String get baseUrl => switch (this) {
    Flavor.dev => 'https://flavorizr-b3322-dev.web.app',
    Flavor.staging => 'https://flavorizr-b3322-staging.web.app',
    Flavor.prod => 'https://flavorizr-b3322.web.app',
  };

  bool get isDebugMode => switch (this) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => kDebugMode,
  };
}
