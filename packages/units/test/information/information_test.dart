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

  forAll('equivalentTo',
      (Gen.positiveInt, informationUnit, informationUnit).tupled, (t) {
    t((n, unitA, unitB) {
      expect(unitB(unitA(n).to(unitB)).equivalentTo(unitA(n)), isTrue);
    });
  });

  test('Information.toCoarsest', () {
    expect(1000000000.bytes.toCoarsest(), 1.gigabytes);
    expect(4294967296.kibibytes.toCoarsest(), 4.tebibytes);
    expect(1000000000.bits.toCoarsest(), 1.gigabits);
    expect(4294967296.kibibits.toCoarsest(), 4.tebibits);
  });
}

final Gen<InformationUnit> informationUnit =
    Gen.oneOf(Information.units.toIList());
