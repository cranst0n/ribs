import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Irradiance', () {
    QuantityProperties.parsing(Irradiance.parse, Irradiance.units);
    QuantityProperties.equivalence(irradiance, irradianceUnit);
    QuantityProperties.roundtrip(irradiance, roundTrips);

    test('operator +', () {
      final result = 2.0.wattsPerSquareMeter + 1000.0.milliwattsPerSquareMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Irradiance.wattsPerSquareMeter));
    });

    test('operator -', () {
      final result = 5.0.wattsPerSquareMeter - 2000.0.milliwattsPerSquareMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Irradiance.wattsPerSquareMeter));
    });
  });
}

final roundTrips = <Function1<Irradiance, Irradiance>>[
  (i) => Irradiance(i.toMilliwattsPerSquareMeter.to(i.unit), i.unit),
  (i) => Irradiance(i.toWattsPerSquareMeter.to(i.unit), i.unit),
  (i) => Irradiance(i.toErgsPerSecondPerSquareCentimeter.to(i.unit), i.unit),
];
