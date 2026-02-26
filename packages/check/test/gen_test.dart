import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  Gen.integer.tuple2.forAll('tuple2', (t) => expect(t, isNotNull));
  Gen.integer.tuple3.forAll('tuple3', (t) => expect(t, isNotNull));
  Gen.integer.tuple4.forAll('tuple4', (t) => expect(t, isNotNull));
  Gen.integer.tuple5.forAll('tuple5', (t) => expect(t, isNotNull));
  Gen.integer.tuple6.forAll('tuple6', (t) => expect(t, isNotNull));
  Gen.integer.tuple7.forAll('tuple7', (t) => expect(t, isNotNull));
  Gen.integer.tuple8.forAll('tuple8', (t) => expect(t, isNotNull));
  Gen.integer.tuple9.forAll('tuple9', (t) => expect(t, isNotNull));
  Gen.integer.tuple10.forAll('tuple10', (t) => expect(t, isNotNull));
  Gen.integer.tuple11.forAll('tuple11', (t) => expect(t, isNotNull));
  Gen.integer.tuple12.forAll('tuple12', (t) => expect(t, isNotNull));
  Gen.integer.tuple13.forAll('tuple13', (t) => expect(t, isNotNull));
  Gen.integer.tuple14.forAll('tuple14', (t) => expect(t, isNotNull));
  Gen.integer.tuple15.forAll('tuple15', (t) => expect(t, isNotNull));

  Gen.alphaLowerChar.forAll('alphaLowerChar', (c) {
    expect(c.toLowerCase(), c);
    expect(c.toUpperCase(), isNot(c));
    expect(c.length, 1);
  });

  Gen.alphaLowerChar.forAll('alphaLowerChar', (c) {
    expect(c.toLowerCase(), c);
    expect(c.length, 1);
  });

  Gen.alphaLowerString(10).forAll('alphaLowerString', (s) {
    expect(s.toLowerCase(), s);
    expect(s.length <= 10, isTrue);
  });

  Gen.alphaUpperChar.forAll('alphaUpperChar', (c) {
    expect(c.toUpperCase(), c);
    expect(c.toLowerCase(), isNot(c));
    expect(c.length, 1);
  });

  Gen.alphaUpperChar.forAll('alphaUpperChar', (c) {
    expect(c.toUpperCase(), c);
    expect(c.length, 1);
  });

  Gen.alphaUpperString(10).forAll('alphaUpperString', (s) {
    expect(s.toUpperCase(), s);
    expect(s.length <= 10, isTrue);
  });

  Gen.atLeastOne([1, 2, 3]).forAll('atLeastOne', (l) {
    expect(l, isNotEmpty);
  });

  Gen.dateTime.forAll('dateTime', (x) {
    expect(x.year, isPositive);
    expect(x.month, isPositive);
  });

  Gen.duration.forAll('duration', (x) {
    expect(x.inDays, anyOf(isNegative, 0, isPositive));
  });

  Gen.either(Gen.dateTime, Gen.positiveInt).forAll('either', (e) {
    e.fold(
      (dateTime) => expect(dateTime.year, isPositive),
      (i) => expect(i, isPositive),
    );
  });

  Gen.hexString(8).map((a) => a.padLeft(1, '0')).forAll('hexString', (str) {
    expect(int.tryParse(str, radix: 16), isNotNull);
  });

  Gen.imapOf(Gen.chooseInt(1, 20), Gen.nonEmptyHexString(), Gen.positiveInt).forAll(
    'imapOf',
    (m) => expect(m.isEmpty, isFalse),
  );

  Gen.mapOf(Gen.chooseInt(1, 20), Gen.nonEmptyHexString(), Gen.positiveInt).forAll(
    'mapOf',
    (m) => expect(m.isEmpty, isFalse),
  );

  Gen.nonEmptyHexString(8).forAll('nonEmptyHexString', (str) {
    expect(int.tryParse(str, radix: 16), isNotNull);
  });

  Gen.nonNegativeInt.forAll('nonNegativeInt', (i) {
    expect(i >= 0, isTrue);
  });

  Gen.oneOf([1, 2, 3]).forAll('oneOf', (x) {
    expect(x, anyOf(1, 2, 3));
  });

  Gen.oneOfGen([Gen.constant('a'), Gen.constant('b')]).forAll('oneOfGen', (ab) {
    expect(ab, anyOf('a', 'b'));
  });

  Gen.option(Gen.positiveInt).forAll('option', (i) {
    expect(i.filter((a) => a > 0), i);
  });

  Gen.positiveInt.forAll('positiveInt', (i) {
    expect(i, isPositive);
  });

  Gen.some(Gen.positiveInt).forAll('some', (i) {
    expect(i, isSome<int>());
  });

  Gen.chooseInt(0, 0).forAll('Choose.integer(0, 0)', (i) {
    expect(i, 0);
  });
}
