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
