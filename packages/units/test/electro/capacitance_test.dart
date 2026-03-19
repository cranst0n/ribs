import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Capacitance', () {
    QuantityProperties.parsing(Capacitance.parse, Capacitance.units);
    QuantityProperties.equivalence(capacitance, capacitanceUnit);
    QuantityProperties.roundtrip(capacitance, roundTrips);

    test('operator +', () {
      final result = 2.0.farads + 1000.0.millifarads;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Capacitance.farads));
    });

    test('operator -', () {
      final result = 5.0.farads - 1000.0.millifarads;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(Capacitance.farads));
    });
  });
}

final roundTrips = <Function1<Capacitance, Capacitance>>[
  (c) => Capacitance(c.toFemtofarads.to(c.unit), c.unit),
  (c) => Capacitance(c.toPicofarads.to(c.unit), c.unit),
  (c) => Capacitance(c.toNanofarads.to(c.unit), c.unit),
  (c) => Capacitance(c.toMicrofarads.to(c.unit), c.unit),
  (c) => Capacitance(c.toMillifarads.to(c.unit), c.unit),
  (c) => Capacitance(c.toFarads.to(c.unit), c.unit),
];
