import 'package:matcher/src/expect/async_matcher.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/src/rill.dart';
import 'package:test/test.dart';

Matcher producesError([Object? matcher]) => _ProducesError(matcher);
Matcher producesInOrder(Object expected) => _ProducesInOrder(expected);
Matcher producesNothing() => _ProducesNothing();
Matcher producesOnly<A>(A a) => _ProducesInOrder([a]);
Matcher producesSameAs<A>(Rill<A> expected) => _ProducesSameAs(expected);
Matcher producesUnordered(Object expected) => _ProducesUnordered(expected);

class _ProducesError extends AsyncMatcher {
  final Object? matcher;

  _ProducesError(this.matcher);

  @override
  Description describe(Description description) => description.add('produces an error');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is! Rill) {
      return 'was not a Rill';
    }

    return item.compile.toList.unsafeRunFutureOutcome().then((outcome) {
      return outcome.fold(
        () => fail('Rill did not succeed, but was canceled'),
        (err, _) {
          if (matcher != null) {
            expect(err, matcher);
          }
        },
        (a) => fail('Rill did not error, but was succeeded: $a'),
      );
    });
  }
}

class _ProducesInOrder extends AsyncMatcher {
  final Object expected;

  _ProducesInOrder(this.expected);

  @override
  Description describe(Description description) => description.add('produces in order');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is! Rill) {
      return 'was not a Rill';
    }

    return item.compile.toList.unsafeRunFutureOutcome().then((outcome) {
      return outcome.fold(
        () => fail('Rill did not succeed, but was canceled'),
        (err, _) => fail('Rill did not succeed, but errored: $err'),
        (a) {
          if (expected is Iterable) {
            expect(a, ilist(expected as Iterable));
          } else if (expected is RIterableOnce) {
            expect(a, (expected as RIterableOnce).toIList());
          } else {
            fail('Invalid matcher provides: $expected');
          }
        },
      );
    });
  }
}

class _ProducesNothing extends AsyncMatcher {
  _ProducesNothing();

  @override
  Description describe(Description description) => description.add('produces nothing');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is! Rill) {
      return 'was not a Rill';
    }

    return item.compile.toList.unsafeRunFutureOutcome().then((outcome) {
      return outcome.fold(
        () => fail('Rill did not succeed, but was canceled'),
        (err, _) => fail('Rill did not succeed, but errored: $err'),
        (a) => expect(a.isEmpty, isTrue),
      );
    });
  }
}

class _ProducesSameAs<A> extends AsyncMatcher {
  final Rill<A> expected;

  _ProducesSameAs(this.expected);

  @override
  Description describe(Description description) => description.add('produces same as');

  @override
  dynamic matchAsync(dynamic item) async {
    if (item is! Rill) {
      return 'was not a Rill';
    }

    final a = await item.compile.toList.unsafeRunFutureOutcome();
    final b = await expected.compile.toList.unsafeRunFutureOutcome();

    a.fold(
      () => expect(b.isCanceled, isTrue),
      (errA, _) {
        b.fold(
          () => fail('A failed but B was canceled.'),
          (errB, _) => errA == errB,
          (_) => fail('A failed but B succeeded.'),
        );
      },
      (resultA) {
        b.fold(
          () => fail('A succeeded but B was canceled.'),
          (_, _) => fail('A errored but B was canceled.'),
          (resultB) => expect(resultA, resultB),
        );
      },
    );
  }
}

class _ProducesUnordered extends AsyncMatcher {
  final Object expected;

  _ProducesUnordered(this.expected);

  @override
  Description describe(Description description) => description.add('produces unordered');

  @override
  dynamic matchAsync(dynamic item) {
    if (item is! Rill) {
      return 'was not a Rill';
    }

    return item.compile.toList.unsafeRunFutureOutcome().then((outcome) {
      return outcome.fold(
        () => fail('Rill did not succeed, but was canceled'),
        (err, _) => fail('Rill did not succeed, but errored: $err'),
        (a) {
          if (expected is Iterable) {
            final iterable = expected as Iterable;

            expect(
              a.size == iterable.length &&
                  a.forall((a0) => iterable.contains(a0)) &&
                  ilist(iterable).forall((a0) => a.contains(a0)),
              isTrue,
            );
          } else if (expected is RIterableOnce) {
            final iterable = (expected as RIterableOnce).toIList();

            expect(
              a.size == iterable.size &&
                  a.forall((a0) => iterable.contains(a0)) &&
                  iterable.forall((a0) => a.contains(a0)),
              isTrue,
            );
          }
        },
      );
    });
  }
}
