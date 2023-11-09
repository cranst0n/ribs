import 'package:ribs_check/src/gen.dart';
import 'package:ribs_check/src/prop.dart';
import 'package:test/expect.dart';

void main() {
  forAll('tuple2', Gen.integer.tuple2, (t) => expect(t, isNotNull));
  forAll('tuple3', Gen.integer.tuple3, (t) => expect(t, isNotNull));
  forAll('tuple4', Gen.integer.tuple4, (t) => expect(t, isNotNull));
  forAll('tuple5', Gen.integer.tuple5, (t) => expect(t, isNotNull));
  forAll('tuple6', Gen.integer.tuple6, (t) => expect(t, isNotNull));
  forAll('tuple7', Gen.integer.tuple7, (t) => expect(t, isNotNull));
  forAll('tuple8', Gen.integer.tuple8, (t) => expect(t, isNotNull));
  forAll('tuple9', Gen.integer.tuple9, (t) => expect(t, isNotNull));
  forAll('tuple10', Gen.integer.tuple10, (t) => expect(t, isNotNull));
  forAll('tuple11', Gen.integer.tuple11, (t) => expect(t, isNotNull));
  forAll('tuple12', Gen.integer.tuple12, (t) => expect(t, isNotNull));
  forAll('tuple13', Gen.integer.tuple13, (t) => expect(t, isNotNull));
  forAll('tuple14', Gen.integer.tuple14, (t) => expect(t, isNotNull));
  forAll('tuple15', Gen.integer.tuple15, (t) => expect(t, isNotNull));

  forAll('alphaLowerChar', Gen.alphaLowerChar, (c) {
    expect(c.toLowerCase(), c);
    expect(c.length, 1);
  });

  forAll('alphaLowerString', Gen.alphaLowerString(10), (s) {
    expect(s.toLowerCase(), s);
    expect(s.length <= 10, isTrue);
  });

  forAll('atLeastOne', Gen.atLeastOne([1, 2, 3]), (l) {
    expect(l, isNotEmpty);
  });

  forAll('dateTime', Gen.dateTime, (x) {
    expect(x.year, isPositive);
    expect(x.month, isPositive);
  });

  forAll('duration', Gen.duration, (x) {
    expect(x.inDays, anyOf(isNegative, 0, isPositive));
  });

  forAll('hexString', Gen.nonEmptyHexString(8), (str) {
    expect(int.tryParse(str, radix: 16), isNotNull);
  });
}
