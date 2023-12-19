import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('DataRate', () {
    QuantityProperties.parsing(DataRate.parse, DataRate.units);
    QuantityProperties.equivalence(dataRate, dataRateUnit);
    QuantityProperties.roundtrip(dataRate, roundTrips);
  });
}

final roundTrips = <Function1<DataRate, DataRate>>[
  (r) => DataRate(r.toBytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toKilobytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toKibibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toMegabytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toMebibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toGigabytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toGibibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toTerabytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toTebibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toPetabytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toPebibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toExabytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toExbibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toZettabytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toZebibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toYottabytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toYobibytesPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toBitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toKilobitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toKibibitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toMegabitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toMebibitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toGigabitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toGibibitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toTerabitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toTebibitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toPetabitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toPebibitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toExabitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toExbibitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toZettabitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toZebibitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toYottabitsPerSecond.to(r.unit), r.unit),
  (r) => DataRate(r.toYobibitsPerSecond.to(r.unit), r.unit),
];
