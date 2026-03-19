import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('ElectricCurrent', () {
    QuantityProperties.parsing(ElectricCurrent.parse, ElectricCurrent.units);
    QuantityProperties.equivalence(electricCurrent, electricCurrentUnit);
    QuantityProperties.roundtrip(electricCurrent, roundTrips);

    test('operator +', () {
      final result = 2.0.amperes + 1000.0.milliamperes;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(ElectricCurrent.amperes));
    });

    test('operator -', () {
      final result = 5.0.amperes - 1000.0.milliamperes;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(ElectricCurrent.amperes));
    });
  });
}

final roundTrips = <Function1<ElectricCurrent, ElectricCurrent>>[
  (c) => ElectricCurrent(c.toMicroamperes.to(c.unit), c.unit),
  (c) => ElectricCurrent(c.toMilliamperes.to(c.unit), c.unit),
  (c) => ElectricCurrent(c.toAmperes.to(c.unit), c.unit),
  (c) => ElectricCurrent(c.toDeciamperes.to(c.unit), c.unit),
  (c) => ElectricCurrent(c.toKiloamperes.to(c.unit), c.unit),
];
