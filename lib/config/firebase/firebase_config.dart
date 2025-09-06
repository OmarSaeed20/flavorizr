import 'package:firebase_core/firebase_core.dart';
import 'package:flavorizr/config/flavors.dart' as f show Flavor, F;
import 'package:flavorizr/config/flavors.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'firebase_options/firebase_options_dev.dart' as fb_options_dev;
import 'firebase_options/firebase_options_staging.dart' as fb_options_staging;
import 'firebase_options/firebase_options_prod.dart' as fb_options_prod;

class FirebaseConfig {
  static setup() async {
    getCurrentFlavor();
    await Firebase.initializeApp(options: getFirebaseOptions());
  }

  static f.Flavor getCurrentFlavor() {
    f.Flavor flavor;
    // const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    try {
      flavor = f.F.appFlavor;
    } catch (e) {
      flavor = f.Flavor.values.firstWhere(
        (element) => element.name == appFlavor,
        orElse: () => f.Flavor.dev,
      );
    }

    return flavor;
  }

  static FirebaseOptions getFirebaseOptions() => switch (getCurrentFlavor()) {
    Flavor.dev => fb_options_dev.DefaultFirebaseOptions.currentPlatform,
    Flavor.staging => fb_options_staging.DefaultFirebaseOptions.currentPlatform,
    Flavor.prod => fb_options_prod.DefaultFirebaseOptions.currentPlatform,
  };

  static String get projectId => getFirebaseOptions().projectId;

  static String get flavorName => switch (getCurrentFlavor()) {
    Flavor.dev => 'Development',
    Flavor.staging => 'Staging',
    Flavor.prod => 'Production',
  };

  static String get flavorDisplayName => switch (getCurrentFlavor()) {
    Flavor.dev => 'Flavorizr Dev',
    Flavor.staging => 'Flavorizr Staging',
    Flavor.prod => 'Flavorizr',
  };
}

/* 

  ## flavorizr-dev
flutterfire configure --project=flavorizr-b3322-dev --out=lib/firebase_options_dev.dart --ios-bundle-id=com.example.flavorizr.dev --android-app-id=com.example.flavorizr.dev

  ## flavorizr-staging
flutterfire configure --project=flavorizr-b3322-staging --out=lib/firebase_options_staging.dart --ios-bundle-id=com.example.flavorizr.staging --android-app-id=com.example.flavorizr.staging

  ## flavorizr-prod
flutterfire configure --project=flavorizr-b3322 --out=lib/firebase_options.dart --ios-bundle-id=com.example.flavorizr --android-app-id=com.example.flavorizr

 */