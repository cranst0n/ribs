import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Luminance', () {
    QuantityProperties.parsing(Luminance.parse, Luminance.units);
    QuantityProperties.equivalence(luminance, luminanceUnit);
    QuantityProperties.roundtrip(luminance, roundTrips);

    test('operator +', () {
      final result = 2.0.nits + 0.0001.stilbs;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(Luminance.nits));
    });

    test('operator -', () {
      final result = 5.0.nits - 0.0001.stilbs;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(Luminance.nits));
    });
  });
}

final roundTrips = <Function1<Luminance, Luminance>>[
  (l) => Luminance(l.toNits.to(l.unit), l.unit),
  (l) => Luminance(l.toStilbs.to(l.unit), l.unit),
  (l) => Luminance(l.toFootlamberts.to(l.unit), l.unit),
  (l) => Luminance(l.toLamberts.to(l.unit), l.unit),
];
