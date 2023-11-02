import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

void main() {
  test('Information', () {
    expect(42.bytes.toBits.toBytes, 42.bytes);
    expect(42.bytes.toOctets.toBytes, 42.bytes);
  });

  forAll(
    'Information.conversion',
    (Gen.positiveInt, informationUnit, informationUnit).tupled,
    (tuple) => expect(
      tuple((n, unitA, unitB) => unitB(unitA(n).to(unitB)).to(unitA)),
      closeTo(tuple.$1, 1e-6),
    ),
  );

  forAll(
    'Information.parse',
    (Gen.positiveInt, Gen.oneOf(ilist(['', ' '])), informationUnit).tupled,
    (tuple) => expect(
      tuple((n, spaces, unit) =>
          Information.parse('$n$spaces${unit.symbol}').isDefined),
      isTrue,
    ),
  );

  test('equivalentTo', () {
    expect(1.megabytes.equivalentTo(1000.kilobytes), isTrue);
  });

  test('Information.toCoarsest', () {
    expect(1000000.kilobytes.toCoarsest(), 1.gigabytes);
  });
}

final Gen<InformationUnit> informationUnit =
    Gen.oneOf(Information.units.toIList());
