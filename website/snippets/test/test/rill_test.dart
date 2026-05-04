// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_test/ribs_test_rill.dart';
import 'package:test/test.dart';

// #region testing-rill-in-order
void producesInOrderTests() {
  test('emits expected sequence', () {
    expect(Rill.emits([1, 2, 3]), producesInOrder([1, 2, 3]));
    expect(Rill.emits([1, 2, 3]).map((n) => n * 2), producesInOrder([2, 4, 6]));

    // IList is also accepted by the matcher
    expect(Rill.emits([10, 20]), producesInOrder(ilist([10, 20])));
  });
}
// #endregion testing-rill-in-order

// #region testing-rill-only
void producesOnlyTests() {
  test('emits exactly one element', () {
    expect(Rill.emit(42), producesOnly(42));
  });
}
// #endregion testing-rill-only

// #region testing-rill-unordered
void producesUnorderedTests() {
  test('emits the same elements in any order', () {
    expect(Rill.emits([3, 1, 2]), producesUnordered([1, 2, 3]));
  });

  test('checking merged rills', () {
    expect(
      Rill.emits([1, 2, 3]).merge(Rill.emits([4, 5, 6])),
      producesUnordered([1, 2, 3, 4, 5, 6]),
    );
  });
}
// #endregion testing-rill-unordered

// #region testing-rill-nothing
void producesNothingTests() {
  test('emits no elements', () {
    expect(Rill.empty<int>(), producesNothing());
    expect(Rill.emits([1]).filter((_) => false), producesNothing());
  });
}
// #endregion testing-rill-nothing

// #region testing-rill-error
void producesErrorTests() {
  test('fails with error', () {
    expect(Rill.raiseError<int>('oops'), producesError('oops'));
    expect(Rill.raiseError<int>(Exception('!')), producesError(isA<Exception>()));
    expect(Rill.raiseError<int>('fatal'), producesError()); // any error
  });
}
// #endregion testing-rill-error

// #region testing-rill-same-as
void producesSameAsTests() {
  test('identity transformation preserves contents', () {
    final source = Rill.emits([1, 2, 3]);
    expect(source.map((n) => n), producesSameAs(Rill.emits([1, 2, 3])));
  });

  test('error comparison', () {
    expect(
      Rill.raiseError<int>('oops'),
      producesSameAs(Rill.raiseError<int>('oops')),
    );
  });

  test('codec round-trip', () {
    Rill<A> roundTrip<A>(Rill<A> source) => source;

    expect(roundTrip(Rill.emits([1, 2, 3])), producesSameAs(Rill.emits([1, 2, 3])));
  });
}
// #endregion testing-rill-same-as

void main() {
  group('producesInOrder', producesInOrderTests);
  group('producesOnly', producesOnlyTests);
  group('producesUnordered', producesUnorderedTests);
  group('producesNothing', producesNothingTests);
  group('producesError', producesErrorTests);
  group('producesSameAs', producesSameAsTests);
}
