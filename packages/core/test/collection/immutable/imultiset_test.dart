import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IMultiSet', () {
    test('empty', () {
      expect(IMultiSet.empty<String>(), IMultiSet.empty<String>());
      expect(IMultiSet.empty<String>().size, 0);
    });

    test('equality', () {
      final ms1 = imultiset(['a', 'b', 'b', 'c']);
      final ms2 = imultiset(['a', 'b', 'b', 'c']);

      expect(ms1, ms2);
      expect(ms2, ms1);
      expect(ms1.hashCode, ms2.hashCode);
    });

    test('concat', () {
      expect(
        imultiset([1, 1]),
        imultiset([1]).concat(imultiset([1])),
      );

      expect(
        imultiset(['a', 'a', 'a']),
        imultiset(['a']).concat(imultiset(['a', 'a'])),
      );
    });

    test('map', () {
      expect(
        imultiset(['a', 'b', 'b']).map((x) => x.toUpperCase()),
        imultiset(['A', 'B', 'B']),
      );

      expect(
        imultiset(['a', 'b']).map((_) => 1),
        imultiset([1, 1]),
      );

      expect(
        imultiset(['a', 'b', 'b']).mapOccurences((_) => ('c', 2)),
        imultiset(['c', 'c', 'c', 'c']),
      );
    });

    test('incl / operator +', () {
      expect(IMultiSet.empty<String>() + 'a', imultiset(['a']));
      expect(imultiset(['a']) + 'a', imultiset(['a', 'a']));
      expect(imultiset(['a', 'b']).incl('b'), imultiset(['a', 'b', 'b']));
    });

    test('excl / operator -', () {
      expect(imultiset(['a', 'a']) - 'a', imultiset(['a']));
      expect(imultiset(['a']) - 'a', IMultiSet.empty<String>());
      expect(imultiset(['a']) - 'b', imultiset(['a']));
    });

    test('collect', () {
      expect(
        imultiset(['a', 'b', 'b', 'c']).collect(
          (String x) => x == 'b' ? Some(x.toUpperCase()) : none<String>(),
        ),
        imultiset(['B', 'B']),
      );
      expect(
        imultiset(['a', 'b']).collect((_) => none<String>()),
        IMultiSet.empty<String>(),
      );
    });

    test('concatOccurences', () {
      expect(
        IMultiSet.empty<String>().concatOccurences(ilist([('a', 2), ('b', 1)])),
        imultiset(['a', 'a', 'b']),
      );
    });

    test('drop / dropRight / dropWhile', () {
      expect(imultiset([1, 2, 3]).drop(0).size, 3);
      expect(imultiset([1, 2, 3]).drop(3), IMultiSet.empty<int>());
      expect(imultiset([1, 2, 3]).dropRight(0).size, 3);
      expect(imultiset([1, 2, 3]).dropRight(3), IMultiSet.empty<int>());
      expect(imultiset([1, 2, 3]).dropWhile((_) => true), IMultiSet.empty<int>());
      expect(imultiset([1, 2, 3]).dropWhile((_) => false).size, 3);
    });

    test('filter / filterNot', () {
      expect(
        imultiset(['a', 'b', 'b', 'c']).filter((String x) => x == 'b'),
        imultiset(['b', 'b']),
      );
      expect(
        imultiset(['a', 'b', 'b', 'c']).filterNot((String x) => x == 'b'),
        imultiset(['a', 'c']),
      );
    });

    test('filterOccurences', () {
      expect(
        imultiset(['a', 'b', 'b', 'c']).filterOccurences(
          ((String, int) occ) => occ.$2 > 1,
        ),
        imultiset(['b', 'b']),
      );
    });

    test('flatMap', () {
      expect(
        imultiset(['a', 'b']).flatMap((String x) => imultiset([x, x])),
        imultiset(['a', 'a', 'b', 'b']),
      );
    });

    test('flatMapOccurences', () {
      expect(
        imultiset(['a', 'b', 'b']).flatMapOccurences(
          ((String, int) occ) => ilist([(occ.$1.toUpperCase(), occ.$2)]),
        ),
        imultiset(['A', 'B', 'B']),
      );
    });

    test('groupBy', () {
      final grouped = imultiset(['a', 'b', 'b', 'aa']).groupBy((String x) => x.length);
      expect(grouped[1], imultiset(['a', 'b', 'b']));
      expect(grouped[2], imultiset(['aa']));
    });

    test('groupMap', () {
      final grouped = imultiset(['a', 'b', 'b']).groupMap(
        (String x) => x.length,
        (String x) => x.toUpperCase(),
      );
      expect(grouped[1], imultiset(['A', 'B', 'B']));
    });

    test('grouped', () {
      expect(imultiset([1, 2, 3]).grouped(2).toIList().size, 2);
      expect(imultiset([1, 2, 3]).grouped(3).toIList().size, 1);
    });

    test('init / inits', () {
      expect(imultiset([1, 2, 3]).init.size, 2);
      expect(imultiset([1, 2]).inits.toIList().size, 3); // [ms, ms.init, empty]
    });

    test('partition', () {
      final (evens, odds) = imultiset([1, 1, 2, 3, 3]).partition((int x) => x.isEven);
      expect(evens, imultiset([2]));
      expect(odds, imultiset([1, 1, 3, 3]));
    });

    test('partitionMap', () {
      final result = imultiset([1, 2, 3]).partitionMap(
        (int x) => x.isEven ? Either.right<String, int>(x) : Either.left<String, int>(x.toString()),
      );
      expect(result.$1, imultiset(['1', '3']));
      expect(result.$2, imultiset([2]));
    });

    test('slice', () {
      expect(imultiset([1, 2, 3]).slice(0, 3).size, 3);
      expect(imultiset([1, 2, 3]).slice(1, 3).size, 2);
      expect(imultiset([1, 2, 3]).slice(0, 0), IMultiSet.empty<int>());
    });

    test('sliding', () {
      expect(imultiset([1, 2, 3]).sliding(2).toIList().size, 2);
    });

    test('span', () {
      final (all, none_) = imultiset([1, 2, 3]).span((_) => true);
      expect(all.size, 3);
      expect(none_, IMultiSet.empty<int>());

      final (none2, all2) = imultiset([1, 2, 3]).span((_) => false);
      expect(none2, IMultiSet.empty<int>());
      expect(all2.size, 3);
    });

    test('splitAt', () {
      final (first, second) = imultiset([1, 2, 3]).splitAt(2);
      expect(first.size, 2);
      expect(second.size, 1);
    });

    test('tail / tails', () {
      expect(imultiset([1, 2, 3]).tail.size, 2);
      expect(imultiset([1, 2]).tails.toIList().size, 3); // [ms, ms.tail, empty]
    });

    test('take / takeRight / takeWhile', () {
      expect(imultiset([1, 2, 3]).take(0), IMultiSet.empty<int>());
      expect(imultiset([1, 2, 3]).take(3).size, 3);
      expect(imultiset([1, 2, 3]).takeRight(0), IMultiSet.empty<int>());
      expect(imultiset([1, 2, 3]).takeRight(3).size, 3);
      expect(imultiset([1, 2, 3]).takeWhile((_) => false), IMultiSet.empty<int>());
      expect(imultiset([1, 2, 3]).takeWhile((_) => true).size, 3);
    });

    test('tapEach', () {
      final seen = <int>[];
      imultiset([1, 2, 2, 3]).tapEach(seen.add);
      expect(seen.length, 4);
    });

    test('zip', () {
      expect(imultiset([1, 2]).zip(imultiset([3, 4])).size, 2);
      expect(imultiset([1, 2]).zip(IMultiSet.empty<int>()).size, 0);
    });

    test('zipAll', () {
      expect(imultiset([1]).zipAll(imultiset([2, 3]), 0, 0).size, 2);
    });

    test('zipWithIndex', () {
      expect(imultiset(['a', 'b', 'b']).zipWithIndex().size, 3);
    });
  });
}
