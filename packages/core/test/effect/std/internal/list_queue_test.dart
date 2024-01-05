import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/effect/std/internal/list_queue.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('ListQueue', () {
    final q0 = ListQueue.empty<int>();
    final q1 = q0.enqueue(1);
    final q2 = q1.enqueue(2);
    final q3 = q2.enqueue(3);

    test('concat', () {
      expect(q0.concat(q0), q0);
      expect(q0.concat(q1), q1);
      expect(q1.concat(q0), q1);
      expect(q1.concat(q2).toList(), ilist([1, 1, 2]));
    });

    test('dequeueOption', () {
      expect(q0.dequeueOption(), isNone());
      expect(q1.dequeueOption(), isSome((1, q0)));
      expect(q2.dequeueOption(), isSome((1, q0.enqueue(2))));
      expect(q3.dequeueOption(), isSome((1, q0.enqueue(2).enqueue(3))));
    });

    test('enqueueAll', () {
      expect(q0.enqueueAll([]), q0);
      expect(q1.enqueueAll([2, 3]), q3);
    });
  });
}
