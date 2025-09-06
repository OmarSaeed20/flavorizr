import 'package:flavorizr/config/flavors.dart' show Flavor;
import 'package:flutter/foundation.dart';

import 'firebase/firebase_config.dart';

class AppConfig {
  static String get apiUrl {
    switch (FirebaseConfig.getCurrentFlavor()) {
      case Flavor.dev:
        return 'https://dev-api.example.com';
      case Flavor.staging:
        return 'https://staging-api.example.com';
      case Flavor.prod:
        return 'https://api.example.com';
    }
  }

  static bool get debugMode => switch (FirebaseConfig.getCurrentFlavor()) {
    Flavor.dev => true,
    Flavor.staging => true,
    Flavor.prod => kDebugMode,
  };

  static Map<String, dynamic> get firebaseConfig {
    return {
      'projectId': FirebaseConfig.projectId,
      'flavor': FirebaseConfig.flavorName,
      'debugMode': debugMode,
    };
  }

  static String get flavorName => FirebaseConfig.flavorName;
}
