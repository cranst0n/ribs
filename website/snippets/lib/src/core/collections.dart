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

// nel

final nonEmptyList = nel(1, [2, 3, 4, 5]);

final first = nonEmptyList.head;
final nelOdds = nonEmptyList.filter((a) => a.isOdd);

// nel

// imap

final map = IMap.fromIterable([
  ('red', 1),
  ('orange', 2),
  ('yellow', 3),
  ('green', 4),
  ('blue', 5),
  ('indigo', 6),
  ('violet', 7),
]);

final updatedMap = map.updated('green', 90);
final defaultValue = map.withDefaultValue(-1);
final defaultValue2 = map.withDefault((key) => key.length);

// imap

// iset

final aSet = ISet.of([1, 3, 5, 7, 9]);

final remove5 = aSet.excl(5);
final remove1and9 = aSet.removedAll(iset([1, 9]));
final add11 = aSet + 11;

// iset
