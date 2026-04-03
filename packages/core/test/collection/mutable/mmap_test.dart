import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:test/test.dart';

void main() {
  MMap<int, String> make123() => mmap({1: 'one', 2: 'two', 3: 'three'});

  group('MMap', () {
    test('simple', () {
      final m = MMap.empty<int, String>();

      expect(m.isEmpty, isTrue);
      expect(m.size, 0);

      expect(m.put(0, '0'), isNone());
      expect(m.put(0, 'zero'), isSome('0'));

      expect(m.get(0), isSome('zero'));
      expect(m.get(1), isNone());

      expect(m.remove(0), isSome('zero'));
      expect(m.remove(1), isNone());

      expect(m.isEmpty, isTrue);
    });

    test('from', () {
      final src = ilist([(1, 'one'), (2, 'two')]);
      final m = MMap.from(src);
      expect(m.get(1), isSome('one'));
      expect(m.get(2), isSome('two'));
      expect(m.size, 2);
    });

    test('fromDart', () {
      final m = MMap.fromDart({1: 'one', 2: 'two'});
      expect(m.get(1), isSome('one'));
      expect(m.get(2), isSome('two'));
    });

    test('operator []=  and operator []', () {
      final m = MMap.empty<int, String>();
      m[1] = 'one';
      expect(m[1], 'one');
      m[1] = 'ONE';
      expect(m[1], 'ONE');
    });

    test('operator [] uses defaultValue when key absent', () {
      final m = MMap.empty<int, String>().withDefaultValue('?');
      expect(m[99], '?');
    });

    test('contains', () {
      final m = make123();
      expect(m.contains(1), isTrue);
      expect(m.contains(99), isFalse);
    });

    test('clear', () {
      final m = make123();
      m.clear();
      expect(m.isEmpty, isTrue);
      expect(m.size, 0);
    });

    test('concat', () {
      final m = mmap({1: 'one'});
      m.concat(RIterator.fromDart([(2, 'two'), (3, 'three')].iterator));
      expect(m.size, 3);
      expect(m.get(2), isSome('two'));
    });

    test('update', () {
      final m = make123();
      m.update(1, 'ONE');
      expect(m.get(1), isSome('ONE'));
    });

    test('getOrElse (RMap)', () {
      final m = make123();
      expect(m.getOrElse(1, () => 'fallback'), 'one');
      expect(m.getOrElse(99, () => 'fallback'), 'fallback');
    });

    test('getOrElseUpdate', () {
      final m = mmap({1: 'one'});
      expect(m.getOrElseUpdate(1, () => 'computed'), 'one');
      expect(m.getOrElseUpdate(2, () => 'computed'), 'computed');
      expect(m.get(2), isSome('computed'));
    });

    test('keys and values', () {
      final m = mmap({1: 'one', 2: 'two'});
      expect(m.keys.toIList().sortBy(Order.ints, (int a) => a), IList.fromDart([1, 2]));
      expect(
        m.values.toIList().sortBy(Order.strings, (String a) => a),
        IList.fromDart(['one', 'two']),
      );
    });

    test('toMap', () {
      final m = make123();
      expect(m.toMap(), {1: 'one', 2: 'two', 3: 'three'});
    });

    test('filter', () {
      final m = make123();
      final result = m.filter((kv) => kv.$1 <= 2);
      expect(result.size, 2);
      expect(result.get(1), isSome('one'));
      expect(result.get(3), isNone());
    });

    test('filterNot', () {
      final m = make123();
      final result = m.filterNot((kv) => kv.$1 == 2);
      expect(result.size, 2);
      expect(result.get(2), isNone());
    });

    test('filterInPlace', () {
      final m = make123();
      m.filterInPlace((kv) => kv.$1 != 2);
      expect(m.size, 2);
      expect(m.get(2), isNone());
      expect(m.get(1), isSome('one'));
    });

    test('removeAll', () {
      final m = make123();
      m.removeAll(ilist([1, 2]));
      expect(m.get(1), isNone());
      expect(m.get(2), isNone());
      expect(m.get(3), isSome('three'));
    });

    test('updateWith — insert', () {
      final m = mmap({1: 'one'});
      m.updateWith(2, (_) => const Some('two'));
      expect(m.get(2), isSome('two'));
    });

    test('updateWith — modify existing', () {
      final m = mmap({1: 'one'});
      m.updateWith(1, (prev) => prev.map((v) => v.toUpperCase()));
      expect(m.get(1), isSome('ONE'));
    });

    test('updateWith — remove when returning None', () {
      final m = mmap({1: 'one'});
      m.updateWith(1, (_) => none());
      expect(m.get(1), isNone());
    });

    test('withDefault', () {
      final m = mmap({1: 'one'}).withDefault((k) => 'key=$k');
      expect(m[1], 'one');
      expect(m[99], 'key=99');
    });

    test('withDefaultValue', () {
      final m = mmap({1: 'one'}).withDefaultValue('missing');
      expect(m[1], 'one');
      expect(m[99], 'missing');
    });

    test('take and drop', () {
      final m = mmap({1: 'one', 2: 'two', 3: 'three'});
      expect(m.take(2).size, 2);
      expect(m.drop(2).size, 1);
    });

    test('slice', () {
      final m = mmap({1: 'one', 2: 'two', 3: 'three'});
      expect(m.slice(1, 3).size, 2);
    });

    test('partition', () {
      final m = make123();
      final (evens, odds) = m.partition((kv) => kv.$1.isEven);
      expect(evens.size, 1);
      expect(odds.size, 2);
    });

    test('span', () {
      final m = mmap({1: 'one', 2: 'two', 3: 'three'});
      final (a, b) = m.span((kv) => kv.$1 < 3);
      expect(a.size + b.size, 3);
    });

    test('splitAt', () {
      final m = make123();
      final (a, b) = m.splitAt(2);
      expect(a.size, 2);
      expect(b.size, 1);
    });

    test('groupBy', () {
      final m = make123();
      final grouped = m.groupBy((kv) => kv.$1.isEven ? 'even' : 'odd');
      expect(grouped.get('even').map((g) => g.size), isSome(1));
      expect(grouped.get('odd').map((g) => g.size), isSome(2));
    });

    test('tapEach', () {
      final seen = <int>[];
      make123().tapEach((kv) => seen.add(kv.$1));
      seen.sort();
      expect(seen, [1, 2, 3]);
    });
  });

  test('equality', () {
    expect(mmap({}), mmap({}));
    expect(mmap({1: 'one', 2: 'two'}), mmap({1: 'one', 2: 'two'}));
  });
}
