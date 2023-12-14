import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../gen.dart';
import '../quantity_properties.dart';

void main() {
  group('Frequency', () {
    QuantityProperties.parsing(Frequency.parse, Frequency.units);
    QuantityProperties.equivalence(frequency, frequencyUnit);
    QuantityProperties.roundtrip(frequency, roundTrips);
  });
}

final roundTrips = <Function1<Frequency, Frequency>>[
  (f) => Frequency(f.toHertz.to(f.unit), f.unit),
  (f) => Frequency(f.toKilohertz.to(f.unit), f.unit),
  (f) => Frequency(f.toMegahertz.to(f.unit), f.unit),
  (f) => Frequency(f.toGigahertz.to(f.unit), f.unit),
  (f) => Frequency(f.toTerahertz.to(f.unit), f.unit),
  (f) => Frequency(f.toRevolutionsPerMinute.to(f.unit), f.unit),
];
