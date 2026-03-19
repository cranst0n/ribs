import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Radiance', () {
    QuantityProperties.parsing(Radiance.parse, Radiance.units);
    QuantityProperties.equivalence(radiance, radianceUnit);
    QuantityProperties.roundtrip(radiance, roundTrips);

    test('operator +', () {
      final result =
          2.0.wattsPerSteradianPerSquareMeter + 1000.0.milliwattsPerSteradianPerSquareMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Radiance.wattsPerSteradianPerSquareMeter));
    });

    test('operator -', () {
      final result =
          5.0.wattsPerSteradianPerSquareMeter - 2000.0.milliwattsPerSteradianPerSquareMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Radiance.wattsPerSteradianPerSquareMeter));
    });
  });
}

final roundTrips = <Function1<Radiance, Radiance>>[
  (r) => Radiance(r.toMilliwattsPerSteradianPerSquareMeter.to(r.unit), r.unit),
  (r) => Radiance(r.toWattsPerSteradianPerSquareMeter.to(r.unit), r.unit),
];
