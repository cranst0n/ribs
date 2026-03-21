// Comprehensive tests for BitmapIndexedMapNode and HashCollisionMapNode.
//
// Most paths are exercised via the IHashMap public API; direct node-level tests
// cover operations that are not reachable through that API (replaceValue=false,
// concat, transform, foreachEntry/foreachWithHash, copy, apply, getTuple, etc.).

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/hashing.dart';
import 'package:ribs_core/src/collection/immutable/map/map_node.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

/// All instances share the same hashCode, forcing HashCollisionMapNode.
class _CK {
  final String name;
  const _CK(this.name);

  @override
  int get hashCode => 0xABCDEF;

  @override
  bool operator ==(Object other) => other is _CK && name == other.name;

  @override
  String toString() => 'CK($name)';
}

/// Build a BitmapIndexedMapNode from a plain Dart map.
BitmapIndexedMapNode<K, V> _nodeOf<K, V>(Map<K, V> pairs) {
  var node = MapNode.empty<K, V>();
  for (final e in pairs.entries) {
    final h = e.key.hashCode;
    node = node.updated(e.key, e.value, h, Hashing.improve(h), 0, true);
  }
  return node;
}

/// Collect all entries from a node into a plain Dart map.
Map<K, V> _drain<K, V>(MapNode<K, V> node) {
  final out = <K, V>{};
  node.foreach((kv) => out[kv.$1] = kv.$2);
  return out;
}

int _h(dynamic key) => Hashing.improve(key.hashCode);

