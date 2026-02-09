import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  group('Pull', () {
    test('unsafe Pull.flatMap', () {
      Pull<String, Unit> go() {
        final pull = Pull.output1(123);
        return pull.flatMap((_) => Pull.output1('123'));
      }

      expect(() => go(), throwsA(isA<TypeError>()));
    });
  });
}
