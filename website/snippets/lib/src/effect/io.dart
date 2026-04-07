// ignore_for_file: avoid_print, unused_local_variable, unused_element

import 'dart:io';
import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

Future<void> snippet1() async {
  // #region io-1
  final rng = Future(() => math.Random.secure().nextInt(1000));

  await rng.then((x) => rng.then((y) => print('x: $x / y: $y')));
  // #endregion io-1
}

Future<void> snippet2() async {
  // #region io-2
  // Substitute the definition of fut with it's expression
  // x and y are different (probably)
  await Future(
    () => math.Random.secure().nextInt(1000),
  ).then(
    (x) => Future(() => math.Random.secure().nextInt(1000)).then((y) => print('x: $x / y: $y')),
  );
  // #endregion io-2
}

Future<void> snippet3() async {
  // #region io-3
  final rng = IO.delay(() => math.Random.secure().nextInt(1000));

  // x and y are different (probably)
  await rng.flatMap((x) => rng.flatMap((y) => IO.print('x: $x / y: $y'))).unsafeRunFuture();
  // #endregion io-3
}

Future<void> asyncSnippet1() async {
  // #region io-async-1
  IO<A> futureToIO<A>(Function0<Future<A>> fut) {
    return IO.async_<A>((cb) {
      fut().then(
        (a) => cb(Right(a)),
        onError: (Object err, StackTrace st) => cb(Left(err)),
      );
    });
  }

  // #endregion io-async-1
}

Future<void> errorHandlingSnippet1() async {
  // #region error-handling-1
  // composable handler using handleError
  final ioA = IO.delay(() => 90 / 0).handleError((ex) => 0);
  final ioB = IO.delay(() => 90 / 0).handleErrorWith((ex) => IO.pure(double.infinity));

  IO<double> safeDiv(int a, int b) => IO.defer(() {
    if (b != 0) {
      return IO.pure(a / b);
    } else {
      return IO.raiseError('cannot divide by 0!');
    }
  });
  // #endregion error-handling-1
}

void safeResourcesSnippet1() {
  // #region safe-resources-1
  final sink = File('path/to/file').openWrite();

  try {
    // use sink...
  } catch (e) {
    // catch error
  } finally {
    sink.close();
  }
  // #endregion safe-resources-1
}

void safeResourcesSnippet2() {
  // #region safe-resources-2
  final sink = IO.delay(() => File('path/to/file')).map((f) => f.openWrite());

  // bracket *ensures* that the sink is closed
  final program = sink.bracket(
    (sink) => IO.exec(() => sink.writeAll(['Hello', 'World'])),
    (sink) => IO.exec(() => sink.close()),
  );
  // #endregion safe-resources-2
}

Future<void> conversionsSnippet() async {
  // #region conversions-1
  IO.fromOption(const Some(42), () => Exception('raiseError: none'));

  IO.fromEither(Either.right(42));

  IO.fromFuture(IO.delay(() => Future(() => 42)));

  IO.fromCancelableOperation(
    IO.delay(
      () => CancelableOperation.fromFuture(
        Future(() => 32),
        onCancel: () => print('canceled!'),
      ),
    ),
  );
  // #endregion conversions-1

  // #region conversions-bad-future
  final fut = Future(() => print('bad'));

  // Too late! Future is already running!
  final ioBad = IO.fromFuture(IO.pure(fut));

  // IO.pure parameter is not lazy so it's evaluated immediately!
  final ioAlsoBad = IO.fromFuture(IO.pure(Future(() => print('also bad'))));

  // Here we preserve laziness so that ioGood is referentially transparent
  final ioGood = IO.fromFuture(IO.delay(() => Future(() => print('good'))));
  // #endregion conversions-bad-future
}

void deferSnippet() {
  // #region io-defer
  // IO.delay: synchronous thunk that produces a plain value A
  final delayEx = IO.delay(() => math.Random.secure().nextInt(100));

  // IO.defer: thunk that produces an IO<A> — use when choosing between IOs
  // at runtime, or when IO construction itself could throw
  IO<int> coinFlip() => IO.defer(() {
    final heads = math.Random.secure().nextBool();
    return heads ? IO.pure(1) : IO.raiseError('tails!');
  });
  // #endregion io-defer
}

void combinatorsSnippet() {
  // #region io-combinators
  // map: transform the successful value
  final doubled = IO.pure(21).map((n) => n * 2); // IO(42)

  // flatMap: sequence two IOs, passing the result of the first to the second
  final chained = IO.pure(10).flatMap((n) => IO.pure(n + 5)); // IO(15)

  // flatTap: run a side-effect using the value, then pass the value through
  final logged = IO.pure(42).flatTap((n) => IO.print('computed: $n')); // IO(42)

  // productR: run two IOs in sequence, keep only the second result
  final init = IO.print('setup').productR(IO.pure(42)); // IO(42)

  // attempt: pull a potential error into an Either instead of raising it
  final safe = IO.raiseError<int>('oops').attempt(); // IO<Either<Object, int>>

  // redeem: recover from an error or transform the success, all in one step
  final recovered = IO.raiseError<int>('oops').redeem((_) => -1, (n) => n * 2); // IO(-1)
  // #endregion io-combinators
}

