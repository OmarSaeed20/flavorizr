import 'package:fast_golden_taxi/config/firebase/firebase_options/firebase_options_dev.dart'
    as fb_options_dev;
import 'package:fast_golden_taxi/config/firebase/firebase_options/firebase_options_prod.dart'
    as fb_options_prod;
import 'package:fast_golden_taxi/config/firebase/firebase_options/firebase_options_staging.dart'
    as fb_options_staging;
import 'package:fast_golden_taxi/config/flavors.dart' as f show F;
import 'package:fast_golden_taxi/config/flavors.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  const FirebaseConfig();

  static Future<void> setup() async {
    // getCurrentFlavor();
    await Firebase.initializeApp(options: getFirebaseOptions());
  }

  /* static f.Flavor getCurrentFlavor() {
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
 */
  static FirebaseOptions getFirebaseOptions() => switch (f.F.appFlavor) {
    Flavor.dev => fb_options_dev.DefaultFirebaseOptions.currentPlatform,
    Flavor.staging => fb_options_staging.DefaultFirebaseOptions.currentPlatform,
    Flavor.prod => fb_options_prod.DefaultFirebaseOptions.currentPlatform,
  };

  static String get projectId => getFirebaseOptions().projectId;

  static String get flavorName => switch (f.F.appFlavor) {
    Flavor.dev => 'Development',
    Flavor.staging => 'Staging',
    Flavor.prod => 'Production',
  };

  static String get flavorDisplayName => switch (f.F.appFlavor) {
    Flavor.dev => 'Fast Golden Taxi Dev',
    Flavor.staging => 'Fast Golden Taxi Staging',
    Flavor.prod => 'Fast Golden Taxi',
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
