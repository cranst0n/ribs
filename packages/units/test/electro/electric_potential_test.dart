import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('DataRate', () {
    QuantityProperties.parsing(ElectricPotential.parse, ElectricPotential.units);
    QuantityProperties.equivalence(electricPotential, electricPotentialUnit);
    QuantityProperties.roundtrip(electricPotential, roundTrips);

    test('operator +', () {
      final result = 1.0.kilovolts + 1000.0.millivolts;
      expect(result.value, closeTo(1.001, 1e-9));
      expect(result.unit, equals(ElectricPotential.kilovolts));
    });

    test('operator -', () {
      final result = 5.0.volts - 1000.0.millivolts;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(ElectricPotential.volts));
    });
  });
}

final roundTrips = <Function1<ElectricPotential, ElectricPotential>>[
  (p) => ElectricPotential(p.toMicrovolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toMillivolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toVolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toKilovolts.to(p.unit), p.unit),
  (p) => ElectricPotential(p.toMegavolts.to(p.unit), p.unit),
];
