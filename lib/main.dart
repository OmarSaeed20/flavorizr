import 'package:fast_golden_taxi/bootstrap.dart';
import 'package:fast_golden_taxi/config/flavors.dart';
import 'package:flutter/services.dart' show appFlavor;

void main() {
  // Determine the flavor from the platform
  final flavor = Flavor.values.firstWhere(
    (f) => f.name == appFlavor,
    orElse: () => Flavor.dev,
  );

  bootstrap(flavor);
}
