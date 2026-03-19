import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Force', () {
    QuantityProperties.parsing(Force.parse, Force.units);
    QuantityProperties.equivalence(force, forceUnit);
    QuantityProperties.roundtrip(force, roundTrips);
  });
}

final roundTrips = <Function1<Force, Force>>[
  (f) => Force(f.toMicronewtons.to(f.unit), f.unit),
  (f) => Force(f.toMillinewtons.to(f.unit), f.unit),
  (f) => Force(f.toNewtons.to(f.unit), f.unit),
  (f) => Force(f.toKilonewtons.to(f.unit), f.unit),
  (f) => Force(f.toMeganewtons.to(f.unit), f.unit),
  (f) => Force(f.toPoundsForce.to(f.unit), f.unit),
  (f) => Force(f.toKiloponds.to(f.unit), f.unit),
  (f) => Force(f.toPoundals.to(f.unit), f.unit),
  (f) => Force(f.toDynes.to(f.unit), f.unit),
  (f) => Force(f.toKips.to(f.unit), f.unit),
];
