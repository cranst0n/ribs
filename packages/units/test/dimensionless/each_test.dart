import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Each', () {
    QuantityProperties.parsing(Each.parse, Each.units);
    QuantityProperties.equivalence(each, eachUnit);
    QuantityProperties.roundtrip(each, roundTrips);
  });
}

final roundTrips = <Function1<Each, Each>>[
  (e) => Each(e.toEach.to(e.unit), e.unit),
  (e) => Each(e.toDozen.to(e.unit), e.unit),
  (e) => Each(e.toScore.to(e.unit), e.unit),
  (e) => Each(e.toGross.to(e.unit), e.unit),
  (e) => Each(e.toGreatGross.to(e.unit), e.unit),
];
