import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Momentum', () {
    QuantityProperties.parsing(Momentum.parse, Momentum.units);
    QuantityProperties.equivalence(momentum, momentumUnit);
    QuantityProperties.roundtrip(momentum, roundTrips);
  });
}

final roundTrips = <Function1<Momentum, Momentum>>[
  (m) => Momentum(m.toNewtonSeconds.to(m.unit), m.unit),
  (m) => Momentum(m.toPoundForceSeconds.to(m.unit), m.unit),
];
