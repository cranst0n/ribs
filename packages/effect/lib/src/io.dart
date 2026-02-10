import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/io_runtime.dart';
import 'package:ribs_effect/src/platform/stub.dart'
    if (dart.library.js_interop) 'platform/web.dart'
    if (dart.library.io) 'platform/native.dart';
import 'package:ribs_effect/src/std/internal/stack.dart';

part 'io/algebra.dart';
part 'io/continuation.dart';
part 'io/fiber.dart';
part 'io/resumption.dart';
part 'io/tracing.dart';

typedef AsyncCallback<A> = Function1<Either<Object, A>, void>;
typedef AsyncBody<A> = Function1<AsyncCallback<A>, void>;
typedef AsyncBodyWithFin<A> = Function1<AsyncCallback<A>, IO<Option<IO<Unit>>>>;

typedef AWon<A, B> = (Outcome<A>, IOFiber<B>);
typedef BWon<A, B> = (IOFiber<A>, Outcome<B>);
typedef RacePairOutcome<A, B> = Either<AWon<A, B>, BWon<A, B>>;

/// IO is a datatype that can be used to control side-effects within
/// synchronous and asynchronous code.
sealed class IO<A> with Functor<A>, Applicative<A>, Monad<A> {
  const IO();

  static final PlatformImpl _platformImpl = PlatformImpl();

  static void installFiberDumpSignalHandler() => _platformImpl.installFiberDumpSignalHandler();

  /// Suspends the asynchronous effect [k] within [IO]. When evaluation is
  /// completed, the callback will be invoked with the result of the [IO].
  /// If the newly created [IO] is canceled, the provided finalizer will be
  /// invoked.
  static IO<A> async<A>(AsyncBodyWithFin<A> k) => _async(k);
  static IO<A> _async<A>(AsyncBodyWithFin<A> k) => _Async(k).traced('async');

  /// Suspends the asynchronous effect [k] within [IO]. When evaluation is
  /// completed, the callback will be invoked with the result of the [IO].
  static IO<A> async_<A>(AsyncBody<A> k) => _async_(k).traced('async_');
  static IO<A> _async_<A>(AsyncBody<A> k) => _Async((cb) {
    k(cb);
    return _none();
  });

  /// Runs both [ioa] and [iob] together, returning a tuple of both results
  /// if both of them are successful. If either of them results in an error or
  /// is canceled, that error or cancelation is propogated.
  static IO<(A, B)> both<A, B>(IO<A> ioa, IO<B> iob) => _both(ioa, iob).traced('both');
  static IO<(A, B)> _both<A, B>(IO<A> ioa, IO<B> iob) => IO._uncancelable(
    (poll) => poll(_racePair(ioa, iob))._flatMap(
      (winner) => winner.fold(
        (aWon) => aWon((oca, f) {
          return oca.fold(
            () => f.cancel()._productR(() => poll(IO.canceled))._productR(() => IO._never()),
            (err, st) => f.cancel()._productR(() => IO._raiseError(err, st)),
            (a) => poll(f.join())
                ._onCancel(f.cancel())
                ._flatMap(
                  (ocb) => ocb.fold(
                    () => poll(IO.canceled)._productR(() => IO._never()),
                    (err, st) => IO._raiseError(err, st),
                    (b) => IO.pure((a, b)),
                  ),
                ),
          );
        }),
        (bWon) => bWon((f, ocb) {
          return ocb.fold(
            () => f.cancel()._productR(() => poll(IO.canceled))._productR(() => IO._never()),
            (err, st) => f.cancel()._productR(() => IO._raiseError(err, st)),
            (b) => poll(f.join())
                ._onCancel(f.cancel())
                ._flatMap(
                  (oca) => oca.fold(
                    () => poll(IO.canceled)._productR(() => IO._never()),
                    (err, st) => IO._raiseError(err, st),
                    (a) => IO.pure((a, b)),
                  ),
                ),
          );
        }),
      ),
    ),
  );

  /// Runs both [ioa] and [iob], returning a tuple of the [Outcome] of each.
  static IO<(Outcome<A>, Outcome<B>)> bothOutcome<A, B>(IO<A> ioa, IO<B> iob) =>
      _bothOutcome(ioa, iob);
  static IO<(Outcome<A>, Outcome<B>)> _bothOutcome<A, B>(IO<A> ioa, IO<B> iob) => IO._uncancelable(
    (poll) => poll(_racePair(ioa, iob))._flatMap(
      (winner) => winner.fold(
        (aWon) => aWon((a, f) => poll(f.join())._onCancel(f.cancel())._tupleLeft(a)),
        (bWon) => bWon((f, b) => poll(f.join())._onCancel(f.cancel())._tupleRight(b)),
      ),
    ),
  );

