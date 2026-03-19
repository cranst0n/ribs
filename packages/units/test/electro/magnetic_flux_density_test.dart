import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('MagneticFluxDensity', () {
    QuantityProperties.parsing(MagneticFluxDensity.parse, MagneticFluxDensity.units);
    QuantityProperties.equivalence(magneticFluxDensity, magneticFluxDensityUnit);
    QuantityProperties.roundtrip(magneticFluxDensity, roundTrips);

    test('operator +', () {
      final result = 2.0.teslas + 1000.0.milliteslas;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(MagneticFluxDensity.teslas));
    });

    test('operator -', () {
      final result = 5.0.teslas - 1000.0.milliteslas;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(MagneticFluxDensity.teslas));
    });
  });
}

final roundTrips = <Function1<MagneticFluxDensity, MagneticFluxDensity>>[
  (m) => MagneticFluxDensity(m.toNanoteslas.to(m.unit), m.unit),
  (m) => MagneticFluxDensity(m.toMicroteslas.to(m.unit), m.unit),
  (m) => MagneticFluxDensity(m.toMilliteslas.to(m.unit), m.unit),
  (m) => MagneticFluxDensity(m.toTeslas.to(m.unit), m.unit),
  (m) => MagneticFluxDensity(m.toGauss.to(m.unit), m.unit),
];
