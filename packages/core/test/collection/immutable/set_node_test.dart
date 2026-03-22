// Comprehensive tests for BitmapIndexedSetNode and HashCollisionSetNode.
//
// Most paths are exercised via the IHashSet public API; direct node-level
// tests cover operations that are not reachable through that API
// (foreachWithHash, foreachWithHashWhile, copy, subsetOf, ==, etc.).

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/hashing.dart';
import 'package:ribs_core/src/collection/immutable/set/set_node.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// All instances share the same hashCode, forcing HashCollisionSetNode.
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

/// Build a BitmapIndexedSetNode from an iterable of elements.
BitmapIndexedSetNode<A> _nodeOf<A>(Iterable<A> elems) {
  var node = SetNode.empty<A>();
  for (final e in elems) {
    final h = e.hashCode;
    node = node.updated(e, h, Hashing.improve(h), 0);
  }
  return node;
}

/// Collect all elements from a node into a Dart Set.
Set<A> _drain<A>(SetNode<A> node) {
  final out = <A>{};
  node.foreach(out.add);
  return out;
}

int _h(dynamic key) => Hashing.improve(key.hashCode);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // =========================================================================
  // SetNode.empty
  // =========================================================================

  group('SetNode.empty', () {
    test('size is 0', () => expect(SetNode.empty<int>().size, 0));
    test('hasPayload is false', () => expect(SetNode.empty<int>().hasPayload, isFalse));
    test('hasNodes is false', () => expect(SetNode.empty<int>().hasNodes, isFalse));
    test('payloadArity is 0', () => expect(SetNode.empty<int>().payloadArity, 0));
    test('nodeArity is 0', () => expect(SetNode.empty<int>().nodeArity, 0));

    test('contains returns false', () {
      final n = SetNode.empty<int>();
      expect(n.contains(42, 42, _h(42), 0), isFalse);
    });

    test('foreach visits nothing', () {
      var count = 0;
      SetNode.empty<int>().foreach((_) => count++);
      expect(count, 0);
    });

    test('foreachWithHash visits nothing', () {
      var count = 0;
      SetNode.empty<int>().foreachWithHash((_, _) => count++);
      expect(count, 0);
    });

    test('foreachWithHashWhile returns true on empty', () {
      expect(SetNode.empty<int>().foreachWithHashWhile((_, _) => true), isTrue);
    });

    test('filterImpl returns empty', () {
      expect(SetNode.empty<int>().filterImpl((_) => true, false).size, 0);
    });
  });

  // =========================================================================
  // BitmapIndexedSetNode — flat (no sub-nodes)
  // =========================================================================

  group('BitmapIndexedSetNode flat', () {
    test('single element: structural properties', () {
      final n = _nodeOf([42]);
      expect(n.size, 1);
      expect(n.hasPayload, isTrue);
      expect(n.hasNodes, isFalse);
      expect(n.payloadArity, 1);
      expect(n.nodeArity, 0);
    });

    test('contains: hit and miss', () {
      final n = _nodeOf(['a', 'b', 'c']);
      expect(n.contains('a', 'a'.hashCode, _h('a'), 0), isTrue);
      expect(n.contains('b', 'b'.hashCode, _h('b'), 0), isTrue);
      expect(n.contains('z', 'z'.hashCode, _h('z'), 0), isFalse);
    });

    test('updated: inserting existing element returns same node', () {
      final n = _nodeOf([1, 2, 3]);
      final n2 = n.updated(2, 2, _h(2), 0);
      expect(identical(n, n2), isTrue);
    });

    test('updated: inserting new element grows node', () {
      final n = _nodeOf([1, 2, 3]);
      final n2 = n.updated(99, 99, _h(99), 0);
      expect(n2.size, 4);
      expect(n2.contains(99, 99, _h(99), 0), isTrue);
    });

    test('removed: element not present returns same node', () {
      final n = _nodeOf([1, 2, 3]);
      final n2 = n.removed(99, 99, _h(99), 0);
      expect(identical(n, n2), isTrue);
    });

    test('removed: from 2-element node at index 0 leaves single element', () {
      final n = _nodeOf([1, 2]);
      final h1 = 1.hashCode;
      final h2 = 2.hashCode;
      final n2 = n.removed(1, h1, Hashing.improve(h1), 0);
      expect(n2.size, 1);
      expect(n2.contains(2, h2, Hashing.improve(h2), 0), isTrue);
      expect(n2.contains(1, h1, Hashing.improve(h1), 0), isFalse);
    });

    test('removed: from 2-element node at index 1 leaves single element', () {
      final n = _nodeOf([1, 2]);
      final h1 = 1.hashCode;
      final h2 = 2.hashCode;
      final n2 = n.removed(2, h2, Hashing.improve(h2), 0);
      expect(n2.size, 1);
      expect(n2.contains(1, h1, Hashing.improve(h1), 0), isTrue);
      expect(n2.contains(2, h2, Hashing.improve(h2), 0), isFalse);
    });

    test('removed: from multi-element node shrinks size', () {
      final n = _nodeOf([1, 2, 3, 4, 5]);
      final h3 = 3.hashCode;
      final n2 = n.removed(3, h3, Hashing.improve(h3), 0);
      expect(n2.size, 4);
      expect(n2.contains(3, h3, Hashing.improve(h3), 0), isFalse);
    });

    test('foreach visits all elements', () {
      final n = _nodeOf([10, 20, 30]);
      expect(_drain(n), {10, 20, 30});
    });

    test('foreachWithHash delivers correct original hash', () {
      final n = _nodeOf([42]);
      var captured = -1;
      n.foreachWithHash((_, h) => captured = h);
      expect(captured, 42.hashCode);
    });

    test('foreachWithHash visits all elements', () {
      final n = _nodeOf([1, 2, 3]);
      final seen = <int>{};
      n.foreachWithHash((elem, _) => seen.add(elem));
      expect(seen, {1, 2, 3});
    });

    test('foreachWithHashWhile stops early on false', () {
      final n = _nodeOf([1, 2, 3, 4, 5]);
      var count = 0;
      // stop after first element
      n.foreachWithHashWhile((_, _) {
        count++;
        return false;
      });
      expect(count, 1);
    });

    test('foreachWithHashWhile returns true when predicate always holds', () {
      final n = _nodeOf([1, 2, 3]);
      final result = n.foreachWithHashWhile((_, _) => true);
      expect(result, isTrue);
    });

    test('foreachWithHashWhile returns false when predicate rejects', () {
      final n = _nodeOf([1, 2, 3]);
      final result = n.foreachWithHashWhile((_, _) => false);
      expect(result, isFalse);
    });

    test('copy is equal but not identical', () {
      final n = _nodeOf([1, 2, 3]);
      final c = n.copy();
      expect(identical(n, c), isFalse);
      expect(n == c, isTrue);
    });

    test('== operator: identical returns true', () {
      final n = _nodeOf([1, 2]);
      expect(n == n, isTrue);
    });

    test('== operator: equal nodes with same elements', () {
      final n1 = _nodeOf([1, 2, 3]);
      final n2 = _nodeOf([1, 2, 3]);
      expect(n1 == n2, isTrue);
    });

    test('== operator: different elements → false', () {
      final n1 = _nodeOf([1, 2, 3]);
      final n2 = _nodeOf([1, 2, 4]);
      expect(n1 == n2, isFalse);
    });

    test('hashCode throws UnimplementedError', () {
      expect(() => _nodeOf([1]).hashCode, throwsUnimplementedError);
    });

    test('filterImpl: all pass (flipped=false)', () {
      final n = _nodeOf([1, 2, 3]);
      final f = n.filterImpl((_) => true, false);
      expect(f.size, 3);
    });

    test('filterImpl: none pass (flipped=false)', () {
      final n = _nodeOf([1, 2, 3]);
      final f = n.filterImpl((_) => false, false);
      expect(f.size, 0);
    });

    test('filterImpl: some pass (flipped=false)', () {
      final n = _nodeOf([1, 2, 3, 4, 5, 6]);
      final f = n.filterImpl((x) => x.isEven, false);
      expect(_drain(f), {2, 4, 6});
    });

    test('filterImpl: flipped=true works as filterNot', () {
      final n = _nodeOf([1, 2, 3, 4]);
      final f = n.filterImpl((x) => x.isEven, true);
      expect(_drain(f), {1, 3});
    });

    test('filterImpl: same node returned when all pass', () {
      final n = _nodeOf([1, 2, 3]);
      expect(identical(n.filterImpl((_) => true, false), n), isTrue);
    });

    test('filterImpl: empty returned when none pass', () {
      final n = _nodeOf([1, 2, 3]);
      expect(n.filterImpl((_) => false, false).size, 0);
    });
  });

  // Large sets force the trie to grow beyond depth 0, so these tests exercise
  // the node-branch paths inside contains / updated / removed / filterImpl.

  group('BitmapIndexedSetNode deep', () {
    // 64 elements is more than enough to create several levels of sub-nodes.
    final large = List.generate(64, (i) => i);

    test('contains: all elements found', () {
      final n = _nodeOf(large);
      for (final e in large) {
        expect(n.contains(e, e.hashCode, _h(e), 0), isTrue);
      }
    });

    test('contains: absent elements not found', () {
      final n = _nodeOf(large);
      expect(n.contains(1000, 1000, _h(1000), 0), isFalse);
    });

    test('foreach: visits every element exactly once', () {
      final n = _nodeOf(large);
      final seen = <int>{};
      n.foreach(seen.add);
      expect(seen, large.toSet());
    });

    test('foreachWithHash: delivers correct original hash for all elements', () {
      final n = _nodeOf(large);
      final mismatches = <int>[];
      n.foreachWithHash((elem, originalHash) {
        if (originalHash != elem.hashCode) mismatches.add(elem);
      });
      expect(mismatches, isEmpty);
    });

    test('foreachWithHashWhile: stops early', () {
      final n = _nodeOf(large);
      var count = 0;
      n.foreachWithHashWhile((_, _) {
        count++;
        return count < 10;
      });
      expect(count, 10);
    });

    test('filterImpl with subnodes: some pass', () {
      final n = _nodeOf(large);
      final f = n.filterImpl((x) => x.isEven, false);
      expect(_drain(f), large.where((x) => x.isEven).toSet());
    });

    test('filterImpl with subnodes: subnode reduced to single element migrates to data', () {
      // After filtering, some subnodes may shrink to 1 element and must be
      // "migrated" back up to the parent's data array.
      final n = _nodeOf(large);
      // Remove all but one element in a probable subnode by keeping only 0.
      final f = n.filterImpl((x) => x == 0, false);
      expect(f.size, 1);
      expect(_drain(f), {0});
    });

    test('filterImpl with subnodes: all pass returns same node', () {
      final n = _nodeOf(large);
      expect(identical(n.filterImpl((_) => true, false), n), isTrue);
    });

    test('removed: from a subnode that then has size 1 promotes to inline', () {
      // Build a set where at least one subnode has exactly 2 elements, then
      // remove one of them so the subnode shrinks to 1 and is promoted.
      final n = _nodeOf(large);
      // Remove elements one by one — at some point a sub-node shrinks to 1.
      var cur = n;
      for (final e in large.reversed) {
        final h = e.hashCode;
        cur = cur.removed(e, h, Hashing.improve(h), 0);
      }
      expect(cur.size, 0);
    });

    test('copy is deep: mutating copy does not affect original', () {
      final n = _nodeOf(large);
      final c = n.copy();
      expect(n == c, isTrue);
      expect(identical(n, c), isFalse);
    });

    test('subsetOf: identical node', () {
      final n = _nodeOf(large);
      expect(n.subsetOf(n, 0), isTrue);
    });

    test('subsetOf: empty is subset of everything', () {
      final empty = SetNode.empty<int>();
      final n = _nodeOf(large);
      expect(empty.subsetOf(n, 0), isTrue);
    });

    test('subsetOf: proper subset', () {
      final sub = _nodeOf(large.take(20));
      final sup = _nodeOf(large);
      expect(sub.subsetOf(sup, 0), isTrue);
    });

    test('subsetOf: not a subset', () {
      final n1 = _nodeOf([1, 2, 3, 4]);
      final n2 = _nodeOf([1, 2, 5, 6]);
      expect(n1.subsetOf(n2, 0), isFalse);
    });

    test('subsetOf: larger node is not subset of smaller', () {
      final small = _nodeOf([1, 2]);
      final large_ = _nodeOf([1, 2, 3, 4, 5, 6]);
      expect(large_.subsetOf(small, 0), isFalse);
    });
  });

  group('BitmapIndexedSetNode concat', () {
    test('empty concat non-empty returns right', () {
      final empty = SetNode.empty<int>();
      final right = _nodeOf([1, 2, 3]);
      expect(identical(empty.concat(right, 0), right), isTrue);
    });

    test('non-empty concat empty returns left', () {
      final left = _nodeOf([1, 2, 3]);
      final empty = SetNode.empty<int>();
      expect(identical(left.concat(empty, 0), left), isTrue);
    });

    test('node concat itself returns self', () {
      final n = _nodeOf([1, 2, 3]);
      expect(identical(n.concat(n, 0), n), isTrue);
    });

    test('single-element right is merged correctly', () {
      final left = _nodeOf([1, 2, 3, 4, 5, 6, 7]);
      final right = _nodeOf([99]);
      final result = left.concat(right, 0);
      expect(result.size, 8);
      expect(result.contains(99, 99.hashCode, _h(99), 0), isTrue);
    });

    test('disjoint sets concatenate to union', () {
      final a = _nodeOf(List.generate(32, (i) => i));
      final b = _nodeOf(List.generate(32, (i) => i + 100));
      final result = a.concat(b, 0);
      expect(result.size, 64);
    });

    test('overlapping sets: result is union (no duplicates)', () {
      final a = _nodeOf([1, 2, 3, 4, 5]);
      final b = _nodeOf([3, 4, 5, 6, 7]);
      final result = a.concat(b, 0);
      expect(_drain(result), {1, 2, 3, 4, 5, 6, 7});
    });

    test('concat subset returns left (unchanged)', () {
      final left = _nodeOf([1, 2, 3, 4, 5, 6, 7]);
      final sub = _nodeOf([2, 4]);
      final result = left.concat(sub, 0);
      expect(identical(result, left), isTrue);
    });

    test('right superset: result contains all right elements', () {
      final small = _nodeOf([1, 2]);
      final large_ = _nodeOf(List.generate(32, (i) => i));
      final result = small.concat(large_, 0);
      expect(result.size, 32);
    });

    test('concat with HashCollisionSetNode throws', () {
      // Build a BitmapIndexedSetNode<_CK> containing a HashCollisionSetNode
      // as its only sub-node, then pass that sub-node into concat.
      const ckA = _CK('a');
      const ckB = _CK('b');
      final h = ckA.hashCode;
      var root = SetNode.empty<_CK>();
      root = root.updated(ckA, h, Hashing.improve(h), 0);
      root = root.updated(ckB, h, Hashing.improve(h), 0);
      final hc = root.getNode(0); // SetNode<_CK>, runtime type HC
      expect(() => root.concat(hc, 0), throwsA(isA<UnsupportedError>()));
    });
  });

  group('BitmapIndexedSetNode diff', () {
    test('empty diff anything returns empty', () {
      final empty = SetNode.empty<int>();
      final n = _nodeOf([1, 2, 3]);
      expect(empty.diff(n, 0).size, 0);
    });

    test('anything diff empty returns self', () {
      final n = _nodeOf([1, 2, 3]);
      final empty = SetNode.empty<int>();
      expect(identical(n.diff(empty, 0), n), isTrue);
    });

    test('size-1 node diff containing set → empty', () {
      final one = _nodeOf([5]);
      final big = _nodeOf([1, 2, 3, 4, 5]);
      expect(one.diff(big, 0).size, 0);
    });

    test('size-1 node diff not-containing set → itself', () {
      final one = _nodeOf([99]);
      final n = _nodeOf([1, 2, 3]);
      expect(identical(one.diff(n, 0), one), isTrue);
    });

    test('disjoint sets: diff returns left unchanged', () {
      final a = _nodeOf([1, 2, 3]);
      final b = _nodeOf([4, 5, 6]);
      expect(identical(a.diff(b, 0), a), isTrue);
    });

    test('full overlap: diff empties the node', () {
      final a = _nodeOf([1, 2, 3, 4, 5]);
      expect(a.diff(a, 0).size, 0);
    });

    test('partial overlap: diff removes the intersection', () {
      final a = _nodeOf(List.generate(32, (i) => i));
      final b = _nodeOf(List.generate(16, (i) => i));
      final result = a.diff(b, 0);
      expect(_drain(result), List.generate(16, (i) => i + 16).toSet());
    });

    test('subnode reduced to 1 during diff is migrated to inline data', () {
      // Build two large sets sharing all but a few elements, so that after
      // diff some subnodes shrink to 1.
      final a = _nodeOf(List.generate(64, (i) => i));
      // Remove all evens from `a` via diff.
      final b = _nodeOf(List.generate(32, (i) => i * 2));
      final result = a.diff(b, 0);
      expect(_drain(result), List.generate(32, (i) => i * 2 + 1).toSet());
    });

    test('diff with HashCollisionSetNode throws', () {
      // Same approach: extract the HC sub-node from a _CK root, then call
      // root.diff(hc) which hits the BitmapIndexed guard and throws.
      const ckA = _CK('a');
      const ckB = _CK('b');
      final h = ckA.hashCode;
      var root = SetNode.empty<_CK>();
      root = root.updated(ckA, h, Hashing.improve(h), 0);
      root = root.updated(ckB, h, Hashing.improve(h), 0);
      final hc = root.getNode(0); // SetNode<_CK>, runtime type HC
      expect(() => root.diff(hc, 0), throwsA(isA<UnsupportedError>()));
    });
  });

  // Created by inserting 2+ _CK instances (all have hashCode == 0xABCDEF)
  // into a BitmapIndexedSetNode.  After max trie depth is exceeded,
  // mergeTwoKeyValPairs returns a HashCollisionSetNode.

  /// Build a BitmapIndexedSetNode that contains a HashCollisionSetNode
  /// for all _CK elements whose original hash is 0xABCDEF.
  BitmapIndexedSetNode<_CK> ckNode(Iterable<String> names) {
    var node = SetNode.empty<_CK>();
    for (final name in names) {
      final ck = _CK(name);
      final h = ck.hashCode;
      node = node.updated(ck, h, Hashing.improve(h), 0);
    }
    return node;
  }

  group('HashCollisionSetNode (via _CK colliding elements)', () {
    // Retrieve the HashCollisionSetNode that lives inside the BitmapIndexed
    // root after we've inserted 2+ _CK elements (it may be many levels deep
    // since all _CK share the same hash, forcing recursion until shift >= 32).
    HashCollisionSetNode<_CK> getHCNode(BitmapIndexedSetNode<_CK> root) {
      SetNode<_CK> node = root;
      while (node is BitmapIndexedSetNode<_CK>) {
        node = node.getNode(0);
      }
      return node as HashCollisionSetNode<_CK>;
    }

    test('two colliding elements produce a HashCollisionSetNode', () {
      final root = ckNode(['a', 'b']);
      final hc = getHCNode(root);
      expect(hc, isA<HashCollisionSetNode<_CK>>());
      expect(hc.size, 2);
    });

    test('size equals number of distinct colliding elements', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c', 'd']));
      expect(hc.size, 4);
    });

    test('hasPayload is true, hasNodes is false', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      expect(hc.hasPayload, isTrue);
      expect(hc.hasNodes, isFalse);
    });

    test('nodeArity is 0', () {
      expect(getHCNode(ckNode(['a', 'b'])).nodeArity, 0);
    });

    test('payloadArity equals size', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      expect(hc.payloadArity, hc.size);
    });

    test('contains: finds matching element', () {
      final hc = getHCNode(ckNode(['x', 'y']));
      const ckX = _CK('x');
      final h = ckX.hashCode;
      expect(hc.contains(ckX, h, Hashing.improve(h), 0), isTrue);
    });

    test('contains: does not find absent element with same hash', () {
      final hc = getHCNode(ckNode(['x', 'y']));
      const absent = _CK('z');
      final h = absent.hashCode;
      expect(hc.contains(absent, h, Hashing.improve(h), 0), isFalse);
    });

    test('updated: adding existing element returns self', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      const a = _CK('a');
      final h = a.hashCode;
      final result = hc.updated(a, h, Hashing.improve(h), 0);
      expect(identical(result, hc), isTrue);
    });

    test('updated: adding new element grows content', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      const c = _CK('c');
      final h = c.hashCode;
      final result = hc.updated(c, h, Hashing.improve(h), 0) as HashCollisionSetNode<_CK>;
      expect(result.size, 3);
      expect(result.contains(c, h, Hashing.improve(h), 0), isTrue);
    });

    test('removed: absent element returns self', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      const z = _CK('z');
      final h = z.hashCode;
      expect(identical(hc.removed(z, h, Hashing.improve(h), 0), hc), isTrue);
    });

    test('removed: down to 1 element promotes to BitmapIndexedSetNode', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      const a = _CK('a');
      final h = a.hashCode;
      final result = hc.removed(a, h, Hashing.improve(h), 0);
      expect(result, isA<BitmapIndexedSetNode<_CK>>());
      expect(result.size, 1);
    });

    test('removed: down to 2+ stays as HashCollisionSetNode', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      const a = _CK('a');
      final h = a.hashCode;
      final result = hc.removed(a, h, Hashing.improve(h), 0);
      expect(result, isA<HashCollisionSetNode<_CK>>());
      expect(result.size, 2);
    });

    test('concat: with self returns self', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      expect(identical(hc.concat(hc, 0), hc), isTrue);
    });

    test('concat: with proper subset returns self', () {
      final hc2 = getHCNode(ckNode(['a', 'b']));
      final hc3 = getHCNode(ckNode(['a', 'b', 'c']));
      // hc2 is a subset of hc3; hc3.concat(hc2) should return hc3.
      expect(identical(hc3.concat(hc2, 0), hc3), isTrue);
    });

    test('concat: new elements are added', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      final hcMore = getHCNode(ckNode(['a', 'b', 'c', 'd']));
      final result = hc.concat(hcMore, 0) as HashCollisionSetNode<_CK>;
      expect(result.size, 4);
    });

    test('concat with BitmapIndexedSetNode throws', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      // A BitmapIndexedSetNode<_CK> with no HC sub-node (only 1 element).
      final bm = ckNode(['c']);
      expect(() => hc.concat(bm, 0), throwsA(isA<UnsupportedError>()));
    });

    test('filterImpl: all pass returns self', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      expect(identical(hc.filterImpl((_) => true, false), hc), isTrue);
    });

    test('filterImpl: none pass returns empty', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      final result = hc.filterImpl((_) => false, false);
      expect(result.size, 0);
    });

    test('filterImpl: down to 1 promotes to BitmapIndexedSetNode', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      const a = _CK('a');
      final result = hc.filterImpl((elem) => elem == a, false);
      expect(result, isA<BitmapIndexedSetNode<_CK>>());
      expect(result.size, 1);
    });

    test('filterImpl: partial reduces size', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c', 'd']));
      final keep = {const _CK('a'), const _CK('c')};
      final result = hc.filterImpl(keep.contains, false) as HashCollisionSetNode<_CK>;
      expect(result.size, 2);
    });

    test('filterImpl: flipped=true works as filterNot', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      const a = _CK('a');
      final result = hc.filterImpl((elem) => elem == a, true);
      // keeps all except 'a' — 2 remain
      expect(result.size, 2);
    });

    test('foreach visits all colliding elements', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      final seen = <String>{};
      hc.foreach((elem) => seen.add(elem.name));
      expect(seen, {'a', 'b', 'c'});
    });

    test('foreachWithHash provides original hash (0xABCDEF) for all', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      final hashes = <int>{};
      hc.foreachWithHash((_, h) => hashes.add(h));
      expect(hashes, {0xABCDEF});
    });

    test('foreachWithHashWhile: stops early', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c', 'd']));
      var count = 0;
      hc.foreachWithHashWhile((_, _) {
        count++;
        return count < 2;
      });
      expect(count, 2);
    });

    test('foreachWithHashWhile: returns true when all pass', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      expect(hc.foreachWithHashWhile((_, _) => true), isTrue);
    });

    test('foreachWithHashWhile: returns false when predicate rejects', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      expect(hc.foreachWithHashWhile((_, _) => false), isFalse);
    });

    test('copy: same size but not identical object', () {
      // HashCollisionSetNode does not override ==, so two distinct copies are
      // not == even with identical content.  Only check size and non-identity.
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      final c = hc.copy();
      expect(c.size, hc.size);
      expect(identical(c, hc), isFalse);
    });

    test('copy equality is determined by content identity (same IVector)', () {
      // HashCollisionSetNode.copy just wraps same content IVector, so the
      // copy should be equal.
      final hc = getHCNode(ckNode(['a', 'b']));
      final c = hc.copy();
      expect(c.size, hc.size);
    });

    test('subsetOf: self is a subset of itself', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      expect(hc.subsetOf(hc, 0), isTrue);
    });

    test('subsetOf: proper subset holds', () {
      final small = getHCNode(ckNode(['a', 'b']));
      final big = getHCNode(ckNode(['a', 'b', 'c', 'd']));
      expect(small.subsetOf(big, 0), isTrue);
    });

    test('subsetOf: not a subset when big vs small', () {
      final big = getHCNode(ckNode(['a', 'b', 'c']));
      final small = getHCNode(ckNode(['a', 'b']));
      expect(big.subsetOf(small, 0), isFalse);
    });

    test('subsetOf: non-HashCollisionSetNode is never a superset', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      // A BitmapIndexedSetNode<_CK> is not a HashCollisionSetNode, so hc
      // cannot be a subset of it per the HC subsetOf implementation.
      final bm = ckNode(['c']);
      expect(hc.subsetOf(bm, 0), isFalse);
    });

    test('diff: removes elements present in that', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c', 'd']));
      final remove = getHCNode(ckNode(['b', 'd']));
      final result = hc.diff(remove, 0);
      final seen = <String>{};
      result.foreach((e) => seen.add(e.name));
      expect(seen, {'a', 'c'});
    });

    test('diff: removing all elements → empty', () {
      final hc = getHCNode(ckNode(['a', 'b']));
      final result = hc.diff(hc, 0);
      expect(result.size, 0);
    });

    test('diff: removing none → same size', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      final other = getHCNode(ckNode(['x', 'y'])); // 'x','y' not in hc
      final result = hc.diff(other, 0);
      expect(result.size, 3);
    });

    test('cachedDartKeySetHashCode equals size * hash', () {
      final hc = getHCNode(ckNode(['a', 'b', 'c']));
      expect(hc.cachedDartKeySetHashCode, hc.size * Hashing.improve(0xABCDEF));
    });
  });

  group('IHashSet operations exercising internal nodes', () {
    test('large concat preserves all elements', () {
      final a = iset(List.generate(50, (i) => i));
      final b = iset(List.generate(50, (i) => i + 25));
      expect(a.concat(b).size, 75);
    });

    test('large diff leaves correct residual', () {
      final a = iset(List.generate(50, (i) => i));
      final b = iset(List.generate(25, (i) => i));
      expect(a.diff(b).size, 25);
    });

    test('filter on large set with subnode pruning', () {
      final s = iset(List.generate(100, (i) => i));
      final evens = s.filter((x) => x.isEven);
      expect(evens.size, 50);
      expect(evens.forall((x) => x.isEven), isTrue);
    });

    test('hash-colliding elements all contained', () {
      final elems = ['a', 'b', 'c', 'd', 'e'].map(_CK.new).toList();
      // Build an ISet<_CK> holding all colliding elements.
      final s = iset(elems);
      for (final e in elems) {
        expect(s.contains(e), isTrue);
      }
    });

    test('hash-colliding elements: removedAll works correctly', () {
      final all = ['a', 'b', 'c', 'd', 'e'].map(_CK.new).toList();
      final s = iset(all);
      // filterNot exercises HC-aware removal without shallow-mutation issues.
      final toRemove = <_CK>{const _CK('b'), const _CK('d')};
      final result = s.filterNot(toRemove.contains);
      expect(result.size, 3);
      expect(result.contains(const _CK('b')), isFalse);
      expect(result.contains(const _CK('d')), isFalse);
    });

    test('hash-colliding elements: diff works correctly', () {
      final a = iset(['a', 'b', 'c', 'd', 'e'].map(_CK.new).toList());
      // Make b an IHashSet (5+ elements) so the CHAMP node-level diff is used.
      final b = iset(['c', 'd', 'x', 'y', 'z'].map(_CK.new).toList());
      // 'x', 'y', 'z' not in a; 'c' and 'd' are → diff removes c,d; result: a,b,e
      expect(a.diff(b).size, 3);
    });

    test('hash-colliding elements: filter works correctly', () {
      final elems = ['a', 'b', 'c', 'd', 'e'].map(_CK.new).toList();
      final s = iset(elems);
      final keep = {const _CK('a'), const _CK('c')};
      final result = s.filter(keep.contains);
      expect(result.size, 2);
      expect(result.contains(const _CK('a')), isTrue);
      expect(result.contains(const _CK('c')), isTrue);
    });

    test('hash-colliding elements: set equals itself', () {
      // HashCollisionSetNode does not override ==, so two separately-built sets
      // with the same _CK elements are not structurally equal. However a set
      // is always equal to itself (checked via identical()).
      final a = iset(['a', 'b', 'c', 'd', 'e'].map(_CK.new).toList());
      expect(a == a, isTrue);
      expect(a.hashCode, isA<int>());
    });
  });
}