  /// Creates an [IO] that will evaluate [acquire], pass the result
  /// to [use] if successful and then guarantee the evaluation of [release].
  static IO<B> bracketFull<A, B>(
    Function1<Poll, IO<A>> acquire,
    Function1<A, IO<B>> use,
    Function2<A, Outcome<B>, IO<Unit>> release,
  ) => _bracketFull(acquire, use, release).traced('bracketFull');
  static IO<B> _bracketFull<A, B>(
    Function1<Poll, IO<A>> acquire,
    Function1<A, IO<B>> use,
    Function2<A, Outcome<B>, IO<Unit>> release,
  ) => IO._uncancelable(
    (poll) => acquire(poll)._flatMap(
      (a) => IO._defer(() => poll(use(a)))._guaranteeCase((oc) => release(a, oc)),
    ),
  );

  /// Creates an [IO] that immediately results in an [Outcome] of [Canceled].
  static const IO<Unit> canceled = _Canceled();

  /// Introduces an asynchronous boundary in the IO runtime loop that can
  /// be used for cancelation checking and fairness, among other things.
  static const IO<Unit> cede = _Cede();

  /// Suspends the synchronous evaluation of [thunk] in [IO].
  static IO<A> defer<A>(Function0<IO<A>> thunk) => _defer(thunk).traced('defer');
  static IO<A> _defer<A>(Function0<IO<A>> thunk) => _delay(thunk)._flatten();

  /// Creates a new [Deferred] of the given generic type.
  static IO<Deferred<A>> deferred<A>() => Deferred.of<A>();

  /// Suspends the synchronous evaluation of [thunk] in [IO].
  static IO<A> delay<A>(Function0<A> thunk) => _delay(thunk).traced('delay');
  static IO<A> _delay<A>(Function0<A> thunk) => _Delay(Fn0(thunk));

  /// Executes the given function, discarding any result.
  static IO<Unit> exec<A>(Function0<A> thunk) => _exec(thunk).traced('exec');
  static IO<Unit> _exec<A>(Function0<A> thunk) => _Delay(Fn0(thunk))._voided();

  /// Creates an [IO] that returns the value or error of the underlying
  /// [CancelableOperation]. If new [IO] is canceled, the cancelation request
  /// will be forwarded to the underlying  [CancelableOperation].
  static IO<A> fromCancelableOperation<A>(IO<CancelableOperation<A>> op) {
    return op
        ._flatMap((op) {
          return IO._async<A>((cb) {
            return IO._delay(() {
              op.then(
                (a) => cb(a.asRight()),
                onError: (e, s) => cb(e.asLeft()),
              );

              return Some(IO._fromFutureF(() => op.cancel().then((_) => Unit())));
            });
          });
        })
        .traced('fromCancelableOperation');
  }

  /// Alias for `IO.pure` when [either] is [Right], or `IO.raiseError` with
  /// [either] providing the error when [either] is [Left].
  static IO<A> fromEither<A>(Either<Object, A> either) => _fromEither(either).traced('fromEither');
  static IO<A> _fromEither<A>(Either<Object, A> either) =>
      either.fold((e) => IO._raiseError<A>(e), IO.pure);

  /// Create an [IO] that returns the value of the underlying [Future] or
  /// the error [fut] emits.
  static IO<A> fromFuture<A>(IO<Future<A>> fut) => _fromFuture(fut).traced('fromFuture');
  static IO<A> _fromFuture<A>(IO<Future<A>> fut) => fut._flatMap(
    (f) => _async_<A>(
      (cb) => f.then(
        (a) => cb(a.asRight()),
        onError: (Object e, StackTrace s) => cb(e.asLeft()),
      ),
    ),
  );

  /// Create an [IO] that returns the value of the underlying [Future] function
  /// or the error [futF] emits.
  static IO<A> fromFutureF<A>(Function0<Future<A>> futF) =>
      _fromFutureF(futF).traced('fromFutureF');
  static IO<A> _fromFutureF<A>(Function0<Future<A>> futF) => _fromFuture(IO._delay(futF));

  /// Alias for `IO.pure` when [option] is [Some], or `IO.raiseError` with
  /// [orElse] providing the error when [option] is [None].
  static IO<A> fromOption<A>(Option<A> option, Function0<Object> orElse) =>
      _fromOption(option, orElse).traced('fromOption');
  static IO<A> _fromOption<A>(Option<A> option, Function0<Object> orElse) =>
      option.fold(() => IO._raiseError<A>(orElse()), IO.pure);

  /// Returns a non-terminating [IO], alias for `async_((_) {})`.
  static IO<A> never<A>() => _never<A>().traced('never');
  static IO<A> _never<A>() => _async_((_) {});

  /// Alias for `IO.pure(const None())`.
  static IO<Option<A>> none<A>() => _none<A>().traced('none');
  static IO<Option<A>> _none<A>() => IO.pure(const None());

  /// Returns the current [DateTime] when evaluation occurs.
  static const IO<DateTime> now = _Now();

  /// Writes [message] to stdout, delaying the effect until evaluation.
  static IO<Unit> print(String message) => _platformImpl.print(message).traced('print');

  /// Writes [message] with a newline to stdout, delaying the effect until
  /// evaluation.
  static IO<Unit> println(String message) => _platformImpl.println(message).traced('println');

  /// Writes [message] to stderr, delaying the effect until evaluation.
  static IO<Unit> printErr(String message) => _platformImpl.printErr(message).traced('printErr');

