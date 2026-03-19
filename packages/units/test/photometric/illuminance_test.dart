import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Illuminance', () {
    QuantityProperties.parsing(Illuminance.parse, Illuminance.units);
    QuantityProperties.equivalence(illuminance, illuminanceUnit);
    QuantityProperties.roundtrip(illuminance, roundTrips);

    test('operator +', () {
      final result = 2.0.lux + 1000.0.millilux;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Illuminance.lux));
    });

    test('operator -', () {
      final result = 5.0.lux - 1000.0.millilux;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(Illuminance.lux));
    });
  });
}

final roundTrips = <Function1<Illuminance, Illuminance>>[
  (i) => Illuminance(i.toMillilux.to(i.unit), i.unit),
  (i) => Illuminance(i.toLux.to(i.unit), i.unit),
  (i) => Illuminance(i.toKilolux.to(i.unit), i.unit),
  (i) => Illuminance(i.toFootcandles.to(i.unit), i.unit),
];
