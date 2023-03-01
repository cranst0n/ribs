import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

void main() {
  test('Deca <-> Deci', () {
    expect(MetricSystem.Deca * MetricSystem.Deci, 1);
  });

  test('Hecto <-> Centi', () {
    expect(MetricSystem.Hecto * MetricSystem.Centi, 1);
  });

  test('Kilo <-> Milli', () {
    expect(MetricSystem.Kilo * MetricSystem.Milli, 1);
  });

  test('Mega <-> Micro', () {
    expect(MetricSystem.Mega * MetricSystem.Micro, 1);
  });

  test('Giga <-> Nano', () {
    expect(MetricSystem.Giga * MetricSystem.Nano, 1);
  });

  test('Tera <-> Pico', () {
    expect(MetricSystem.Tera * MetricSystem.Pico, 1);
  });

  test('Peta <-> Femto', () {
    expect(MetricSystem.Peta * MetricSystem.Femto, 1);
  });

  test('Exa <-> Atto', () {
    expect(MetricSystem.Exa * MetricSystem.Atto, 1);
  });

  test('Zetta <-> Zepto', () {
    expect(MetricSystem.Zetta * MetricSystem.Zepto, closeTo(1, 1e-9));
  });

  test('Yotta <-> Yocto', () {
    expect(MetricSystem.Yotta * MetricSystem.Yocto, closeTo(1, 1e-9));
  });
}
