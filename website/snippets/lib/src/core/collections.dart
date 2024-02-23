// ignore_for_file: avoid_print

import 'package:ribs_core/ribs_core.dart';

// ilist

final l = IList.range(0, 10);
final plusOne = l.map((n) => n + 1);
final odds = l.filter((n) => n.isOdd);

final maybeFirstElement = l.headOption;
final numLessThan5 = l.count((n) => n < 5);
final combined = l.concat(l);
final dropLast3 = l.dropRight(3);

final anyBigNumbers = l.exists((a) => a > 100);
final everyoneLessThan1000 = l.forall((a) => a < 1000);

final maybe4 = l.find((a) => a == 4);

// ilist

// ivector

final v = ivec([1, 2, 3]);

final perms = v.permutations();
final sliding = v.sliding(2, 2);
final evensMinus1 = v.collect((x) => Option.when(() => x.isEven, () => x - 1));

final scanVec = v.scan(0, (a, b) => a + b);
final sortedVec = v.sorted(Order.ints.reverse());

// ivector

// nel

final nonEmptyList = nel(1, [2, 3, 4, 5]);

final first = nonEmptyList.head;
final nelOdds = nonEmptyList.filter((a) => a.isOdd);

// nel

// range

final rInc = Range.inclusive(0, 5).tapEach(print); // 0, 1, 2, 3, 4, 5
final rExc0 = Range.exclusive(0, 5).by(2).tapEach(print); // 0, 2, 4
final rExc1 = Range.exclusive(0, 5, 2).tapEach(print); // 0, 2, 4

// range

// imap

final map = imap({
  'red': 1,
  'orange': 2,
  'yellow': 3,
  'green': 4,
  'blue': 5,
  'indigo': 6,
  'violet': 7,
});

final updatedMap = map.updated('green', 90);
final defaultValue = map.withDefaultValue(-1);
final defaultValue2 = map.withDefault((key) => key.length);

// imap

// iset

final aSet = iset([1, 3, 5, 7, 9]);

final remove5 = aSet.excl(5);
final remove1and9 = aSet.removedAll(iset([1, 9]));
final add11 = aSet + 11;

// iset
