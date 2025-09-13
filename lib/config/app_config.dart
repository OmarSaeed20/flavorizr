import 'package:flavorizr/config/flavors.dart' show F, Flavor;
import 'package:flutter/foundation.dart';

import 'firebase/firebase_config.dart';

class AppConfig {
  const AppConfig();
  static String get baseUrl {
    switch (F.appFlavor) {
      case Flavor.dev:
        return 'https://dev-api.example.com';
      case Flavor.staging:
        return 'https://staging-api.example.com';
      case Flavor.prod:
        return 'https://api.example.com';
    }
  }

  static bool get isDebugMode => switch (F.appFlavor) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => kDebugMode,
  };

  static Map<String, dynamic> get firebaseConfig {
    return {
      'projectId': FirebaseConfig.projectId,
      'flavor': flavorName,
      'debugMode': isDebugMode,
    };
  }

  static String get flavorName => F.name;
}
