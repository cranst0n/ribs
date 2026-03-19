import 'dart:math' as math;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Angle', () {
    QuantityProperties.parsing(Angle.parse, Angle.units);
    QuantityProperties.equivalence(angle, angleUnit);
    QuantityProperties.roundtrip(angle, roundTrips);

    test('operator +', () {
      final result = 1.0.radians + 180.0.degrees;
      expect(result.value, closeTo(1.0 + math.pi, 1e-9));
      expect(result.unit, equals(Angle.radians));
    });

    test('operator -', () {
      final result = 3.0.radians - 180.0.degrees;
      expect(result.value, closeTo(3.0 - math.pi, 1e-9));
      expect(result.unit, equals(Angle.radians));
    });

    test('sin', () {
      expect(0.0.radians.sin, closeTo(0.0, 1e-9));
      expect(90.0.degrees.sin, closeTo(1.0, 1e-9));
    });

    test('cos', () {
      expect(0.0.radians.cos, closeTo(1.0, 1e-9));
      expect(180.0.degrees.cos, closeTo(-1.0, 1e-9));
    });

    test('tan', () {
      expect(0.0.radians.tan, closeTo(0.0, 1e-9));
      expect(45.0.degrees.tan, closeTo(1.0, 1e-9));
    });

    test('asin', () {
      expect(0.0.radians.asin, closeTo(0.0, 1e-9));
      expect(1.0.radians.asin, closeTo(math.asin(1.0), 1e-9));
    });

    test('acos', () {
      expect(0.0.radians.acos, closeTo(math.pi / 2, 1e-9));
      expect(1.0.radians.acos, closeTo(0.0, 1e-9));
    });
  });
}

final roundTrips = <Function1<Angle, Angle>>[
  (a) => Angle(a.toRadians.to(a.unit), a.unit),
  (a) => Angle(a.toDegrees.to(a.unit), a.unit),
  (a) => Angle(a.toGradians.to(a.unit), a.unit),
  (a) => Angle(a.toTurns.to(a.unit), a.unit),
  (a) => Angle(a.toArcminutes.to(a.unit), a.unit),
  (a) => Angle(a.toArcseconds.to(a.unit), a.unit),
];