void concurrencySnippet() {
  // #region io-both
  final fetchUser = IO.pure('Alice');
  final fetchProfile = IO.pure(99);

  // Both IOs run concurrently; if either fails the other is canceled
  final program = IO
      .both(fetchUser, fetchProfile)
      .flatMap((t) => IO.print('user: ${t.$1}, score: ${t.$2}'));
  // #endregion io-both

  // #region io-race
  final fast = IO.sleep(100.milliseconds).productR(IO.pure('fast result'));
  final slow = IO.sleep(500.milliseconds).productR(IO.pure('slow result'));

  // The winner is returned as Either<A, B>; the loser is automatically canceled
  final race = IO
      .race(fast, slow)
      .map((winner) => winner.fold((a) => 'A won: $a', (b) => 'B won: $b'));
  // #endregion io-race
}

void timingSnippet() {
  // #region io-timing
  // sleep: deliberate async delay
  final delayed = IO.sleep(200.milliseconds).productR(IO.pure(42));

  // timed: measure how long an IO takes
  final measured = IO.pure(42).timed(); // IO<(Duration, int)>

  // timeout: raise TimeoutException if the IO doesn't finish in time
  final withTimeout = IO.sleep(5.seconds).timeout(1.seconds);

  // timeoutTo: return a fallback IO instead of raising
  final withFallback = IO.sleep(5.seconds).productR(IO.pure(42)).timeoutTo(1.seconds, IO.pure(-1));
  // #endregion io-timing
}

void repetitionSnippet() {
  // #region io-repetition
  // replicate: run sequentially n times, collect results
  final rolls = IO.delay(() => math.Random.secure().nextInt(6) + 1).replicate(3);
  // IO<IList<int>>

  // replicate_: run n times, discard results
  final ticks = IO.print('tick').replicate_(5);

  // iterateUntil: keep running until the predicate is satisfied
  final poll = IO.delay(() => math.Random.secure().nextInt(100)).iterateUntil((n) => n > 90);
  // IO<int> — repeats until a value > 90 is produced
  // #endregion io-repetition
}

void traverseSnippet() {
  // #region io-traverse
  // traverseIO: apply an IO-valued function to each element, sequentially.
  // Short-circuits on the first error — later elements are not evaluated.
  final validated = ilist([2, 4, 6]).traverseIO(
    (n) => n.isEven ? IO.pure(n * 10) : IO.raiseError<int>('odd: $n'),
  ); // IO<IList<int>>([20, 40, 60])

  // traverseIO_: same, but discard the results
  final logged = ilist(['a', 'b', 'c']).traverseIO_((s) => IO.print('processing: $s'));

  // sequence: collapse IList<IO<A>> into IO<IList<A>>
  final actions = ilist([IO.pure(1), IO.pure(2), IO.pure(3)]);
  final sequenced = actions.sequence(); // IO<IList<int>>

  // parTraverseIO / parSequence: same ideas, but run all IOs concurrently
  final parallel = ilist([1, 2, 3]).parTraverseIO((n) => IO.pure(n * 10));
  // #endregion io-traverse
}

Future<void> outcomeSnippet() async {
  // #region io-outcome
  final outcome = await IO.pure(42).unsafeRunFutureOutcome();

  // fold over the three possible cases: canceled, errored, succeeded
  outcome.fold(
    () => print('IO was canceled'),
    (err, _) => print('IO failed: $err'),
    (value) => print('IO succeeded: $value'), // IO succeeded: 42
  );
  // #endregion io-outcome
}

Future<void> cancelationSnippet() async {
  // #region cancelation-1
  int count = 0;

  // Our IO program
  final io = IO
      .pure(42)
      .delayBy(10.seconds)
      .onCancel(IO.exec(() => count += 1))
      .onCancel(IO.exec(() => count += 2))
      .onCancel(IO.exec(() => count += 3));

  // .start() kicks off the IO execution and gives us a handle to that
  // execution in the form of an IOFiber
  final fiber = await io.start().unsafeRunFuture();

  // We immediately cancel the IO
  fiber.cancel().unsafeRunAndForget();

  // .join() will wait for the fiber to finish
  // In this case, that's immediate since we've canceled the IO above
  final outcome = await fiber.join().unsafeRunFuture();

  // Show the Outcome of the IO as well as confirmation that our `onCancel`
  // handlers have been called since the IO was canceled
  print('Outcome: $outcome | count: $count'); // Outcome: Canceled | count: 6
  // #endregion cancelation-1
}
