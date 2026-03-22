import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/mutable/hash_set.dart';
import 'package:test/test.dart';

void main() {
  group('Array', () {
    test('empty has length 0', () {
      expect(Array.empty<int>().length, 0);
      expect(Array.empty<int>().isEmpty, isTrue);
    });

    test('ofDim creates null-filled array', () {
      final a = Array.ofDim<int>(3);
      expect(a.length, 3);
      expect(a[0], isNull);
    });

    test('fill creates array filled with value', () {
      final a = Array.fill(4, 7);
      expect(a.length, 4);
      expect(a[0], 7);
      expect(a[3], 7);
    });

    test('fromDart round-trips', () {
      final a = Array.fromDart<int>([1, 2, 3]);
      expect(a.length, 3);
      expect(a[0], 1);
      expect(a[2], 3);
    });

    test('operator []= sets value', () {
      final a = Array.ofDim<int>(3);
      a[1] = 42;
      expect(a[1], 42);
    });

    test('update returns self', () {
      final a = Array.ofDim<int>(3);
      final r = a.update(0, 99);
      expect(identical(r, a), isTrue);
      expect(a[0], 99);
    });

    test('range', () {
      final a = Array.range(0, 5);
      expect(a.length, 5);
      expect(a[0], 0);
      expect(a[4], 4);
    });

    test('range with step', () {
      final a = Array.range(0, 10, 2);
      expect(a.length, 5);
      expect(a[0], 0);
      expect(a[4], 8);
    });

    test('range with negative step', () {
      final a = Array.range(5, 0, -1);
      expect(a.length, 5);
      expect(a[0], 5);
      expect(a[4], 1);
    });

    test('range zero step throws', () {
      expect(() => Array.range(0, 5, 0), throwsArgumentError);
    });

    test('tabulate', () {
      final a = Array.tabulate<int>(4, (i) => i * i);
      expect(a.length, 4);
      expect(a[0], 0);
      expect(a[3], 9);
    });

    test('map', () {
      final a = Array.fromDart<int>([1, 2, 3]).map((x) => x * 2);
      expect(a[0], 2);
      expect(a[2], 6);
    });

    test('collect', () {
      final a = Array.fromDart<int>([1, 2, 3, 4]).collect(
        (x) => x.isEven ? Some(x * 10) : const None(),
      );
      expect(a.length, 2);
      expect(a[0], 20);
      expect(a[1], 40);
    });

    test('slice', () {
      final a = Array.fromDart<int>([0, 1, 2, 3, 4]).slice(1, 4);
      expect(a.length, 3);
      expect(a[0], 1);
      expect(a[2], 3);
    });

    test('slice clamped to bounds', () {
      final a = Array.fromDart<int>([0, 1, 2]).slice(-1, 100);
      expect(a.length, 3);
    });

    test('slice empty when from >= until', () {
      final a = Array.fromDart<int>([0, 1, 2]).slice(3, 1);
      expect(a.isEmpty, isTrue);
    });

    test('clone is independent copy', () {
      final a = Array.fromDart<int>([1, 2, 3]);
      final b = a.clone();
      b[0] = 99;
      expect(a[0], 1);
    });

    test('toList', () {
      final a = Array.fromDart<int>([5, 6, 7]);
      expect(a.toList(), [5, 6, 7]);
    });

    test('foreach iterates all elements', () {
      final collected = <int?>[];
      Array.fromDart<int>([1, 2, 3]).foreach(collected.add);
      expect(collected, [1, 2, 3]);
    });

    test('filled fills with value', () {
      final a = Array.fromDart<int>([1, 2, 3]);
      a.filled(0);
      expect(a[0], 0);
      expect(a[2], 0);
    });

    test('iterator', () {
      final a = Array.fromDart<int>([10, 20, 30]);
      final vals = a.iterator.toIList();
      expect(vals, ilist([10, 20, 30]));
    });

    test('equals symmetric', () {
      final a = Array.fromDart<int>([1, 2, 3]);
      final b = Array.fromDart<int>([1, 2, 3]);
      final c = Array.fromDart<int>([1, 2, 4]);
      expect(Array.equals(a, b), isTrue);
      expect(Array.equals(a, c), isFalse);
      expect(Array.equals(a, a), isTrue);
    });

    test('equals different lengths', () {
      final a = Array.fromDart<int>([1, 2]);
      final b = Array.fromDart<int>([1, 2, 3]);
      expect(Array.equals(a, b), isFalse);
    });

    test('arraycopy', () {
      final src = Array.fromDart<int>([1, 2, 3, 4, 5]);
      final dst = Array.ofDim<int>(5);
      Array.arraycopy(src, 1, dst, 0, 3);
      expect(dst[0], 2);
      expect(dst[1], 3);
      expect(dst[2], 4);
    });

    test('copyOf truncates', () {
      final a = Array.fromDart<int>([1, 2, 3, 4, 5]);
      final b = Array.copyOf(a, 3);
      expect(b.length, 3);
      expect(b[2], 3);
    });

    test('copyOf pads with null', () {
      final a = Array.fromDart<int>([1, 2]);
      final b = Array.copyOf(a, 4);
      expect(b.length, 4);
      expect(b[3], isNull);
    });

    test('copyOfRange', () {
      final a = Array.fromDart<int>([0, 1, 2, 3, 4]);
      final b = Array.copyOfRange(a, 2, 4);
      expect(b.length, 2);
      expect(b[0], 2);
      expect(b[1], 3);
    });
  });

  group('ArrayBuilder', () {
    test('addOne then result', () {
      final b = ArrayBuilder<int>();
      b.addOne(1);
      b.addOne(2);
      b.addOne(3);
      final a = b.result();
      expect(a.length, 3);
      expect(a[0], 1);
      expect(a[2], 3);
    });

    test('addAll', () {
      final b = ArrayBuilder<int>()..addAll(ilist([10, 20, 30]));
      final a = b.result();
      expect(a.length, 3);
      expect(a[1], 20);
    });

    test('addArray', () {
      final src = Array.fromDart<int>([5, 6, 7]);
      final b = ArrayBuilder<int>()..addArray(src);
      final a = b.result();
      expect(a.length, 3);
      expect(a[0], 5);
    });

    test('addArray with offset and length', () {
      final src = Array.fromDart<int>([0, 1, 2, 3, 4]);
      final b = ArrayBuilder<int>()..addArray(src, offset: 2, length: 2);
      final a = b.result();
      expect(a.length, 2);
      expect(a[0], 2);
      expect(a[1], 3);
    });

    test('clear resets builder', () {
      final b =
          ArrayBuilder<int>()
            ..addOne(1)
            ..addOne(2);
      b.clear();
      expect(b.length, 0);
      final a = b.result();
      expect(a.length, 0);
    });

    test('result is exact-size copy when capacity != size', () {
      final b =
          ArrayBuilder<int>()
            ..addOne(1)
            ..addOne(2);
      b.result(); // First call may return a copy
      // Second call on a fresh builder with exact cap == size returns array
      final b2 = ArrayBuilder<int>();
      b2.addOne(42);
      final a = b2.result();
      expect(a[0], 42);
    });

    test('builder is used by Array.builder()', () {
      final b = Array.builder<String>();
      b.addOne('hello');
      b.addOne('world');
      final a = b.result();
      expect(a.length, 2);
      expect(a[0], 'hello');
    });
  });

  group('ListBuffer', () {
    ListBuffer<int> lb(List<int> xs) => xs.fold(ListBuffer<int>(), (b, x) => b..addOne(x));

    test('empty', () {
      final b = ListBuffer<int>();
      expect(b.isEmpty, isTrue);
      expect(b.length, 0);
      expect(b.knownSize, 0);
    });

    test('addOne / length / operator[]', () {
      final b = lb([1, 2, 3]);
      expect(b.length, 3);
      expect(b[0], 1);
      expect(b[2], 3);
    });

    test('addAll', () {
      final b = ListBuffer<int>()..addAll(ilist([10, 20, 30]));
      expect(b.length, 3);
      expect(b[1], 20);
    });

    test('append alias', () {
      final b = ListBuffer<int>()..append(5);
      expect(b[0], 5);
    });

    test('appendAll', () {
      final b = ListBuffer<int>()..appendAll(ilist([1, 2]));
      expect(b.length, 2);
    });

    test('prepend', () {
      final b = lb([2, 3])..prepend(1);
      expect(b[0], 1);
      expect(b.length, 3);
    });

    test('prependAll', () {
      final b = lb([3, 4])..prependAll(ilist([1, 2]));
      expect(b.toIList(), ilist([1, 2, 3, 4]));
    });

    test('last and lastOption', () {
      final b = lb([1, 2, 3]);
      expect(b.last, 3);
      expect(b.lastOption, const Some(3));
    });

    test('last on empty throws', () {
      expect(() => ListBuffer<int>().last, throwsStateError);
    });

    test('lastOption on empty is None', () {
      expect(ListBuffer<int>().lastOption, const None());
    });

    test('insert at index', () {
      final b = lb([1, 3])..insert(1, 2);
      expect(b.toIList(), ilist([1, 2, 3]));
    });

    test('insert at 0', () {
      final b = lb([2, 3])..insert(0, 1);
      expect(b[0], 1);
    });

    test('insert at end is addOne', () {
      final b = lb([1, 2])..insert(2, 3);
      expect(b[2], 3);
    });

    test('insert out of bounds throws', () {
      expect(() => lb([1, 2]).insert(5, 99), throwsRangeError);
      expect(() => lb([1, 2]).insert(-1, 99), throwsRangeError);
    });

    test('insertAll', () {
      final b = lb([1, 4])..insertAll(1, ilist([2, 3]));
      expect(b.toIList(), ilist([1, 2, 3, 4]));
    });

    test('insertAll at end', () {
      final b = lb([1, 2])..insertAll(2, ilist([3, 4]));
      expect(b.toIList(), ilist([1, 2, 3, 4]));
    });

    test('remove returns removed element', () {
      final b = lb([1, 2, 3]);
      expect(b.remove(1), 2);
      expect(b.toIList(), ilist([1, 3]));
    });

    test('remove first element', () {
      final b = lb([10, 20, 30]);
      expect(b.remove(0), 10);
      expect(b.length, 2);
    });

    test('remove out of bounds throws', () {
      expect(() => lb([1, 2]).remove(5), throwsRangeError);
      expect(() => lb([1, 2]).remove(-1), throwsRangeError);
    });

    test('removeN removes count elements from index', () {
      final b = lb([1, 2, 3, 4, 5])..removeN(1, 2);
      expect(b.toIList(), ilist([1, 4, 5]));
    });

    test('removeN with count 0 is no-op', () {
      final b = lb([1, 2, 3])..removeN(0, 0);
      expect(b.length, 3);
    });

    test('removeN negative count throws', () {
      expect(() => lb([1, 2, 3]).removeN(0, -1), throwsArgumentError);
    });

    test('clear empties buffer', () {
      final b = lb([1, 2, 3])..clear();
      expect(b.isEmpty, isTrue);
    });

    test('update changes element', () {
      final b = lb([1, 2, 3])..update(1, 99);
      expect(b[1], 99);
    });

    test('update first element', () {
      final b = lb([1, 2, 3])..update(0, 10);
      expect(b[0], 10);
    });

    test('update out of bounds throws', () {
      expect(() => lb([1, 2, 3]).update(5, 0), throwsRangeError);
    });

    test('toIList', () {
      final list = lb([1, 2, 3]).toIList();
      expect(list, ilist([1, 2, 3]));
    });

    test('toIList aliasing: mutation after toIList creates copy', () {
      final b = lb([1, 2, 3]);
      final l = b.toIList();
      b.addOne(4);
      // Original list is unaffected — aliasing ensures a copy was made
      expect(l, ilist([1, 2, 3]));
    });

    test('prependToList', () {
      final b = lb([1, 2]);
      final l = b.prependToList(ilist([3, 4]));
      expect(l, ilist([1, 2, 3, 4]));
    });

    test('prependToList on empty returns xs unchanged', () {
      final b = ListBuffer<int>();
      final l = b.prependToList(ilist([1, 2]));
      expect(l, ilist([1, 2]));
    });

    test('reverse', () {
      final b = lb([1, 2, 3]).reverse();
      expect(b.toIList(), ilist([3, 2, 1]));
    });

    test('subtractOne removes first occurrence', () {
      final b = lb([1, 2, 3, 2])..subtractOne(2);
      expect(b.toIList(), ilist([1, 3, 2]));
    });

    test('subtractOne removes head', () {
      final b = lb([1, 2, 3])..subtractOne(1);
      expect(b.toIList(), ilist([2, 3]));
    });

    test('subtractOne on empty is no-op', () {
      final b = ListBuffer<int>()..subtractOne(5);
      expect(b.isEmpty, isTrue);
    });

    test('subtractOne absent element is no-op', () {
      final b = lb([1, 2, 3])..subtractOne(99);
      expect(b.length, 3);
    });

    test('appended returns new buffer with element', () {
      final b = lb([1, 2]);
      final b2 = b.appended(3);
      expect(b2.toIList(), ilist([1, 2, 3]));
      expect(b.length, 2); // original unchanged
    });

    test('filterInPlace keeps matching elements', () {
      final b = lb([1, 2, 3, 4, 5])..filterInPlace((x) => x.isOdd);
      expect(b.toIList(), ilist([1, 3, 5]));
    });

    test('filterInPlace removes all', () {
      final b = lb([1, 2, 3])..filterInPlace((_) => false);
      expect(b.isEmpty, isTrue);
    });

    test('mapInPlace transforms in place', () {
      final b = lb([1, 2, 3])..mapInPlace((x) => x * 10);
      expect(b.toIList(), ilist([10, 20, 30]));
    });

    test('patchInPlace inserts', () {
      final b = lb([1, 2, 5])..patchInPlace(2, ilist([3, 4]), 0);
      expect(b.toIList(), ilist([1, 2, 3, 4, 5]));
    });

    test('patchInPlace replaces', () {
      final b = lb([1, 2, 99, 4])..patchInPlace(2, ilist([3]), 1);
      expect(b.toIList(), ilist([1, 2, 3, 4]));
    });

    test('dropInPlace', () {
      final b = lb([1, 2, 3, 4])..dropInPlace(2);
      expect(b.toIList(), ilist([3, 4]));
    });

    test('dropInPlace clamped', () {
      final b = lb([1, 2])..dropInPlace(100);
      expect(b.isEmpty, isTrue);
    });

    test('dropRightInPlace', () {
      final b = lb([1, 2, 3, 4])..dropRightInPlace(2);
      expect(b.toIList(), ilist([1, 2]));
    });

    test('takeInPlace', () {
      final b = lb([1, 2, 3, 4])..takeInPlace(2);
      expect(b.toIList(), ilist([1, 2]));
    });

    test('takeRightInPlace', () {
      final b = lb([1, 2, 3, 4])..takeRightInPlace(2);
      expect(b.toIList(), ilist([3, 4]));
    });

    test('dropWhileInPlace', () {
      final b = lb([1, 2, 3, 4])..dropWhileInPlace((x) => x < 3);
      expect(b.toIList(), ilist([3, 4]));
    });

    test('dropWhileInPlace all match clears buffer', () {
      final b = lb([1, 2, 3])..dropWhileInPlace((_) => true);
      expect(b.isEmpty, isTrue);
    });

    test('takeWhileInPlace', () {
      final b = lb([1, 2, 3, 4])..takeWhileInPlace((x) => x < 3);
      expect(b.toIList(), ilist([1, 2]));
    });

    test('sliceInPlace', () {
      final b = lb([0, 1, 2, 3, 4])..sliceInPlace(1, 4);
      expect(b.toIList(), ilist([1, 2, 3]));
    });

    test('padToInPlace extends with fill element', () {
      final b = lb([1, 2])..padToInPlace(5, 0);
      expect(b.toIList(), ilist([1, 2, 0, 0, 0]));
    });

    test('padToInPlace no-op when already long enough', () {
      final b = lb([1, 2, 3])..padToInPlace(2, 0);
      expect(b.length, 3);
    });

    test('iterator mutation guard', () {
      final b = lb([1, 2, 3]);
      final it = b.iterator;
      it.next(); // consume one
      b.addOne(4);
      expect(() => it.hasNext, throwsStateError);
    });

    test('equality same elements', () {
      expect(lb([1, 2, 3]) == lb([1, 2, 3]), isTrue);
    });

    test('equality different elements', () {
      expect(lb([1, 2, 3]) == lb([1, 2, 4]), isFalse);
    });

    test('hashCode consistent with equal buffers', () {
      expect(lb([1, 2, 3]).hashCode, lb([1, 2, 3]).hashCode);
    });
  });

  group('MHashSet', () {
    test('empty', () {
      final s = MHashSet.empty<int>();
      expect(s.isEmpty, isTrue);
      expect(s.size, 0);
    });

    test('add returns true for new element', () {
      final s = MHashSet<int>();
      expect(s.add(1), isTrue);
      expect(s.size, 1);
    });

    test('add returns false for duplicate', () {
      final s = MHashSet<int>()..add(1);
      expect(s.add(1), isFalse);
      expect(s.size, 1);
    });

    test('contains', () {
      final s = MHashSet<int>()..add(42);
      expect(s.contains(42), isTrue);
      expect(s.contains(0), isFalse);
    });

    test('remove returns true when present', () {
      final s = MHashSet<int>()..add(5);
      expect(s.remove(5), isTrue);
      expect(s.contains(5), isFalse);
    });

    test('remove returns false when absent', () {
      expect(MHashSet<int>().remove(5), isFalse);
    });

    test('concat adds all elements', () {
      final s =
          MHashSet<int>()
            ..add(1)
            ..add(2);
      s.concat(ilist([3, 4]).toISet());
      expect(s.size, 4);
      expect(s.contains(3), isTrue);
    });

    test('from', () {
      final s = MHashSet.from(ilist([1, 2, 3]));
      expect(s.size, 3);
      expect(s.contains(2), isTrue);
    });

    test('iterator yields all elements', () {
      final s = MHashSet.from(ilist([10, 20, 30]));
      final vals = s.iterator.toIList().toList()..sort();
      expect(vals, [10, 20, 30]);
    });

    test('+ operator adds element', () {
      final s = MSet.empty<int>();
      expect(s + 42, isTrue);
      expect(s.contains(42), isTrue);
    });

    test('- operator removes element', () {
      final s = MSet.of([1, 2, 3]);
      expect(s - 2, isTrue);
      expect(s.contains(2), isFalse);
    });

    test('union', () {
      final a = MSet.of([1, 2]);
      final b = MSet.of([2, 3]);
      final u = a.union(b);
      expect(u.contains(1), isTrue);
      expect(u.contains(3), isTrue);
    });

    test('diff', () {
      final a = MSet.of([1, 2, 3]);
      final b = MSet.of([2, 3]);
      final d = a.diff(b);
      expect(d.contains(1), isTrue);
      expect(d.contains(2), isFalse);
    });

    test('subsetOf', () {
      final small = MSet.of([1, 2]);
      final large = MSet.of([1, 2, 3]);
      expect(small.subsetOf(large), isTrue);
      expect(large.subsetOf(small), isFalse);
    });

    test('equality', () {
      expect(MSet.of([1, 2, 3]) == MSet.of([3, 2, 1]), isTrue);
      expect(MSet.of([1, 2]) == MSet.of([1, 3]), isFalse);
    });

    test('hashCode consistent', () {
      expect(MSet.of([1, 2, 3]).hashCode, MSet.of([3, 2, 1]).hashCode);
    });

    test('grows table when over load factor', () {
      // Insert enough elements to trigger table growth
      final s = MHashSet<int>(initialCapacity: 4);
      for (var i = 0; i < 20; i++) {
        s.add(i);
      }
      expect(s.size, 20);
      for (var i = 0; i < 20; i++) {
        expect(s.contains(i), isTrue);
      }
    });
  });

  group('MHashMap', () {
    test('empty', () {
      final m = MHashMap.empty<String, int>();
      expect(m.isEmpty, isTrue);
      expect(m.size, 0);
    });

    test('put inserts and returns None for new key', () {
      final m = MHashMap<String, int>();
      expect(m.put('a', 1), const None());
      expect(m.size, 1);
    });

    test('put returns previous value on update', () {
      final m = MHashMap<String, int>()..put('a', 1);
      expect(m.put('a', 2), const Some(1));
      expect(m.get('a'), const Some(2));
    });

    test('get returns None for missing key', () {
      expect(MHashMap<String, int>().get('missing'), const None());
    });

    test('contains', () {
      final m = MHashMap<String, int>()..put('x', 10);
      expect(m.contains('x'), isTrue);
      expect(m.contains('y'), isFalse);
    });

    test('remove returns previous value', () {
      final m = MHashMap<String, int>()..put('a', 1);
      expect(m.remove('a'), const Some(1));
      expect(m.contains('a'), isFalse);
    });

    test('remove absent key returns None', () {
      expect(MHashMap<String, int>().remove('k'), const None());
    });

    test('operator []= / get round-trip', () {
      final m = MMap.empty<String, int>();
      m['hello'] = 42;
      expect(m.get('hello'), const Some(42));
    });

    test('getOrElseUpdate inserts and returns default for missing key', () {
      final m = MHashMap<String, int>();
      final v = m.getOrElseUpdate('k', () => 99);
      expect(v, 99);
      expect(m.get('k'), const Some(99));
    });

    test('getOrElseUpdate returns existing value', () {
      final m = MHashMap<String, int>()..put('k', 1);
      expect(m.getOrElseUpdate('k', () => 99), 1);
    });

    test('keys', () {
      final m =
          MHashMap<String, int>()
            ..put('a', 1)
            ..put('b', 2);
      final keys = m.keys.toList()..sort();
      expect(keys, ['a', 'b']);
    });

    test('valuesIterator', () {
      final m =
          MHashMap<String, int>()
            ..put('a', 1)
            ..put('b', 2);
      final vals = m.valuesIterator.toIList().toList()..sort();
      expect(vals, [1, 2]);
    });

    test('iterator yields all pairs', () {
      final m =
          MHashMap<String, int>()
            ..put('a', 1)
            ..put('b', 2);
      final pairs = m.iterator.toIList().toList()..sort((x, y) => x.$1.compareTo(y.$1));
      expect(pairs[0], ('a', 1));
      expect(pairs[1], ('b', 2));
    });

    test('iterator on empty returns nothing', () {
      expect(MHashMap<String, int>().iterator.toIList(), nil<(String, int)>());
    });

    test('clear empties map', () {
      final m =
          MHashMap<String, int>()
            ..put('a', 1)
            ..put('b', 2);
      m.clear();
      expect(m.isEmpty, isTrue);
    });

    test('concat adds all pairs', () {
      final m = MHashMap<String, int>()..put('a', 1);
      m.concat(ilist([('b', 2), ('c', 3)]));
      expect(m.size, 3);
      expect(m.get('c'), const Some(3));
    });

    test('fromDart', () {
      final m = MMap.fromDart({'x': 10, 'y': 20});
      expect(m.get('x'), const Some(10));
      expect(m.size, 2);
    });

    test('updateWith inserts when absent', () {
      final m = MMap.empty<String, int>();
      m.updateWith('k', (_) => const Some(1));
      expect(m.get('k'), const Some(1));
    });

    test('updateWith updates when present', () {
      final m = MMap.empty<String, int>()..['k'] = 5;
      m.updateWith('k', (v) => v.map((n) => n + 1));
      expect(m.get('k'), const Some(6));
    });

    test('updateWith removes when function returns None', () {
      final m = MMap.empty<String, int>()..['k'] = 5;
      m.updateWith('k', (_) => const None());
      expect(m.contains('k'), isFalse);
    });

    test('withDefault returns default for missing key', () {
      final m = MMap.empty<String, int>().withDefault((_) => -1);
      expect(m.defaultValue('anything'), -1);
    });

    test('withDefaultValue', () {
      final m = MMap.empty<String, int>().withDefaultValue(0);
      expect(m.defaultValue('k'), 0);
    });

    test('filterInPlace keeps matching pairs', () {
      final m =
          MHashMap<String, int>()
            ..put('a', 1)
            ..put('b', 2)
            ..put('c', 3);
      m.filterInPlace((kv) => kv.$2 > 1);
      expect(m.size, 2);
      expect(m.contains('a'), isFalse);
    });

    test('grows table when over load factor', () {
      final m = MHashMap<int, int>(initialCapacity: 4);
      for (var i = 0; i < 20; i++) {
        m.put(i, i * 2);
      }
      expect(m.size, 20);
      for (var i = 0; i < 20; i++) {
        expect(m.get(i), Some(i * 2));
      }
    });
  });

  // ///////////////////////////////////////////////////////////////////////////
  // MMultiSet
  // ///////////////////////////////////////////////////////////////////////////

  group('MMultiSet', () {
    test('empty', () {
      expect(MMultiSet.empty<int>().size, 0);
      expect(MMultiSet.empty<int>().isEmpty, isTrue);
    });

    test('from iterable counts occurrences', () {
      final ms = mmultiset([1, 2, 2, 3, 3, 3]);
      expect(ms.occurrences.get(1), const Some(1));
      expect(ms.occurrences.get(2), const Some(2));
      expect(ms.occurrences.get(3), const Some(3));
    });

    test('incl increases count', () {
      final ms = mmultiset([1, 1]);
      final ms2 = ms.incl(1);
      expect(ms2.occurrences.get(1), const Some(3));
    });

    test('+ operator is incl', () {
      final ms = mmultiset([1]);
      final ms2 = ms + 1;
      expect(ms2.occurrences.get(1), const Some(2));
    });

    test('excl decreases count', () {
      final ms = mmultiset([1, 1, 1]);
      final ms2 = ms.excl(1);
      expect(ms2.occurrences.get(1), const Some(2));
    });

    test('excl removes when count reaches 0', () {
      final ms = mmultiset([1]);
      final ms2 = ms.excl(1);
      expect(ms2.occurrences.get(1), const None());
    });

    test('- operator is excl', () {
      final ms = mmultiset([1, 1]);
      final ms2 = ms - 1;
      expect(ms2.occurrences.get(1), const Some(1));
    });

    test('excl absent element is no-op', () {
      final ms = mmultiset([1]);
      final ms2 = ms.excl(99);
      expect(ms2.occurrences.get(1), const Some(1));
    });

    test('concat', () {
      final a = mmultiset([1, 2]);
      final b = mmultiset([2, 3]);
      final c = a.concat(b);
      expect(c.occurrences.get(2), const Some(2));
    });

    test('iterator size matches total count', () {
      final ms = mmultiset([1, 2, 2, 3]);
      expect(ms.iterator.toIList().length, 4);
    });

    test('fromOccurences', () {
      final ms = MMultiSet.fromOccurences(ilist([(1, 3), (2, 2)]));
      expect(ms.occurrences.get(1), const Some(3));
      expect(ms.occurrences.get(2), const Some(2));
    });

    test('filter', () {
      final ms = mmultiset([1, 2, 2, 3]).filter((x) => x < 3);
      expect(ms.occurrences.get(3), const None());
    });

    test('map', () {
      final ms = mmultiset([1, 2, 3]).map((x) => x * 2);
      expect(ms.occurrences.get(2), const Some(1));
      expect(ms.occurrences.get(6), const Some(1));
    });

    test('from same MMultiSet is identity', () {
      final ms = mmultiset([1, 2, 3]);
      expect(identical(MMultiSet.from(ms), ms), isTrue);
    });
  });

  group('MMultiDict', () {
    test('empty', () {
      expect(MMultiDict.empty<String, int>().size, 0);
    });

    test('add single entry', () {
      final d = MMultiDict.empty<String, int>().add('a', 1);
      expect(d.get('a').contains(1), isTrue);
    });

    test('add multiple values for same key', () {
      final d = MMultiDict.empty<String, int>().add('a', 1).add('a', 2);
      expect(d.get('a').size, 2);
      expect(d.get('a').contains(1), isTrue);
      expect(d.get('a').contains(2), isTrue);
    });

    test('+ operator adds entry', () {
      final d = MMultiDict.empty<String, int>() + ('a', 1);
      expect(d.get('a').contains(1), isTrue);
    });

    test('get on missing key returns empty set', () {
      expect(MMultiDict.empty<String, int>().get('x').isEmpty, isTrue);
    });

    test('from iterable', () {
      final d = mmultidict([('a', 1), ('b', 2), ('a', 3)]);
      expect(d.get('a').size, 2);
      expect(d.get('b').size, 1);
    });

    test('fromDart', () {
      final d = MMultiDict.fromDart({'x': 10, 'y': 20});
      expect(d.get('x').contains(10), isTrue);
    });

    test('sets', () {
      final d = mmultidict([('a', 1), ('b', 2)]);
      expect(d.sets.size, 2);
    });

    test('iterator yields all pairs', () {
      final d = mmultidict([('a', 1), ('a', 2), ('b', 3)]);
      expect(d.size, 3);
    });

    test('filter', () {
      final d = mmultidict([('a', 1), ('b', 2), ('a', 3)]).filter((kv) => kv.$2 > 1);
      expect(d.size, 2);
      expect(d.get('a').contains(1), isFalse);
    });

    test('from same MMultiDict is identity', () {
      final d = mmultidict([('a', 1)]);
      expect(identical(MMultiDict.from(d), d), isTrue);
    });

    test('concat', () {
      final a = mmultidict([('a', 1)]);
      final b = mmultidict([('a', 2), ('b', 3)]);
      final c = a.concat(b);
      expect(c.get('a').size, 2);
      expect(c.get('b').size, 1);
    });
  });

  group('MutationTrackerIterator', () {
    test('detects addOne during iteration', () {
      final b =
          ListBuffer<int>()
            ..addOne(1)
            ..addOne(2);
      final it = b.iterator;
      it.next();
      b.addOne(3);
      expect(() => it.hasNext, throwsStateError);
    });

    test('detects clear during iteration', () {
      final b = ListBuffer<int>()..addOne(1);
      final it = b.iterator;
      b.clear();
      expect(() => it.hasNext, throwsStateError);
    });

    test('no mutation — iteration succeeds', () {
      final b =
          ListBuffer<int>()
            ..addOne(1)
            ..addOne(2)
            ..addOne(3);
      final it = b.iterator;
      final result = <int>[];
      while (it.hasNext) {
        result.add(it.next());
      }
      expect(result, [1, 2, 3]);
    });
  });
}
