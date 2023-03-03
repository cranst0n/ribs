import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/rill/scope.dart';

class Rill<O> implements Monad<O> {
  final Pull<O, Unit> _pull;

  Rill._(this._pull);

  static Rill<O> emits<O>(List<O> os) => Pull.fromIterable(os).rill;

  static Rill<Never> empty = Pull.done.rill;

  static Rill<O> eval<O>(IO<O> o) => Eval(o).flatMap((o) => Output(o)).rill;

  static Rill<O> iterate<O>(O initial, Function1<O, O> f) =>
      Pull.iterate(initial, f).voided.rill;

  static Rill<O> raiseError<O>(IOError err) => RillError(err).rill;

  @override
  Rill<O2> ap<O2>(covariant Rill<Function1<O, O2>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  RillCompiled<O> get compile => RillCompiled(_pull);

  Rill<O> concat(Rill<O> that) => _pull.flatMap((p0) => that._pull).rill;

  Rill<O> drop(int n) => _pull.drop(n).rill;

  Rill<O> filter(Function1<O, bool> p) => _pull.filter(p).rill;

  @override
  Rill<O2> flatMap<O2>(covariant Function1<O, Rill<O2>> f) =>
      _pull.flatMapOutput((o) => f(o)._pull).rill;

  IO<A> fold<A>(A init, Function2<A, O, A> f) =>
      _pull.fold(init, f).map((t) => t.$2);

  Rill<O> handleErrorWith(Function1<IOError, Rill<O>> f) =>
      _pull.handleErrorWith((a) => f(a)._pull).rill;

  @override
  Rill<O2> map<O2>(Function1<O, O2> f) => _pull.mapOutput(f).rill;

  Rill<O2> mapEval<O2>(Function1<O, IO<O2>> f) =>
      flatMap((o) => Rill.eval(f(o)));

  Rill<O> onComplete(Function0<Rill<O>> that) =>
      handleErrorWith((e) => that().concat(raiseError(e))).concat(that());

  Rill<O> get repeat => _pull.repeat().rill;

  Rill<O> take(int n) => _pull.take(n).voided.rill;

  Rill<O2> through<O2>(Pipe<O, O2> pipe) => pipe(this);

  Pull<O, Unit> get toPull => _pull;
}

typedef Pipe<I, O> = Function1<Rill<I>, Rill<O>>;

class RillCompiled<O> {
  final Pull<O, Unit> _pull;

  const RillCompiled(this._pull);

  IO<Unit> get drain => _pull.fold(null, (_, __) => null).as(Unit());

  IO<IList<O>> get toIList =>
      _pull.fold(nil<O>(), (acc, elem) => acc.append(elem)).map((t) => t.$2);

  IO<List<O>> get toList => _pull
      .fold(List<O>.empty(growable: true), (acc, elem) => acc..add(elem))
      .map((t) => t.$2);
}

abstract class Pull<O, R> {
  const Pull();

  IO<Either<R, Tuple2<O, Pull<O, R>>>> get step;

  Pull<O, R> drop(int n) => n <= 0
      ? this
      : uncons.flatMap((step) => step.fold(
            (r) => Result(r),
            (tuple) => tuple((_, tl) => tl.drop(n - 1)),
          ));

  Pull<O, R> filter(Function1<O, bool> p) => uncons.flatMap((step) => step.fold(
        (r) => Result(r),
        (tuple) => tuple((hd, tl) =>
            // ignore: unnecessary_cast
            (p(hd) ? Output(hd) : (Pull.done as Pull<O, Unit>))
                .flatMap((p0) => tl.filter(p))),
      ));

  // TODO: sus
  Pull<O2, R2> flatMap<O2, R2>(covariant Function1<R, Pull<O2, R2>> f) =>
      FlatMap(this as Pull<O2, R>, f);

  IO<Tuple2<R, A>> fold<A>(A init, Function2<A, O, A> f) =>
      step.flatMap((step) => step.fold(
            (r) => IO.pure(Tuple2(r, init)),
            (tuple) => tuple((hd, tl) => tl.fold(f(init, hd), f)),
          ));

  Pull<O, R> handleErrorWith(Function1<IOError, Pull<O, R>> f) =>
      Handle(this, f);

  Pull<O, R2> map<R2>(Function1<R, R2> f) => flatMap((r) => Result(f(r)));

  Pull<O2, R> mapOutput<O2>(Function1<O, O2> f) =>
      uncons.flatMap((step) => step.fold(
            (r) => Result(r),
            (tuple) => tuple(
                (hd, tl) => Output(f(hd)).flatMap((_) => tl.mapOutput(f))),
          ));

  Pull<O, Unit> repeat() => flatMap((_) => repeat());

  Pull<O, Option<R>> take(int n) => n <= 0
      ? Result(none())
      : uncons.flatMap((step) => step.fold(
            (r) => Result(r.some),
            (tuple) =>
                tuple((hd, tl) => Output(hd).flatMap((_) => tl.take(n - 1))),
          ));

