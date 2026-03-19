import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('ElectricConductance', () {
    QuantityProperties.parsing(ElectricConductance.parse, ElectricConductance.units);
    QuantityProperties.equivalence(electricConductance, electricConductanceUnit);
    QuantityProperties.roundtrip(electricConductance, roundTrips);

    test('operator +', () {
      final result = 2.0.siemens + 1000.0.millisiemens;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(ElectricConductance.siemens));
    });

    test('operator -', () {
      final result = 5.0.siemens - 1000.0.millisiemens;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(ElectricConductance.siemens));
    });
  });
}

final roundTrips = <Function1<ElectricConductance, ElectricConductance>>[
  (c) => ElectricConductance(c.toPicosiemens.to(c.unit), c.unit),
  (c) => ElectricConductance(c.toMicrosiemens.to(c.unit), c.unit),
  (c) => ElectricConductance(c.toMillisiemens.to(c.unit), c.unit),
  (c) => ElectricConductance(c.toSiemens.to(c.unit), c.unit),
];
