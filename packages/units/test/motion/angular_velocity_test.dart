import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('AngularVelocity', () {
    QuantityProperties.parsing(AngularVelocity.parse, AngularVelocity.units);
    QuantityProperties.equivalence(angularVelocity, angularVelocityUnit);
    QuantityProperties.roundtrip(angularVelocity, roundTrips);
  });
}

final roundTrips = <Function1<AngularVelocity, AngularVelocity>>[
  (a) => AngularVelocity(a.toRadiansPerSecond.to(a.unit), a.unit),
  (a) => AngularVelocity(a.toDegreesPerSecond.to(a.unit), a.unit),
  (a) => AngularVelocity(a.toRevolutionsPerSecond.to(a.unit), a.unit),
  (a) => AngularVelocity(a.toRevolutionsPerMinute.to(a.unit), a.unit),
  (a) => AngularVelocity(a.toRadiansPerMinute.to(a.unit), a.unit),
  (a) => AngularVelocity(a.toRadiansPerHour.to(a.unit), a.unit),
];