  /// Writes [message] with a newline to stderr, delaying the effect until
  /// evaluation.
  static IO<Unit> printErrLn(String message) =>
      _platformImpl.printErrLn(message).traced('printErrLn');

  /// Lifts a pure value into [IO].
  static IO<A> pure<A>(A a) => _Pure(a);

  /// Runs [ioa] and [iob] together, returning the first [IO] to finish after
  /// the loser is canceled.
  static IO<Either<A, B>> race<A, B>(IO<A> ioa, IO<B> iob) => _race(ioa, iob).traced('race');
  static IO<Either<A, B>> _race<A, B>(IO<A> ioa, IO<B> iob) => IO._uncancelable(
    (poll) => poll(IO._racePair(ioa, iob))._flatMap(
      (winner) {
        return winner.fold(
          (aWon) => aWon((oca, fiberB) {
            return oca.fold(
              () => fiberB
                  .cancel()
                  ._productR(() => fiberB.join())
                  ._flatMap(
                    (ocb) => ocb.fold(
                      () => poll(IO.canceled)._productR(() => IO._never()),
                      (err, st) => IO._raiseError(err, st),
                      (b) => IO.pure(Right(b)),
                    ),
                  ),
              (err, st) => fiberB.cancel()._productR(() => IO._raiseError(err)),
              (a) => fiberB.cancel()._as(Left(a)),
            );
          }),
          (bWon) => bWon((fiberA, ocb) {
            return ocb.fold(
              () => fiberA
                  .cancel()
                  ._productR(() => fiberA.join())
                  ._flatMap(
                    (oca) => oca.fold(
                      () => poll(IO.canceled)._productR(() => IO._never()),
                      (err, st) => IO._raiseError(err, st),
                      (a) => IO.pure(Left(a)),
                    ),
                  ),
              (err, st) => fiberA.cancel()._productR(() => IO._raiseError(err, st)),
              (b) => fiberA.cancel()._as(Right(b)),
            );
          }),
        );
      },
    ),
  );

  /// Runs [ioa] and [iob] together, returning the [Outcome] of the winner after
  /// canceling the loser.
  static IO<Either<Outcome<A>, Outcome<B>>> raceOutcome<A, B>(IO<A> ioa, IO<B> iob) =>
      _raceOutcome(ioa, iob);
  static IO<Either<Outcome<A>, Outcome<B>>> _raceOutcome<A, B>(
    IO<A> ioa,
    IO<B> iob,
  ) => IO._uncancelable(
    (poll) => poll(_racePair(ioa, iob))._flatMap(
      (winner) => winner.fold(
        (aWon) => aWon((a, f) => f.cancel()._as(Left(a))),
        (bWon) => bWon((f, b) => f.cancel()._as(Right(b))),
      ),
    ),
  );

  /// Runs [ioa] and [iob] together, returning a pair of the [Outcome] of the
  /// [IO] that finished first (won) and an [IOFiber] handle for the loser.
  static IO<Either<AWon<A, B>, BWon<A, B>>> racePair<A, B>(IO<A> ioa, IO<B> iob) =>
      _racePair(ioa, iob).traced('racePair');
  static IO<Either<AWon<A, B>, BWon<A, B>>> _racePair<A, B>(IO<A> ioa, IO<B> iob) =>
      _RacePair(ioa, iob);

  /// Create an IO that will inject the given error into the IO evaluation.
  static IO<A> raiseError<A>(Object error, [StackTrace? st]) =>
      _raiseError<A>(error, st).traced('raiseError');
  static IO<A> _raiseError<A>(Object error, [StackTrace? st]) =>
      _Error(error, st ?? StackTrace.current);

  /// Returns an `IO.raiseError` when [cond] is false, otherwice `IO.unit`.
  static IO<Unit> raiseUnless(bool cond, Function0<Object> e) =>
      _raiseUnless(cond, e).traced('raiseUnless');
  static IO<Unit> _raiseUnless(bool cond, Function0<Object> e) =>
      IO._unlessA(cond, () => IO._raiseError<Unit>(e()));

  /// Returns an `IO.raiseError` when [cond] is true, otherwice `IO.unit`.
  static IO<Unit> raiseWhen(bool cond, Function0<Object> e) =>
      _raiseWhen(cond, e).traced('raiseWhen');
  static IO<Unit> _raiseWhen(bool cond, Function0<Object> e) =>
      IO._whenA(cond, () => IO._raiseError<Unit>(e()));

  /// Reads a line from stdin. **This is a blocking operation and will
  /// not finish until a full line of input is available from the console.**
  static IO<String> readLine() => _platformImpl.readLine();

  /// Creates a new [Ref] of the given generic type.
  static IO<Ref<A>> ref<A>(A a) => Ref.of(a);

  /// Creates an ansynchronous [IO] that will sleep for the given [duration]
  /// and resume when finished.
  static IO<Unit> sleep(Duration duration) => _sleep(duration).traced('sleep');
  static IO<Unit> _sleep(Duration duration) => _Sleep(duration);

  /// Alias for `IO.pure(Some(a))`.
  static IO<Option<A>> some<A>(A a) => _some(a).traced('some');
  static IO<Option<A>> _some<A>(A a) => IO.pure(Some(a));

