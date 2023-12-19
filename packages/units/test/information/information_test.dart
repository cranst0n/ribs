import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('Information', () {
    QuantityProperties.parsing(Information.parse, Information.units);
    QuantityProperties.equivalence(information, informationUnit);
    QuantityProperties.roundtrip(information, roundTrips);

    test('toCoarsest', () {
      expect(1000000000.bytes.toCoarsest(), 1.gigabytes);
      expect(2147483648.kibibytes.toCoarsest(), 2.tebibytes);
      expect(1000000000.bits.toCoarsest(), 1.gigabits);
      expect(2147483648.kibibits.toCoarsest(), 2.tebibits);
    });
  });
}

final roundTrips = <Function1<Information, Information>>[
  (i) => Information(i.toBytes.to(i.unit), i.unit),
  (i) => Information(i.toOctets.to(i.unit), i.unit),
  (i) => Information(i.toKilobytes.to(i.unit), i.unit),
  (i) => Information(i.toKibibytes.to(i.unit), i.unit),
  (i) => Information(i.toMegabytes.to(i.unit), i.unit),
  (i) => Information(i.toMebibytes.to(i.unit), i.unit),
  (i) => Information(i.toGigabytes.to(i.unit), i.unit),
  (i) => Information(i.toGibibytes.to(i.unit), i.unit),
  (i) => Information(i.toTerabytes.to(i.unit), i.unit),
  (i) => Information(i.toTebibytes.to(i.unit), i.unit),
  (i) => Information(i.toPetabytes.to(i.unit), i.unit),
  (i) => Information(i.toPebibytes.to(i.unit), i.unit),
  (i) => Information(i.toExabytes.to(i.unit), i.unit),
  (i) => Information(i.toExbibytes.to(i.unit), i.unit),
  (i) => Information(i.toZettabytes.to(i.unit), i.unit),
  (i) => Information(i.toZebibytes.to(i.unit), i.unit),
  (i) => Information(i.toYottabytes.to(i.unit), i.unit),
  (i) => Information(i.toYobibytes.to(i.unit), i.unit),
  (i) => Information(i.toBits.to(i.unit), i.unit),
  (i) => Information(i.toKilobits.to(i.unit), i.unit),
  (i) => Information(i.toKibibits.to(i.unit), i.unit),
  (i) => Information(i.toMegabits.to(i.unit), i.unit),
  (i) => Information(i.toMebibits.to(i.unit), i.unit),
  (i) => Information(i.toGigabits.to(i.unit), i.unit),
  (i) => Information(i.toGibibits.to(i.unit), i.unit),
  (i) => Information(i.toTerabits.to(i.unit), i.unit),
  (i) => Information(i.toTebibits.to(i.unit), i.unit),
  (i) => Information(i.toPetabits.to(i.unit), i.unit),
  (i) => Information(i.toPebibits.to(i.unit), i.unit),
  (i) => Information(i.toExabits.to(i.unit), i.unit),
  (i) => Information(i.toExbibits.to(i.unit), i.unit),
  (i) => Information(i.toZettabits.to(i.unit), i.unit),
  (i) => Information(i.toZebibits.to(i.unit), i.unit),
  (i) => Information(i.toYottabits.to(i.unit), i.unit),
  (i) => Information(i.toYobibits.to(i.unit), i.unit),
];
