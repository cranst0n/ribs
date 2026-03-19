import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

import '../arbitraries.dart';
import '../quantity_properties.dart';

void main() {
  group('VolumeFlow', () {
    QuantityProperties.parsing(VolumeFlow.parse, VolumeFlow.units);
    QuantityProperties.equivalence(volumeFlow, volumeFlowUnit);
    QuantityProperties.roundtrip(volumeFlow, roundTrips);
  });
}

final roundTrips = <Function1<VolumeFlow, VolumeFlow>>[
  (v) => VolumeFlow(v.toCubicMetersPerSecond.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toCubicFeetPerSecond.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toCubicFeetPerMinute.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toGallonsPerMinute.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toLitersPerSecond.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toLitersPerMinute.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toLitersPerHour.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toNanolitersPerSecond.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toMicrolitersPerSecond.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toMillilitersPerSecond.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toMillilitersPerMinute.to(v.unit), v.unit),
  (v) => VolumeFlow(v.toMillilitersPerHour.to(v.unit), v.unit),
];
