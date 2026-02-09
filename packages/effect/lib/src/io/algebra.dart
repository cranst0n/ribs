part of '../io.dart';

final class _Pure<A> extends IO<A> {
  final A value;

  const _Pure(this.value);

  @override
  String toString() => 'Pure($value)';
}

final class _Error<A> extends IO<A> {
  final Object error;
  final StackTrace? stackTrace;

  const _Error(this.error, [this.stackTrace]);

  @override
  String toString() => 'Error($error)';
}

final class _Delay<A> extends IO<A> {
  final Fn0<A> thunk;

  const _Delay(this.thunk);

  @override
  String toString() => 'Delay($thunk)';
}

final class _Async<A> extends IO<A> {
  final AsyncBodyWithFin<A> body;

  const _Async(this.body);

  _AsyncGet<A> getter() => _AsyncGet();

  @override
  String toString() => 'Async($body)';
}

final class _AsyncGet<A> extends IO<A> {
  Either<Object, dynamic>? value;

  _AsyncGet();

  @override
  String toString() => 'AsyncGet($value)';
}

final class _Map<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, B> f;

  const _Map(this.ioa, this.f);

  @override
  String toString() => 'Map($ioa, $f)';
}

final class _FlatMap<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, IO<B>> f;

  const _FlatMap(this.ioa, this.f);

  @override
  String toString() => 'FlatMap($ioa, $f)';
}

final class _Attempt<A> extends IO<Either<Object, A>> {
  final IO<A> ioa;

  Either<Object, A> right(dynamic value) => Right<Object, A>(value as A);
  Either<Object, A> left(Object error) => Left<Object, A>(error);

  const _Attempt(this.ioa);

  @override
  String toString() => 'Attempt($ioa)';
}

final class _Now extends IO<DateTime> {
  const _Now();

  @override
  String toString() => '_Now';
}

final class _Sleep extends IO<Unit> {
  final Duration duration;

  const _Sleep(this.duration);

  @override
  String toString() => 'Sleep($duration)';
}

final class _Cede extends IO<Unit> {
  const _Cede();

  @override
  String toString() => 'Cede';
}

final class _Start<A> extends IO<IOFiber<A>> {
  final IO<A> ioa;

  const _Start(this.ioa);

  IOFiber<A> createFiber(IORuntime runtime) => IOFiber(ioa, runtime: runtime);

  @override
  String toString() => 'Start($ioa)';
}

final class _HandleErrorWith<A> extends IO<A> {
  final IO<A> ioa;
  final Fn1<Object, IO<A>> f;

  const _HandleErrorWith(this.ioa, this.f);

  @override
  String toString() => 'HandleErrorWith($ioa, $f)';
}

final class _OnCancel<A> extends IO<A> {
  final IO<A> ioa;
  final IO<Unit> fin;

  const _OnCancel(this.ioa, this.fin);

  @override
  String toString() => 'OnCancel($ioa, $fin)';
}

final class _Canceled extends IO<Unit> {
  const _Canceled();

  @override
  String toString() => 'Canceled';
}

final class _RacePair<A, B> extends IO<RacePairOutcome<A, B>> {
  final IO<A> ioa;
  final IO<B> iob;

  const _RacePair(this.ioa, this.iob);

  IOFiber<A> createFiberA(IORuntime runtime, int autoCedeN) => IOFiber(ioa, runtime: runtime);
  IOFiber<B> createFiberB(IORuntime runtime, int autoCedeN) => IOFiber(iob, runtime: runtime);

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

final class _Uncancelable<A> extends IO<A> {
  final Function1<Poll, IO<A>> body;

  const _Uncancelable(this.body);

  @override
  String toString() => 'Uncancelable<$A>($body)';
}

final class _UnmaskRunLoop<A> extends IO<A> {
  final IO<A> ioa;
  final int id;
  final IOFiber<dynamic> self;

  const _UnmaskRunLoop(this.ioa, this.id, this.self);

  @override
  String toString() => 'UnmaskRunLoop<$A>($ioa, $id)';
}

final class _EndFiber extends IO<dynamic> {
  const _EndFiber();

  @override
  String toString() => 'EndFiber';
}

final class _Traced<A> extends IO<A> {
  final IO<A> ioa;
  final String label;
  final StackTrace? location;

  final int? depth;

  _Traced(this.ioa, this.label, [this.depth]) : location = StackTrace.current;

  @override
  String toString() => 'Traced($label)';
}
