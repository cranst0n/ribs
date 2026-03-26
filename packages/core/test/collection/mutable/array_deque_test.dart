import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  ArrayDeque<A> arrayDeque<A>(Iterable<A> as) => ArrayDeque<A>().addAll(ilist(as));

  test('ArrayDeque', () {
    final buffer = ArrayDeque<int>();
    final buffer2 = ListBuffer<int>();

    void run<U>(Function1<Buffer<int>, U> f) {
      expect(f(buffer), f(buffer2));
      expect(buffer, buffer2);
      expect(buffer.reverse(), buffer2.reverse());
    }

    run((b) => b.addAll(ilist([1, 2, 3, 4, 5])));
    run((b) => b.prepend(6).prepend(7).prepend(8));
    run((b) => b.dropInPlace(2));
    run((b) => b.dropRightInPlace(2));
    run((b) => b.insert(2, -3));
    run((b) => b.insertAll(0, ilist([9, 10, 11])));
    run((b) => b.insertAll(1, ilist([12, 13])));
    run((b) => b.insertAll(0, ilist([23, 24])));
    run((b) => b.appendAll(ilist([25, 26])));
    run((b) => b.remove(2));
    run((b) => b.prependAll(Range.inclusive(14, 17)));
    run((b) => b.removeN(1, 5));
    run((b) => b.prependAll(IList.tabulate(100, identity)));
    run((b) => b.insertAll(b.length - 5, IList.tabulate(10, identity)));

    buffer.trimToSize();

    run((b) => b.addAll(IVector.tabulate(100, identity)));
    run((b) => b.addAll(RIterator.tabulate(100, identity)));

    Range.inclusive(0, 100).foreach((n) {
      expect(buffer.splitAt(n), buffer2.splitAt(n));
    });
  });

  test('copyToArrayOutOfBounds', () {
    final target = arr<int>([]);
    expect(
      arrayDeque([1, 2]).copyToArray(target, 1, 0),
      0,
    );
  });

  test('insert when resize is needed', () {
    final deque = arrayDeque(List.generate(15, identity));
    deque.insert(1, -1);

    expect(
      arrayDeque([0, -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]),
      deque,
    );
  });

  test('insert all', () {
    var a = arrayDeque([0, 1]);
    a.insertAll(1, ilist([2]));
    expect(arrayDeque([0, 2, 1]), a);

    a = arrayDeque([0, 1]);
    a.insertAll(2, ilist([2]));
    expect(arrayDeque([0, 1, 2]), a);
  });
}
