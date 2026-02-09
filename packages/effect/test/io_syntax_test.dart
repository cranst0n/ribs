import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test_matchers.dart';
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
        IO.pure(6),
        IO.pure(7),
        IO.pure(8),
        IO.pure(9),
        IO.pure(10),
        IO.pure(11),
        IO.pure(12),
        IO.pure(13),
        IO.pure(14),
        IO.pure(15),
        IO.pure(16),
        IO.pure(17),
        IO.pure(18),
        IO.pure(19),
        IO.pure(20),
        IO.pure(21),
        IO.pure(22),
      );

      expect(tuple.tupled, ioSucceeded());
      expect(tuple.parTupled, ioSucceeded());
    });
  });
}
