import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('IMultiDict', () {
    test('empty', () {
      expect(IMultiDict.empty<String, int>(), IMultiDict.empty<String, int>());
      expect(IMultiDict.empty<String, int>().size, 0);
    });

    test('equality', () {
      final md1 = imultidict([
        ('a', 1),
        ('b', 0),
        ('b', 1),
        ('c', 3),
      ]);

      final md2 = imultidict([
        ('a', 1),
        ('b', 0),
        ('b', 1),
        ('c', 3),
      ]);

      expect(md1, md2);
      expect(md2, md1);
      expect(md2.hashCode, md1.hashCode);
    });

    test('access', () {
      final md = imultidict([
        ('a', 1),
        ('b', 0),
        ('b', 1),
        ('c', 3),
      ]);

      expect(iset({0, 1}), md.get('b'));
      expect(iset(<int>{}), md.get('d'));
      expect(md.containsKey('a'), isTrue);
      expect(md.containsKey('d'), isFalse);
      expect(md.containsEntry(('a', 1)), isTrue);
      expect(md.containsEntry(('a', 2)), isFalse);
      expect(md.containsEntry(('d', 2)), isFalse);
      expect(md.containsValue(1), isTrue);
      expect(md.containsValue(3), isTrue);
      expect(md.containsValue(4), isFalse);
    });

    test('concat', () {
      expect(
        imultidict([(1, true), (1, false)]),
        imultidict([(1, true)]).concat(imultidict([(1, false)])),
      );
    });

    test('fromDart', () {
      expect(IMultiDict.fromDart({'a': 1, 'b': 2}), imultidict([('a', 1), ('b', 2)]));
      expect(IMultiDict.fromDart(<String, int>{}), IMultiDict.empty<String, int>());
    });

    test('add / operator +', () {
      expect(IMultiDict.empty<String, int>() + ('a', 1), imultidict([('a', 1)]));
      expect(imultidict([('a', 1)]).add('a', 2), imultidict([('a', 1), ('a', 2)]));
      expect(imultidict([('a', 1)]).add('b', 1), imultidict([('a', 1), ('b', 1)]));
    });

    test('filterNot', () {
      expect(
        imultidict([('a', 1), ('b', 2)]).filterNot(((String, int) kv) => kv.$1 == 'a'),
        imultidict([('b', 2)]),
      );
      expect(
        imultidict([('a', 1), ('b', 2)]).filterNot((_) => true),
        IMultiDict.empty<String, int>(),
      );
    });

    test('filterSets', () {
      final md = imultidict([('a', 1), ('b', 2), ('b', 3)]);
      expect(
        md.filterSets(((String, RSet<int>) kv) => kv.$1 == 'b'),
        imultidict([('b', 2), ('b', 3)]),
      );
      expect(
        md.filterSets((_) => false),
        IMultiDict.empty<String, int>(),
      );
    });

    test('sets', () {
      final md = imultidict([('a', 1), ('b', 2), ('b', 3)]);
      expect(md.sets.get('a'), Some(iset({1})));
      expect(md.sets.get('b'), Some(iset({2, 3})));
      expect(md.sets.get('c'), none<ISet<int>>());
    });

    test('groupBy', () {
      final grouped = imultidict([('a', 1), ('b', 2), ('a', 3)]).groupBy(
        ((String, int) kv) => kv.$1,
      );
      expect(grouped.get('a'), Some(imultidict([('a', 1), ('a', 3)])));
      expect(grouped.get('b'), Some(imultidict([('b', 2)])));
      expect(grouped.get('c'), none<IMultiDict<String, int>>());
    });

    test('grouped', () {
      expect(
        imultidict([('a', 1), ('b', 2), ('c', 3)]).grouped(2).toIList().size,
        2,
      );
    });

    test('init / inits', () {
      expect(imultidict([('a', 1), ('b', 2), ('c', 3)]).init.size, 2);
      expect(imultidict([('a', 1), ('b', 2)]).inits.toIList().size, 3);
    });

    test('partition', () {
      final (as_, bs) = imultidict([('a', 1), ('b', 2), ('a', 3)]).partition(
        ((String, int) kv) => kv.$1 == 'a',
      );
      expect(as_, imultidict([('a', 1), ('a', 3)]));
      expect(bs, imultidict([('b', 2)]));
    });

    test('slice', () {
      expect(imultidict([('a', 1), ('b', 2), ('c', 3)]).slice(0, 3).size, 3);
      expect(imultidict([('a', 1), ('b', 2), ('c', 3)]).slice(1, 3).size, 2);
      expect(
        imultidict([('a', 1), ('b', 2)]).slice(0, 0),
        IMultiDict.empty<String, int>(),
      );
    });

    test('sliding', () {
      expect(
        imultidict([('a', 1), ('b', 2), ('c', 3)]).sliding(2).toIList().size,
        2,
      );
    });

    test('drop / dropRight / dropWhile', () {
      final md = imultidict([('a', 1), ('b', 2), ('c', 3)]);
      expect(md.drop(0).size, 3);
      expect(md.drop(3), IMultiDict.empty<String, int>());
      expect(md.dropRight(0).size, 3);
      expect(md.dropRight(3), IMultiDict.empty<String, int>());
      expect(md.dropWhile((_) => true), IMultiDict.empty<String, int>());
      expect(md.dropWhile((_) => false).size, 3);
    });

    test('span', () {
      final md = imultidict([('a', 1), ('b', 2), ('c', 3)]);
      final (all, none_) = md.span((_) => true);
      expect(all.size, 3);
      expect(none_, IMultiDict.empty<String, int>());

      final (empty_, all2) = md.span((_) => false);
      expect(empty_, IMultiDict.empty<String, int>());
      expect(all2.size, 3);
    });

    test('splitAt', () {
      final (first, second) = imultidict([('a', 1), ('b', 2), ('c', 3)]).splitAt(2);
      expect(first.size, 2);
      expect(second.size, 1);
    });

    test('tail / tails', () {
      expect(imultidict([('a', 1), ('b', 2), ('c', 3)]).tail.size, 2);
      expect(imultidict([('a', 1), ('b', 2)]).tails.toIList().size, 3);
    });

    test('take / takeRight / takeWhile', () {
      final md = imultidict([('a', 1), ('b', 2), ('c', 3)]);
      expect(md.take(0), IMultiDict.empty<String, int>());
      expect(md.take(3).size, 3);
      expect(md.takeRight(0), IMultiDict.empty<String, int>());
      expect(md.takeRight(3).size, 3);
      expect(md.takeWhile((_) => false), IMultiDict.empty<String, int>());
      expect(md.takeWhile((_) => true).size, 3);
    });

    test('tapEach', () {
      final seen = <(String, int)>[];
      imultidict([('a', 1), ('b', 2)]).tapEach(seen.add);
      expect(seen.length, 2);
    });
  });

  test('map', () {
    final md1 = imultidict([('a', 1), ('b', 2)]);
    final md1Mapped = IMultiDict.from(md1.map((t) => (t.$1.toUpperCase(), t.$2)));
    final md1Expected = imultidict([('A', 1), ('B', 2)]);

    final md2 = imultidict([('a', true), ('b', true)]);
    final md2Mapped = IMultiDict.from(md2.map((t) => (1, t.$2)));
    final md2Expected = imultidict([(1, true), (1, true)]);

    final md3 = imultidict([('a', 1), ('b', 2), ('b', 3)]);
    final md3Mapped = IMultiDict.from(md3.mapSets((_) => ('c', iset({1, 2, 3, 4}))));
    final md3Expected = imultidict([('c', 1), ('c', 2), ('c', 3), ('c', 4)]);

    expect(md1Mapped, md1Expected);
    expect(md2Mapped, md2Expected);
    expect(md3Mapped, md3Expected);
  });

  test('filter', () {
    final filtered = imultidict([('a', 1), ('b', 2)]).filter((kv) => kv.$1 == 'a' && kv.$2.isEven);

    expect(filtered.toSeq().isEmpty, isTrue);
  });
}
