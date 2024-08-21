import 'package:ribs_check/src/sandbox/gen2.dart';
import 'package:ribs_check/src/sandbox/seed.dart';
import 'package:ribs_check/src/sandbox/shrink.dart';
import 'package:ribs_check/src/sandbox/test.dart';
import 'package:test/test.dart';

void main() {
  forAll(
    'ints',
    Gen2.integer(0, 10),
    (i) {
      expect(0 <= i && i <= 10, isTrue);
    },
    shrink: Shrink.integer,
    testParams: TestParameters()
        .withTestCallback(const ConsoleReporter(1, 80))
        .withInitialSeed(Seed.fromBase64(
          '1HgfJH4bI87h-Rwj3pdPoZ1lsP2JON3Ebc2hYvyrRJF=',
        )),
  );
}
