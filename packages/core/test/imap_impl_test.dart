// Tests targeting internal implementation details of IMap:
// _EmptyMap, _Map1, _Map2, _Map3, _Map4, IHashMap, and IMapBuilder.

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  IMap<String, int> mapN(int n) {
    IMap<String, int> m = IMap.empty<String, int>();
    for (var i = 1; i <= n; i++) {
      m = m.updated('k$i', i);
    }
    return m;
  }

  group('IMap state transitions via updated', () {
    test('empty -> Map1', () {
      final m = IMap.empty<String, int>().updated('a', 1);
      expect(m.size, 1);
      expect(m.get('a'), isSome(1));
    });

    test('Map1 -> Map2 (new key)', () {
      final m = mapN(2);
      expect(m.size, 2);
      expect(m.get('k1'), isSome(1));
      expect(m.get('k2'), isSome(2));
    });

    test('Map1 -> Map1 (same key)', () {
      final m = mapN(1).updated('k1', 99);
      expect(m.size, 1);
      expect(m.get('k1'), isSome(99));
    });

    test('Map2 -> Map3 (new key)', () {
      final m = mapN(3);
      expect(m.size, 3);
      expect(m.get('k3'), isSome(3));
    });

    test('Map2 -> Map2 (update key1)', () {
      final m = mapN(2).updated('k1', 100);
      expect(m.size, 2);
      expect(m.get('k1'), isSome(100));
      expect(m.get('k2'), isSome(2));
    });

    test('Map2 -> Map2 (update key2)', () {
      final m = mapN(2).updated('k2', 200);
      expect(m.size, 2);
      expect(m.get('k1'), isSome(1));
      expect(m.get('k2'), isSome(200));
    });

    test('Map3 -> Map4 (new key)', () {
      final m = mapN(4);
      expect(m.size, 4);
      expect(m.get('k4'), isSome(4));
    });

    test('Map3 -> Map3 (update each key)', () {
      for (var i = 1; i <= 3; i++) {
        final m = mapN(3).updated('k$i', 999);
        expect(m.size, 3);
        expect(m.get('k$i'), isSome(999));
      }
    });

    test('Map4 -> IHashMap (new key)', () {
      final m = mapN(5);
      expect(m.size, 5);
      for (var i = 1; i <= 5; i++) {
        expect(m.get('k$i'), isSome(i));
      }
    });

    test('Map4 -> Map4 (update key1)', () {
      final m = mapN(4).updated('k1', 100);
      expect(m.size, 4);
      expect(m.get('k1'), isSome(100));
      expect(m.get('k2'), isSome(2));
      expect(m.get('k3'), isSome(3));
      expect(m.get('k4'), isSome(4));
    });

    test('Map4 -> Map4 (update key2)', () {
      final m = mapN(4).updated('k2', 200);
      expect(m.size, 4);
      expect(m.get('k2'), isSome(200));
    });

    test('Map4 -> Map4 (update key3)', () {
      final m = mapN(4).updated('k3', 300);
      expect(m.size, 4);
      expect(m.get('k3'), isSome(300));
    });

    // Updating key4 in a _Map4 falls through to the IHashMap path in the
    // implementation; the result is still semantically correct.
    test('Map4 update key4 preserves correct value', () {
      final m = mapN(4).updated('k4', 400);
      expect(m.size, 4);
      expect(m.get('k4'), isSome(400));
      // Other keys must be unaffected.
      expect(m.get('k1'), isSome(1));
      expect(m.get('k2'), isSome(2));
      expect(m.get('k3'), isSome(3));
    });
  });

  group('IMap state transitions via removed', () {
    test('Map1 -> Empty (matching key)', () {
      final m = mapN(1).removed('k1');
      expect(m.size, 0);
      expect(m.isEmpty, isTrue);
    });

    test('Map1 -> Map1 (non-matching key)', () {
      final m = mapN(1).removed('z');
      expect(m.size, 1);
      expect(m.get('k1'), isSome(1));
    });

    test('Map2 -> Map1 (remove key1)', () {
      final m = mapN(2).removed('k1');
      expect(m.size, 1);
      expect(m.get('k1'), isNone());
      expect(m.get('k2'), isSome(2));
    });

    test('Map2 -> Map1 (remove key2)', () {
      final m = mapN(2).removed('k2');
      expect(m.size, 1);
      expect(m.get('k2'), isNone());
      expect(m.get('k1'), isSome(1));
    });

    test('Map2 -> Map2 (non-matching key)', () {
      final m = mapN(2).removed('z');
      expect(m.size, 2);
    });

    test('Map3 -> Map2 (remove each key)', () {
      for (var i = 1; i <= 3; i++) {
        final m = mapN(3).removed('k$i');
        expect(m.size, 2);
        expect(m.get('k$i'), isNone());
      }
    });

    test('Map3 -> Map3 (non-matching key)', () {
      final m = mapN(3).removed('z');
      expect(m.size, 3);
    });

    test('Map4 -> Map3 (remove each key)', () {
      for (var i = 1; i <= 4; i++) {
        final m = mapN(4).removed('k$i');
        expect(m.size, 3);
        expect(m.get('k$i'), isNone());
      }
    });

    test('Map4 -> Map4 (non-matching key)', () {
      final m = mapN(4).removed('z');
      expect(m.size, 4);
    });
  });

  group('_EmptyMap', () {
    final empty = IMap.empty<String, int>();

    test('contains always false', () {
      expect(empty.contains('anything'), isFalse);
    });

    test('get always None', () {
      expect(empty.get('anything'), isNone());
    });

    test('getOrElse returns default', () {
      expect(empty.getOrElse('k', () => 42), 42);
    });

    test('isEmpty true', () {
      expect(empty.isEmpty, isTrue);
    });

    test('knownSize is 0', () {
      expect(empty.knownSize, 0);
    });

    test('size is 0', () {
      expect(empty.size, 0);
    });

    test('removed returns itself', () {
      expect(empty.removed('x'), empty);
    });

    test('keys is empty ISet', () {
      expect(empty.keys.isEmpty, isTrue);
    });

    test('values is empty', () {
      expect(empty.values.isEmpty, isTrue);
    });

    test('iterator has no elements', () {
      expect(empty.iterator.hasNext, isFalse);
    });

    test('updated creates Map1', () {
      final m = empty.updated('a', 1);
      expect(m.size, 1);
      expect(m.get('a'), isSome(1));
    });
  });

  group('_Map1', () {
    final m = IMap.empty<String, int>().updated('a', 1);

    test('knownSize is 1', () {
      expect(m.knownSize, 1);
    });

    test('exists', () {
      expect(m.exists((kv) => kv.$2 == 1), isTrue);
      expect(m.exists((kv) => kv.$2 == 99), isFalse);
    });

    test('forall', () {
      expect(m.forall((kv) => kv.$2 > 0), isTrue);
      expect(m.forall((kv) => kv.$2 > 10), isFalse);
    });

    test('foreach visits single element', () {
      var count = 0;
      m.foreach((_) => count++);
      expect(count, 1);
    });

    test('keys contains only key1', () {
      expect(m.keys, iset(['a']));
    });

    test('valuesIterator yields only value1', () {
      expect(m.values.toIList(), ilist([1]));
    });
  });

  group('_Map2', () {
    final m = mapN(2);

    test('knownSize is 2', () {
      expect(m.knownSize, 2);
    });

    test('exists short-circuits', () {
      expect(m.exists((kv) => kv.$1 == 'k1'), isTrue);
      expect(m.exists((kv) => kv.$1 == 'k2'), isTrue);
      expect(m.exists((kv) => kv.$1 == 'z'), isFalse);
    });

    test('forall', () {
      expect(m.forall((kv) => kv.$2 > 0), isTrue);
      expect(m.forall((kv) => kv.$2 > 1), isFalse);
    });

    test('foreach visits both elements', () {
      var sum = 0;
      m.foreach((kv) => sum += kv.$2);
      expect(sum, 3);
    });

    test('keys contains both keys', () {
      expect(m.keys, iset(['k1', 'k2']));
    });
  });

  group('_Map3', () {
    final m = mapN(3);

    test('knownSize is 3', () {
      expect(m.knownSize, 3);
    });

    test('get all three keys', () {
      expect(m.get('k1'), isSome(1));
      expect(m.get('k2'), isSome(2));
      expect(m.get('k3'), isSome(3));
      expect(m.get('z'), isNone());
    });

    test('exists and forall', () {
      expect(m.exists((kv) => kv.$2 == 3), isTrue);
      expect(m.forall((kv) => kv.$2 <= 3), isTrue);
      expect(m.forall((kv) => kv.$2 < 3), isFalse);
    });

    test('foreach visits all three', () {
      var sum = 0;
      m.foreach((kv) => sum += kv.$2);
      expect(sum, 6);
    });

    test('keys contains all three', () {
      expect(m.keys, iset(['k1', 'k2', 'k3']));
    });
  });

  group('_Map4', () {
    final m = mapN(4);

    test('knownSize is 4', () {
      expect(m.knownSize, 4);
    });

    test('get all four keys', () {
      for (var i = 1; i <= 4; i++) {
        expect(m.get('k$i'), isSome(i));
      }
      expect(m.get('z'), isNone());
    });

    test('contains each key', () {
      for (var i = 1; i <= 4; i++) {
        expect(m.contains('k$i'), isTrue);
      }
      expect(m.contains('z'), isFalse);
    });

    test('exists', () {
      expect(m.exists((kv) => kv.$2 == 4), isTrue);
      expect(m.exists((kv) => kv.$2 == 99), isFalse);
    });

    test('forall', () {
      expect(m.forall((kv) => kv.$2 <= 4), isTrue);
      expect(m.forall((kv) => kv.$2 < 4), isFalse);
    });

    test('foreach visits all four', () {
      var sum = 0;
      m.foreach((kv) => sum += kv.$2);
      expect(sum, 10);
    });

    test('keys contains all four', () {
      expect(m.keys, iset(['k1', 'k2', 'k3', 'k4']));
    });
  });

  group('IHashMap (large map)', () {
    // Use late + setUp so each test gets its own fresh map instance,
    // avoiding sharing mutable CHAMP trie nodes across tests.
    late IMap<String, int> m;
    setUp(() => m = mapN(10));

    test('size is 10', () {
      expect(m.size, 10);
    });

    test('knownSize is 10', () {
      expect(m.knownSize, 10);
    });

    test('get all keys', () {
      for (var i = 1; i <= 10; i++) {
        expect(m.get('k$i'), isSome(i));
      }
      expect(m.get('z'), isNone());
    });

    test('updated existing key', () {
      final m2 = m.updated('k5', 999);
      expect(m2.size, 10);
      expect(m2.get('k5'), isSome(999));
    });

    test('updated new key grows map', () {
      final m2 = m.updated('k11', 11);
      expect(m2.size, 11);
      expect(m2.get('k11'), isSome(11));
    });

    test('removed existing key shrinks map', () {
      final m2 = m.removed('k1');
      expect(m2.size, 9);
      expect(m2.get('k1'), isNone());
    });

    test('removed non-existent key unchanged', () {
      final m2 = m.removed('z');
      expect(m2.size, 10);
    });

    test('keys returns all keys', () {
      expect(m.keys.size, 10);
      for (var i = 1; i <= 10; i++) {
        expect(m.contains('k$i'), isTrue);
      }
    });
  });

  group('IMapBuilder', () {
    test('empty builder produces empty map', () {
      expect(IMap.builder<String, int>().result(), imap({}));
    });

    test('addOne builds up to Map4', () {
      final b =
          IMap.builder<String, int>()
            ..addOne(('a', 1))
            ..addOne(('b', 2))
            ..addOne(('c', 3))
            ..addOne(('d', 4));
      final m = b.result();
      expect(m.size, 4);
      expect(m.get('a'), isSome(1));
      expect(m.get('d'), isSome(4));
    });

    test('addOne with 5th distinct key switches to IHashMap', () {
      final b =
          IMap.builder<String, int>()
            ..addOne(('a', 1))
            ..addOne(('b', 2))
            ..addOne(('c', 3))
            ..addOne(('d', 4))
            ..addOne(('e', 5));
      final m = b.result();
      expect(m.size, 5);
      for (final k in ['a', 'b', 'c', 'd', 'e']) {
        expect(m.contains(k), isTrue);
      }
    });

    test('addOne with duplicate key at size 4 stays in small-map path', () {
      // When size == 4 and the key already exists, the builder should NOT
      // switch to IHashMap — it just updates the value in place.
      final b =
          IMap.builder<String, int>()
            ..addOne(('a', 1))
            ..addOne(('b', 2))
            ..addOne(('c', 3))
            ..addOne(('d', 4))
            ..addOne(('a', 99)); // duplicate of existing key
      final m = b.result();
      expect(m.size, 4);
      expect(m.get('a'), isSome(99));
    });

    test('addAll builds a correct map', () {
      final pairs = ilist([('x', 10), ('y', 20), ('z', 30)]);
      final m = IMap.builder<String, int>().addAll(pairs).result();
      expect(m, imap({'x': 10, 'y': 20, 'z': 30}));
    });

    test('clear resets builder', () {
      final b =
          IMap.builder<String, int>()
            ..addOne(('a', 1))
            ..addOne(('b', 2));
      b.clear();
      expect(b.result(), imap({}));
    });

    test('clear after switching to IHashMap resets completely', () {
      final b =
          IMap.builder<String, int>()
            ..addOne(('a', 1))
            ..addOne(('b', 2))
            ..addOne(('c', 3))
            ..addOne(('d', 4))
            ..addOne(('e', 5));
      b.clear();
      b.addOne(('z', 26));
      final m = b.result();
      expect(m.size, 1);
      expect(m.get('z'), isSome(26));
    });
  });

  group('IMap.from identity shortcut', () {
    test('from with _EmptyMap returns same instance', () {
      final empty = IMap.empty<String, int>();
      expect(identical(IMap.from(empty), empty), isTrue);
    });

    test('from with IHashMap returns same instance', () {
      final m = mapN(10);
      expect(identical(IMap.from(m), m), isTrue);
    });

    test('from with _Map1 returns same instance', () {
      final m = mapN(1);
      expect(identical(IMap.from(m), m), isTrue);
    });

    test('from with _Map4 returns same instance', () {
      final m = mapN(4);
      expect(identical(IMap.from(m), m), isTrue);
    });
  });

  group('IMap.fromDartIterable', () {
    test('empty iterable gives empty map', () {
      expect(IMap.fromDartIterable<String, int>([]), imap({}));
    });

    test('converts dart iterable of tuples', () {
      final pairs = [('a', 1), ('b', 2), ('c', 3)];
      expect(IMap.fromDartIterable(pairs), imap({'a': 1, 'b': 2, 'c': 3}));
    });

    test('later duplicate keys win', () {
      final pairs = [('a', 1), ('a', 99)];
      final m = IMap.fromDartIterable(pairs);
      expect(m.size, 1);
      expect(m.get('a'), isSome(99));
    });
  });

  group('updatedWith', () {
    final m = imap({'a': 1, 'b': 2});

    test('key absent, function returns None -> unchanged', () {
      final m2 = m.updatedWith('z', (v) => none());
      expect(m2, m);
      expect(m2.size, 2);
    });

    test('key absent, function returns Some -> inserted', () {
      final m2 = m.updatedWith('z', (v) => const Some(99));
      expect(m2.size, 3);
      expect(m2.get('z'), isSome(99));
    });

    test('key present, function returns None -> removed', () {
      final m2 = m.updatedWith('a', (_) => none());
      expect(m2.size, 1);
      expect(m2.get('a'), isNone());
    });

    test('key present, function returns Some -> updated', () {
      final m2 = m.updatedWith('a', (v) => v.map((n) => n * 10));
      expect(m2.size, 2);
      expect(m2.get('a'), isSome(10));
    });
  });

  group('withDefault', () {
    test('get returns default for missing key', () {
      final m = imap({'a': 1}).withDefault((String k) => k.length);
      expect(m['a'], 1);
      expect(m['missing'], 7);
    });

    test('removed preserves default function', () {
      final m = imap({'a': 1, 'b': 2}).withDefault((String k) => k.length);
      final m2 = m.removed('a');
      expect(m2['a'], 1); // default is k.length for 'a' which is 1
      expect(m2['b'], 2);
    });

    test('updated preserves default function', () {
      final m = imap({'a': 1}).withDefault((String _) => 999);
      final m2 = m.updated('b', 2);
      expect(m2['b'], 2);
      expect(m2['z'], 999); // default still works
    });

    test('withDefaultValue uses constant', () {
      final m = imap({'a': 1}).withDefaultValue(0);
      expect(m['a'], 1);
      expect(m['z'], 0);
    });

    test('isEmpty, size, keys, values delegate to underlying', () {
      final m = imap({'a': 1, 'b': 2}).withDefault((String _) => 0);
      expect(m.size, 2);
      expect(m.isEmpty, isFalse);
      expect(m.keys, iset(['a', 'b']));
      expect(m.values.toISet(), iset([1, 2]));
    });

    test('get still returns None via get() (default only via operator[])', () {
      final m = imap({'a': 1}).withDefault((String _) => 999);
      expect(m.get('z'), isNone());
    });
  });

  group('equality edge cases', () {
    test('different types are not equal', () {
      final m = imap({'a': 1});
      // ignore: unrelated_type_equality_checks
      expect(m == 'not a map', isFalse);
    });

    test('maps with same keys but different values are not equal', () {
      expect(imap({'a': 1}) == imap({'a': 2}), isFalse);
    });

    test('maps with different key counts are not equal', () {
      expect(imap({'a': 1}) == imap({'a': 1, 'b': 2}), isFalse);
    });

    test('empty maps are equal', () {
      expect(IMap.empty<String, int>() == IMap.empty<String, int>(), isTrue);
    });

    test('large maps with same content are equal', () {
      expect(mapN(10) == mapN(10), isTrue);
    });

    test('large maps with different content are not equal', () {
      final m1 = mapN(10);
      final m2 = m1.updated('k1', 999);
      expect(m1 == m2, isFalse);
    });
  });
}
