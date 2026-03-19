import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('SolidAngle', () {
    QuantityProperties.parsing(SolidAngle.parse, SolidAngle.units);
    QuantityProperties.equivalence(solidAngle, solidAngleUnit);
    QuantityProperties.roundtrip(solidAngle, roundTrips);

    test('operator +', () {
      final result = 2.0.steradians + 1000.0.millisteradians;
      expect(result.value, closeTo(3.0, 1e-9));
      expect(result.unit, equals(SolidAngle.steradians));
    });

    test('operator -', () {
      final result = 5.0.steradians - 1000.0.millisteradians;
      expect(result.value, closeTo(4.0, 1e-9));
      expect(result.unit, equals(SolidAngle.steradians));
    });
  });
}

final roundTrips = <Function1<SolidAngle, SolidAngle>>[
  (s) => SolidAngle(s.toMillisteradians.to(s.unit), s.unit),
  (s) => SolidAngle(s.toSteradians.to(s.unit), s.unit),
  (s) => SolidAngle(s.toSquareDegrees.to(s.unit), s.unit),
];
