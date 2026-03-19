// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';

// imap-construction

final imapEmpty = IMap.empty<String, int>();
final imapFromLiteral = imap({'a': 1, 'b': 2, 'c': 3});
final imapFromDart = IMap.fromDart({'x': 10, 'y': 20});
final imapFromPairs = IMap.fromDartIterable([('a', 1), ('b', 2), ('c', 3)]);

// imap-construction

// imap-ops

final base = imap({'a': 1, 'b': 2, 'c': 3});

// operator + takes a (K, V) tuple and returns a new IMap
final withD = base + ('d', 4); // {'a':1,'b':2,'c':3,'d':4}
final overrideB = base + ('b', 99); // {'a':1,'b':99,'c':3}

// operator - takes a key and returns a new IMap
final withoutA = base - 'a'; // {'b':2,'c':3}

// get returns Some(value) or None — never throws
final valB = base.get('b'); // Some(2)
final valZ = base.get('z'); // None

// operator [] throws if key is absent
final direct = base['a']; // 1

// getOrElse provides a fallback
final orElse = base.getOrElse('z', () => 0); // 0

// updatedWith lets you modify or remove an entry in one step
final incremented = base.updatedWith('a', (Option<int> old) => old.map((v) => v + 1));
final inserted = base.updatedWith('d', (Option<int> old) => const Some(42));

// mapValues transforms every value, preserving keys
final doubled = base.mapValues((int v) => v * 2); // {'a':2,'b':4,'c':6}

// transform has access to both key and value
final labelled = base.transform(
  (String k, int v) => '$k=$v',
); // {'a':'a=1','b':'b=2','c':'c=3'}

// removedAll removes a set of keys at once
final pruned = base.removedAll(ilist(['a', 'c'])); // {'b':2}

// imap-ops

// imap-builder

IMap<String, int> buildMap() {
  final builder = IMap.builder<String, int>();
  for (var i = 0; i < 5; i++) {
    builder.addOne(('key$i', i));
  }
  return builder.result();
}

// imap-builder

// mmap-ops

void mmapExample() {
  final m = MMap.empty<String, int>();

  // operator []= mutates in place (like a Dart Map)
  m['a'] = 1;
  m['b'] = 2;

  // put returns the previous value as Option
  final prev = m.put('a', 99); // Some(1)

  // get returns Some(value) or None
  final val = m.get('b'); // Some(2)

  // remove returns the removed value as Option
  final removed = m.remove('b'); // Some(2)

  // getOrElseUpdate inserts and returns a default if absent
  final guaranteed = m.getOrElseUpdate('c', () => 100); // 100; 'c'->100 inserted

  // updateWith applies a remapper; returning None removes the entry
  m.updateWith('a', (Option<int> old) => old.map((v) => v + 1));

  // removeAll removes several keys at once
  m.removeAll(ilist(['a', 'c']));

  // filterInPlace removes entries that do not satisfy the predicate
  m['x'] = 5;
  m['y'] = 15;
  m.filterInPlace(((String, int) kv) => kv.$2 > 10); // only 'y' remains

  // clear empties the map
  m.clear();
}

// mmap-ops

// imultidict-construction

final mdEmpty = IMultiDict.empty<String, int>();

// Each (key, value) pair is added as a separate entry under the same key
final mdFromLiteral = imultidict([('a', 1), ('a', 2), ('b', 3)]);

// imultidict-construction

// imultidict-ops

final md = imultidict([('a', 1), ('a', 2), ('b', 3), ('b', 4)]);

// get returns the set of values for a key, or an empty set
final valuesForA = md.get('a'); // ISet {1, 2}
final valuesForZ = md.get('z'); // ISet {} (empty)

// operator + adds a single (key, value) entry; use explicit typed record to avoid
// Dart parsing ('c', 99) as two separate operator arguments
const (String, int) entryC = ('c', 99);
const (String, int) entryA3 = ('a', 3);
final mdWithC = md + entryC; // 'c' -> {99}
final mdWithExtraA = md + entryA3; // 'a' -> {1, 2, 3}

// sets exposes the underlying IMap<K, ISet<V>>
final setsMap = md.sets; // IMap {'a': ISet{1,2}, 'b': ISet{3,4}}

final hasKeyA = md.containsKey('a'); // true
final hasKeyZ = md.containsKey('z'); // false
final hasEntry = md.containsEntry(('a', 1)); // true
final hasValue = md.containsValue(3); // true

// imultidict-ops
