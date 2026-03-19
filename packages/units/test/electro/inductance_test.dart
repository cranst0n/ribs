import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Inductance', () {
    QuantityProperties.parsing(Inductance.parse, Inductance.units);
    QuantityProperties.equivalence(inductance, inductanceUnit);
    QuantityProperties.roundtrip(inductance, roundTrips);

    test('operator +', () {
      final result = 2.0.henries + 1000.0.millihenries;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Inductance.henries));
    });

    test('operator -', () {
      final result = 5.0.henries - 1000.0.millihenries;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(Inductance.henries));
    });
  });
}

final roundTrips = <Function1<Inductance, Inductance>>[
  (i) => Inductance(i.toPicohenries.to(i.unit), i.unit),
  (i) => Inductance(i.toNanohenries.to(i.unit), i.unit),
  (i) => Inductance(i.toMicrohenries.to(i.unit), i.unit),
  (i) => Inductance(i.toMillihenries.to(i.unit), i.unit),
  (i) => Inductance(i.toHenries.to(i.unit), i.unit),
];
