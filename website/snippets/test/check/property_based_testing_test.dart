import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

// #region check-basic

void basicTests() {
  // Gen.integer generates random ints across the full 32-bit range.
  // .forAll registers a test that runs the body 100 times by default.
  Gen.integer.forAll('abs is non-negative', (int n) {
    expect(n.abs(), greaterThanOrEqualTo(0));
  });

  // Built-in string generators cover common character sets.
  Gen.alphaLowerString().forAll('lowercase string is already lowercased', (String s) {
    expect(s.toLowerCase(), equals(s));
  });

  // List generators: sizeGen controls how many elements are produced.
  Gen.ilistOf(Gen.chooseInt(0, 20), Gen.integer).forAll(
    'reversing twice is identity',
    (IList<int> xs) {
      expect(xs.reverse().reverse(), equals(xs));
    },
  );
}

// #endregion check-basic

// #region check-combining

void combiningTests() {
  // A tuple of generators passes each value as a separate parameter to forAll.
  (Gen.integer, Gen.integer).forAll('addition is commutative', (int a, int b) {
    expect(a + b, equals(b + a));
  });

  // map transforms the generated value before handing it to the test.
  Gen.positiveInt.map((int n) => n * 2).forAll('doubling a positive int gives an even number', (
    int n,
  ) {
    expect(n % 2, equals(0));
  });

  // flatMap creates *dependent* generators — the second Gen uses the value
  // from the first. This generates a (lo, hi) pair that always satisfies lo <= hi.
  final rangeGen = Gen.chooseInt(-100, 100).flatMap(
    (int lo) => Gen.chooseInt(lo, 100).map((int hi) => (lo, hi)),
  );

  rangeGen.forAll('generated range always has lo <= hi', ((int, int) t) {
    expect(t.$1, lessThanOrEqualTo(t.$2));
  });

  // frequency picks between generators with weighted probability.
  // Here: 10% None, 90% Some with a positive int.
  Gen.option(Gen.positiveInt).forAll('option gen produces mostly Some', (Option<int> opt) {
    // Just checking the type is correct; no assertion about which variant.
    opt.fold(() => null, (int n) => expect(n, greaterThan(0)));
  });
}

// #endregion check-combining

// #region check-custom-gen

enum Priority { low, medium, high }

final class Task {
  final String name;
  final Priority priority;
  final int estimateHours;

  const Task(this.name, this.priority, this.estimateHours);

  @override
  String toString() => 'Task($name, $priority, ${estimateHours}h)';
}

// Build a Gen<Task> by combining three generators with .tupled and .map.
final Gen<Task> genTask = (
  Gen.nonEmptyAlphaNumString(20),
  Gen.chooseEnum(Priority.values),
  Gen.chooseInt(1, 40),
).tupled.map((t) => Task(t.$1, t.$2, t.$3));

void customGenTests() {
  genTask.forAll('task estimate is always within range', (Task task) {
    expect(task.estimateHours, greaterThanOrEqualTo(1));
    expect(task.estimateHours, lessThanOrEqualTo(40));
  });

  // Gen.ilistOf propagates the element shrinker automatically — if the
  // property fails for a long list, ribs_check will try shorter lists first.
  Gen.ilistOf(Gen.chooseInt(1, 8), genTask).forAll(
    'total estimate for a non-empty task list is positive',
    (IList<Task> tasks) {
      final total = tasks.foldLeft(0, (int acc, Task t) => acc + t.estimateHours);
      expect(total, greaterThan(0));
    },
  );
}

// #endregion check-custom-gen

// #region check-shrinking

void shrinkingTests() {
  // Shrink candidates can be inspected directly via gen.shrink(value).
  // Built-in shrinkers for Int drive values toward 0.
  test('integer shrinker produces candidates closer to 0', () {
    final candidates = Gen.integer.shrink(100).toList();
    expect(candidates, contains(0));
    expect(candidates.every((int n) => n.abs() < 100), isTrue);
  });

  // String shrinker removes characters — a failing string is minimised to the
  // shortest string that still triggers the failure.
  test('string shrinker produces shorter candidates', () {
    final candidates = Gen.alphaLowerString().shrink('hello').toList();
    expect(candidates.every((String s) => s.length < 'hello'.length), isTrue);
  });

  // IList shrinker removes elements, then shrinks individual elements.
  test('ilist shrinker removes elements', () {
    final xs = ilist([10, 20, 30, 40]);
    final candidates = Gen.ilistOf(Gen.chooseInt(0, 10), Gen.integer).shrink(xs).toList();
    expect(candidates.any((IList<int> c) => c.length < xs.length), isTrue);
  });
}

// #endregion check-shrinking

// #region check-seed

void seedTests() {
  // Pass seed: to lock the random sequence — the same seed always produces
  // the same inputs in the same order.  Useful for reproducing a CI failure.
  Gen.integer.forAll(
    'fixed seed produces a deterministic sequence',
    (int n) => expect(n, isNotNull),
    seed: 12345,
  );

  // numTests: controls the sample size (default 100).
  Gen.alphaLowerString().forAll(
    'run with 50 samples',
    (String s) => expect(s, isA<String>()),
    numTests: 50,
  );

  // When a property fails without an explicit seed, ribs_check prints:
  //
  //   Failed after 7 iterations using value <-42>.
  //   Initial seed: [1706123456789]
  //   To reproduce: RIBS_CHECK_SEED=1706123456789 dart test --plain-name "..."
  //
  // Set RIBS_CHECK_SEED in the environment to replay a failing run without
  // changing the test source.
}

// #endregion check-seed

void main() {
  group('basic properties', basicTests);
  group('combining generators', combiningTests);
  group('custom generator', customGenTests);
  group('shrinking', shrinkingTests);
  group('seed and sample size', seedTests);
}
