import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('LuminousFlux', () {
    QuantityProperties.parsing(LuminousFlux.parse, LuminousFlux.units);
    QuantityProperties.equivalence(luminousFlux, luminousFluxUnit);
    QuantityProperties.roundtrip(luminousFlux, roundTrips);

    test('operator +', () {
      final result = 2.0.lumens + 1000.0.millilumens;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(LuminousFlux.lumens));
    });

    test('operator -', () {
      final result = 5.0.lumens - 1000.0.millilumens;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(LuminousFlux.lumens));
    });
  });
}

final roundTrips = <Function1<LuminousFlux, LuminousFlux>>[
  (l) => LuminousFlux(l.toMicrolumens.to(l.unit), l.unit),
  (l) => LuminousFlux(l.toMillilumens.to(l.unit), l.unit),
  (l) => LuminousFlux(l.toLumens.to(l.unit), l.unit),
];
