import 'dart:async';
import 'dart:io' show stderr, stdin, stdout;

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/effect/std/internal/stack.dart';

/// Specific [Exception] type that is raised within [IO].
class RuntimeException implements Exception {
  /// Reason for the exception.
  final Object message;

  /// StackTrace at the time when the exception was thrown.
  final StackTrace stackTrace;

  RuntimeException(this.message, [StackTrace? stackTrace])
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => message.toString();
}

typedef AsyncCallback<A> = Function1<Either<RuntimeException, A>, void>;
typedef AsyncBody<A> = Function1<AsyncCallback<A>, void>;
typedef AsyncBodyWithFin<A> = Function1<AsyncCallback<A>, IO<Option<IO<Unit>>>>;

typedef AWon<A, B> = (Outcome<A>, IOFiber<B>);
typedef BWon<A, B> = (IOFiber<A>, Outcome<B>);
typedef RacePairOutcome<A, B> = Either<AWon<A, B>, BWon<A, B>>;

/// IO is a datatype that can be used to control side-effects within
/// synchronous and asynchronous code.
sealed class IO<A> extends Monad<A> {
  /// Suspends the asynchronous effect [k] within [IO]. When evaluation is
  /// completed, the callback will be invoked with the result of the [IO].
  /// If the newly created [IO] is canceled, the provided finalizer will be
  /// invoked.
  static IO<A> async<A>(AsyncBodyWithFin<A> k) => _Async(k);

  /// Suspends the asynchronous effect [k] within [IO]. When evaluation is
  /// completed, the callback will be invoked with the result of the [IO].
  static IO<A> async_<A>(AsyncBody<A> k) => _Async((cb) {
        k(cb);
        return none();
      });