  /// Alias for `IO.delay(() => throw UnimplementedError())`
  static IO<Never> get stub => _stub.traced('stub');
  static IO<Never> get _stub => IO._delay(() => throw UnimplementedError());

  /// Creates an uncancelable region within the IO run loop. The [Poll] provided
  /// can be used to create unmasked cancelable regions within the uncancelable
  /// region.
  static IO<A> uncancelable<A>(Function1<Poll, IO<A>> body) =>
      _uncancelable(body).traced('uncancelable');
  static IO<A> _uncancelable<A>(Function1<Poll, IO<A>> body) => _Uncancelable(body);

  /// Alias for `IO.pure(Unit())`.
  static final IO<Unit> unit = IO.pure(Unit());

  /// Returns the [action] argument when [cond] is false, otherwise returns
  /// [IO.unit].
  static IO<Unit> unlessA<A>(bool cond, Function0<IO<A>> action) =>
      _unlessA(cond, action).traced('unlessA');
  static IO<Unit> _unlessA<A>(bool cond, Function0<IO<A>> action) =>
      cond ? IO.unit : action()._voided();

  /// Returns the [action] argument when [cond] is true, otherwise returns
  /// [IO.unit].
  static IO<Unit> whenA<A>(bool cond, Function0<IO<A>> action) =>
      _whenA(cond, action).traced('whenA');
  static IO<Unit> _whenA<A>(bool cond, Function0<IO<A>> action) =>
      cond ? action()._voided() : IO.unit;

  /// Return an IO that will wait the specified [duration] **after** evaluating
  /// and then return the result.
  IO<A> andWait(Duration duration) => _andWait(duration).traced('andWait');
  IO<A> _andWait(Duration duration) => _flatTap((_) => IO._sleep(duration));

  @override
  IO<B> ap<B>(IO<Function1<A, B>> f) => _flatMap((a) => f._map((f) => f(a)));

  /// Replaces the result of this [IO] with the given value.
  IO<B> as<B>(B b) => _as(b).traced('as');
  IO<B> _as<B>(B b) => _map((_) => b);

  /// Extracts any exceptions encountered during evaluation into an [Either]
  /// value.
  IO<Either<Object, A>> attempt() => _attempt().traced('attempt');
  IO<Either<Object, A>> _attempt() => _Attempt(this);

  IO<A> attemptTap<B>(Function1<Either<Object, A>, IO<B>> f) => _attemptTap(f).traced('attemptTap');
  IO<A> _attemptTap<B>(Function1<Either<Object, A>, IO<B>> f) =>
      _attempt()._flatTap(f)._rethrowError();

  /// Creates a new [Resource] that will start the execution of this fiber and
  /// cancel the execution when the [Resource] is finalized.
  Resource<IO<Outcome<A>>> background() =>
      Resource.make(_start(), (fiber) => fiber.cancel()).map((f) => f.join());

  /// Returns an IO that uses this IO as the resource acquisition, [use] as the
  /// IO action that action that uses the resource, and [release] as the
  /// finalizer that will clean up the resource.
  IO<B> bracket<B>(Function1<A, IO<B>> use, Function1<A, IO<Unit>> release) =>
      _bracket(use, release).traced('bracket');
  IO<B> _bracket<B>(Function1<A, IO<B>> use, Function1<A, IO<Unit>> release) =>
      _bracketCase(use, (a, _) => release(a));

  /// Returns an IO that uses this IO as the resource acquisition, [use] as the
  /// IO action that action that uses the resource, and [release] as the
  /// finalizer that will clean up the resource. Both result of this IO *and*
  /// the [Outcome] of [use] are provided to [release].
  IO<B> bracketCase<B>(
    Function1<A, IO<B>> use,
    Function2<A, Outcome<B>, IO<Unit>> release,
  ) => _bracketCase(use, release).traced('bracketCase');
  IO<B> _bracketCase<B>(
    Function1<A, IO<B>> use,
    Function2<A, Outcome<B>, IO<Unit>> release,
  ) => IO._bracketFull((_) => this, use, release);

  IO<A> cancelable(IO<Unit> fin) => _cancelable(fin).traced('cancelable');
  IO<A> _cancelable(IO<Unit> fin) => IO._uncancelable((poll) {
    return _start()._flatMap((fiber) {
      return poll(fiber.join())
          ._onCancel(fin._guarantee(fiber.cancel()))
          ._flatMap((oc) => oc.embed(poll(canceled._productR(() => IO._never()))));
    });
  });

  /// Prints the result of this IO (value, error or canceled) to stdout
  IO<A> debug({String prefix = 'DEBUG'}) => _guaranteeCase(
    (outcome) => outcome.fold(
      () => _platformImpl.println('$prefix: Canceled'),
      (err, _) => _platformImpl.println('$prefix: Errored: $err'),
      (a) => _platformImpl.println('$prefix: Succeeded: $a'),
    ),
  ).traced('debug');

  /// Return an IO that will wait the specified [duration] **before** evaluating
  /// and then return the result.
  IO<A> delayBy(Duration duration) => _delayBy(duration).traced('delayBy');
  IO<A> _delayBy(Duration duration) => IO._sleep(duration)._productR(() => this);