void main() {
  group('MapNode.empty', () {
    test('has size 0', () {
      expect(MapNode.empty<String, int>().size, 0);
    });

    test('hasPayload is false', () {
      expect(MapNode.empty<String, int>().hasPayload, isFalse);
    });

    test('hasNodes is false', () {
      expect(MapNode.empty<String, int>().hasNodes, isFalse);
    });

    test('payloadArity is 0', () {
      expect(MapNode.empty<String, int>().payloadArity, 0);
    });

    test('nodeArity is 0', () {
      expect(MapNode.empty<String, int>().nodeArity, 0);
    });

    test('get returns None', () {
      final n = MapNode.empty<String, int>();
      expect(n.get('k', 'k'.hashCode, _h('k'), 0), isNone());
    });

    test('containsKey returns false', () {
      final n = MapNode.empty<String, int>();
      expect(n.containsKey('k', 'k'.hashCode, _h('k'), 0), isFalse);
    });

    test('foreach visits nothing', () {
      var count = 0;
      MapNode.empty<String, int>().foreach((_) => count++);
      expect(count, 0);
    });

    test('filterImpl returns empty', () {
      final filtered = MapNode.empty<String, int>().filterImpl((_) => true, false);
      expect(filtered.size, 0);
    });
  });

  group('BitmapIndexedMapNode flat: 1 - 4 entries', () {
    test('single entry: size, hasPayload, payloadArity', () {
      final n = _nodeOf({'a': 1});
      expect(n.size, 1);
      expect(n.hasPayload, isTrue);
      expect(n.hasNodes, isFalse);
      expect(n.payloadArity, 1);
      expect(n.nodeArity, 0);
    });

    test('get hit and miss', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      expect(n.get('a', 'a'.hashCode, _h('a'), 0), isSome(1));
      expect(n.get('b', 'b'.hashCode, _h('b'), 0), isSome(2));
      expect(n.get('z', 'z'.hashCode, _h('z'), 0), isNone());
    });

    test('getOrElse hit returns value, miss invokes default', () {
      final n = _nodeOf({'a': 1});
      expect(n.getOrElse('a', 'a'.hashCode, _h('a'), 0, () => 99), 1);
      expect(n.getOrElse('z', 'z'.hashCode, _h('z'), 0, () => 99), 99);
    });

    test('containsKey', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      expect(n.containsKey('a', 'a'.hashCode, _h('a'), 0), isTrue);
      expect(n.containsKey('z', 'z'.hashCode, _h('z'), 0), isFalse);
    });

    test('apply hit returns value', () {
      final n = _nodeOf({'x': 42});
      expect(n.apply('x', 'x'.hashCode, _h('x'), 0), 42);
    });

    test('apply miss throws', () {
      final n = _nodeOf({'x': 42});
      expect(() => n.apply('z', 'z'.hashCode, _h('z'), 0), throwsA(isA<UnsupportedError>()));
    });

    test('getTuple hit returns pair', () {
      final n = _nodeOf({'a': 1});
      expect(n.getTuple('a', 'a'.hashCode, _h('a'), 0), ('a', 1));
    });

    test('getTuple miss throws', () {
      final n = _nodeOf({'a': 1});
      expect(() => n.getTuple('z', 'z'.hashCode, _h('z'), 0), throwsA(anything));
    });

    test('getPayload, getKey, getValue, getHash', () {
      final n = _nodeOf({'only': 7});
      expect(n.getPayload(0), ('only', 7));
      expect(n.getKey(0), 'only');
      expect(n.getValue(0), 7);
      expect(n.getHash(0), 'only'.hashCode);
    });

    test('updated: new key inserts and increases size', () {
      final n0 = _nodeOf({'a': 1});
      final h = 'b'.hashCode;
      final n1 = n0.updated('b', 2, h, Hashing.improve(h), 0, true);
      expect(n1.size, 2);
      expect(n1.get('a', 'a'.hashCode, _h('a'), 0), isSome(1));
      expect(n1.get('b', h, Hashing.improve(h), 0), isSome(2));
    });

    test('updated replaceValue=true, same value → returns same node', () {
      final n = _nodeOf({'a': 1});
      final n2 = n.updated('a', 1, 'a'.hashCode, _h('a'), 0, true);
      expect(identical(n, n2), isTrue);
    });

    test('updated replaceValue=true, different value → new node with updated value', () {
      final n = _nodeOf({'a': 1});
      final n2 = n.updated('a', 99, 'a'.hashCode, _h('a'), 0, true);
      expect(n2.get('a', 'a'.hashCode, _h('a'), 0), isSome(99));
      expect(n2.size, 1);
    });

    test('updated replaceValue=false, existing key → same node', () {
      final n = _nodeOf({'a': 1});
      final n2 = n.updated('a', 999, 'a'.hashCode, _h('a'), 0, false);
      expect(identical(n, n2), isTrue);
      expect(n2.get('a', 'a'.hashCode, _h('a'), 0), isSome(1));
    });

    test('removed existing key → size decreases', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final n2 = n.removed('a', 'a'.hashCode, _h('a'), 0);
      expect(n2.size, 1);
      expect(n2.get('a', 'a'.hashCode, _h('a'), 0), isNone());
      expect(n2.get('b', 'b'.hashCode, _h('b'), 0), isSome(2));
    });

    test('removed second key when two flat entries (index 0)', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final n2 = n.removed('b', 'b'.hashCode, _h('b'), 0);
      expect(n2.size, 1);
      expect(n2.get('b', 'b'.hashCode, _h('b'), 0), isNone());
    });

    test('removed missing key → same node', () {
      final n = _nodeOf({'a': 1});
      final n2 = n.removed('z', 'z'.hashCode, _h('z'), 0);
      expect(identical(n, n2), isTrue);
    });

    test('foreach visits all entries', () {
      final n = _nodeOf({'a': 1, 'b': 2, 'c': 3});
      final seen = <String, int>{};
      n.foreach((kv) => seen[kv.$1] = kv.$2);
      expect(seen, {'a': 1, 'b': 2, 'c': 3});
    });

    test('foreachEntry visits all entries', () {
      final n = _nodeOf({'x': 10, 'y': 20});
      final keys = <String>[];
      final values = <int>[];
      n.foreachEntry((k, v) {
        keys.add(k);
        values.add(v);
      });
      expect(keys.toSet(), {'x', 'y'});
      expect(values.toSet(), {10, 20});
    });

    test('foreachWithHash provides correct original hash', () {
      final n = _nodeOf({'a': 1});
      int? capturedHash;
      n.foreachWithHash((k, v, h) => capturedHash = h);
      expect(capturedHash, 'a'.hashCode);
    });

    test('transform identity (no value changes) → returns same node', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final n2 = n.transform<int>((k, v) => v);
      expect(identical(n, n2), isTrue);
    });

    test('transform with changes → new node with transformed values', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final n2 = n.transform<String>((k, v) => '$k=$v');
      expect(_drain(n2), {'a': 'a=1', 'b': 'b=2'});
    });

    test('copy is a deep-independent copy', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final c = n.copy();
      expect(c == n, isTrue);
      expect(identical(c, n), isFalse);
    });

    test('filterImpl all pass → same node', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final n2 = n.filterImpl((_) => true, false);
      expect(identical(n, n2), isTrue);
    });

    test('filterImpl none pass → empty node', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final n2 = n.filterImpl((_) => false, false);
      expect(n2.size, 0);
    });

    test('filterImpl flipped=true (filterNot semantics)', () {
      final n = _nodeOf({'a': 1, 'b': 2, 'c': 3});
      // flipped=true means pred is the complement, so pred==(v>1) keeps v<=1
      final n2 = n.filterImpl((kv) => kv.$2 > 1, true);
      expect(_drain(n2), {'a': 1});
    });

    test('filterImpl some pass → new node', () {
      final n = _nodeOf({'a': 1, 'b': 2, 'c': 3});
      final n2 = n.filterImpl((kv) => kv.$2 >= 2, false);
      expect(n2.size, 2);
      expect(n2.get('a', 'a'.hashCode, _h('a'), 0), isNone());
      expect(n2.get('b', 'b'.hashCode, _h('b'), 0), isSome(2));
      expect(n2.get('c', 'c'.hashCode, _h('c'), 0), isSome(3));
    });

    test('equality: same content', () {
      final n1 = _nodeOf({'a': 1, 'b': 2});
      final n2 = _nodeOf({'a': 1, 'b': 2});
      expect(n1 == n2, isTrue);
    });

    test('equality: different values', () {
      final n1 = _nodeOf({'a': 1});
      final n2 = _nodeOf({'a': 2});
      expect(n1 == n2, isFalse);
    });

    test('equality: different keys', () {
      expect(_nodeOf({'a': 1}) == _nodeOf({'b': 1}), isFalse);
    });

    test('equality: different node type → false', () {
      // ignore: unrelated_type_equality_checks
      expect(_nodeOf({'a': 1}) == 'not a node', isFalse);
    });
  });

  group('BitmapIndexedMapNode deep (40 entries)', () {
    // 40 > 32 (branching factor), so by pigeonhole principle the node will
    // have sub-nodes.
    late BitmapIndexedMapNode<String, int> deep;
    setUp(() {
      deep = _nodeOf(Map.fromEntries(List.generate(40, (i) => MapEntry('k$i', i))));
    });

    test('size is 40', () => expect(deep.size, 40));

    test('has sub-nodes', () => expect(deep.hasNodes, isTrue));

    test('get all keys', () {
      for (var i = 0; i < 40; i++) {
        final k = 'k$i';
        expect(deep.get(k, k.hashCode, _h(k), 0), isSome(i));
      }
    });

    test('get missing key', () {
      expect(deep.get('zzz', 'zzz'.hashCode, _h('zzz'), 0), isNone());
    });

    test('containsKey all keys', () {
      for (var i = 0; i < 40; i++) {
        final k = 'k$i';
        expect(deep.containsKey(k, k.hashCode, _h(k), 0), isTrue);
      }
    });

    test('foreach visits all 40 entries', () {
      final out = <String, int>{};
      deep.foreach((kv) => out[kv.$1] = kv.$2);
      expect(out.length, 40);
      for (var i = 0; i < 40; i++) {
        expect(out['k$i'], i);
      }
    });

    test('foreachEntry visits all entries', () {
      var count = 0;
      deep.foreachEntry((k, v) => count++);
      expect(count, 40);
    });

    test('foreachWithHash provides original hash for all entries', () {
      deep.foreachWithHash((k, v, h) {
        expect(h, k.hashCode);
      });
    });

    test('removed existing key reduces size by 1', () {
      final n2 = deep.removed('k0', 'k0'.hashCode, _h('k0'), 0);
      expect(n2.size, 39);
      expect(n2.get('k0', 'k0'.hashCode, _h('k0'), 0), isNone());
    });

    test('removed all keys results in empty', () {
      MapNode<String, int> n = deep;
      for (var i = 0; i < 40; i++) {
        final k = 'k$i';
        n = n.removed(k, k.hashCode, _h(k), 0);
      }
      expect(n.size, 0);
    });

    test('filterImpl keeping half the entries', () {
      final n2 = deep.filterImpl((kv) => kv.$2 < 20, false);
      expect(n2.size, 20);
      for (var i = 0; i < 20; i++) {
        final k = 'k$i';
        expect(n2.get(k, k.hashCode, _h(k), 0), isSome(i));
      }
    });

    test('filterImpl keeping none → empty', () {
      final n2 = deep.filterImpl((_) => false, false);
      expect(n2.size, 0);
    });

    test('transform values', () {
      final n2 = deep.transform<String>((k, v) => '${v * 2}');
      for (var i = 0; i < 40; i++) {
        final k = 'k$i';
        expect(n2.get(k, k.hashCode, _h(k), 0), isSome('${i * 2}'));
      }
    });

    test('transform identity returns same node', () {
      final n2 = deep.transform<int>((k, v) => v);
      expect(identical(deep, n2), isTrue);
    });

    test('copy is independent', () {
      final c = deep.copy();
      expect(c == deep, isTrue);
      expect(identical(c, deep), isFalse);
    });
  });

  group('BitmapIndexedMapNode.concat', () {
    test('empty concat non-empty → non-empty', () {
      final empty = MapNode.empty<String, int>();
      final right = _nodeOf({'a': 1, 'b': 2});
      final result = empty.concat(right, 0);
      expect(identical(result, right), isTrue);
    });

    test('non-empty concat empty → non-empty', () {
      final left = _nodeOf({'a': 1, 'b': 2});
      final empty = MapNode.empty<String, int>();
      final result = left.concat(empty, 0);
      expect(identical(result, left), isTrue);
    });

    test('node concat itself → itself', () {
      final n = _nodeOf({'a': 1, 'b': 2});
      final result = n.concat(n, 0);
      expect(identical(result, n), isTrue);
    });

    test('concat single-elem right: result has all keys', () {
      final left = _nodeOf({'a': 1, 'b': 2});
      final right = _nodeOf({'c': 3});
      final result = left.concat(right, 0);
      expect(result.size, 3);
      expect(_drain(result), {'a': 1, 'b': 2, 'c': 3});
    });

    test('concat disjoint nodes: all keys present', () {
      final left = _nodeOf({'a': 1, 'b': 2, 'c': 3});
      final right = _nodeOf({'d': 4, 'e': 5, 'f': 6});
      final result = left.concat(right, 0);
      expect(result.size, 6);
      expect(_drain(result), {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5, 'f': 6});
    });

    test('concat overlapping keys: right overwrites left', () {
      final left = _nodeOf({'a': 1, 'b': 2, 'c': 3});
      final right = _nodeOf({'b': 99, 'c': 100, 'd': 4});
      final result = left.concat(right, 0);
      expect(result.size, 4);
      final m = _drain(result);
      expect(m['a'], 1);
      expect(m['b'], 99); // right wins
      expect(m['c'], 100); // right wins
      expect(m['d'], 4);
    });

    test('concat large nodes', () {
      final left = _nodeOf(Map.fromEntries(List.generate(20, (i) => MapEntry('L$i', i))));
      final right = _nodeOf(Map.fromEntries(List.generate(20, (i) => MapEntry('R$i', i))));
      final result = left.concat(right, 0);
      expect(result.size, 40);
    });

    test('concat with partial overlap', () {
      final left = _nodeOf({'a': 1, 'b': 2, 'c': 3, 'd': 4});
      final right = _nodeOf({'c': 30, 'd': 40, 'e': 5, 'f': 6});
      final result = left.concat(right, 0);
      expect(result.size, 6);
      final m = _drain(result);
      expect(m['a'], 1);
      expect(m['b'], 2);
      expect(m['c'], 30);
      expect(m['d'], 40);
      expect(m['e'], 5);
      expect(m['f'], 6);
    });

    test('concat with HashCollisionMapNode throws', () {
      final bmNode = _nodeOf({'a': 1});
      final hcNode = HashCollisionMapNode<String, int>(
        42,
        Hashing.improve(42),
        ivec([('b', 2)]),
      );
      expect(() => bmNode.concat(hcNode, 0), throwsUnsupportedError);
    });
  });

  group('HashCollisionMapNode direct', () {
    const origHash = 0xABCDEF;
    late final improvedHash = Hashing.improve(origHash);

    HashCollisionMapNode<_CK, int> hcNode(Map<String, int> entries) =>
        HashCollisionMapNode<_CK, int>(
          origHash,
          Hashing.improve(origHash),
          IVector.fromDart(entries.entries.map((e) => (_CK(e.key), e.value)).toList()),
        );

    test('size equals number of entries', () {
      expect(hcNode({'a': 1, 'b': 2}).size, 2);
      expect(hcNode({'a': 1, 'b': 2, 'c': 3}).size, 3);
    });

    test('hasPayload is true, hasNodes is false', () {
      final n = hcNode({'a': 1});
      expect(n.hasPayload, isTrue);
      expect(n.hasNodes, isFalse);
    });

    test('nodeArity is 0', () {
      expect(hcNode({'a': 1, 'b': 2}).nodeArity, 0);
    });

    test('payloadArity equals size', () {
      final n = hcNode({'a': 1, 'b': 2, 'c': 3});
      expect(n.payloadArity, 3);
    });

    test('get: existing key returns Some', () {
      final n = hcNode({'a': 1, 'b': 2});
      expect(n.get(const _CK('a'), origHash, improvedHash, 0), isSome(1));
      expect(n.get(const _CK('b'), origHash, improvedHash, 0), isSome(2));
    });

    test('get: absent key (same hash) returns None', () {
      final n = hcNode({'a': 1});
      expect(n.get(const _CK('z'), origHash, improvedHash, 0), isNone());
    });

    test('get: wrong hash returns None', () {
      final n = hcNode({'a': 1});
      expect(n.get(const _CK('a'), 0, Hashing.improve(0), 0), isNone());
    });

    test('getOrElse: hit returns value', () {
      final n = hcNode({'a': 42});
      expect(n.getOrElse(const _CK('a'), origHash, improvedHash, 0, () => -1), 42);
    });

    test('getOrElse: miss invokes default', () {
      final n = hcNode({'a': 42});
      expect(n.getOrElse(const _CK('z'), origHash, improvedHash, 0, () => -1), -1);
    });

    test('getOrElse: wrong hash invokes default', () {
      final n = hcNode({'a': 42});
      expect(n.getOrElse(const _CK('a'), 0, Hashing.improve(0), 0, () => -1), -1);
    });

    test('containsKey: hit and miss', () {
      final n = hcNode({'a': 1, 'b': 2});
      expect(n.containsKey(const _CK('a'), origHash, improvedHash, 0), isTrue);
      expect(n.containsKey(const _CK('z'), origHash, improvedHash, 0), isFalse);
    });

    test('containsKey: wrong hash → false', () {
      final n = hcNode({'a': 1});
      expect(n.containsKey(const _CK('a'), 0, Hashing.improve(0), 0), isFalse);
    });

    test('apply: existing key returns value', () {
      final n = hcNode({'a': 7});
      expect(n.apply(const _CK('a'), origHash, improvedHash, 0), 7);
    });

    test('apply: missing key throws', () {
      final n = hcNode({'a': 7});
      expect(() => n.apply(const _CK('z'), origHash, improvedHash, 0), throwsA(anything));
    });

    test('getTuple: existing key returns pair', () {
      final n = hcNode({'a': 5});
      expect(n.getTuple(const _CK('a'), origHash, improvedHash, 0), (const _CK('a'), 5));
    });

    test('getTuple: missing key throws', () {
      final n = hcNode({'a': 5});
      expect(() => n.getTuple(const _CK('z'), origHash, improvedHash, 0), throwsA(anything));
    });

    test('getPayload, getKey, getValue, getHash', () {
      final n = hcNode({'a': 10});
      expect(n.getPayload(0).$2, 10);
      expect(n.getKey(0), const _CK('a'));
      expect(n.getValue(0), 10);
      expect(n.getHash(0), origHash); // all entries share same original hash
    });

    test('updated replaceValue=true, same value → same node', () {
      final n = hcNode({'a': 1});
      final n2 = n.updated(const _CK('a'), 1, origHash, improvedHash, 0, true);
      expect(identical(n, n2), isTrue);
    });

    test('updated replaceValue=true, different value → new node', () {
      final n = hcNode({'a': 1, 'b': 2});
      final n2 = n.updated(const _CK('a'), 99, origHash, improvedHash, 0, true);
      expect(n2.size, 2);
      expect(n2.get(const _CK('a'), origHash, improvedHash, 0), isSome(99));
      expect(n2.get(const _CK('b'), origHash, improvedHash, 0), isSome(2));
    });

    test('updated replaceValue=false, existing key → same node', () {
      final n = hcNode({'a': 1});
      final n2 = n.updated(const _CK('a'), 999, origHash, improvedHash, 0, false);
      expect(identical(n, n2), isTrue);
    });

    test('updated new key (same hash) → larger node', () {
      final n = hcNode({'a': 1});
      final n2 = n.updated(const _CK('b'), 2, origHash, improvedHash, 0, true);
      expect(n2.size, 2);
      expect(n2.get(const _CK('b'), origHash, improvedHash, 0), isSome(2));
    });

    test('removed existing key (>1 remaining) → smaller HashCollision node', () {
      final n = hcNode({'a': 1, 'b': 2, 'c': 3});
      final n2 = n.removed(const _CK('b'), origHash, improvedHash, 0);
      expect(n2.size, 2);
      expect(n2.get(const _CK('b'), origHash, improvedHash, 0), isNone());
      expect(n2.get(const _CK('a'), origHash, improvedHash, 0), isSome(1));
      expect(n2.get(const _CK('c'), origHash, improvedHash, 0), isSome(3));
      expect(n2, isA<HashCollisionMapNode<_CK, int>>());
    });

    test('removed existing key (1 remaining) → BitmapIndexedMapNode', () {
      final n = hcNode({'a': 1, 'b': 2});
      final n2 = n.removed(const _CK('a'), origHash, improvedHash, 0);
      expect(n2.size, 1);
      expect(n2, isA<BitmapIndexedMapNode<_CK, int>>());
      expect(n2.get(const _CK('b'), origHash, improvedHash, 0), isSome(2));
    });

    test('removed absent key → same node', () {
      final n = hcNode({'a': 1, 'b': 2});
      final n2 = n.removed(const _CK('z'), origHash, improvedHash, 0);
      expect(identical(n, n2), isTrue);
    });

    test('foreach visits all entries', () {
      final n = hcNode({'a': 1, 'b': 2, 'c': 3});
      final out = <String, int>{};
      n.foreach((kv) => out[kv.$1.name] = kv.$2);
      expect(out, {'a': 1, 'b': 2, 'c': 3});
    });

    test('foreachEntry visits all entries', () {
      final n = hcNode({'x': 10, 'y': 20});
      final keys = <String>[];
      n.foreachEntry((k, v) => keys.add(k.name));
      expect(keys.toSet(), {'x', 'y'});
    });

    test('foreachWithHash provides originalHash for all entries', () {
      final n = hcNode({'a': 1, 'b': 2});
      final hashes = <int>[];
      n.foreachWithHash((k, v, h) => hashes.add(h));
      expect(hashes, everyElement(origHash));
    });

    test('filterImpl all pass → same node', () {
      final n = hcNode({'a': 1, 'b': 2});
      final n2 = n.filterImpl((_) => true, false);
      expect(identical(n, n2), isTrue);
    });

    test('filterImpl none pass → empty node', () {
      final n = hcNode({'a': 1, 'b': 2});
      final n2 = n.filterImpl((_) => false, false);
      expect(n2.size, 0);
    });

    test('filterImpl one remains → BitmapIndexedMapNode', () {
      final n = hcNode({'a': 1, 'b': 2, 'c': 3});
      final n2 = n.filterImpl((kv) => kv.$1 == const _CK('a'), false);
      expect(n2.size, 1);
      expect(n2, isA<BitmapIndexedMapNode<_CK, int>>());
    });

    test('filterImpl multiple remain → HashCollisionMapNode', () {
      final n = hcNode({'a': 1, 'b': 2, 'c': 3, 'd': 4});
      final n2 = n.filterImpl((kv) => kv.$2 <= 2, false);
      expect(n2.size, 2);
      expect(n2, isA<HashCollisionMapNode<_CK, int>>());
    });

    test('filterImpl flipped (filterNot semantics)', () {
      final n = hcNode({'a': 1, 'b': 2, 'c': 3});
      // flipped=true → keep entries where pred is FALSE
      final n2 = n.filterImpl((kv) => kv.$2 == 2, true);
      expect(n2.size, 2);
      expect(n2.get(const _CK('b'), origHash, improvedHash, 0), isNone());
    });

    test('transform identity → same node', () {
      final n = hcNode({'a': 1, 'b': 2});
      final n2 = n.transform<int>((k, v) => v);
      expect(identical(n, n2), isTrue);
    });

    test('transform with changes → new node', () {
      final n = hcNode({'a': 1, 'b': 2});
      final n2 = n.transform<String>((k, v) => '${k.name}:$v');
      expect(n2, isA<HashCollisionMapNode<_CK, String>>());
      expect(n2.size, 2);
    });

    test('copy → same content, different instance', () {
      final n = hcNode({'a': 1, 'b': 2});
      final c = n.copy();
      expect(c == n, isTrue);
      expect(identical(c, n), isFalse);
    });

    test('concat with itself → same node', () {
      final n = hcNode({'a': 1, 'b': 2});
      final result = n.concat(n, 0);
      expect(identical(result, n), isTrue);
    });

    test('concat two different collision nodes → right overwrites left', () {
      final left = hcNode({'a': 1, 'b': 2});
      // Build right with same hash but different values
      final right = HashCollisionMapNode<_CK, int>(
        origHash,
        Hashing.improve(origHash),
        ivec([(const _CK('b'), 99), (const _CK('c'), 3)]),
      );
      final result = left.concat(right, 0) as HashCollisionMapNode<_CK, int>;
      expect(result.size, 3);
      expect(result.get(const _CK('a'), origHash, improvedHash, 0), isSome(1));
      expect(result.get(const _CK('b'), origHash, improvedHash, 0), isSome(99));
      expect(result.get(const _CK('c'), origHash, improvedHash, 0), isSome(3));
    });

    test('concat with left not in right → appended', () {
      final left = hcNode({'a': 1, 'b': 2});
      final right = hcNode({'c': 3, 'd': 4});
      final result = left.concat(right, 0) as HashCollisionMapNode<_CK, int>;
      expect(result.size, 4);
    });

    test('concat with BitmapIndexedMapNode throws', () {
      final n = hcNode({'a': 1});
      final bmNode = MapNode.empty<_CK, int>().updated(
        const _CK('x'),
        1,
        const _CK('x').hashCode,
        Hashing.improve(const _CK('x').hashCode),
        0,
        true,
      );
      expect(() => n.concat(bmNode, 0), throwsUnsupportedError);
    });

    test('equality: same content', () {
      final n1 = hcNode({'a': 1, 'b': 2});
      final n2 = hcNode({'a': 1, 'b': 2});
      expect(n1 == n2, isTrue);
    });

    test('equality: different values', () {
      expect(hcNode({'a': 1}) == hcNode({'a': 2}), isFalse);
    });

    test('equality: missing key', () {
      expect(hcNode({'a': 1, 'b': 2}) == hcNode({'a': 1}), isFalse);
    });

    test('equality: different type → false', () {
      // ignore: unrelated_type_equality_checks
      expect(hcNode({'a': 1}) == 'not a node', isFalse);
    });
  });

  group('HashCollisionMapNode via IHashMap (same-hashCode keys)', () {
    // All _CK instances have the same hashCode → they end up in a
    // HashCollisionMapNode inside the IHashMap trie.

    test('insert and retrieve multiple colliding keys', () {
      var m = IMap.empty<_CK, int>();
      m = m.updated(const _CK('a'), 1).updated(const _CK('b'), 2).updated(const _CK('c'), 3);
      expect(m.size, 3);
      expect(m.get(const _CK('a')), isSome(1));
      expect(m.get(const _CK('b')), isSome(2));
      expect(m.get(const _CK('c')), isSome(3));
      expect(m.get(const _CK('z')), isNone());
    });

    test('update existing colliding key', () {
      final m = IMap.empty<_CK, int>()
          .updated(const _CK('a'), 1)
          .updated(const _CK('b'), 2)
          .updated(const _CK('a'), 99);
      expect(m.size, 2);
      expect(m.get(const _CK('a')), isSome(99));
    });

    test('remove one colliding key leaves others', () {
      final m = IMap.empty<_CK, int>()
          .updated(const _CK('a'), 1)
          .updated(const _CK('b'), 2)
          .updated(const _CK('c'), 3)
          .removed(const _CK('b'));
      expect(m.size, 2);
      expect(m.get(const _CK('b')), isNone());
      expect(m.get(const _CK('a')), isSome(1));
      expect(m.get(const _CK('c')), isSome(3));
    });

    test('remove colliding key down to 1 entry', () {
      final m = IMap.empty<_CK, int>()
          .updated(const _CK('a'), 1)
          .updated(const _CK('b'), 2)
          .removed(const _CK('a'));
      expect(m.size, 1);
      expect(m.get(const _CK('b')), isSome(2));
    });

    test('remove all colliding keys → empty map', () {
      var m = IMap.empty<_CK, int>().updated(const _CK('a'), 1).updated(const _CK('b'), 2);
      m = m.removed(const _CK('a')).removed(const _CK('b'));
      expect(m.isEmpty, isTrue);
    });

    test('contains with colliding keys', () {
      final m = IMap.empty<_CK, int>().updated(const _CK('a'), 1).updated(const _CK('b'), 2);
      expect(m.contains(const _CK('a')), isTrue);
      expect(m.contains(const _CK('z')), isFalse);
    });

    test('filter on colliding keys', () {
      final m = IMap.empty<_CK, int>()
          .updated(const _CK('a'), 1)
          .updated(const _CK('b'), 2)
          .updated(const _CK('c'), 3)
          .filter((kv) => kv.$2 > 1);
      expect(m.size, 2);
      expect(m.get(const _CK('a')), isNone());
    });

    test('mapValues on colliding keys', () {
      final m = IMap.empty<_CK, int>()
          .updated(const _CK('a'), 1)
          .updated(const _CK('b'), 2)
          .mapValues((v) => v * 10);
      expect(m.get(const _CK('a')), isSome(10));
      expect(m.get(const _CK('b')), isSome(20));
    });

    test('equality of maps with colliding keys', () {
      final m1 = IMap.empty<_CK, int>().updated(const _CK('a'), 1).updated(const _CK('b'), 2);
      final m2 = IMap.empty<_CK, int>().updated(const _CK('a'), 1).updated(const _CK('b'), 2);
      expect(m1 == m2, isTrue);
    });

    test('keys and values accessible', () {
      final m = IMap.empty<_CK, int>().updated(const _CK('x'), 10).updated(const _CK('y'), 20);
      expect(m.keys.size, 2);
      expect(m.values.toIList().size, 2);
    });
  });

  group('sub-node escalation via IHashMap', () {
    // When an IHashMap contains only two colliding keys and one is removed,
    // the trie root escalates to the single remaining leaf.
    test('remove from 2-collision-key map → size 1 map', () {
      final m = IMap.empty<_CK, int>().updated(const _CK('a'), 1).updated(const _CK('b'), 2);
      final m2 = m.removed(const _CK('a'));
      expect(m2.size, 1);
      expect(m2.get(const _CK('b')), isSome(2));
    });

    test('map with only colliding keys is fully traversable', () {
      var m = IMap.empty<_CK, int>();
      for (var i = 0; i < 5; i++) {
        m = m.updated(_CK('k$i'), i);
      }
      final entries = m.toIList();
      expect(entries.size, 5);
    });
  });

  group('IHashMap concat via IMap.concat (indirect node paths)', () {
    test('concat two large maps', () {
      final m1 = IMap.fromDartIterable(
        List.generate(20, (i) => ('L$i', i)),
      );
      final m2 = IMap.fromDartIterable(
        List.generate(20, (i) => ('R$i', i)),
      );
      final result = m1.concat(m2);
      expect(result.size, 40);
    });

    test('concat with overlap: right overwrites', () {
      final m1 = imap({'a': 1, 'b': 2, 'c': 3});
      final m2 = imap({'b': 99, 'c': 100, 'd': 4});
      final result = m1.concat(m2);
      expect(result.get('b'), isSome(99));
      expect(result.get('c'), isSome(100));
      expect(result.get('a'), isSome(1));
      expect(result.get('d'), isSome(4));
    });
  });
}
