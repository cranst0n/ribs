import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

void main() {
  test('Information', () {
    expect(42.bytes.toBits.toBytes, 42.bytes);
    expect(42.bytes.toOctets.toBytes, 42.bytes);
  });

  forAll(Gen.tuple3(Gen.positiveInt, informationUnit, informationUnit))(
    (tuple) => expect(
      tuple((n, unitA, unitB) => unitB(unitA(n).to(unitB)).to(unitA)),
      closeTo(tuple.$1, 1e-6),
    ),
  ).run(description: 'Information.conversion', numTests: 500);

  forAll(Gen.tuple3(
      Gen.positiveInt, Gen.oneOf(ilist(['', ' '])), informationUnit))(
    (tuple) => expect(
      tuple((n, spaces, unit) =>
          Information.parse('$n$spaces${unit.symbol}').isDefined),
      isTrue,
    ),
  ).run(description: 'Information.parse', numTests: 500);

  test('equivalentTo', () {
    expect(1.megabytes.equivalentTo(1000.kilobytes), isTrue);
  });

  test('Information.toCoarsest', () {
    expect(1000000.kilobytes.toCoarsest(), 1.gigabytes);
  });
}

final Gen<InformationUnit> informationUnit =
    Gen.oneOf(Information.units.toIList());