  /// Sequences the evaluation of this IO and the provided function [f] that
  /// will create the next [IO] to be evaluated.
  @override
  IO<B> flatMap<B>(Function1<A, IO<B>> f) => _flatMap(f).traced('flatMap');
  IO<B> _flatMap<B>(Function1<A, IO<B>> f) => _FlatMap(this, Fn1(f));

  /// Performs the side-effect encoded in [f] using the value created by this
  /// [IO], then returning the original value.
  IO<A> flatTap<B>(Function1<A, IO<B>> f) => _flatTap(f).traced('flatTap');
  IO<A> _flatTap<B>(Function1<A, IO<B>> f) => _flatMap((a) => f(a)._as(a));

  /// Continually re-evaluate this [IO] forever, until an error or cancelation.
  IO<Never> foreverM() => _foreverM().traced('foreverM');
  IO<Never> _foreverM() => _productR(() => _foreverM());

  /// Executes the provided finalizer [fin] regardless of the [Outcome] of
  /// evaluating this [IO].
  IO<A> guarantee(IO<Unit> fin) => _guarantee(fin).traced('guarantee');
  IO<A> _guarantee(IO<Unit> fin) => IO._uncancelable(
    (poll) => poll(
      this,
    )._onCancel(fin)._onError((e) => fin._productR(() => IO._raiseError(e)))._flatTap((_) => fin),
  );

  /// Executes the provided finalizer [fin] which can decide what action to
  /// take depending on the [Outcome] of this [IO].
  IO<A> guaranteeCase(Function1<Outcome<A>, IO<Unit>> fin) =>
      _guaranteeCase(fin).traced('guaranteeCase');
  IO<A> _guaranteeCase(Function1<Outcome<A>, IO<Unit>> fin) => IO._uncancelable(
    (poll) => poll(this)
        ._onCancel(fin(Outcome.canceled()))
        ._onError((err) => fin(Outcome.errored(err)))
        ._flatTap((a) => fin(Outcome.succeeded(a))),
  );

  /// Intercepts any upstream Exception, returning the value generated by [f].
  IO<A> handleError(Function1<Object, A> f) => _handleError(f).traced('handleError');
  IO<A> _handleError(Function1<Object, A> f) => _handleErrorWith((e) => IO.pure(f(e)));

  /// Intercepts any upstream Exception, sequencing in the [IO] generated by [f].
  IO<A> handleErrorWith(Function1<Object, IO<A>> f) =>
      _handleErrorWith(f).traced('handleErrorWith');
  IO<A> _handleErrorWith(Function1<Object, IO<A>> f) => _HandleErrorWith(this, Fn1(f));

  IO<A> isolate({String? debugName}) => _platformImpl.isolate(this, debugName: debugName);

  /// Continually re-evaluates this [IO] until the computed value satisfies the
  /// given predicate [p]. The first computed value that satisfies [p] will be
  /// the final result.
  IO<A> iterateUntil(Function1<A, bool> p) => _iterateUntil(p).traced('iterateUntil');
  IO<A> _iterateUntil(Function1<A, bool> p) => _iterateWhile((a) => !p(a));

  /// Continually re-evaluates this [IO] while the computed value satisfies the
  /// given predicate [p]. The first computed value that does not satisfy [p]
  /// will be the final result.
  IO<A> iterateWhile(Function1<A, bool> p) => _iterateWhile(p).traced('iterateWhile');
  IO<A> _iterateWhile(Function1<A, bool> p) =>
      _flatMap((a) => p(a) ? _iterateWhile(p) : IO.pure(a));

  /// Applies [f] to the value of this IO, returning the result.
  @override
  IO<B> map<B>(Function1<A, B> f) => _map(f).traced('map');
  IO<B> _map<B>(Function1<A, B> f) => _Map(this, Fn1(f));

  /// Attaches a finalizer to this [IO] that will be evaluated if this
  /// [IO] is canceled.
  IO<A> onCancel(IO<Unit> fin) => _onCancel(fin).traced('onCancel');
  IO<A> _onCancel(IO<Unit> fin) => _OnCancel(this, fin);

  /// Performs the given side-effect if this [IO] results in a error.
  IO<A> onError(Function1<Object, IO<Unit>> f) => _onError(f).traced('onError');
  IO<A> _onError(Function1<Object, IO<Unit>> f) =>
      _handleErrorWith((e) => f(e)._attempt()._productR(() => IO._raiseError<A>(e)));

  /// Replaces any failures from this IO with [None]. A successful value is
  /// wrapped in [Some].
  IO<Option<A>> option() => _option().traced('option');
  IO<Option<A>> _option() => _redeem((_) => const None(), (a) => Some(a));

  /// If the evaluation of this [IO] results in an error, run [that] as an
  /// attempt to recover.
  IO<A> orElse(Function0<IO<A>> that) => _orElse(that).traced('orElse');
  IO<A> _orElse(Function0<IO<A>> that) => _handleErrorWith((_) => that());

