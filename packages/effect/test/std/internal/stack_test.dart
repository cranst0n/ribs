import 'package:ribs_effect/src/std/internal/stack.dart';
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

    s.push(42);
    expect(s.size, 1);
    expect(s.pop(), 42);
    expect(s.size, 0);
  });

  test('peek', () {
    final s = Stack<int>();

    s.push(0);
    s.push(1);

    expect(s.peek, 1);
    expect(s.pop(), 1);
    expect(s.peek, 0);
  });

  test('isEmpty', () {
    final s = Stack<int>();

    expect(s.isEmpty, isTrue);
    expect(s.nonEmpty, isFalse);

    s.push(1);

    expect(s.isEmpty, isFalse);
    expect(s.nonEmpty, isTrue);
  });

  test('grows as necessary', () {
    final s = Stack<int>();

    for (int i = 0; i < 100; i++) {
      s.push(i);
    }

    expect(s.size, 100);
    expect(s.pop(), 99);
    expect(s.pop(), 98);
  });
}
