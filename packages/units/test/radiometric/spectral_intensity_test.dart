import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('SpectralIntensity', () {
    QuantityProperties.parsing(SpectralIntensity.parse, SpectralIntensity.units);
    QuantityProperties.equivalence(spectralIntensity, spectralIntensityUnit);
    QuantityProperties.roundtrip(spectralIntensity, roundTrips);

    test('operator +', () {
      final result = 2.0.wattsPerSteradianPerMeter + 1000.0.milliwattsPerSteradianPerMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(SpectralIntensity.wattsPerSteradianPerMeter));
    });

    test('operator -', () {
      final result = 5.0.wattsPerSteradianPerMeter - 2000.0.milliwattsPerSteradianPerMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(SpectralIntensity.wattsPerSteradianPerMeter));
    });
  });
}

final roundTrips = <Function1<SpectralIntensity, SpectralIntensity>>[
  (s) => SpectralIntensity(s.toMilliwattsPerSteradianPerMeter.to(s.unit), s.unit),
  (s) => SpectralIntensity(s.toWattsPerSteradianPerMeter.to(s.unit), s.unit),
];
