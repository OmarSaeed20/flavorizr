import 'package:flutter/material.dart' show runApp;
import 'package:flutter/services.dart' show appFlavor;

import 'app.dart';
import 'config/firebase/firebase_config.dart' show FirebaseConfig;
import 'config/flavors.dart';

void main() async {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );
  await FirebaseConfig.setup();
  runApp(const App());
}
