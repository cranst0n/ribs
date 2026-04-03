import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:test/test.dart';

void main() {
  group('MHashMap', () {
    test('empty', () {
      final m = MHashMap<int, String>();
      expect(m.isEmpty, isTrue);
      expect(m.size, 0);
      expect(m.knownSize, 0);
    });

    test('put returns previous value', () {
      final m = MHashMap<int, String>();
      expect(m.put(1, 'one'), isNone());
      expect(m.put(1, 'ONE'), isSome('one'));
      expect(m.get(1), isSome('ONE'));
    });

    test('get on missing key returns None', () {
      expect(MHashMap<int, String>().get(99), isNone());
    });

    test('remove returns previous value', () {
      final m = MHashMap<int, String>();
      m.put(1, 'one');
      expect(m.remove(1), isSome('one'));
      expect(m.remove(1), isNone());
      expect(m.isEmpty, isTrue);
    });

    test('knownSize tracks size', () {
      final m = MHashMap<int, String>();
      expect(m.knownSize, 0);
      m.put(1, 'one');
      expect(m.knownSize, 1);
      m.put(2, 'two');
      expect(m.knownSize, 2);
      m.remove(1);
      expect(m.knownSize, 1);
    });

    test('keys returns ISet of all keys', () {
      final m = MHashMap<int, String>();
      m.put(1, 'one');
      m.put(2, 'two');
      m.put(3, 'three');
      expect(m.keys, iset({1, 2, 3}));
    });

    test('valuesIterator yields all values', () {
      final m = MHashMap<int, String>();
      m.put(1, 'one');
      m.put(2, 'two');
      final vals = m.valuesIterator.toIList().sortBy(Order.strings, (String s) => s);
      expect(vals, IList.fromDart(['one', 'two']));
    });

    test('iterator yields all key-value pairs', () {
      final m = MHashMap<int, String>();
      m.put(1, 'one');
      m.put(2, 'two');
      final pairs = m.iterator.toIList().sortBy(Order.ints, (kv) => kv.$1);
      expect(pairs, IList.fromDart([(1, 'one'), (2, 'two')]));
    });

    test('iterator on empty map is empty', () {
      expect(MHashMap<int, String>().iterator.toList(), isEmpty);
    });

    test('clear resets map', () {
      final m = MHashMap<int, String>();
      m.put(1, 'one');
      m.put(2, 'two');
      m.clear();
      expect(m.isEmpty, isTrue);
      expect(m.size, 0);
      // can add to cleared map
      m.put(3, 'three');
      expect(m.get(3), isSome('three'));
    });

    test('custom initialCapacity and loadFactor', () {
      final m = MHashMap<int, String>(initialCapacity: 4, loadFactor: 0.5);
      for (var i = 0; i < 20; i++) {
        m.put(i, '$i');
      }
      expect(m.size, 20);
      for (var i = 0; i < 20; i++) {
        expect(m.get(i), isSome('$i'));
      }
    });

    test('grows table and preserves all entries under load', () {
      // Exercises rehashing: inserts enough entries to trigger multiple
      // table doublings and verifies every key is still reachable.
      final m = MHashMap<int, String>();
      for (var i = 0; i < 100; i++) {
        m.put(i, 'v$i');
      }
      expect(m.size, 100);
      for (var i = 0; i < 100; i++) {
        expect(m.get(i), isSome('v$i'));
      }
    });

    test('handles hash collisions in chain', () {
      // Force two keys into the same bucket by using a tiny initial capacity,
      // then verify both are retrievable and independently updatable.
      final m = MHashMap<int, String>(initialCapacity: 2, loadFactor: 0.99);
      m.put(1, 'one');
      m.put(2, 'two');
      m.put(3, 'three');
      expect(m.get(1), isSome('one'));
      expect(m.get(2), isSome('two'));
      expect(m.get(3), isSome('three'));
      m.put(2, 'TWO');
      expect(m.get(2), isSome('TWO'));
      expect(m.get(1), isSome('one'));
    });
  });
}