  /// Runs this [IO] [n] times, accumulating the result from each evaluation
  /// into an [IList]. All replications will be run asynchronously.
  IO<IList<A>> parReplicate(int n) => _parReplicate(n).traced('parReplicate');
  IO<IList<A>> _parReplicate(int n) =>
      n <= 0
          ? IO.pure(nil())
          : IO._both(this, _parReplicate(n - 1)).mapN((a, acc) => acc.prepended(a));

  /// Runs this [IO] [n] times, discarding any resulting values.  All
  /// replications will be run asynchronously.
  IO<Unit> parReplicate_(int n) => _parReplicate_(n).traced('parReplicate_');
  IO<Unit> _parReplicate_(int n) =>
      n <= 0 ? IO.unit : IO._both(this, _parReplicate_(n - 1))._voided();

  /// Sequentially evaluate this [IO], then [that], and return the product
  /// (i.e. tuple) of each value.
  IO<(A, B)> product<B>(IO<B> that) => _product(that).traced('product');
  IO<(A, B)> _product<B>(IO<B> that) => _flatMap((a) => that._map((b) => (a, b)));

  /// Sequentially evaluate this [IO], then [that], returning the value
  /// producted by this, discarding that value from [that].
  IO<A> productL<B>(Function0<IO<B>> that) => _productL(that).traced('productL');
  IO<A> _productL<B>(Function0<IO<B>> that) => _flatMap((a) => that()._as(a));

  /// Sequentially evaluate this [IO], then [that], returning the value
  /// producted by [that], discarding the value from this.
  IO<B> productR<B>(Function0<IO<B>> that) => _productR(that).traced('productR');
  IO<B> _productR<B>(Function0<IO<B>> that) => _flatMap((_) => that());

  /// Returns the value created from [recover] or [map], depending on whether
  /// this [IO] results in an error or is successful.
  IO<B> redeem<B>(Function1<Object, B> recover, Function1<A, B> map) =>
      _redeem(recover, map).traced('redeem');
  IO<B> _redeem<B>(Function1<Object, B> recover, Function1<A, B> map) =>
      _attempt()._map((a) => a.fold(recover, map));

  /// Returns the value created from [recover] or [map], depending on whether
  /// this [IO] results in an error or is successful.
  IO<B> redeemWith<B>(
    Function1<Object, IO<B>> recover,
    Function1<A, IO<B>> bind,
  ) => _redeemWith(recover, bind).traced('redeemWith');
  IO<B> _redeemWith<B>(
    Function1<Object, IO<B>> recover,
    Function1<A, IO<B>> bind,
  ) => _attempt()._flatMap((a) => a.fold(recover, bind));

  /// Runs this [IO] [n] times, accumulating the result from each evaluation
  /// into an [IList].
  IO<IList<A>> replicate(int n) => _replicate(n).traced('replicate');
  IO<IList<A>> _replicate(int n) =>
      n <= 0 ? IO.pure(nil()) : _flatMap((a) => _replicate(n - 1)._map((l) => l.prepended(a)));

  /// Runs this [IO] [n] times, discarding any resulting values.
  IO<Unit> replicate_(int n) => _replicate_(n).traced('replicate_');
  IO<Unit> _replicate_(int n) => n <= 0 ? IO.unit : _flatMap((_) => _replicate_(n - 1));

  /// Starts the execution of this IO, returning a handle to the running IO in
  /// the form of an [IOFiber]. The fiber can be used to wait for a result
  /// or cancel it's execution.
  IO<IOFiber<A>> start() => _start().traced('start');
  IO<IOFiber<A>> _start() => _Start<A>(this);

  /// Times how long this [IO] takes to evaluate, and returns the [Duration]
  /// and the value as a tuple.
  IO<(Duration, A)> timed() => _timed().traced('timed');
  IO<(Duration, A)> _timed() =>
      (now, this, now).mapN((startTime, a, endTime) => (endTime.difference(startTime), a));

  /// Creates an [IO] that returns the value of this IO, or raises an error
  /// if the evaluation take longer than [duration].
  IO<A> timeout(Duration duration) => _timeout(duration).traced('timeout');
  IO<A> _timeout(Duration duration) => _timeoutTo(
    duration,
    IO._defer(() => IO._raiseError(TimeoutException(duration.toString()))),
  );

  IO<A> timeoutAndForget(Duration duration) =>
      _timeoutAndForget(duration).traced('timeoutAndForget');
  IO<A> _timeoutAndForget(Duration duration) => IO._uncancelable(
    (poll) => poll(IO._racePair(this, IO._sleep(duration)))._flatMap(
      (a) => a.fold(
        (aWon) {
          final (oc, f) = aWon;
          return poll(
            f.cancel()._productR(() => oc.embed(poll(IO.canceled)._productR(() => IO._never<A>()))),
          );
        },
        (bWon) {
          final (f, _) = bWon;

          return f.cancel()._start()._productR(
            () => IO._raiseError<A>(TimeoutException(duration.toString())),
          );
        },
      ),
    ),
  );

