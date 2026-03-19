import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('ElectricResistance', () {
    QuantityProperties.parsing(ElectricResistance.parse, ElectricResistance.units);
    QuantityProperties.equivalence(electricResistance, electricResistanceUnit);
    QuantityProperties.roundtrip(electricResistance, roundTrips);

    test('operator +', () {
      final result = 2.0.ohms + 1000.0.milliohms;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(ElectricResistance.ohms));
    });

    test('operator -', () {
      final result = 5.0.ohms - 1000.0.milliohms;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(ElectricResistance.ohms));
    });
  });
}

final roundTrips = <Function1<ElectricResistance, ElectricResistance>>[
  (r) => ElectricResistance(r.toMicroohms.to(r.unit), r.unit),
  (r) => ElectricResistance(r.toMilliohms.to(r.unit), r.unit),
  (r) => ElectricResistance(r.toOhms.to(r.unit), r.unit),
  (r) => ElectricResistance(r.toKiloohms.to(r.unit), r.unit),
  (r) => ElectricResistance(r.toMegaohms.to(r.unit), r.unit),
  (r) => ElectricResistance(r.toGigaohms.to(r.unit), r.unit),
];
