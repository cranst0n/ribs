import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('MassFlow', () {
    QuantityProperties.parsing(MassFlow.parse, MassFlow.units);
    QuantityProperties.equivalence(massFlow, massFlowUnit);
    QuantityProperties.roundtrip(massFlow, roundTrips);
  });
}

final roundTrips = <Function1<MassFlow, MassFlow>>[
  (m) => MassFlow(m.toKilogramsPerSecond.to(m.unit), m.unit),
  (m) => MassFlow(m.toKilogramsPerMinute.to(m.unit), m.unit),
  (m) => MassFlow(m.toKilogramsPerHour.to(m.unit), m.unit),
  (m) => MassFlow(m.toGramsPerSecond.to(m.unit), m.unit),
  (m) => MassFlow(m.toPoundsPerSecond.to(m.unit), m.unit),
  (m) => MassFlow(m.toPoundsPerMinute.to(m.unit), m.unit),
  (m) => MassFlow(m.toPoundsPerHour.to(m.unit), m.unit),
  (m) => MassFlow(m.toKilopoundsPerHour.to(m.unit), m.unit),
  (m) => MassFlow(m.toMegapoundsPerHour.to(m.unit), m.unit),
];