  /// Creates an [IO] that will return the value of this IO, or the value of
  /// [fallback] if the evaluation of this IO exceeds [duration].
  IO<A> timeoutTo(Duration duration, IO<A> fallback) =>
      _timeoutTo(duration, fallback).traced('timeoutTo');
  IO<A> _timeoutTo(Duration duration, IO<A> fallback) => IO
      ._race(this, IO._sleep(duration))
      ._flatMap(
        (winner) => winner.fold(
          (a) => IO.pure(a),
          (_) => fallback,
        ),
      );

  /// Lifts this [IO] to a [Resource]
  Resource<A> toResource() => Resource.eval(this);

  SyncIO<Either<IO<A>, A>> toSyncIO(int limit) =>
      _SyncStep.interpret(this, limit).map((a) => a.map((a) => a.$1));

  /// Creates an [IO] that will return the value of this IO tupled with [b],
  /// with [b] taking the first element of the tuple.
  IO<(B, A)> tupleLeft<B>(B b) => _tupleLeft(b).traced('tupleLeft');
  IO<(B, A)> _tupleLeft<B>(B b) => _map((a) => (b, a));

  /// Creates an [IO] that will return the value of this IO tupled with [b],
  /// with [b] taking the second element of the tuple.
  IO<(A, B)> tupleRight<B>(B b) => _tupleRight(b).traced('tupleRight');
  IO<(A, B)> _tupleRight<B>(B b) => _map((a) => (a, b));

  /// Evaluates this [IO] repeatedly until evaluating [cond] results is `true`.
  /// Results from every evaluation is accumulated in the returned [IList].
  ///
  /// Note that [cond] is evaluated *after* evaluating this [IO] for each
  /// repetition.
  IO<IList<A>> untilM(IO<bool> cond) => _untilM(cond).traced('untilM');
  IO<IList<A>> _untilM(IO<bool> cond) {
    IO<IList<A>> loop(IList<A> acc) => _flatMap(
      (a) => cond._ifM(
        () => IO.pure(acc.appended(a)),
        () => loop(acc.appended(a)),
      ),
    );

    return loop(nil());
  }

  /// Evaluates this [IO] repeatedly until evaluating [cond] results is `true`.
  /// Results are discarded.
  ///
  /// Note that [cond] is evaluated *after* evaluating this [IO] for each
  /// repetition.
  IO<Unit> untilM_(IO<bool> cond) => _untilM_(cond).traced('untilM_');
  IO<Unit> _untilM_(IO<bool> cond) =>
      _productR(() => cond._ifM(() => IO.unit, () => _untilM_(cond)));

  /// Discards the value of this IO and replaces it with [Unit].
  IO<Unit> voided() => _voided();
  IO<Unit> _voided() => _as(Unit());

  /// Evaluates this [IO] repeatedly until evaluating [cond] results is `false`.
  /// Results from every evaluation is accumulated in the returned [IList].
  ///
  /// Note that [cond] is evaluated *before* evaluating this [IO] for each
  /// repitition.
  IO<IList<A>> whilelM(IO<bool> cond) => _whilelM(cond).traced('whileM');
  IO<IList<A>> _whilelM(IO<bool> cond) {
    IO<IList<A>> loop(IList<A> acc) {
      return cond._ifM(
        () => _flatMap((a) => loop(acc.appended(a))),
        () => IO.pure(acc),
      );
    }

    return loop(nil());
  }

  /// Evaluates this [IO] repeatedly until evaluating [cond] results is `false`.
  /// Results are discarded.
  ///
  /// Note that [cond] is evaluated *before* evaluating this [IO] for each
  /// repitition.
  IO<Unit> whileM_(IO<bool> cond) => _whileM_(cond).traced('whileM_');
  IO<Unit> _whileM_(IO<bool> cond) => cond.ifM(
    () => _productR(() => _whileM_(cond)),
    () => IO.unit,
  );

  /// Starts the evaluation this IO and invokes the given callback [cb] with
  /// the [Outcome].
  void unsafeRunAsync(
    Function1<Outcome<A>, void> cb, {
    IORuntime? runtime,
  }) {
    _unsafeRunFiber(
      () => cb(Canceled()),
      (err, stackTrace) => cb(Errored(err, stackTrace)),
      (a) => cb(Succeeded(a)),
      runtime: runtime,
    );
  }

  /// Starts the evaluation of this IO and discards any results.
  void unsafeRunAndForget({
    IORuntime? runtime,
  }) => _unsafeRunFiber(() {}, (_, _) {}, (_) {}, runtime: runtime);

  /// Starts the evaluation of this IO and returns a [Future] that will complete
  /// with the [Outcome] of the evaluation. The [Future] may complete with an
  /// error if the evaluation of the [IO] encounters and error or is canceled.
  Future<A> unsafeRunFuture({
    IORuntime? runtime,
  }) => unsafeRunFutureCancelable(runtime: runtime).$1;

  /// Starts the evaluation of this IO and returns a [Future] that will complete
  /// with the [Outcome] of the evaluation as well as a function that can be
  /// called to cancel the future. The [Future] will not complete with an error,
  /// since the value itself is capable of conveying an error was encountered.
  /// If the evaluation has already finished, the cancelation function is a
  /// no-op.
  (Future<A>, Function0<Future<Unit>>) unsafeRunFutureCancelable({
    IORuntime? runtime,
  }) {
    final completer = Completer<A>();

    final fiber = _unsafeRunFiber(
      () => completer.completeError('Fiber canceled'),
      (err, stackTrace) => completer.completeError(err, stackTrace),
      (a) => completer.complete(a),
      runtime: runtime,
    );

    return (completer.future, () => fiber.cancel().unsafeRunFuture());
  }

