import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('IQueue', () {
    test('equality', () {
      expect(iqueue([]), iqueue([]));
      expect(iqueue([1, 2, 3]), iqueue([1, 2, 3]));
      expect(iqueue([10, 20, 30]), iqueue([30, 20, 10]).reverse());
    });

    test('basic', () {
      final q0 = iqueue([0, 1, 2, 3]);
      final (a, q1) = q0.dequeue();
      final (b, q2) = q1.dequeue();
      final (c, q3) = q2.dequeue();
      final (d, q4) = q3.dequeue();

      expect((a, b, c, d), (0, 1, 2, 3));

      expect(q1[2], 3);

      expect(q0.front, 0);
      expect(q1.front, 1);
      expect(q2.front, 2);
      expect(q3.front, 3);
      expect(() => q4.front, throwsRangeError);

      expect(q0.last, 3);
      expect(q1.last, 3);
      expect(q2.last, 3);
      expect(q3.last, 3);
      expect(() => q4.last, throwsRangeError);

      expect(q0.reverse().toIList(), ilist([3, 2, 1, 0]));

      expect(q4.dequeueOption(), isNone());
      expect(q4.enqueue(42).dequeue(), (42, IQueue.empty<int>()));

      expect(
        q0.enqueueAll(ilist([4, 5, 6, 7])).toIList(),
        ilist([0, 1, 2, 3, 4, 5, 6, 7]),
      );

      expect(q0.prepended(42).dequeue(), (42, q0));
    });
  });
}
