part of '../io.dart';

/// Registers an asynchronous callback with the IO runtime.
///
/// The [body] receives a callback to signal completion and returns an
/// optional finalizer [IO] for cleanup on cancelation.
final class _Async<A> extends IO<A> {
  final AsyncBodyWithFin<A> body;

  const _Async(this.body);

  _AsyncGet<A> getter() => _AsyncGet();

  @override
  String toString() => 'Async($body)';
}

/// Sentinel node inserted by the interpreter to retrieve the result of
/// an [_Async] callback once it has been invoked.
final class _AsyncGet<A> extends IO<A> {
  Either<Object, dynamic>? value;

  _AsyncGet();

  @override
  String toString() => 'AsyncGet($value)';
}

/// Captures exceptions from [ioa] into an [Either] value, preventing
/// them from propagating as fiber errors.
final class _Attempt<A> extends IO<Either<Object, A>> {
  final IO<A> ioa;

  Either<Object, A> right(dynamic value) => Right<Object, A>(value as A);
  Either<Object, A> left(Object error) => Left<Object, A>(error);

  const _Attempt(this.ioa);

  @override
  String toString() => 'Attempt($ioa)';
}

/// Triggers self-cancelation of the current fiber.
final class _Canceled extends IO<Unit> {
  const _Canceled();

  @override
  String toString() => 'Canceled';
}

/// Introduces an asynchronous boundary, yielding control back to the
/// runtime scheduler for fairness and cancelation checking.
final class _Cede extends IO<Unit> {
  const _Cede();

  @override
  String toString() => 'Cede';
}

/// Defers a synchronous computation via [thunk], evaluated lazily by the
/// interpreter.
final class _Delay<A> extends IO<A> {
  final Function0<A> thunk;

  const _Delay(this.thunk);

  @override
  String toString() => 'Delay($thunk)';
}

/// Internal sentinel that signals the fiber interpreter to terminate the
/// current fiber's run loop.
final class _EndFiber extends IO<dynamic> {
  const _EndFiber();

  @override
  String toString() => 'EndFiber';
}

/// Raises [error] (and optional [stackTrace]) as a fiber error.
final class _Error<A> extends IO<A> {
  final Object error;
  final StackTrace? stackTrace;

  const _Error(this.error, [this.stackTrace]);

  @override
  String toString() => 'Error($error)';
}

/// Monadic bind: sequences [ioa] and passes its result through [f] to
/// produce the next [IO] step.
final class _FlatMap<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, IO<B>> f;

  const _FlatMap(this.ioa, this.f);

  @override
  String toString() => 'FlatMap($ioa, $f)';
}

/// Error recovery: runs [ioa] and, if it raises, applies [f] to the
/// error to produce a fallback [IO].
final class _HandleErrorWith<A> extends IO<A> {
  final IO<A> ioa;
  final Fn2<Object, StackTrace?, IO<A>> f;

  const _HandleErrorWith(this.ioa, this.f);

  @override
  String toString() => 'HandleErrorWith($ioa, $f)';
}

/// Functor map: transforms the result of [ioa] using [f].
final class _Map<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, B> f;

  const _Map(this.ioa, this.f);

  @override
  String toString() => 'Map($ioa, $f)';
}

/// Obtains the current wall-clock time from the [IORuntime].
final class _Now extends IO<DateTime> {
  const _Now();

  @override
  String toString() => 'Now';
}

/// Attaches a cancelation finalizer [fin] to [ioa]. If [ioa] is canceled,
/// [fin] is guaranteed to run.
final class _OnCancel<A> extends IO<A> {
  final IO<A> ioa;
  final IO<Unit> fin;

  const _OnCancel(this.ioa, this.fin);

  @override
  String toString() => 'OnCancel($ioa, $fin)';
}

/// A pure (already computed) value lifted into [IO].
final class _Pure<A> extends IO<A> {
  final A value;

  const _Pure(this.value);

  @override
  String toString() => 'Pure($value)';
}

/// Races two [IO] effects concurrently, returning the outcome of the
/// winner along with a handle to the loser's fiber.
final class _RacePair<A, B> extends IO<RacePairOutcome<A, B>> {
  final IO<A> ioa;
  final IO<B> iob;

  const _RacePair(this.ioa, this.iob);

  IOFiber<A> createFiberA(IORuntime runtime) => IOFiber(ioa, runtime: runtime);
  IOFiber<B> createFiberB(IORuntime runtime) => IOFiber(iob, runtime: runtime);

  RacePairOutcome<A, B> aWon(
    Outcome<dynamic> oc,
    IOFiber<dynamic> fiberB,
  ) => Left((oc as Outcome<A>, fiberB as IOFiber<B>));

  RacePairOutcome<A, B> bWon(
    Outcome<dynamic> oc,
    IOFiber<dynamic> fiberA,
  ) => Right((fiberA as IOFiber<A>, oc as Outcome<B>));

  @override
  String toString() => 'RacePair<$A, $B>($ioa, $iob)';
}

/// Suspends the current fiber for [duration], resuming via the runtime's
/// timer scheduler.
final class _Sleep extends IO<Unit> {
  final Duration duration;

  const _Sleep(this.duration);

  @override
  String toString() => 'Sleep($duration)';
}

/// Forks [ioa] into a new fiber, returning a handle to the child fiber.
final class _Start<A> extends IO<IOFiber<A>> {
  final IO<A> ioa;

  const _Start(this.ioa);

  IOFiber<A> createFiber(IORuntime runtime) => IOFiber(ioa, runtime: runtime);

  @override
  String toString() => 'Start($ioa)';
}

/// Wraps [ioa] with a tracing [label] and captures the call-site
/// [StackTrace] for diagnostic purposes.
final class _Traced<A> extends IO<A> {
  final IO<A> ioa;
  final String label;
  final StackTrace? location;

  final int? depth;

  _Traced(this.ioa, this.label, [this.depth]) : location = StackTrace.current;

  @override
  String toString() => 'Traced($label)';
}

/// Masks cancelation for the duration of [body]. The [Poll] passed to
/// [body] allows selective re-enabling of cancelation for sub-regions.
final class _Uncancelable<A> extends IO<A> {
  final Function1<Poll, IO<A>> body;

  const _Uncancelable(this.body);

  @override
  String toString() => 'Uncancelable<$A>($body)';
}

/// Re-enables cancelation for [ioa] within an [_Uncancelable] region.
/// Used internally by the [Poll] mechanism.
final class _UnmaskRunLoop<A> extends IO<A> {
  final IO<A> ioa;
  final int id;
  final IOFiber<dynamic> self;

  const _UnmaskRunLoop(this.ioa, this.id, this.self);

  @override
  String toString() => 'UnmaskRunLoop<$A>($ioa, $id)';
}
