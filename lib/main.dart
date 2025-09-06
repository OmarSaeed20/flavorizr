import 'package:flutter/material.dart' show runApp;
import 'package:flutter/services.dart' show appFlavor;

import 'app.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  runApp(const App());
}
