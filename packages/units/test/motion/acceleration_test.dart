import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Acceleration', () {
    QuantityProperties.parsing(Acceleration.parse, Acceleration.units);
    QuantityProperties.equivalence(acceleration, accelerationUnit);
    QuantityProperties.roundtrip(acceleration, roundTrips);
  });
}

final roundTrips = <Function1<Acceleration, Acceleration>>[
  (a) => Acceleration(a.toMetersPerSecondSquared.to(a.unit), a.unit),
  (a) => Acceleration(a.toFeetPerSecondSquared.to(a.unit), a.unit),
  (a) => Acceleration(a.toEarthGravities.to(a.unit), a.unit),
];
