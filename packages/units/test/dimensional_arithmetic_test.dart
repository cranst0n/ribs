import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

void main() {
  group('Dimensional arithmetic', () {
    test('Length / Time => Velocity', () {
      final v = 10.meters / 2.seconds;
      expect(v.toMetersPerSecond.value, closeTo(5.0, 1e-9));
    });

    test('Velocity / Time => Acceleration', () {
      final a = 10.metersPerSecond / 2.seconds;
      expect(a.toMetersPerSecondSquared.value, closeTo(5.0, 1e-9));
    });

    test('Mass * Acceleration => Force', () {
      final f = 10.kilograms * 2.metersPerSecondSquared;
      expect(f.toNewtons.value, closeTo(20.0, 1e-9));
    });

    test('Force * Length => Energy', () {
      final e = 10.newtons * 2.meters;
      expect(e.toJoules.value, closeTo(20.0, 1e-9));
    });

    test('Force / Area => Pressure', () {
      final p = 10.newtons / 2.squareMeters;
      expect(p.toPascals.value, closeTo(5.0, 1e-9));
    });

    test('Mass / Volume => Density', () {
      final d = 10.kilograms / 2.cubicMeters;
      expect(d.toKilogramsPerCubicMeter.value, closeTo(5.0, 1e-9));
    });

    test('Volume / Time => VolumeFlow', () {
      final vf = 10.cubicMeters / 2.seconds;
      expect(vf.toCubicMetersPerSecond.value, closeTo(5.0, 1e-9));
    });

    test('Angle / Time => AngularVelocity', () {
      final av = 10.radians / 2.seconds;
      expect(av.toRadiansPerSecond.value, closeTo(5.0, 1e-9));
    });

    test('Energy / Time => Power', () {
      final p = 10.joules / 2.seconds;
      expect(p.toWatts.value, closeTo(5.0, 1e-9));
    });

    test('Power * Time => Energy', () {
      final e = 10.watts * 2.seconds;
      expect(e.toJoules.value, closeTo(20.0, 1e-9));
    });

    test('ElectricCurrent * ElectricResistance => ElectricPotential (V = IR)', () {
      final v = 2.amperes * 5.ohms;
      expect(v.toVolts.value, closeTo(10.0, 1e-9));
    });

    test('ElectricPotential / ElectricResistance => ElectricCurrent (I = V/R)', () {
      final i = 10.volts / 2.ohms;
      expect(i.toAmperes.value, closeTo(5.0, 1e-9));
    });

    test('ElectricPotential * ElectricCurrent => Power (P = VI)', () {
      final p = 10.volts * 2.amperes;
      expect(p.toWatts.value, closeTo(20.0, 1e-9));
    });
  });
}
