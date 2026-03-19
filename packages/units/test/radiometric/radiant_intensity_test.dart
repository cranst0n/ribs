import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('RadiantIntensity', () {
    QuantityProperties.parsing(RadiantIntensity.parse, RadiantIntensity.units);
    QuantityProperties.equivalence(radiantIntensity, radiantIntensityUnit);
    QuantityProperties.roundtrip(radiantIntensity, roundTrips);

    test('operator +', () {
      final result = 2.0.wattsPerSteradian + 1000.0.milliwattsPerSteradian;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(RadiantIntensity.wattsPerSteradian));
    });

    test('operator -', () {
      final result = 5.0.wattsPerSteradian - 2000.0.milliwattsPerSteradian;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(RadiantIntensity.wattsPerSteradian));
    });
  });
}

final roundTrips = <Function1<RadiantIntensity, RadiantIntensity>>[
  (r) => RadiantIntensity(r.toMilliwattsPerSteradian.to(r.unit), r.unit),
  (r) => RadiantIntensity(r.toWattsPerSteradian.to(r.unit), r.unit),
];
