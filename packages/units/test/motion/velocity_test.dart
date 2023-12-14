import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../gen.dart';
import '../quantity_properties.dart';

void main() {
  group('Velocity', () {
    QuantityProperties.parsing(Velocity.parse, Velocity.units);
    QuantityProperties.equivalence(velocity, velocityUnit);
    QuantityProperties.roundtrip(velocity, roundTrips);
  });
}

final roundTrips = <Function1<Velocity, Velocity>>[
  (v) => Velocity(v.toFeetPerSecond.to(v.unit), v.unit),
  (v) => Velocity(v.toMillimetersPerSecond.to(v.unit), v.unit),
  (v) => Velocity(v.toMetersPerSecond.to(v.unit), v.unit),
  (v) => Velocity(v.toKilometersPerSecond.to(v.unit), v.unit),
  (v) => Velocity(v.toKilometersPerHour.to(v.unit), v.unit),
  (v) => Velocity(v.toUsMilesPerHour.to(v.unit), v.unit),
  (v) => Velocity(v.toKnots.to(v.unit), v.unit),
];
