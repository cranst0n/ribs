import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  MQueue<A> stack<A>(Iterable<A> as) => MQueue.from(ilist(as));

  test('MStack basic ops', () {
    final s = stack(<int>[]);

    s.enqueue(1);
    expect(s.toList(), [1]);

    s.enqueueAll(stack([2, 3]));
    expect(s.toList(), [1, 2, 3]);
    expect(s.head, 1);

    s.dequeue();
    expect(s.toList(), [2, 3]);

    s.dequeueAll((_) => true);
    expect(s, isEmpty);
  });
}
