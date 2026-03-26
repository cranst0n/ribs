import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  MStack<A> stack<A>(Iterable<A> as) => MStack.from(ilist(as));

  test('MStack basic ops', () {
    final s = stack(<int>[]);

    s.push(1);
    expect(s.toList(), [1]);

    s.pushAll(stack([2, 3]));
    expect(s.toList(), [3, 2, 1]);
    expect(s.head, 3);

    s.pop();
    expect(s.toList(), [2, 1]);

    s.popAll();
    expect(s, isEmpty);
  });

  test('reversing returns a Stack', () {
    final s1 = stack([1, 2, 3]);
    final s2 = s1.reverse();

    expect(s2, isA<MStack<int>>());
  });

  test('popWhile preserves interation order', () {
    final s = stack(List.generate(10, (n) => n * 10));
    final l = s.toIList().take(5);

    expect(l, s.popWhile((n) => n < 50));
    expect(s, hasLength(5));
  });
}
