import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:test/test.dart';

void main() {
  MMultiDict<String, int> makeAbc() => mmultidict([
    ('a', 1),
    ('b', 0),
    ('b', 1),
    ('c', 3),
  ]);

  group('MMultiDict', () {
    test('empty', () {
      expect(MMultiDict.empty<String, int>(), MMultiDict.empty<String, int>());
      expect(MMultiDict.empty<String, int>().size, 0);
    });

    test('equality', () {
      final md1 = makeAbc();
      final md2 = makeAbc();

      expect(md1, md2);
      expect(md2, md1);
      expect(md2.hashCode, md1.hashCode);
    });

    test('access', () {
      final md = makeAbc();

      expect(mset({0, 1}), md.get('b'));
      expect(mset(<int>{}), md.get('d'));
      expect(md.containsKey('a'), isTrue);
      expect(md.containsKey('d'), isFalse);
      expect(md.containsEntry(('a', 1)), isTrue);
      expect(md.containsEntry(('a', 2)), isFalse);
      expect(md.containsEntry(('d', 2)), isFalse);
      expect(md.containsValue(1), isTrue);
      expect(md.containsValue(3), isTrue);
      expect(md.containsValue(4), isFalse);
    });

    test('add and operator +', () {
      final md = MMultiDict.empty<String, int>();
      md.add('a', 1);
      expect(md.containsEntry(('a', 1)), isTrue);

      final md2 = md + ('a', 2);
      expect(md2.containsEntry(('a', 2)), isTrue);
      expect(md2.containsEntry(('a', 1)), isTrue);
    });

    test('fromDart', () {
      final md = MMultiDict.fromDart({'a': 1, 'b': 2});
      expect(md.containsEntry(('a', 1)), isTrue);
      expect(md.containsEntry(('b', 2)), isTrue);
      expect(md.size, 2);
    });

    test('concat', () {
      expect(
        mmultidict([(1, true), (1, false)]),
        mmultidict([(1, true)]).concat(mmultidict([(1, false)])),
      );
    });

    test('entryExists', () {
      final md = makeAbc();
      expect(md.entryExists('b', (v) => v > 0), isTrue);
      expect(md.entryExists('b', (v) => v > 5), isFalse);
      expect(md.entryExists('z', (v) => v > 0), isFalse);
    });

    test('keySet', () {
      final md = makeAbc();
      expect(md.keySet(), iset({'a', 'b', 'c'}));
    });

    test('values', () {
      final md = mmultidict([('a', 1), ('b', 2)]);
      final vals = md.values.toIList().sortBy(Order.ints, (int v) => v);
      expect(vals, IList.fromDart([1, 2]));
    });

    test('sets', () {
      final md = mmultidict([('a', 1), ('a', 2)]);
      expect(md.sets.get('a').map((s) => s.size), isSome(2));
    });

    test('filterNot', () {
      final md = makeAbc();
      final result = md.filterNot((kv) => kv.$1 == 'b');
      expect(result.containsKey('b'), isFalse);
      expect(result.containsKey('a'), isTrue);
    });

    test('filterSets', () {
      final md = makeAbc();
      final result = md.filterSets((kv) => kv.$1 != 'b');
      expect(result.containsKey('b'), isFalse);
      expect(result.containsKey('a'), isTrue);
      expect(result.containsKey('c'), isTrue);
    });

    test('partition', () {
      final md = makeAbc();
      final (yes, no) = md.partition((kv) => kv.$1 == 'a');
      expect(yes.containsKey('a'), isTrue);
      expect(yes.containsKey('b'), isFalse);
      expect(no.containsKey('b'), isTrue);
      expect(no.containsKey('a'), isFalse);
    });

    test('tapEach', () {
      final seen = <String>[];
      makeAbc().tapEach((kv) => seen.add(kv.$1));
      expect(seen.toSet(), {'a', 'b', 'c'});
    });

    test('take and drop', () {
      final md = makeAbc();
      expect(md.take(2).size, 2);
      expect(md.drop(2).size, md.size - 2);
    });

    test('takeWhile and dropWhile', () {
      final md = mmultidict([('a', 1), ('a', 2), ('b', 3)]);
      final taken = md.takeWhile((kv) => kv.$2 < 3);
      final dropped = md.dropWhile((kv) => kv.$2 < 3);
      expect(taken.size + dropped.size, md.size);
    });
  });

  test('map', () {
    final md1 = mmultidict([('a', 1), ('b', 2)]);
    final md1Mapped = MMultiDict.from(md1.map((t) => (t.$1.toUpperCase(), t.$2)));
    final md1Expected = mmultidict([('A', 1), ('B', 2)]);

    final md2 = mmultidict([('a', true), ('b', true)]);
    final md2Mapped = MMultiDict.from(md2.map((t) => (1, t.$2)));
    final md2Expected = mmultidict([(1, true), (1, true)]);

    final md3 = mmultidict([('a', 1), ('b', 2), ('b', 3)]);
    final md3Mapped = MMultiDict.from(md3.mapSets((_) => ('c', iset({1, 2, 3, 4}))));
    final md3Expected = mmultidict([('c', 1), ('c', 2), ('c', 3), ('c', 4)]);

    expect(md1Mapped, md1Expected);
    expect(md2Mapped, md2Expected);
    expect(md3Mapped, md3Expected);
  });

  test('filter', () {
    final filtered = mmultidict([('a', 1), ('b', 2)]).filter((kv) => kv.$1 == 'a' && kv.$2.isEven);

    expect(filtered.toSeq().isEmpty, isTrue);
  });
}
