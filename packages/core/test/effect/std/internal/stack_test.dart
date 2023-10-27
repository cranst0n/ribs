import 'package:ribs_core/src/effect/std/internal/stack.dart';
import 'package:test/test.dart';

void main() {
  test('push/pop', () {
    final s = Stack<int>();

    s.push(0);
    s.push(1);

    expect(s.size, 2);
    expect(s.pop(), 1);
    expect(s.pop(), 0);
  });

  test('clear', () {
    final s = Stack<int>();

    s.push(0);
    s.push(1);

    expect(s.size, 2);
    s.clear();

    expect(s.size, 0);
  });
}
