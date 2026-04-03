import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('MMultiSet', () {
    test('empty', () {
      expect(MMultiSet.empty<String>(), MMultiSet.empty<String>());
      expect(MMultiSet.empty<String>().size, 0);
    });

    test('equality', () {
      final ms1 = mmultiset(['a', 'b', 'b', 'c']);
      final ms2 = mmultiset(['a', 'b', 'b', 'c']);

      expect(ms1, ms2);
      expect(ms2, ms1);
      expect(ms1.hashCode, ms2.hashCode);
    });

    test('fromOccurences', () {
      final ms = MMultiSet.fromOccurences(RIterator.fromDart([('a', 2), ('b', 3)].iterator));
      expect(ms.get('a'), 2);
      expect(ms.get('b'), 3);
      expect(ms.size, 5);
    });

    test('incl and operator +', () {
      final ms = MMultiSet.empty<String>();
      ms.incl('a');
      expect(ms.get('a'), 1);
      ms.incl('a');
      expect(ms.get('a'), 2);

      final ms2 = ms + 'b';
      expect(ms2.get('b'), 1);
    });

    test('excl and operator -', () {
      final ms = mmultiset(['a', 'a', 'b']);
      ms.excl('a');
      expect(ms.get('a'), 1);
      ms.excl('a');
      expect(ms.get('a'), 0);
      expect(ms.contains('a'), isFalse);

      // excl on missing element is a no-op
      ms.excl('z');
      expect(ms.contains('z'), isFalse);

      final ms2 = mmultiset(['a', 'a']);
      final ms3 = ms2 - 'a';
      expect(ms3.get('a'), 1);
    });

    test('contains', () {
      final ms = mmultiset(['a', 'b', 'b']);
      expect(ms.contains('a'), isTrue);
      expect(ms.contains('b'), isTrue);
      expect(ms.contains('z'), isFalse);
    });

    test('get (occurrence count)', () {
      final ms = mmultiset(['x', 'x', 'x', 'y']);
      expect(ms.get('x'), 3);
      expect(ms.get('y'), 1);
      expect(ms.get('z'), 0);
    });

    test('occurrences', () {
      final ms = mmultiset(['a', 'a', 'b']);
      expect(ms.occurrences.get('a'), const Some(2));
      expect(ms.occurrences.get('b'), const Some(1));
      expect(ms.occurrences.get('z').isDefined, isFalse);
    });

    test('concat', () {
      expect(
        mmultiset([1, 1]),
        mmultiset([1]).concat(mmultiset([1])),
      );

      expect(
        mmultiset(['a', 'a', 'a']),
        mmultiset(['a']).concat(mmultiset(['a', 'a'])),
      );
    });

    test('concatOccurences', () {
      final ms = mmultiset(['a', 'b']).concatOccurences(
        ilist([('a', 2), ('c', 1)]),
      );
      expect(ms.get('a'), 2);
      expect(ms.get('c'), 1);
      expect(ms.size, 3);
    });

    test('map', () {
      expect(
        mmultiset(['a', 'b', 'b']).map((x) => x.toUpperCase()),
        mmultiset(['A', 'B', 'B']),
      );

      expect(
        mmultiset(['a', 'b']).map((_) => 1),
        mmultiset([1, 1]),
      );

      expect(
        mmultiset(['a', 'b', 'b']).mapOccurences((_) => ('c', 2)),
        mmultiset(['c', 'c', 'c', 'c']),
      );
    });

    test('filter', () {
      final ms = mmultiset([1, 2, 2, 3]);
      expect(ms.filter((x) => x.isEven), mmultiset([2, 2]));
      expect(ms.filterNot((x) => x.isEven), mmultiset([1, 3]));
    });

    test('filterOccurences', () {
      // keep only elements appearing more than once
      final ms = mmultiset(['a', 'b', 'b', 'c', 'c', 'c']);
      final result = ms.filterOccurences((kv) => kv.$2 > 1);
      expect(result.contains('a'), isFalse);
      expect(result.get('b'), 2);
      expect(result.get('c'), 3);
    });

    test('flatMap', () {
      final ms = mmultiset([1, 2]);
      final result = ms.flatMap((x) => mmultiset([x, x]));
      expect(result.get(1), 2);
      expect(result.get(2), 2);
      expect(result.size, 4);
    });

    test('flatMapOccurences', () {
      final ms = mmultiset(['a', 'a', 'b']);
      // double every occurrence count
      final result = ms.flatMapOccurences(
        (kv) => RIterator.single((kv.$1, kv.$2 * 2)),
      );
      expect(result.get('a'), 4);
      expect(result.get('b'), 2);
    });

    test('collect', () {
      final ms = mmultiset([1, 2, 3, 4]);
      final result = ms.collect((x) => x.isEven ? Some(x * 10) : none<int>());
      expect(result, mmultiset([20, 40]));
    });

    test('collectOccurances', () {
      final ms = mmultiset(['a', 'a', 'b']);
      // keep only 'a', doubling its count
      final result = ms.collectOccurances(
        (kv) => kv.$1 == 'a' ? Some((kv.$1, kv.$2 * 2)) : none(),
      );
      expect(result.get('a'), 4);
      expect(result.contains('b'), isFalse);
    });

    test('partition', () {
      final ms = mmultiset([1, 2, 2, 3]);
      final (evens, odds) = ms.partition((x) => x.isEven);
      expect(evens, mmultiset([2, 2]));
      expect(odds, mmultiset([1, 3]));
    });

    test('partitionMap', () {
      final ms = mmultiset([1, 2, 3, 4]);
      final (lefts, rights) = ms.partitionMap(
        (int x) => x.isEven ? Either.right<String, int>(x) : Either.left<String, int>(x.toString()),
      );
      expect(
        lefts.toIList().sortBy(Order.strings, (String s) => s),
        IList.fromDart(['1', '3']),
      );
      expect(
        rights.toIList().sortBy(Order.ints, (int x) => x),
        IList.fromDart([2, 4]),
      );
    });

    test('tapEach', () {
      final seen = <String>[];
      mmultiset(['a', 'b', 'b']).tapEach(seen.add);
      seen.sort();
      expect(seen, ['a', 'b', 'b']);
    });

    test('take and drop', () {
      final ms = mmultiset([1, 2, 3, 4]);
      expect(ms.take(2).size, 2);
      expect(ms.drop(2).size, 2);
      expect(ms.take(2).size + ms.drop(2).size, ms.size);
    });

    test('groupBy', () {
      final ms = mmultiset([1, 2, 2, 3]);
      final grouped = ms.groupBy((x) => x.isEven ? 'even' : 'odd');
      expect(grouped.get('even').map((g) => g.size), const Some(2));
      expect(grouped.get('odd').map((g) => g.size), const Some(2));
    });

    test('zip', () {
      final ms = mmultiset([1, 2]).zip(mmultiset(['a', 'b']));
      expect(ms.size, 2);
    });

    test('zipWithIndex', () {
      final ms = mmultiset(['x', 'y']).zipWithIndex();
      expect(ms.size, 2);
    });
  });
}