  Pull<Never, Either<R, Tuple2<O, Pull<O, R>>>> get uncons => Eval(step);

  Pull<O, Unit> get voided => map((_) => Unit());

  static Pull<O, Unit> continually<O>(O o) =>
      Output(o).flatMap((_) => continually(o));

  static Pull<Never, Unit> done = Result(Unit());

  static Pull<O, Unit> fromIterable<O>(Iterable<O> os) => os.isEmpty
      ? Pull.done
      : Output(os.first).flatMap((_) => fromIterable(os.skip(1)));

  static Pull<O, Unit> fromIList<O>(IList<O> os) => os.uncons((h, t) =>
      h.fold(() => Pull.done, (h) => Output(h).flatMap((_) => fromIList(t))));

  static Pull<O, Unit> iterate<O>(O initial, Function1<O, O> f) =>
      Output(initial).flatMap((_) => iterate(f(initial), f));

  static Pull<O, R> unfold<O, R>(
    R init,
    Function1<R, Either<R, Tuple2<O, R>>> f,
  ) =>
      f(init).fold(
        (r) => Result(r),
        (tuple) => tuple((o, r2) => unfold(r2, f)),
      );
}

extension PullOps<O> on Pull<O, Unit> {
  Rill<O> get rill => Rill._(this);

  Pull<O2, Unit> flatMapOutput<O2>(Function1<O, Pull<O2, Unit>> f) =>
      uncons.flatMap(
        (step) => step.fold(
          (_) => Result<O2, Unit>(Unit()),
          (tuple) =>
              tuple((hd, tl) => f(hd).flatMap((_) => tl.flatMapOutput(f))),
        ),
      );
}

class Result<O, R> extends Pull<O, R> {
  final R result;

  const Result(this.result);

  @override
  IO<Either<R, Tuple2<O, Pull<O, R>>>> get step => IO.pure(Left(result));
}

class Output<O> extends Pull<O, Unit> {
  final O value;

  const Output(this.value);

  @override
  IO<Either<Unit, Tuple2<O, Pull<O, Unit>>>> get step =>
      IO.pure(Right(Tuple2(value, Pull.done)));
}

class Eval<R> extends Pull<Never, R> {
  final IO<R> action;

  const Eval(this.action);

  @override
  IO<Either<R, Tuple2<Never, Pull<Never, R>>>> get step =>
      action.map(Either.left);
}

class Handle<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final Function1<IOError, Pull<O, R>> handler;

  const Handle(this.source, this.handler);

  @override
  IO<Either<R, Tuple2<O, Pull<O, R>>>> get step {
    if (source is Handle) {
      final h = source as Handle<O, R>;

      return h.source
          .handleErrorWith(
              (x) => h.handler(x).handleErrorWith((y) => handler(y)))
          .step;
    } else {
      return source.step.map((a) {
        return a.fold(
          (r) => r.asLeft<Tuple2<O, Pull<O, R>>>(),
          (tuple) =>
              tuple((hd, tl) => Tuple2(hd, Handle(tl, handler)).asRight<R>()),
        );
      }).handleErrorWith((t) => handler(t).step);
    }
  }
}

class RillError extends Pull<Never, Unit> {
  final IOError error;

  const RillError(this.error);

  @override
  IO<Either<Unit, Tuple2<Never, Pull<Never, Unit>>>> get step =>
      IO.raiseError(error);
}

class FlatMap<X, O, R> extends Pull<O, R> {
  final Pull<O, X> source;
  final Function1<X, Pull<O, R>> f;

  const FlatMap(this.source, this.f);

  @override
  IO<Either<R, Tuple2<O, Pull<O, R>>>> get step {
    if (source is FlatMap<X, O, R>) {
      final fm = source as FlatMap<X, O, R>;

      return fm.source.flatMap((x) => fm.f(x).flatMap((r) => f(r as X))).step;
    } else {
      return source.step.flatMap((step) => step.fold(
            (r) => f(r).step,
            (tuple) =>
                tuple((hd, tl) => IO.pure(Right(Tuple2(hd, tl.flatMap(f))))),
          ));
    }
  }
}

class OpenScope<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final Option<IO<Unit>> finalizer;

  const OpenScope(this.source, this.finalizer);

  @override
  // TODO: implement step
  IO<Either<R, Tuple2<O, Pull<O, R>>>> get step => throw UnimplementedError();
}

class WithScope<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final ScopeId id;
  final ScopeId returnScope;

  const WithScope(this.source, this.id, this.returnScope);

  @override
  // TODO: implement step
  IO<Either<R, Tuple2<O, Pull<O, R>>>> get step => throw UnimplementedError();
}

abstract class StepResult<O, R> {
  const StepResult();
}

class Done<O, R> extends StepResult<O, R> {
  final Scope scope;
  final R result;

  const Done(this.scope, this.result);
}

class Out<O, R> extends StepResult<O, R> {
  final Scope scope;
  final O head;
  final Pull<O, R> tail;

  const Out(this.scope, this.head, this.tail);
}
