import 'package:ribs_core/ribs_core.dart';

// ignore_for_file: unused_local_variable

// option-some
void optionSome() {
  final Option<int> x = 42.some; // Some(42)
  final Option<String> y = 'hello'.some; // Some('hello')
}
// option-some

// either-lift
void eitherLift() {
  final Either<String, int> err = 'not found'.asLeft<int>();
  final Either<String, int> ok = 42.asRight<String>();
}
// either-lift

// duration
void durations() {
  final Duration d1 = 5.seconds;
  final Duration d2 = 100.milliseconds;
  final Duration d3 = 3.minutes;
  final Duration d4 = 2.hours;
}
// duration

// iterable-convert
void iterableConvert() {
  final List<int> dart = [1, 2, 3];

  final IList<int> list = dart.toIList();
  final IVector<int> vector = dart.toIVector();
}
// iterable-convert

// ilist-option-sequence
void ilistOptionSequence() {
  final IList<Option<int>> allSome = ilist([const Some(1), const Some(2), const Some(3)]);
  final Option<IList<int>> result = allSome.sequence(); // Some(IList[1,2,3])

  final IList<Option<int>> hasnone = ilist([const Some(1), none<int>(), const Some(3)]);
  final Option<IList<int>> none_ = hasnone.sequence(); // None
}
// ilist-option-sequence

// ilist-unNone
void ilistUnNone() {
  final IList<Option<int>> mixed = ilist([const Some(1), none<int>(), const Some(3)]);
  final IList<int> compact = mixed.unNone(); // IList[1, 3]
}
// ilist-unNone

// ilist-unzip
void ilistUnzip() {
  final IList<(String, int)> pairs = ilist([('a', 1), ('b', 2)]);
  final (IList<String>, IList<int>) result = pairs.unzip();
}
// ilist-unzip

// string-ops
void stringOps() {
  const String s = 'Hello, World!';

  final String taken = s.take(5); // 'Hello'
  final String dropped = s.drop(7); // 'World!'
  final String filtered = s.filter((c) => c != ','); // 'Hello World!'
  final Option<String> f = s.find((c) => c == 'W'); // Some('W')
  final (String, String) parts = s.splitAt(5); // ('Hello', ', World!')
}
// string-ops

// riterable-numeric
void riterableNumeric() {
  final IList<int> ints = ilist([1, 2, 3, 4, 5]);
  final int sum = ints.sum(); // 15
  final int prod = ints.product(); // 120

  final IList<double> doubles = ilist([1.0, 2.0, 3.0]);
  final double dsum = doubles.sum(); // 6.0
}
// riterable-numeric

// riterable-toIMap
void riterableToIMap() {
  final IList<(String, int)> pairs = ilist([('a', 1), ('b', 2)]);
  final IMap<String, int> map = pairs.toIMap();
}
// riterable-toIMap

// tuple-hlist
void tupleHlist() {
  const t = ('hello', 42, true);

  final String first = t.head; // 'hello'
  final bool last = t.last; // true
  final (int, bool) tl = t.tail; // (42, true)
  final (String, int) it = t.init; // ('hello', 42)
}
// tuple-hlist

// tuple-append-prepend
void tupleAppendPrepend() {
  const pair = ('a', 1);

  final (String, int, bool) appended = pair.appended(true); // ('a', 1, true)
  final (double, String, int) prepended = pair.prepended(3.14); // (3.14, 'a', 1)
}
// tuple-append-prepend

// tuple-call
void tupleCall() {
  const t = ('hello', 42);

  // Spread the tuple as positional arguments into a function.
  final int result = t.call((String s, int n) => s.length + n); // 47
}

// tuple-call
