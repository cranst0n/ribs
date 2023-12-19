import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('DataRate', () {
    QuantityProperties.parsing(
        ElectricPotential.parse, ElectricPotential.units);
    QuantityProperties.equivalence(electricPotential, electricPotentialUnit);
    QuantityProperties.roundtrip(electricPotential, roundTrips);
  });
}

final roundTrips = <Function1<ElectricPotential, ElectricPotential>>[
  (p) => ElectricPotential(p.toMicrovolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toMillivolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toVolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toMilovolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toMegavolts.to(p.unit), p.unit),
];
