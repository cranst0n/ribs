import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
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

  group('ArrayDeque.from', () {
    test('returns same instance when input is already ArrayDeque', () {
      final d = arrayDeque([1, 2, 3]);
      expect(ArrayDeque.from(d), same(d));
    });

    test('builds from unknown-knownSize iterator', () {
      // RIterator.fromDart has knownSize = -1, triggering the addAll fallback
      final iter = RIterator.fromDart([1, 2, 3].iterator);
      final d = ArrayDeque.from(iter);
      expect(d.toList(), [1, 2, 3]);
    });
  });

  group('clear', () {
    test('clear empties the deque', () {
      final d = arrayDeque([1, 2, 3]);
      d.clear();
      expect(d.isEmpty, isTrue);
      expect(d.length, 0);
    });
  });

  group('delegate methods returning ArrayDeque', () {
    late ArrayDeque<int> d;

    setUp(() {
      d = arrayDeque([1, 2, 3, 4, 5]);
    });

    test('append adds element to end', () {
      expect(d.append(6).toList().last, 6);
    });

    test('appended adds element to end', () {
      expect(d.appended(9).toList().last, 9);
    });

    test('appendedAll appends suffix', () {
      expect(d.appendedAll(ilist([6, 7])).toList(), [1, 2, 3, 4, 5, 6, 7]);
    });

    test('appendAll appends suffix (Buffer method)', () {
      expect(d.appendAll(ilist([6, 7])).toList(), [1, 2, 3, 4, 5, 6, 7]);
    });

    test('collect filters and maps', () {
      final result = d.collect((x) => x.isOdd ? Some(x * 10) : const None());
      expect(result.toList(), [10, 30, 50]);
    });

    test('concat joins two deques', () {
      expect(d.concat(ilist([6, 7])).toList(), [1, 2, 3, 4, 5, 6, 7]);
    });

    test('diff removes matching elements', () {
      expect(d.diff(ilist([2, 4])).toList(), [1, 3, 5]);
    });

    test('distinct removes duplicates', () {
      expect(arrayDeque([1, 2, 1, 3]).distinct().toList(), [1, 2, 3]);
    });

    test('distinctBy deduplicates by key', () {
      expect(arrayDeque([1, 2, 3, 4]).distinctBy((x) => x % 2).toList(), [1, 2]);
    });

    test('dropRight drops from end', () {
      expect(d.dropRight(2).toList(), [1, 2, 3]);
    });

    test('dropWhile drops leading matching elements', () {
      expect(d.dropWhile((x) => x < 3).toList(), [3, 4, 5]);
    });

    test('dropWhileInPlace drops leading matching in place', () {
      expect(arrayDeque([1, 2, 3, 4]).dropWhileInPlace((x) => x < 3).toList(), [3, 4]);
    });

    test('filter keeps matching elements', () {
      expect(d.filter((x) => x.isOdd).toList(), [1, 3, 5]);
    });

    test('filterNot removes matching elements', () {
      expect(d.filterNot((x) => x.isEven).toList(), [1, 3, 5]);
    });

    test('flatMap maps and flattens', () {
      expect(d.flatMap((x) => ilist([x, x * 10])).toList(), [1, 10, 2, 20, 3, 30, 4, 40, 5, 50]);
    });

    test('groupBy groups by key', () {
      final groups = d.groupBy((x) => x.isEven ? 'even' : 'odd');
      expect(groups.get('odd').getOrElse(() => ArrayDeque()).toList()..sort(), [1, 3, 5]);
      expect(groups.get('even').getOrElse(() => ArrayDeque()).toList()..sort(), [2, 4]);
    });

    test('grouped produces fixed-size chunks', () {
      final chunks = d.grouped(2).toList();
      expect(chunks[0].toList(), [1, 2]);
      expect(chunks[1].toList(), [3, 4]);
      expect(chunks[2].toList(), [5]);
    });

    test('groupMap groups and transforms', () {
      final g = d.groupMap((x) => x % 2, (x) => x * 10);
      expect(g.get(1).getOrElse(() => ArrayDeque()).toList()..sort(), [10, 30, 50]);
    });

    test('init drops last element', () {
      expect(d.init.toList(), [1, 2, 3, 4]);
    });

    test('inits produces all prefixes', () {
      final inits = d.inits.toList();
      expect(inits.first.toList(), [1, 2, 3, 4, 5]);
      expect(inits.last.toList(), isEmpty);
    });

    test('intersect keeps common elements', () {
      expect(d.intersect(ilist([2, 4, 6])).toList(), [2, 4]);
    });

    test('intersperse inserts separator', () {
      expect(arrayDeque([1, 2, 3]).intersperse(0).toList(), [1, 0, 2, 0, 3]);
    });

    test('padTo pads with element', () {
      expect(d.padTo(7, 0).toList(), [1, 2, 3, 4, 5, 0, 0]);
    });

    test('padToInPlace pads in place', () {
      expect(arrayDeque([1, 2]).padToInPlace(4, 0).toList(), [1, 2, 0, 0]);
    });

    test('partition splits by predicate', () {
      final (evens, odds) = d.partition((x) => x.isEven);
      expect(evens.toList(), [2, 4]);
      expect(odds.toList(), [1, 3, 5]);
    });

    test('partitionMap splits by Either', () {
      final (lefts, rights) = d.partitionMap(
        (x) => x.isEven ? Either.left<int, int>(x) : Either.right<int, int>(x),
      );
      expect(lefts.toList(), [2, 4]);
      expect(rights.toList(), [1, 3, 5]);
    });

    test('patch replaces a slice', () {
      expect(d.patch(1, ilist([20, 30]), 2).toList(), [1, 20, 30, 4, 5]);
    });

    test('scan produces running totals', () {
      expect(arrayDeque([1, 2, 3]).scan(0, (acc, x) => acc + x).toList(), [0, 1, 3, 6]);
    });

    test('scanLeft produces running totals', () {
      expect(arrayDeque([1, 2, 3]).scanLeft(0, (acc, x) => acc + x).toList(), [0, 1, 3, 6]);
    });

    test('scanRight produces running totals from right', () {
      expect(
        arrayDeque([1, 2, 3]).scanRight(0, (x, acc) => x + acc).toList(),
        [6, 5, 3, 0],
      );
    });

    test('slice extracts subrange', () {
      expect(d.slice(1, 4).toList(), [2, 3, 4]);
    });

    test('sliceInPlace keeps subrange', () {
      expect(arrayDeque([1, 2, 3, 4, 5]).sliceInPlace(1, 4).toList(), [2, 3, 4]);
    });

    test('sliding produces overlapping windows', () {
      final windows = arrayDeque([1, 2, 3, 4]).sliding(2).toList();
      expect(windows[0].toList(), [1, 2]);
      expect(windows[1].toList(), [2, 3]);
      expect(windows[2].toList(), [3, 4]);
    });

    test('sortBy sorts by key', () {
      expect(
        arrayDeque([3, 1, 2]).sortBy(Order.ints, identity).toList(),
        [1, 2, 3],
      );
    });

    test('sorted sorts by Order', () {
      expect(arrayDeque([3, 1, 2]).sorted(Order.ints).toList(), [1, 2, 3]);
    });

    test('sortWith sorts by comparator', () {
      expect(arrayDeque([3, 1, 2]).sortWith((a, b) => a < b).toList(), [1, 2, 3]);
    });

    test('span splits at first non-matching', () {
      final (prefix, suffix) = d.span((x) => x < 4);
      expect(prefix.toList(), [1, 2, 3]);
      expect(suffix.toList(), [4, 5]);
    });

    test('subtractOne removes first occurrence', () {
      expect(arrayDeque([1, 2, 3, 2]).subtractOne(2).toList(), [1, 3, 2]);
    });

    test('tail drops first element', () {
      expect(d.tail.toList(), [2, 3, 4, 5]);
    });

    test('tails produces all suffixes', () {
      final tails = d.tails.toList();
      expect(tails.first.toList(), [1, 2, 3, 4, 5]);
      expect(tails.last.toList(), isEmpty);
    });

    test('take keeps first n elements', () {
      expect(d.take(3).toList(), [1, 2, 3]);
    });

    test('takeInPlace keeps first n elements', () {
      expect(arrayDeque([1, 2, 3, 4]).takeInPlace(2).toList(), [1, 2]);
    });

    test('takeRight keeps last n elements', () {
      expect(d.takeRight(2).toList(), [4, 5]);
    });

    test('takeRightInPlace keeps last n elements in place', () {
      expect(arrayDeque([1, 2, 3, 4]).takeRightInPlace(2).toList(), [3, 4]);
    });

    test('takeWhile keeps leading matching elements', () {
      expect(d.takeWhile((x) => x < 4).toList(), [1, 2, 3]);
    });

    test('takeWhileInPlace keeps leading matching elements in place', () {
      expect(arrayDeque([1, 2, 3, 4]).takeWhileInPlace((x) => x < 3).toList(), [1, 2]);
    });

    test('tapEach applies side effect', () {
      final seen = <int>[];
      final result = d.tapEach(seen.add);
      expect(seen, [1, 2, 3, 4, 5]);
      expect(result.toList(), [1, 2, 3, 4, 5]);
    });

    test('traverseEither returns Right when all succeed', () {
      final result = d.traverseEither<String, int>((x) => Either.right(x * 2));
      expect(result.getOrElse(() => ArrayDeque()).toList(), [2, 4, 6, 8, 10]);
    });

    test('traverseEither returns Left on first failure', () {
      final result = d.traverseEither<String, int>(
        (x) => x == 3 ? Either.left('fail') : Either.right(x),
      );
      expect(result.isLeft, isTrue);
    });

    test('traverseOption returns Some when all succeed', () {
      final result = d.traverseOption<int>((x) => Some(x * 2));
      expect(result.getOrElse(() => ArrayDeque()).toList(), [2, 4, 6, 8, 10]);
    });

    test('traverseOption returns None on first failure', () {
      final result = d.traverseOption<int>((x) => x == 3 ? const None() : Some(x));
      expect(result, isNone());
    });

    test('trimToSize reduces backing array to length', () {
      final d2 = arrayDeque([1, 2, 3]);
      d2.trimToSize();
      expect(d2.toList(), [1, 2, 3]);
    });

    test('update changes element at index', () {
      final d2 = arrayDeque([1, 2, 3]);
      d2.update(1, 99);
      expect(d2.toList(), [1, 99, 3]);
    });

    test('updated returns new deque with changed element', () {
      expect(d.updated(2, 99).toList(), [1, 2, 99, 4, 5]);
    });

    test('zip pairs elements with another collection', () {
      expect(d.zip(ilist(['a', 'b', 'c'])).toList(), [(1, 'a'), (2, 'b'), (3, 'c')]);
    });

    test('zipAll pads shorter side', () {
      expect(
        arrayDeque([1, 2]).zipAll(ilist([10, 20, 30]), 0, 99).toList(),
        [(1, 10), (2, 20), (0, 30)],
      );
    });

    test('zipWithIndex pairs elements with their indices', () {
      expect(d.zipWithIndex().toList(), [(1, 0), (2, 1), (3, 2), (4, 3), (5, 4)]);
    });
  });

  group('insert edge cases', () {
    test('insert at index 0 prepends', () {
      final d = arrayDeque([1, 2, 3]);
      d.insert(0, 0);
      expect(d.toList(), [0, 1, 2, 3]);
    });

    test('insert at last index appends', () {
      final d = arrayDeque([1, 2, 3]);
      d.insert(3, 4);
      expect(d.toList(), [1, 2, 3, 4]);
    });

    test('insert out of bounds throws', () {
      final d = arrayDeque([1, 2, 3]);
      expect(() => d.insert(5, 0), throwsA(isA<IndexError>()));
    });
  });

  group('insertAll edge cases', () {
    test('insertAll with unknown-knownSize input (knownSize < 0)', () {
      // RIterator.fromDart has knownSize = -1, triggering the indexed fallback
      final d = arrayDeque([1, 2, 3]);
      d.insertAll(1, RIterator.fromDart([10, 20].iterator));
      expect(d.toList(), [1, 10, 20, 2, 3]);
    });

    test('insertAll triggers resize when needed', () {
      // Fill to near-capacity then insertAll in the middle to force resize
      final d = ArrayDeque<int>().addAll(IList.tabulate(14, identity));
      d.insertAll(7, IList.tabulate(10, (i) => 100 + i));
      expect(d.length, 24);
      expect(d[0], 0);
      expect(d[7], 100);
      expect(d[17], 13 - (14 - 7 - 1)); // last of original suffix after shift
    });
  });

  group('patchInPlace', () {
    test('replaces elements and inserts extra', () {
      final d = arrayDeque([1, 2, 3, 4, 5]);
      d.patchInPlace(1, ilist([20, 30, 40]), 1);
      expect(d.toList(), [1, 20, 30, 40, 3, 4, 5]);
    });

    test('removes extra elements when patch is shorter', () {
      final d = arrayDeque([1, 2, 3, 4, 5]);
      d.patchInPlace(1, ilist([20]), 3);
      expect(d.toList(), [1, 20, 5]);
    });
  });

  group('removeN', () {
    test('removeN negative count throws', () {
      final d = arrayDeque([1, 2, 3]);
      expect(() => d.removeN(0, -1), throwsArgumentError);
    });

    test('removeN triggers shrink on large deque', () {
      // Build a large deque then remove most elements so shouldShrink fires
      final d = ArrayDeque<int>().addAll(IList.tabulate(200, identity));
      d.removeN(0, 190);
      expect(d.length, 10);
      expect(d[0], 190);
    });

    test('removeN suffix-left path (idx > finalLength/2)', () {
      final d = arrayDeque([0, 1, 2, 3, 4, 5, 6, 7]);
      d.removeN(5, 2);
      expect(d.toList(), [0, 1, 2, 3, 4, 7]);
    });
  });

  group('remove head/last', () {
    test('removeHead returns and removes first element', () {
      final d = arrayDeque([10, 20, 30]);
      expect(d.removeHead(), 10);
      expect(d.toList(), [20, 30]);
    });

    test('removeHead on empty throws', () {
      expect(() => ArrayDeque<int>().removeHead(), throwsUnsupportedError);
    });

    test('removeHeadOption returns Some on non-empty', () {
      final d = arrayDeque([10, 20]);
      expect(d.removeHeadOption(), const Some(10));
      expect(d.toList(), [20]);
    });

    test('removeHeadOption returns None on empty', () {
      expect(ArrayDeque<int>().removeHeadOption(), const None());
    });

    test('removeLast returns and removes last element', () {
      final d = arrayDeque([10, 20, 30]);
      expect(d.removeLast(), 30);
      expect(d.toList(), [10, 20]);
    });

    test('removeLast on empty throws', () {
      expect(() => ArrayDeque<int>().removeLast(), throwsUnsupportedError);
    });

    test('removeLastOption returns Some on non-empty', () {
      final d = arrayDeque([10, 20]);
      expect(d.removeLastOption(), const Some(20));
      expect(d.toList(), [10]);
    });

    test('removeLastOption returns None on empty', () {
      expect(ArrayDeque<int>().removeLastOption(), const None());
    });
  });

  group('removeAll and removeHeadWhile', () {
    test('removeAll removes all elements and returns them', () {
      final d = arrayDeque([1, 2, 3]);
      final removed = d.removeAll((_) => true);
      expect(d.isEmpty, isTrue);
      expect(removed.toList(), [1, 2, 3]);
    });

    test('removeHeadWhile removes from front while predicate holds', () {
      final d = arrayDeque([1, 2, 3, 4, 5]);
      final removed = d.removeHeadWhile((x) => x < 4);
      expect(removed.toList(), [1, 2, 3]);
      expect(d.toList(), [4, 5]);
    });
  });

  group('removeFirst', () {
    test('removes and returns first matching element', () {
      final d = arrayDeque([1, 2, 3, 2, 1]);
      expect(d.removeFirst((x) => x == 2), const Some(2));
      expect(d.toList(), [1, 3, 2, 1]);
    });

    test('returns None when no match', () {
      final d = arrayDeque([1, 2, 3]);
      expect(d.removeFirst((x) => x == 9), const None());
    });
  });

  group('iterator', () {
    test('hasNext returns false when exhausted', () {
      final d = arrayDeque([1]);
      final it = d.iterator;
      it.next();
      expect(it.hasNext, isFalse);
    });

    test('next throws when exhausted', () {
      final it = ArrayDeque<int>().iterator;
      expect(() => it.next(), throwsUnsupportedError);
    });
  });
}
