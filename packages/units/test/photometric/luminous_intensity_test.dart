import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('LuminousIntensity', () {
    QuantityProperties.parsing(LuminousIntensity.parse, LuminousIntensity.units);
    QuantityProperties.equivalence(luminousIntensity, luminousIntensityUnit);
    QuantityProperties.roundtrip(luminousIntensity, roundTrips);

    test('operator +', () {
      final result = 2.0.candelas + 1000.0.millicandelas;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(LuminousIntensity.candelas));
    });

    test('operator -', () {
      final result = 5.0.candelas - 1000.0.millicandelas;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(LuminousIntensity.candelas));
    });
  });
}

final roundTrips = <Function1<LuminousIntensity, LuminousIntensity>>[
  (l) => LuminousIntensity(l.toMicrocandelas.to(l.unit), l.unit),
  (l) => LuminousIntensity(l.toMillicandelas.to(l.unit), l.unit),
  (l) => LuminousIntensity(l.toCandelas.to(l.unit), l.unit),
];
