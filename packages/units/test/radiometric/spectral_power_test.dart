import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('SpectralPower', () {
    QuantityProperties.parsing(SpectralPower.parse, SpectralPower.units);
    QuantityProperties.equivalence(spectralPower, spectralPowerUnit);
    QuantityProperties.roundtrip(spectralPower, roundTrips);

    test('operator +', () {
      final result = 2.0.wattsPerMeter + 1000.0.milliwattsPerMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(SpectralPower.wattsPerMeter));
    });

    test('operator -', () {
      final result = 5.0.wattsPerMeter - 2000.0.milliwattsPerMeter;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(SpectralPower.wattsPerMeter));
    });
  });
}

final roundTrips = <Function1<SpectralPower, SpectralPower>>[
  (s) => SpectralPower(s.toMilliwattsPerMeter.to(s.unit), s.unit),
  (s) => SpectralPower(s.toWattsPerMeter.to(s.unit), s.unit),
];
