import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('MagneticFlux', () {
    QuantityProperties.parsing(MagneticFlux.parse, MagneticFlux.units);
    QuantityProperties.equivalence(magneticFlux, magneticFluxUnit);
    QuantityProperties.roundtrip(magneticFlux, roundTrips);

    test('operator +', () {
      final result = 2.0.webers + 1000.0.milliwebers;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(MagneticFlux.webers));
    });

    test('operator -', () {
      final result = 5.0.webers - 1000.0.milliwebers;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(MagneticFlux.webers));
    });
  });
}

final roundTrips = <Function1<MagneticFlux, MagneticFlux>>[
  (m) => MagneticFlux(m.toMicrowebers.to(m.unit), m.unit),
  (m) => MagneticFlux(m.toMilliwebers.to(m.unit), m.unit),
  (m) => MagneticFlux(m.toWebers.to(m.unit), m.unit),
];
