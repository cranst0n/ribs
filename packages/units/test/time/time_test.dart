import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../gen.dart';
import '../quantity_properties.dart';

void main() {
  group('Time', () {
    QuantityProperties.parsing(Time.parse, Time.units);
    QuantityProperties.equivalence(time, timeUnit);
    QuantityProperties.roundtrip(time, roundTrips);
  });
}

final roundTrips = <Function1<Time, Time>>[
  (t) => Time(t.toNanoseconds.to(t.unit), t.unit),
  (t) => Time(t.toMicroseconds.to(t.unit), t.unit),
  (t) => Time(t.toMilliseconds.to(t.unit), t.unit),
  (t) => Time(t.toSeconds.to(t.unit), t.unit),
  (t) => Time(t.toMinutes.to(t.unit), t.unit),
  (t) => Time(t.toHours.to(t.unit), t.unit),
  (t) => Time(t.toDays.to(t.unit), t.unit),
];
