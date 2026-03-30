import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';
import 'package:test/test.dart';

void main() {
  group('IO syntax', () {
    test('tupled', () {
      final tuple = (
        IO.pure(1),
        IO.pure(2),
        IO.pure(3),
        IO.pure(4),
        IO.pure(5),
      );

      expect(tuple.tupled, succeeds());
      expect(tuple.parTupled, succeeds());
    });
  });
}