  /// Runs both [ioa] and [iob] together, returning a tuple of both results
  /// if both of them are successful. If either of them results in an error or
  /// is canceled, that error or cancelation is propogated.
  static IO<(A, B)> both<A, B>(IO<A> ioa, IO<B> iob) => IO.uncancelable(
        (poll) => poll(racePair(ioa, iob)).flatMap(
          (winner) => winner.fold(
            (aWon) => aWon((oca, f) {
              return oca.fold(
                () => f
                    .cancel()
                    .productR(() => poll(IO.canceled))
                    .productR(() => IO.never()),
                (err) => f.cancel().productR(() => IO.raiseError(err)),
                (a) => poll(f.join())
                    .onCancel(f.cancel())
                    .flatMap((ocb) => ocb.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (b) => IO.pure((a, b)),
                        )),
              );
            }),
            (bWon) => bWon((f, ocb) {
              return ocb.fold(
                () => f
                    .cancel()
                    .productR(() => poll(IO.canceled))
                    .productR(() => IO.never()),
                (err) => f.cancel().productR(() => IO.raiseError(err)),
                (b) => poll(f.join())
                    .onCancel(f.cancel())
                    .flatMap((oca) => oca.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (a) => IO.pure((a, b)),
                        )),
              );
            }),
          ),
        ),
      );

  /// Runs both [ioa] and [iob], returning a tuple of the [Outcome] of each.
  static IO<(Outcome<A>, Outcome<B>)> bothOutcome<A, B>(
    IO<A> ioa,
    IO<B> iob,
  ) =>
      IO.uncancelable(
        (poll) => poll(racePair(ioa, iob)).flatMap(
          (winner) => winner.fold(
            (aWon) => aWon(
                (a, f) => poll(f.join()).onCancel(f.cancel()).tupleLeft(a)),
            (bWon) => bWon(
                (f, b) => poll(f.join()).onCancel(f.cancel()).tupleRight(b)),
          ),
        ),
      );

  /// Creates an [IO] that will evaluate [acquire], pass the result
  /// to [use] if successful and then guarantee the evaluation of [release].
  static IO<B> bracketFull<A, B>(
    Function1<Poll, IO<A>> acquire,
    Function1<A, IO<B>> use,
    Function2<A, Outcome<B>, IO<Unit>> release,
  ) =>
      IO.uncancelable(
        (poll) => acquire(poll).flatMap(
          (a) => IO
              .defer(() => poll(use(a)))
              .guaranteeCase((oc) => release(a, oc)),
        ),
      );

  /// Creates an [IO] that immediately results in an [Outcome] of [Canceled].
  static IO<Unit> canceled = _Canceled();

  /// Introduces an asynchronous boundary in the IO runtime loop that can
  /// be used for cancelation checking and fairness, among other things.
  static IO<Unit> cede = _Cede();

  /// Suspends the synchronous evaluation of [thunk] in [IO].
  static IO<A> defer<A>(Function0<IO<A>> thunk) => delay(thunk).flatten();

  /// Creates a new [Deferred] of the given generic type.
  static IO<Deferred<A>> deferred<A>() => Deferred.of<A>();

  /// Suspends the synchronous evaluation of [thunk] in [IO].
  static IO<A> delay<A>(Function0<A> thunk) => _Delay(Fn0(thunk));

  /// Executes the given function, discarding any result.
  static IO<Unit> exec<A>(Function0<A> thunk) => _Delay(Fn0(thunk)).voided();

  /// Creates an [IO] that returns the value or error of the underlying
  /// [CancelableOperation]. If new [IO] is canceled, the cancelation request
  /// will be forwarded to the underlying  [CancelableOperation].
  static IO<A> fromCancelableOperation<A>(IO<CancelableOperation<A>> op) {
    return op.flatMap((op) {
      return IO.async((cb) {
        return IO.delay(() {
          op.then(
            (a) => cb(a.asRight()),
            onError: (e, s) => cb(RuntimeException(e, s).asLeft()),
          );

          return Some(IO.fromFutureF(() => op.cancel().then((_) => Unit())));
        });
      });
    });
  }

  /// Alias for `IO.pure` when [either] is [Right], or `IO.raiseError` with
  /// [either] providing the error when [either] is [Left].
  static IO<A> fromEither<A>(Either<Object, A> either) =>
      either.fold((e) => IO.raiseError<A>(RuntimeException(e)), IO.pure);

  /// Create an [IO] that returns the value of the underlying [Future] or
  /// the error [fut] emits.
  static IO<A> fromFuture<A>(IO<Future<A>> fut) =>
      fut.flatMap((f) => async_<A>((cb) => f.then(
            (a) => cb(a.asRight()),
            onError: (Object e, StackTrace s) =>
                cb(RuntimeException(e, s).asLeft()),
          )));

  /// Create an [IO] that returns the value of the underlying [Future] function
  /// or the error [futF] emits.
  static IO<A> fromFutureF<A>(Function0<Future<A>> futF) =>
      fromFuture(IO.delay(futF));

  /// Alias for `IO.pure` when [option] is [Some], or `IO.raiseError` with
  /// [orElse] providing the error when [option] is [None].
  static IO<A> fromOption<A>(Option<A> option, Function0<Object> orElse) =>
      option.fold(() => IO.raiseError<A>(RuntimeException(orElse())), IO.pure);

  /// Returns a non-terminating [IO], alias for `async_((_) {})`.
  static IO<A> never<A>() => async_((_) {});

  /// Alias for `IO.pure(const None())`.
  static IO<Option<A>> none<A>() => IO.pure(const None());

  /// Returns the current [DateTime] when evaluation occurs.
  static IO<DateTime> now = IO.delay(() => DateTime.now());

  /// Writes [message] to stdout, delaying the effect until evaluation.
  static IO<Unit> print(String message) => IO.exec(() => stdout.write(message));

  /// Writes [message] with a newline to stdout, delaying the effect until
  /// evaluation.
  static IO<Unit> println(String message) =>
      IO.exec(() => stdout.writeln(message));

  /// Writes [message] to stderr, delaying the effect until evaluation.
  static IO<Unit> printErr(String message) =>
      IO.exec(() => stderr.write(message));

  /// Writes [message] with a newline to stderr, delaying the effect until
  /// evaluation.
  static IO<Unit> printErrLn(String message) =>
      IO.exec(() => stderr.writeln(message));

  /// Lifts a pure value into [IO].
  static IO<A> pure<A>(A a) => _Pure(a);

  /// Runs [ioa] and [iob] together, returning the first [IO] to finish after
  /// the loser is canceled.
  static IO<Either<A, B>> race<A, B>(IO<A> ioa, IO<B> iob) => IO.uncancelable(
        (poll) => poll(IO.racePair(ioa, iob)).flatMap(
          (winner) {
            return winner.fold(
              (aWon) => aWon((oca, fiberB) {
                return oca.fold(
                  () => fiberB.cancel().productR(() => fiberB.join()).flatMap(
                        (ocb) => ocb.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (b) => IO.pure(Right(b)),
                        ),
                      ),
                  (err) => fiberB.cancel().productR(() => IO.raiseError(err)),
                  (a) => fiberB.cancel().as(Left(a)),
                );
              }),
              (bWon) => bWon((fiberA, ocb) {
                return ocb.fold(
                  () => fiberA.cancel().productR(() => fiberA.join()).flatMap(
                        (oca) => oca.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (a) => IO.pure(Left(a)),
                        ),
                      ),
                  (err) => fiberA.cancel().productR(() => IO.raiseError(err)),
                  (b) => fiberA.cancel().as(Right(b)),
                );
              }),
            );
          },
        ),
      );

  /// Runs [ioa] and [iob] together, returning the [Outcome] of the winner after
  /// canceling the loser.
  static IO<Either<Outcome<A>, Outcome<B>>> raceOutcome<A, B>(
    IO<A> ioa,
    IO<B> iob,
  ) =>
      IO.uncancelable(
          (poll) => poll(racePair(ioa, iob)).flatMap((winner) => winner.fold(
                (aWon) => aWon((a, f) => f.cancel().as(Left(a))),
                (bWon) => bWon((f, b) => f.cancel().as(Right(b))),
              )));

  /// Runs [ioa] and [iob] together, returning a pair of the [Outcome] of the
  /// [IO] that finished first (won) and an [IOFiber] handle for the loser.
  static IO<Either<AWon<A, B>, BWon<A, B>>> racePair<A, B>(
          IO<A> ioa, IO<B> iob) =>
      _RacePair(ioa, iob);

  /// Create an IO that will inject the given error into the IO evaluation.
  static IO<A> raiseError<A>(RuntimeException error) => _Error(error);

  /// Returns an `IO.raiseError` when [cond] is false, otherwice `IO.unit`.
  static IO<Unit> raiseUnless(bool cond, Function0<RuntimeException> e) =>
      IO.unlessA(cond, () => IO.raiseError<Unit>(e()));

  /// Returns an `IO.raiseError` when [cond] is true, otherwice `IO.unit`.
  static IO<Unit> raiseWhen(bool cond, Function0<RuntimeException> e) =>
      IO.whenA(cond, () => IO.raiseError<Unit>(e()));

  /// Reads a line from stdin. **This is a blocking operation and will
  /// not finish until a full line of input is available from the console.**
  static IO<String> readLine() =>
      IO.delay(() => stdin.readLineSync()).flatMap((l) => Option(l).fold(
          () => IO.raiseError(RuntimeException('stdin line ended')), IO.pure));

  /// Creates a new [Ref] of the given generic type.
  static IO<Ref<A>> ref<A>(A a) => Ref.of(a);

  /// Creates an ansynchronous [IO] that will sleep for the given [duration]
  /// and resume when finished.
  static IO<Unit> sleep(Duration duration) => _Sleep(duration);

  /// Alias for `IO.pure(Some(a))`.
  static IO<Option<A>> some<A>(A a) => IO.pure(Some(a));

  /// Alias for `IO.delay(() => throw UnimplementedError())`
  static IO<Never> get stub => IO.delay(() => throw UnimplementedError());

  /// Creates an uncancelable region within the IO run loop. The [Poll] provided
  /// can be used to create unmasked cancelable regions within the uncancelable
  /// region.
  static IO<A> uncancelable<A>(Function1<Poll, IO<A>> body) =>
      _Uncancelable(body);

  /// Alias for `IO.pure(Unit())`.
  static IO<Unit> unit = IO.pure(Unit());

  /// Returns the [action] argument when [cond] is false, otherwise returns
  /// [IO.unit].
  static IO<Unit> unlessA<A>(bool cond, Function0<IO<A>> action) =>
      cond ? IO.unit : action().voided();

  /// Returns the [action] argument when [cond] is true, otherwise returns
  /// [IO.unit].
  static IO<Unit> whenA<A>(bool cond, Function0<IO<A>> action) =>
      cond ? action().voided() : IO.unit;

  /// Return an IO that will wait the specified [duration] **after** evaluating
  /// and then return the result.
  IO<A> andWait(Duration duration) => flatTap((_) => IO.sleep(duration));

  /// Replaces the result of this [IO] with the given value.
  IO<B> as<B>(B b) => map((_) => b);

  /// Extracts any exceptions encountered during evaluation into an [Either]
  /// value.
  IO<Either<RuntimeException, A>> attempt() => _Attempt(this);

  /// Creates a new [Resource] that will start the execution of this fiber and
  /// cancel the execution when the [Resource] is finalized.
  Resource<IO<Outcome<A>>> background() =>
      Resource.make(start(), (fiber) => fiber.cancel()).map((f) => f.join());

  /// Returns an IO that uses this IO as the resource acquisition, [use] as the
  /// IO action that action that uses the resource, and [release] as the
  /// finalizer that will clean up the resource.
  IO<B> bracket<B>(Function1<A, IO<B>> use, Function1<A, IO<Unit>> release) =>
      bracketCase(use, (a, _) => release(a));

  /// Returns an IO that uses this IO as the resource acquisition, [use] as the
  /// IO action that action that uses the resource, and [release] as the
  /// finalizer that will clean up the resource. Both result of this IO *and*
  /// the [Outcome] of [use] are provided to [release].
  IO<B> bracketCase<B>(
    Function1<A, IO<B>> use,
    Function2<A, Outcome<B>, IO<Unit>> release,
  ) =>
      IO.bracketFull((_) => this, use, release);

  /// Prints the value of this IO (value, error or canceled) to stdout
  IO<A> debug({String prefix = 'DEBUG'}) =>
      flatTap((a) => IO.println('$prefix: $a'));

  /// Return an IO that will wait the specified [duration] **before** evaluating
  /// and then return the result.
  IO<A> delayBy(Duration duration) => IO.sleep(duration).productR(() => this);

  /// Sequences the evaluation of this IO and the provided function [f] that
  /// will create the next [IO] to be evaluated.
  @override
  IO<B> flatMap<B>(covariant Function1<A, IO<B>> f) =>
      _FlatMap(this, Fn1.of(f));

  /// Performs the side-effect encoded in [f] using the value created by this
  /// [IO], then returning the original value.
  IO<A> flatTap<B>(covariant Function1<A, IO<B>> f) =>
      flatMap((a) => f(a).as(a));

  /// Continually re-evaluate this [IO] forever, until an error or cancelation.
  IO<Never> foreverM() => productR(() => foreverM());

  /// Executes the provided finalizer [fin] regardless of the [Outcome] of
  /// evaluating this [IO].
  IO<A> guarantee(IO<Unit> fin) => onCancel(fin)
      .onError((e) => fin.productR(() => IO.raiseError(e)))
      .productL(() => fin);

  /// Executes the provided finalizer [fin] which can decide what action to
  /// take depending on the [Outcome] of this [IO].
  IO<A> guaranteeCase(Function1<Outcome<A>, IO<Unit>> fin) =>
      onCancel(fin(const Canceled()))
          .onError((e) => fin(Errored(e)))
          .flatTap((a) => fin(Succeeded(a)));

  /// Intercepts any upstream Exception, returning the value generated by [f].
  IO<A> handleError(Function1<RuntimeException, A> f) =>
      handleErrorWith((e) => IO.pure(f(e)));

  /// Intercepts any upstream Exception, sequencing in the [IO] generated by [f].
  IO<A> handleErrorWith(covariant Function1<RuntimeException, IO<A>> f) =>
      _HandleErrorWith(this, Fn1.of(f));

  /// Continually re-evaluates this [IO] until the computed value satisfies the
  /// given predicate [p]. The first computed value that satisfies [p] will be
  /// the final result.
  IO<A> iterateUntil(Function1<A, bool> p) => iterateWhile((a) => !p(a));

  /// Continually re-evaluates this [IO] while the computed value satisfies the
  /// given predicate [p]. The first computed value that does not satisfy [p]
  /// will be the final result.
  IO<A> iterateWhile(Function1<A, bool> p) =>
      flatMap((a) => p(a) ? this.iterateWhile(p) : IO.pure(a));

  /// Applies [f] to the value of this IO, returning the result.
  @override
  IO<B> map<B>(covariant Function1<A, B> f) => _Map(this, Fn1.of(f));

  /// Attaches a finalizer to this [IO] that will be evaluated if this
  /// [IO] is canceled.
  IO<A> onCancel(IO<Unit> fin) => _OnCancel(this, fin);

  /// Performs the given side-effect if this [IO] results in a error.
  IO<A> onError(covariant Function1<RuntimeException, IO<Unit>> f) =>
      handleErrorWith(
          (e) => f(e).attempt().productR(() => IO.raiseError<A>(e)));

  /// Replaces any failures from this IO with [None]. A successful value is
  /// wrapped in [Some].
  IO<Option<A>> option() => redeem((_) => const None(), (a) => Some(a));

  /// If the evaluation of this [IO] results in an error, run [that] as an
  /// attempt to recover.
  IO<A> orElse(Function0<IO<A>> that) => handleErrorWith((_) => that());

  /// Sequentially evaluate this [IO], then [that], and return the product
  /// (i.e. tuple) of each value.
  IO<(A, B)> product<B>(IO<B> that) => flatMap((a) => that.map((b) => (a, b)));

  /// Sequentially evaluate this [IO], then [that], returning the value
  /// producted by this, discarding that value from [that].
  IO<A> productL<B>(Function0<IO<B>> that) => flatMap((a) => that().as(a));

  /// Sequentially evaluate this [IO], then [that], returning the value
  /// producted by [that], discarding the value from this.
  IO<B> productR<B>(Function0<IO<B>> that) => flatMap((_) => that());

  /// Returns the value created from [recover] or [map], depending on whether
  /// this [IO] results in an error or is successful.
  IO<B> redeem<B>(
          Function1<RuntimeException, B> recover, Function1<A, B> map) =>
      attempt().map((a) => a.fold(recover, map));

  /// Returns the value created from [recover] or [map], depending on whether
  /// this [IO] results in an error or is successful.
  IO<B> redeemWith<B>(
    Function1<RuntimeException, IO<B>> recover,
    Function1<A, IO<B>> bind,
  ) =>
      attempt().flatMap((a) => a.fold(recover, bind));

  /// Runs this [IO] [n] times, accumulating the result from each evaluation
  /// into an [IList].
  IO<IList<A>> replicate(int n) => n <= 0
      ? IO.pure(nil())
      : flatMap((a) => replicate(n - 1).map((l) => l.prepend(a)));

  /// Runs this [IO] [n] times, accumulating the result from each evaluation
  /// into an [IList]. All replications will be run asynchronously.
  IO<IList<A>> parReplicate(int n) => n <= 0
      ? IO.pure(nil())
      : IO.both(this, parReplicate(n - 1)).mapN((a, acc) => acc.prepend(a));

  /// Runs this [IO] [n] times, discarding any resulting values.
  IO<Unit> replicate_(int n) =>
      n <= 0 ? IO.unit : flatMap((_) => replicate_(n - 1));

  /// Runs this [IO] [n] times, discarding any resulting values.  All
  /// replications will be run asynchronously.
  IO<Unit> parReplicate_(int n) =>
      n <= 0 ? IO.unit : IO.both(this, parReplicate_(n - 1)).voided();

  /// Starts the execution of this IO, returning a handle to the running IO in
  /// the form of an [IOFiber]. The fiber can be used to wait for a result
  /// or cancel it's execution.
  IO<IOFiber<A>> start() => _Start<A>(this);

  /// Times how long this [IO] takes to evaluate, and returns the [Duration]
  /// and the value as a tuple.
  IO<(Duration, A)> timed() => (now, this, now)
      .mapN((startTime, a, endTime) => (endTime.difference(startTime), a));

  /// Creates an [IO] that returns the value of this IO, or raises an error
  /// if the evaluation take longer than [duration].
  IO<A> timeout(Duration duration) => timeoutTo(
      duration,
      IO.defer(() => IO.raiseError(
          RuntimeException(TimeoutException(duration.toString())))));

  /// Creates an [IO] that will return the value of this IO, or the value of
  /// [fallback] if the evaluation of this IO exceeds [duration].
  IO<A> timeoutTo(Duration duration, IO<A> fallback) =>
      IO.race(this, IO.sleep(duration)).flatMap((winner) => winner.fold(
            (a) => IO.pure(a),
            (_) => fallback,
          ));

  /// Lifts this [IO] to a [Resource]
  Resource<A> toResource() => Resource.eval(this);

  SyncIO<Either<IO<A>, A>> toSyncIO(int limit) =>
      _SyncStep.interpret(this, limit).map((a) => a.map((a) => a.$1));

  /// Creates an [IO] that will return the value of this IO tupled with [b],
  /// with [b] taking the first element of the tuple.
  IO<(B, A)> tupleLeft<B>(B b) => map((a) => (b, a));

  /// Creates an [IO] that will return the value of this IO tupled with [b],
  /// with [b] taking the second element of the tuple.
  IO<(A, B)> tupleRight<B>(B b) => map((a) => (a, b));

  /// Evaluates this [IO] repeatedly until evaluating [cond] results is `true`.
  /// Results from every evaluation is accumulated in the returned [IList].
  ///
  /// Note that [cond] is evaluated *after* evaluating this [IO] for each
  /// repetition.
  IO<IList<A>> untilM(IO<bool> cond) {
    IO<IList<A>> loop(IList<A> acc) => flatMap((a) => cond.ifM(
          () => IO.pure(acc.append(a)),
          () => loop(acc.append(a)),
        ));

    return loop(nil());
  }

  /// Evaluates this [IO] repeatedly until evaluating [cond] results is `true`.
  /// Results are discarded.
  ///
  /// Note that [cond] is evaluated *after* evaluating this [IO] for each
  /// repetition.
  IO<Unit> untilM_(IO<bool> cond) =>
      productR(() => cond.ifM(() => IO.unit, () => untilM_(cond)));

  /// Discards the value of this IO and replaces it with [Unit].
  IO<Unit> voided() => as(Unit());

  /// Evaluates this [IO] repeatedly until evaluating [cond] results is `false`.
  /// Results from every evaluation is accumulated in the returned [IList].
  ///
  /// Note that [cond] is evaluated *before* evaluating this [IO] for each
  /// repitition.
  IO<IList<A>> whilelM(IO<bool> cond) {
    IO<IList<A>> loop(IList<A> acc) {
      return cond.ifM(
        () => flatMap((a) => loop(acc.append(a))),
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
  IO<Unit> whileM_(IO<bool> cond) => cond.ifM(
        () => productR(() => whileM_(cond)),
        () => IO.unit,
      );

  /// Starts the evaluation this IO and invokes the given callback [cb] with
  /// the [Outcome].
  void unsafeRunAsync(
    Function1<Outcome<A>, void> cb, {
    int autoCedeN = IOFiber.DefaultAutoCedeN,
  }) {
    _unsafeRunFiber(
      () => cb(const Canceled()),
      (ex) => cb(Errored(ex)),
      (a) => cb(Succeeded(a)),
      autoCedeN: autoCedeN,
    );
  }

  /// Starts the evaluation of this IO and discards any results.
  void unsafeRunAndForget({int autoCedeN = IOFiber.DefaultAutoCedeN}) =>
      _unsafeRunFiber(() {}, (a) {}, (a) {}, autoCedeN: autoCedeN);

  /// Evaluates this IO and returns a [Future] that will complete with the
  /// [Outcome] of the evaluation. The [Future] will not complete with an error,
  /// since the value itself is capable of conveying an error was encountered.
  Future<Outcome<A>> unsafeRunToFutureOutcome({
    int autoCedeN = IOFiber.DefaultAutoCedeN,
  }) {
    final completer = Completer<Outcome<A>>();
    unsafeRunAsync(completer.complete, autoCedeN: autoCedeN);
    return completer.future;
  }

  /// Starts the evaluation of this IO and returns a [Future] that will complete
  /// with the [Outcome] of the evaluation as well as a function that can be
  /// called to cancel the future. The [Future] will not complete with an error,
  /// since the value itself is capable of conveying an error was encountered.
  /// If the evaluation has already finished, the cancelation function is a
  /// no-op.
  (Future<A>, Function0<Future<Unit>>) unsafeRunToFutureCancelable(
      {int autoCedeN = IOFiber.DefaultAutoCedeN}) {
    final completer = Completer<A>();

    final fiber = _unsafeRunFiber(
      () => completer.completeError('Fiber canceled'),
      (ex) => completer.completeError(ex.message, ex.stackTrace),
      (a) => completer.complete(a),
      autoCedeN: autoCedeN,
    );

    return (completer.future, () => fiber.cancel().unsafeRunToFuture());
  }

  /// Starts the evaluation of this IO and returns a [Future] that will complete
  /// with the [Outcome] of the evaluation. The [Future] may complete with an
  /// error if the evaluation of the [IO] encounters and error or is canceled.
  Future<A> unsafeRunToFuture({int autoCedeN = IOFiber.DefaultAutoCedeN}) =>
      unsafeRunToFutureCancelable(autoCedeN: autoCedeN).$1;

  /// Starts the evaluation of this IO and returns  a function that can be
  /// called to cancel the evaluation. If the evaluation has already finished,
  /// the cancelation function is a no-op.
  Function0<Future<Unit>> unsafeRunToCancelable({
    int autoCedeN = IOFiber.DefaultAutoCedeN,
  }) =>
      unsafeRunToFutureCancelable(autoCedeN: autoCedeN).$2;

  IOFiber<A> _unsafeRunFiber(
    Function0<void> canceled,
    Function1<RuntimeException, void> failure,
    Function1<A, void> success, {
    int autoCedeN = IOFiber.DefaultAutoCedeN,
  }) {
    final fiber = IOFiber(
      this,
      callback: (outcome) {
        outcome.fold(
          () => canceled(),
          (ex) => failure(ex),
          (a) => success(a),
        );
      },
      autoCedeN: autoCedeN,
    );

    fiber._schedule();

    return fiber;
  }
}

extension IONestedOps<A> on IO<IO<A>> {
  /// Returns an [IO] that will complete with the value of the inner [IO].
  IO<A> flatten() => flatMap(id);
}

extension IOUnitOps<A> on IO<Unit> {
  /// Ignores any errors.
  IO<Unit> voidError() => handleError((_) => Unit());
}

extension IOBoolOps on IO<bool> {
  /// Returns the evaluation of [ifTrue] when the value of this IO evaluates to
  /// true, otherwise returns [ifFalse].
  IO<B> ifM<B>(Function0<IO<B>> ifTrue, Function0<IO<B>> ifFalse) =>
      flatMap((b) => b ? ifTrue() : ifFalse());
}

extension IOExceptionOps<A> on IO<Either<Exception, A>> {
  /// Inverse of [IO.attempt].
  IO<A> rethrowError() => flatMap(IO.fromEither);
}

/// Utility class to create unmasked blocks within an uncancelable [IO] region.
final class Poll {
  final int _id;
  final IOFiber<dynamic> _fiber;

  Poll._(this._id, this._fiber);

  /// Creates an IO that allows cancelation within the scope of [ioa].
  IO<A> call<A>(IO<A> ioa) => _UnmaskRunLoop(ioa, _id, _fiber);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////               /////////////////////////////////
// /////////////////////////////  Interpreter  /////////////////////////////////
// /////////////////////////////               /////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

final class _Pure<A> extends IO<A> {
  final A value;

  _Pure(this.value);

  @override
  String toString() => 'Pure($value)';
}

final class _Error<A> extends IO<A> {
  final RuntimeException error;

  _Error(this.error);

  @override
  String toString() => 'Error(${error.message})';
}

final class _Delay<A> extends IO<A> {
  final Fn0<A> thunk;

  _Delay(this.thunk);

  @override
  String toString() => 'Delay($thunk)';
}

final class _Async<A> extends IO<A> {
  final AsyncBodyWithFin<A> body;

  _Async(this.body);

  _AsyncGet<A> getter() => _AsyncGet();

  @override
  String toString() => 'Async($body)';
}

final class _AsyncGet<A> extends IO<A> {
  Either<RuntimeException, dynamic>? value;

  _AsyncGet();

  @override
  String toString() => 'AsyncGet($value)';
}

final class _Map<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, B> f;

  _Map(this.ioa, this.f);

  @override
  String toString() => 'Map($ioa, $f)';
}

final class _FlatMap<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, IO<B>> f;

  _FlatMap(this.ioa, this.f);

  @override
  String toString() => 'FlatMap($ioa, $f)';
}

final class _Attempt<A> extends IO<Either<RuntimeException, A>> {
  final IO<A> ioa;

  Either<RuntimeException, A> right(dynamic value) =>
      Right<RuntimeException, A>(value as A);
  Either<RuntimeException, A> left(RuntimeException error) =>
      Left<RuntimeException, A>(error);

  _Attempt(this.ioa);

  @override
  String toString() => 'Attempt($ioa)';
}

final class _Sleep extends IO<Unit> {
  final Duration duration;

  _Sleep(this.duration);

  @override
  String toString() => 'Sleep($duration)';
}

final class _Cede extends IO<Unit> {
  _Cede();

  @override
  String toString() => 'Cede';
}

final class _Start<A> extends IO<IOFiber<A>> {
  final IO<A> ioa;
  final int _autoCedeN;

  _Start(
    this.ioa, {
    int autoCedeN = IOFiber.DefaultAutoCedeN,
  }) : _autoCedeN = autoCedeN;

  IOFiber<A> createFiber() => IOFiber(ioa, autoCedeN: _autoCedeN);

  @override
  String toString() => 'Start($ioa)';
}

final class _HandleErrorWith<A> extends IO<A> {
  final IO<A> ioa;
  final Fn1<RuntimeException, IO<A>> f;

  _HandleErrorWith(this.ioa, this.f);

  @override
  String toString() => 'HandleErrorWith($ioa, $f)';
}

final class _OnCancel<A> extends IO<A> {
  final IO<A> ioa;
  final IO<Unit> fin;

  _OnCancel(this.ioa, this.fin);

  @override
  String toString() => 'OnCancel($ioa, $fin)';
}

final class _Canceled extends IO<Unit> {
  @override
  String toString() => 'Canceled';
}

final class _RacePair<A, B> extends IO<RacePairOutcome<A, B>> {
  final IO<A> ioa;
  final IO<B> iob;

  _RacePair(this.ioa, this.iob);

  IOFiber<A> createFiberA(int autoCedeN) => IOFiber(ioa, autoCedeN: autoCedeN);
  IOFiber<B> createFiberB(int autoCedeN) => IOFiber(iob, autoCedeN: autoCedeN);

  RacePairOutcome<A, B> aWon(
    Outcome<dynamic> oc,
    IOFiber<dynamic> fiberB,
  ) =>
      Left((oc as Outcome<A>, fiberB as IOFiber<B>));

  RacePairOutcome<A, B> bWon(
    Outcome<dynamic> oc,
    IOFiber<dynamic> fiberA,
  ) =>
      Right((fiberA as IOFiber<A>, oc as Outcome<B>));

  @override
  String toString() => 'RacePair<$A, $B>($ioa, $iob)';
}

final class _Uncancelable<A> extends IO<A> {
  final Function1<Poll, IO<A>> body;

  _Uncancelable(this.body);

  @override
  String toString() => 'Uncancelable<$A>($body)';
}

final class _UnmaskRunLoop<A> extends IO<A> {
  final IO<A> ioa;
  final int id;
  final IOFiber<dynamic> self;

  _UnmaskRunLoop(this.ioa, this.id, this.self);

  @override
  String toString() => 'UnmaskRunLoop<$A>($ioa, $id)';
}

final class _EndFiber extends IO<dynamic> {
  @override
  String toString() => 'EndFiber';
}

/// A handle to a running [IO] that allows for cancelation of the [IO] or
/// waiting for completion.
final class IOFiber<A> {
  final IO<A> _startIO;

  final _callbacks = Stack<Function1<Outcome<A>, void>>();
  final _finalizers = Stack<IO<Unit>>();

  var _resumeTag = _Resume.Exec;
  IO<dynamic>? _resumeIO;

  var _finalizing = false;

  final _conts = Stack<_Cont>();
  final _objectState = Stack<dynamic>();

  late IO<Unit> _cancel;
  late IO<Outcome<A>> _join;

  Outcome<A>? _outcome;

  bool _canceled = false;
  int _masks = 0;

  static const int _DefaultMaxStackDepth = 512;
  static const int DefaultAutoCedeN = 512;

  final int _autoCedeN;

  void _schedule() => Timer.run(() => _resume());

  IOFiber(
    this._startIO, {
    Function1<Outcome<A>, void>? callback,
    int autoCedeN = DefaultAutoCedeN,
  }) : _autoCedeN = autoCedeN {
    if (_autoCedeN < 1) throw ArgumentError('Fiber autoCedeN must be > 0');

    _resumeIO = _startIO;

    if (callback != null) {
      _callbacks.push(callback);
    }

    _conts.push(_Cont.RunTerminus);

    _cancel = IO.uncancelable((_) {
      _canceled = true;

      if (_isUnmasked()) {
        return IO.async_((fin) {
          _resumeTag = _Resume.AsyncContinueCanceledWithFinalizer;
          _objectState.push(Fn1.of(fin));
          _schedule();
        });
      } else {
        return join().voided();
      }
    });

    _join = IO.async_((cb) {
      _registerListener((oc) => cb(oc.asRight()));
    });
  }

  /// Creates an [IO] that requsets the fiber be canceled and waits for the
  /// completion/finalization of the fiber.
  IO<Unit> cancel() => _cancel;

  /// Creates an [IO] that will return the [Outcome] of the fiber when it
  /// completes.
  IO<Outcome<A>> join() => _join;

  IO<A> joinWith(IO<A> onCancel) => join().flatMap((a) => a.embed(onCancel));

  IO<A> joinWithNever() => joinWith(IO.never());

  bool _shouldFinalize() => _canceled && _isUnmasked();
  bool _isUnmasked() => _masks == 0;

  void _rescheduleFiber([
    Duration duration = Duration.zero,
  ]) =>
      Future.delayed(duration, () => _resume());

  void _resume() {
    switch (_resumeTag) {
      case _Resume.Exec:
        _execR();
      case _Resume.AsyncContinueSuccessful:
        _asyncContinueSuccessfulR();
      case _Resume.AsyncContinueFailed:
        _asyncContinueFailedR();
      case _Resume.AsyncContinueCanceled:
        _asyncContinueCanceledR();
      case _Resume.AsyncContinueCanceledWithFinalizer:
        _asyncContinueCanceledWithFinalizerR();
      case _Resume.Cede:
        _cedeR();
      case _Resume.AutoCede:
        _autoCedeR();
      case _Resume.Done:
        break;
    }
  }

  void _execR() {
    if (_canceled) {
      _done(const Canceled());
    } else {
      _conts.clear();
      _conts.push(_Cont.RunTerminus);

      _objectState.clear();
      _finalizers.clear();

      final io = _resumeIO;
      _resumeIO = null;

      _runLoop(io!, _autoCedeN);
    }
  }

  void _asyncContinueSuccessfulR() =>
      _runLoop(_succeeded(_objectState.pop(), 0), _autoCedeN);

  void _asyncContinueFailedR() =>
      _runLoop(_failed(_objectState.pop() as RuntimeException, 0), _autoCedeN);

  void _asyncContinueCanceledR() {
    final fin = _prepareFiberForCancelation();
    _runLoop(fin, _autoCedeN);
  }

  void _asyncContinueCanceledWithFinalizerR() {
    final cb = _objectState.pop() as Fn1<Either<RuntimeException, Unit>, void>;
    final fin = _prepareFiberForCancelation(cb);

    _runLoop(fin, _autoCedeN);
  }

  void _cedeR() => _runLoop(_succeeded(Unit(), 0), _autoCedeN);

  void _autoCedeR() {
    final io = _resumeIO;
    _resumeIO = null;

    _runLoop(io!, _autoCedeN);
  }

  void _runLoop(
    IO<dynamic> initial,
    int cedeIterations,
  ) {
    var cur0 = initial;
    int nextCede = cedeIterations;

    while (true) {
      if (cur0 is _EndFiber) {
        break;
      }

      if (nextCede <= 0) {
        _resumeTag = _Resume.AutoCede;
        _resumeIO = cur0;

        _rescheduleFiber();
        break;
      } else if (_shouldFinalize()) {
        cur0 = _prepareFiberForCancelation();
      } else {
        if (cur0 is _Pure) {
          ///////////////////////// PURE /////////////////////////
          cur0 = _succeeded(cur0.value, 0);
        } else if (cur0 is _Error) {
          ///////////////////////// ERROR /////////////////////////
          cur0 = _failed(cur0.error, 0);
        } else if (cur0 is _Delay) {
          ///////////////////////// DELAY /////////////////////////
          cur0 =
              Either.catching(() => (cur0 as _Delay).thunk(), (a, b) => (a, b))
                  .fold<IO<dynamic>>(
            (err) => _failed(RuntimeException(err.$1, err.$2), 0),
            (v) => _succeeded(v, 0),
          );
        } else if (cur0 is _Map) {
          ///////////////////////// MAP /////////////////////////
          final ioa = cur0.ioa;
          final f = cur0.f;

          IO<dynamic> next(Function0<dynamic> value) =>
              Either.catching(() => f(value()), (a, b) => (a, b))
                  .fold<IO<dynamic>>(
                      (err) => _failed(RuntimeException(err.$1, err.$2), 0),
                      (v) => _succeeded(v, 0));

          if (ioa is _Pure) {
            cur0 = next(() => ioa.value);
          } else if (ioa is _Error) {
            cur0 = _failed(ioa.error, 0);
          } else if (ioa is _Delay) {
            cur0 = next(ioa.thunk.call);
          } else {
            _objectState.push(f);
            _conts.push(_Cont.Map);

            cur0 = ioa;
          }
        } else if (cur0 is _FlatMap) {
          ///////////////////////// FLATMAP /////////////////////////
          final ioa = cur0.ioa;
          final f = cur0.f;

          IO<dynamic> next(Function0<dynamic> value) =>
              Either.catching(() => f(value()), (a, b) => (a, b)).fold(
                  (err) => _failed(RuntimeException(err.$1, err.$2), 0), id);

          if (ioa is _Pure) {
            cur0 = next(() => ioa.value);
          } else if (ioa is _Error) {
            cur0 = _failed(ioa.error, 0);
          } else if (ioa is _Delay) {
            cur0 = next(ioa.thunk.call);
          } else {
            _objectState.push(Fn1.of(f.call));
            _conts.push(_Cont.FlatMap);

            cur0 = ioa;
          }
        } else if (cur0 is _Attempt) {
          ///////////////////////// ATTEMPT /////////////////////////
          final ioa = cur0.ioa;

          if (ioa is _Pure) {
            cur0 = _succeeded(cur0.right(ioa.value), 0);
          } else if (ioa is _Error) {
            cur0 = _succeeded(cur0.left(ioa.error), 0);
          } else if (ioa is _Delay) {
            dynamic result;
            RuntimeException? error;

            try {
              result = ioa.thunk();
            } catch (e, s) {
              error = RuntimeException(e, s);
            }

            cur0 = error == null
                ? _succeeded(cur0.right(result), 0)
                : _succeeded(cur0.left(error), 0);
          } else {
            final attempt = cur0;
            // Push this function on to allow proper type tagging when running
            // the continuation
            _objectState.push(Fn1.of((x) => attempt.right(x)));
            _conts.push(_Cont.Attempt);
            cur0 = ioa;
          }
        } else if (cur0 is _Sleep) {
          _resumeTag = _Resume.Cede;
          _rescheduleFiber(cur0.duration);
          break;
        } else if (cur0 is _Cede) {
          _resumeTag = _Resume.Cede;
          _rescheduleFiber();
          break;
        } else if (cur0 is _HandleErrorWith) {
          _objectState.push(cur0.f);
          _conts.push(_Cont.HandleErrorWith);

          cur0 = cur0.ioa;
        } else if (cur0 is _OnCancel) {
          _finalizers.push(cur0.fin);
          _conts.push(_Cont.OnCancel);

          cur0 = cur0.ioa;
        } else if (cur0 is _Async) {
          final io = cur0;

          final resultF = io.getter();

          final finF = io.body((result) {
            resultF.value = result;

            if (!_shouldFinalize()) {
              result.fold(
                (err) {
                  _resumeTag = _Resume.AsyncContinueFailed;
                  _objectState.push(err);
                },
                (a) {
                  _resumeTag = _Resume.AsyncContinueSuccessful;
                  _objectState.push(a);
                },
              );
            } else {
              _resumeTag = _Resume.AsyncContinueCanceled;
            }

            _rescheduleFiber();
          });

          // Ensure we don't cede and potentially miss finalizer registration
          nextCede++;

          cur0 = finF.flatMap((finOpt) => finOpt.fold(
                () => resultF,
                (fin) => resultF.onCancel(fin),
              ));
        } else if (cur0 is _AsyncGet) {
          if (cur0.value != null) {
            cur0 = cur0.value!.fold<IO<dynamic>>(
              (err) => _failed(err, 0),
              (value) => _succeeded(value, 0),
            );
          } else {
            // Process of registering async finalizer lands us here
            break;
          }
        } else if (cur0 is _Start) {
          final fiber = cur0.createFiber();

          fiber._schedule();

          cur0 = _succeeded(fiber, 0);
        } else if (cur0 is _Canceled) {
          _canceled = true;

          if (_isUnmasked()) {
            final fin = _prepareFiberForCancelation();
            cur0 = fin;
          } else {
            cur0 = _succeeded(Unit(), 0);
          }
        } else if (cur0 is _RacePair) {
          final rp = cur0;

          final next = IO.async_<RacePairOutcome<dynamic, dynamic>>((cb) {
            final fiberA = rp.createFiberA(_autoCedeN);
            final fiberB = rp.createFiberB(_autoCedeN);

            // callback should be called exactly once, so when one fiber
            // finishes, remove the callback from the other
            fiberA._setCallback((oc) {
              fiberB._setCallback((_) {});
              cb(Right(rp.aWon(oc, fiberB)));
            });
            fiberB._setCallback((oc) {
              fiberA._setCallback((_) {});
              cb(Right(rp.bWon(oc, fiberA)));
            });

            fiberA._schedule();
            fiberB._schedule();
          });

          cur0 = next;
        } else if (cur0 is _Uncancelable) {
          _masks += 1;
          final id = _masks;

          final poll = Poll._(id, this);

          try {
            cur0 = cur0.body(poll);
          } catch (e, s) {
            cur0 = IO.raiseError(RuntimeException(e, s));
          }

          _conts.push(_Cont.Uncancelable);
        } else if (cur0 is _UnmaskRunLoop) {
          if (_masks == cur0.id && this == cur0.self) {
            _masks -= 1;
            _conts.push(_Cont.Unmask);
          }

          cur0 = cur0.ioa;
        } else {
          throw StateError('_runLoop: $cur0');
        }
      }

      nextCede--;
    }
  }

  void _registerListener(Function1<Outcome<A>, void> cb) {
    if (_outcome == null) {
      _callbacks.push(cb);
    } else {
      cb(_outcome!);
    }
  }

  void _setCallback(Function1<Outcome<A>, void> cb) {
    _callbacks.clear();
    _callbacks.push(cb);
  }

  IO<dynamic> _prepareFiberForCancelation([
    Fn1<Either<RuntimeException, Unit>, void>? cb,
  ]) {
    if (_finalizers.nonEmpty) {
      if (!_finalizing) {
        _finalizing = true;

        _conts.clear();
        _conts.push(_Cont.CancelationLoop);

        _objectState.clear();
        _objectState.push(cb ?? Fn1.of((_) => Unit()));

        _masks += 1;
      }

      return _finalizers.pop();
    } else {
      cb?.call(Right(Unit()));

      _done(const Canceled());
      return _EndFiber();
    }
  }

  IO<dynamic> _succeeded(dynamic result, int depth) {
    final cont = _conts.pop();

    switch (cont) {
      case _Cont.RunTerminus:
        return _runTerminusSuccessK(result);
      case _Cont.Map:
        {
          final f = _objectState.pop() as Fn1F;

          dynamic transformed;
          RuntimeException? error;

          try {
            transformed = f(result);
          } catch (e, s) {
            error = RuntimeException(e, s);
          }

          if (depth > _DefaultMaxStackDepth) {
            return error == null ? _Pure(transformed) : _Error(error);
          } else {
            return error == null
                ? _succeeded(transformed, depth + 1)
                : _failed(error, depth + 1);
          }
        }
      case _Cont.FlatMap:
        {
          final f = _objectState.pop() as Fn1F;

          dynamic transformed;
          RuntimeException? error;

          try {
            transformed = f(result);
          } catch (e, s) {
            error = RuntimeException(e, s);
          }

          return error == null
              ? transformed as IO<dynamic>
              : _failed(error, depth + 1);
        }
      case _Cont.Attempt:
        final f = _objectState.pop() as Fn1F;
        return _succeeded(f(result), depth);
      case _Cont.HandleErrorWith:
        _objectState.pop();
        return _succeeded(result, depth);
      case _Cont.OnCancel:
        _finalizers.pop();
        return _succeeded(result, depth + 1);
      case _Cont.CancelationLoop:
        return _cancelationLoopSuccessK();
      case _Cont.Uncancelable:
        _masks -= 1;
        return _succeeded(result, depth + 1);
      case _Cont.Unmask:
        _masks += 1;
        return _succeeded(result, depth + 1);
    }
  }

  IO<dynamic> _failed(RuntimeException error, int depth) {
    var cont = _conts.pop();

    // Drop all the maps / flatMaps since they don't deal with errors
    while (cont == _Cont.Map || cont == _Cont.FlatMap && _conts.nonEmpty) {
      _objectState.pop();
      cont = _conts.pop();
    }

    switch (cont) {
      case _Cont.Map:
      case _Cont.FlatMap:
        _objectState.pop();
        return _failed(error, depth);
      case _Cont.CancelationLoop:
        return _cancelationLoopFailureK(error);
      case _Cont.RunTerminus:
        return _runTerminusFailureK(error);
      case _Cont.HandleErrorWith:
        final f = _objectState.pop() as Fn1F;

        dynamic recovered;
        RuntimeException? err;

        try {
          recovered = f(error);
        } catch (e, s) {
          err = RuntimeException(e, s);
        }

        return err == null ? recovered as IO<dynamic> : _failed(err, depth + 1);

      case _Cont.OnCancel:
        _finalizers.pop();
        return _failed(error, depth + 1);
      case _Cont.Uncancelable:
        _masks -= 1;
        return _failed(error, depth + 1);
      case _Cont.Unmask:
        _masks += 1;
        return _failed(error, depth + 1);
      case _Cont.Attempt:
        _objectState.pop();
        return _succeeded(Left<RuntimeException, Never>(error), depth);
    }
  }

  void _done(Outcome<A> oc) {
    _join = IO.pure(oc);
    _cancel = IO.pure(Unit());

    _outcome = oc;

    _masks = 0;

    _resumeTag = _Resume.Done;
    _resumeIO = null;

    while (_callbacks.nonEmpty) {
      _callbacks.pop()(oc);
    }
  }

  IO<dynamic> _runTerminusSuccessK(dynamic result) {
    _done(Succeeded(result as A));
    return _EndFiber();
  }

  IO<dynamic> _runTerminusFailureK(RuntimeException error) {
    _done(Errored(error));
    return _EndFiber();
  }

  IO<dynamic> _cancelationLoopSuccessK() {
    if (_finalizers.nonEmpty) {
      _conts.push(_Cont.CancelationLoop);
      return _finalizers.pop();
    } else {
      if (_objectState.nonEmpty) {
        final cb = _objectState.pop() as Fn1F;
        cb.call(Right<RuntimeException, Unit>(Unit()));
      }

      _done(const Canceled());

      return _EndFiber();
    }
  }

  IO<dynamic> _cancelationLoopFailureK(RuntimeException err) =>
      _cancelationLoopSuccessK();
}

// Continuations
enum _Cont {
  Map,
  FlatMap,
  CancelationLoop,
  RunTerminus,
  HandleErrorWith,
  OnCancel,
  Uncancelable,
  Unmask,
  Attempt
}

// Resume
enum _Resume {
  Exec,
  AsyncContinueSuccessful,
  AsyncContinueFailed,
  AsyncContinueCanceled,
  AsyncContinueCanceledWithFinalizer,
  Cede,
  AutoCede,
  Done,
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
        return SyncIO.delay(() => (io as _Delay).thunk())
            .map((a) => Right((a, limit)));
      } else if (io is _Map) {
        final map = io as _Map<dynamic, A>;

        return interpret(map.ioa, limit - 1).map(
          (e) => e.fold(
            (io) => Left(io.map(map.f.call)),
            (result) => Right((map.f(result.$1), result.$2)),
          ),
        );
      } else if (io is _FlatMap) {
        final fm = io as _FlatMap<dynamic, A>;

        return interpret(fm.ioa, limit - 1).flatMap(
          (e) => e.fold(
            (io) => SyncIO.pure(Left(io.flatMap(fm.f.call))),
            (result) => interpret(fm.f(result.$1), limit - 1),
          ),
        );
      } else if (io is _HandleErrorWith) {
        final he = io as _HandleErrorWith<A>;

        return interpret(he.ioa, limit - 1)
            .map((a) => a.fold(
                  (io) => io.handleErrorWith(he.f.call).asLeft<(A, int)>(),
                  (result) => result.asRight<IO<A>>(),
                ))
            .handleErrorWith((ex) => interpret(he.f(ex), limit - 1));
      } else {
        return SyncIO.pure(Left(io));
      }
    }
  }
}
