import 'package:flavorizr/bootstrap.dart';
import 'package:flavorizr/config/flavors.dart';
import 'package:flutter/services.dart' show appFlavor;

void main() {
  // Determine the flavor from the platform
  final flavor = Flavor.values.firstWhere(
    (f) => f.name == appFlavor,
    orElse: () => Flavor.dev,
  );

  bootstrap(flavor);
}
