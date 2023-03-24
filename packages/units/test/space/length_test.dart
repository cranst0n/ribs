import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

void main() {
  test('Length.inches', () {
    expect(1.0.inches.toInches, 1.0.inches);
    expect(1.0.inches.toFeet.value, closeTo(1.0 / 12.0, 1e-5));
    expect(1.0.inches.toCentimeters.value, closeTo(2.54, 1e-5));
  });

  test('length.parse', () {
    expect(Length.parse('1m'), 1.meters.some);
    expect(Length.parse('1.2m'), 1.2.meters.some);
    expect(Length.parse('1 m'), 1.meters.some);
    expect(Length.parse('1e-3 cm'), 1e-3.centimeters.some);
  });

  test('equivalentTo', () {
    expect(12.inches.equivalentTo(1.feet), isTrue);
    expect(12.01.inches.equivalentTo(1.feet), isFalse);
  });

  test('Information.toCoarsest', () {
    expect(1000000.kilobytes.toCoarsest(), 1.gigabytes);
  });
}
