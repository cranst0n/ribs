import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:test/test.dart';

enum _Color { red, green, blue }

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
    expect(i, isSome());
  });

  Gen.chooseInt(0, 0).forAll('Choose.integer(0, 0)', (i) {
    expect(i, 0);
  });

  Gen.alphaNumChar.forAll('alphaNumChar', (c) {
    expect(c.length, 1);
    expect(RegExp(r'^[a-zA-Z0-9]$').hasMatch(c), isTrue);
  });

  Gen.alphaNumString(10).forAll('alphaNumString', (s) {
    expect(s.length <= 10, isTrue);
    expect(RegExp(r'^[a-zA-Z0-9]*$').hasMatch(s), isTrue);
  });

  Gen.asciiChar.forAll('asciiChar', (c) {
    expect(c.length, 1);
    expect(c.codeUnitAt(0) >= 0 && c.codeUnitAt(0) <= 127, isTrue);
  });

  Gen.bigInt.forAll('bigInt', (n) {
    expect(n, isNotNull);
    expect(n >= BigInt.zero, isTrue);
  });

  Gen.binChar.forAll('binChar', (c) {
    expect(c, anyOf('0', '1'));
  });

  Gen.boolean.forAll('boolean', (b) {
    expect(b, anyOf(isTrue, isFalse));
  });

  Gen.byte.forAll('byte', (b) {
    expect(b >= 0 && b <= 255, isTrue);
  });

  Gen.chooseDouble(0.0, 1.0).forAll('chooseDouble', (d) {
    expect(d >= 0.0 && d <= 1.0, isTrue);
  });

  Gen.chooseDouble(-10.0, 10.0).forAll('chooseDouble negative range', (d) {
    expect(d >= -10.0 && d <= 10.0, isTrue);
  });

  Gen.chooseEnum(_Color.values).forAll('chooseEnum', (c) {
    expect(_Color.values.contains(c), isTrue);
  });

  Gen.constant(42).forAll('constant', (i) {
    expect(i, 42);
  });

  Gen.constant('hello').forAll('constant string', (s) {
    expect(s, 'hello');
  });

  Gen.date.forAll('date', (d) {
    expect(d, isNotNull);
    expect(d, isA<DateTime>());
  });

  Gen.hexChar.forAll('hexChar', (c) {
    expect(c.length, 1);
    expect(int.tryParse(c, radix: 16), isNotNull);
  });

  Gen.ilistOf(Gen.chooseInt(0, 10), Gen.positiveInt).forAll('ilistOf', (l) {
    expect(l.size <= 10, isTrue);
    l.foreach((a) => expect(a, isPositive));
  });

  Gen.ilistOfN(5, Gen.integer).forAll('ilistOfN', (l) {
    expect(l.size, 5);
  });

  Gen.integer.forAll('integer', (i) {
    expect(i >= -2147483648 && i <= 2147483647, isTrue);
  });

  Gen.listOf(Gen.chooseInt(0, 5), Gen.boolean).forAll('listOf', (l) {
    expect(l.length <= 5, isTrue);
  });

  Gen.listOfN(3, Gen.byte).forAll('listOfN', (l) {
    expect(l.length, 3);
    for (final b in l) {
      expect(b >= 0 && b <= 255, isTrue);
    }
  });

  Gen.nonEmptyAlphaNumString(10).forAll('nonEmptyAlphaNumString', (s) {
    expect(s.isNotEmpty, isTrue);
    expect(s.length <= 10, isTrue);
    expect(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(s), isTrue);
  });

  Gen.nonEmptyIList(Gen.positiveInt, 5).forAll('nonEmptyIList', (l) {
    expect(l.size >= 1 && l.size <= 5, isTrue);
    l.toIList().foreach((a) => expect(a, isPositive));
  });

  Gen.numChar.forAll('numChar', (c) {
    expect(c.length, 1);
    expect(int.tryParse(c), isNotNull);
  });

  Gen.sequence(ilist([Gen.constant(1), Gen.constant(2), Gen.constant(3)])).forAll('sequence', (l) {
    expect(l.toList(), [1, 2, 3]);
  });

  Gen.positiveInt.retryUntil((i) => i > 100).forAll('retryUntil', (i) {
    expect(i > 100, isTrue);
  });

  Gen.integer.tuple16.forAll('tuple16', (t) => expect(t, isNotNull));
}
