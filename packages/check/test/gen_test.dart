import 'package:ribs_check/src/gen.dart';
import 'package:ribs_check/src/prop.dart';
import 'package:test/expect.dart';

void main() {
  forAll('forAll', Gen.dateTime, (x) {
    expect(x.year, isPositive);
  });
}
