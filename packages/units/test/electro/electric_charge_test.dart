import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('ElectricCharge', () {
    QuantityProperties.parsing(ElectricCharge.parse, ElectricCharge.units);
    QuantityProperties.equivalence(electricCharge, electricChargeUnit);
    QuantityProperties.roundtrip(electricCharge, roundTrips);

    test('operator +', () {
      final result = 2.0.ampereHours + 1000.0.milliampereHours;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(ElectricCharge.ampereHours));
    });

    test('operator -', () {
      final result = 5.0.ampereHours - 1000.0.milliampereHours;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(ElectricCharge.ampereHours));
    });
  });
}

final roundTrips = <Function1<ElectricCharge, ElectricCharge>>[
  (c) => ElectricCharge(c.toCoulombs.to(c.unit), c.unit),
  (c) => ElectricCharge(c.toAmpereHours.to(c.unit), c.unit),
  (c) => ElectricCharge(c.toMilliampereHours.to(c.unit), c.unit),
];