  /// Evaluates this IO and returns a [Future] that will complete with the
  /// [Outcome] of the evaluation. The [Future] will not complete with an error,
  /// since the value itself is capable of conveying an error was encountered.
  Future<Outcome<A>> unsafeRunFutureOutcome({
    IORuntime? runtime,
  }) {
    final completer = Completer<Outcome<A>>();
    unsafeRunAsync(completer.complete, runtime: runtime);
    return completer.future;
  }

  /// Starts the evaluation of this IO and returns  a function that can be
  /// called to cancel the evaluation. If the evaluation has already finished,
  /// the cancelation function is a no-op.
  Function0<Future<Unit>> unsafeRunCancelable({
    IORuntime? runtime,
  }) => unsafeRunFutureCancelable(runtime: runtime).$2;

  IOFiber<A> _unsafeRunFiber(
    Function0<void> canceled,
    Function2<Object, StackTrace?, void> failure,
    Function1<A, void> success, {
    IORuntime? runtime,
  }) {
    final fiber = IOFiber(
      this,
      callback: (outcome) {
        outcome.fold(
          () => canceled(),
          (err, stackTrace) => failure(err, stackTrace),
          (a) => success(a),
        );
      },
      runtime: runtime,
    );

    fiber._run();

    return fiber;
  }
}

extension IONestedOps<A> on IO<IO<A>> {
  /// Returns an [IO] that will complete with the value of the inner [IO].
  IO<A> flatten() => _flatten().traced('flatten');
  IO<A> _flatten() => _flatMap(identity);
}

extension IOUnitOps<A> on IO<Unit> {
  /// Ignores any errors.
  IO<Unit> voidError() => _voidError().traced('voidError');
  IO<Unit> _voidError() => _handleError((_) => Unit());
}

extension IOBoolOps on IO<bool> {
  /// Returns the evaluation of [ifTrue] when the value of this IO evaluates to
  /// true, otherwise returns [ifFalse].
  IO<B> ifM<B>(Function0<IO<B>> ifTrue, Function0<IO<B>> ifFalse) =>
      _ifM(ifTrue, ifFalse).traced('ifM');

  IO<B> _ifM<B>(Function0<IO<B>> ifTrue, Function0<IO<B>> ifFalse) =>
      _flatMap((b) => b ? ifTrue() : ifFalse());
}

extension IOExceptionOps<A> on IO<Either<Object, A>> {
  /// Inverse of [IO.attempt].
  IO<A> rethrowError() => _rethrowError().traced('rethrowError');
  IO<A> _rethrowError() => _flatMap(IO._fromEither);
}

/// Utility class to create unmasked blocks within an uncancelable [IO] region.
abstract class Poll {
  IO<A> call<A>(IO<A> ioa);
}

class _RuntimePoll extends Poll {
  final int _id;
  final IOFiber<dynamic> _fiber;

  _RuntimePoll(this._id, this._fiber);

  /// Creates an IO that allows cancelation within the scope of [ioa].
  @override
  IO<A> call<A>(IO<A> ioa) => _UnmaskRunLoop(ioa, _id, _fiber);
}

class _SyncStep {
  static SyncIO<Either<IO<A>, (A, int)>> interpret<A>(IO<A> io, int limit) {
    if (limit <= 0) {
      return SyncIO.pure(Left(io));
    } else {
      if (io is _Pure) {
        return SyncIO.pure(Right(((io as _Pure).value, limit)));
      } else if (io is _Error) {
        return SyncIO.raiseError((io as _Error).error);
      } else if (io is _Delay) {
        return SyncIO.delay(() => (io as _Delay).thunk()).map((a) => Right((a, limit)));
      } else if (io is _Map) {
        final map = io as _Map<dynamic, A>;

        return interpret(map.ioa, limit - 1).map(
          (e) => e.fold(
            (io) => Left(io._map(map.f.call)),
            (result) => Right((map.f(result.$1), result.$2)),
          ),
        );
      } else if (io is _FlatMap) {
        final fm = io as _FlatMap<dynamic, A>;

        return interpret(fm.ioa, limit - 1).flatMap(
          (e) => e.fold(
            (io) => SyncIO.pure(Left(io._flatMap(fm.f.call))),
            (result) => interpret(fm.f(result.$1), limit - 1),
          ),
        );
      } else if (io is _HandleErrorWith) {
        final he = io as _HandleErrorWith<A>;

        return interpret(he.ioa, limit - 1)
            .map(
              (a) => a.fold(
                (io) => io._handleErrorWith(he.f.call).asLeft<(A, int)>(),
                (result) => result.asRight<IO<A>>(),
              ),
            )
            .handleErrorWith((ex) => interpret(he.f(ex), limit - 1));
      } else {
        return SyncIO.pure(Left(io));
      }
    }
  }
}
