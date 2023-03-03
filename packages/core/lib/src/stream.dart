import 'package:ribs_core/ribs_core.dart';

class Rill<O> implements Monad<O> {
  final Pull<O, Unit> _pull;

  Rill._(this._pull);

  static Rill<O> emits<O>(List<O> os) => Pull.fromIterable(os).toStream;

  static Rill<O> iterate<O>(O initial, Function1<O, O> f) =>
      Pull.iterate(initial, f).voided.toStream;

  @override
  Rill<O2> ap<O2>(covariant Rill<Function1<O, O2>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  Rill<O> concat(Rill<O> that) => _pull.flatMap((p0) => that._pull).toStream;

  Rill<O> drop(int n) => _pull.drop(n).toStream;

  Rill<O> filter(Function1<O, bool> p) => _pull.filter(p).toStream;

  @override
  Rill<O2> flatMap<O2>(covariant Function1<O, Rill<O2>> f) =>
      _pull.flatMapOutput((o) => f(o)._pull).toStream;

  A fold<A>(A init, Function2<A, O, A> f) => _pull.fold(init, f).$2;

  @override
  Rill<O2> map<O2>(Function1<O, O2> f) => _pull.mapOutput(f).toStream;

  Rill<O> take(int n) => _pull.take(n).voided.toStream;

  Rill<O2> through<O2>(Pipe<O, O2> pipe) => pipe(this);

  IList<O> get toIList => _pull.toIList;

  List<O> get toList => _pull.toList;

  Pull<O, Unit> get toPull => _pull;
}

typedef Pipe<I, O> = Function1<Rill<I>, Rill<O>>;

abstract class Pull<O, R> {
  const Pull();

  Either<R, Tuple2<O, Pull<O, R>>> get step;

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
  Pull<O2, R2> flatMap<O2, R2>(covariant Pull<O2, R2> Function(R) f) =>
      FlatMap(this as Pull<O2, R>, f);

  Tuple2<R, A> fold<A>(A init, Function2<A, O, A> f) => step.fold(
        (r) => Tuple2(r, init),
        (tuple) => tuple((hd, tl) => tl.fold(f(init, hd), f)),
      );

  Pull<O, R2> map<R2>(Function1<R, R2> f) => flatMap((r) => Result(f(r)));

  Pull<O2, R> mapOutput<O2>(Function1<O, O2> f) =>
      uncons.flatMap((step) => step.fold(
            (r) => Result(r),
            (tuple) => tuple(
                (hd, tl) => Output(f(hd)).flatMap((_) => tl.mapOutput(f))),
          ));

  IList<O> get toIList => fold(nil<O>(), (acc, elem) => acc.append(elem)).$2;

  List<O> get toList =>
      fold(List<O>.empty(growable: true), (acc, elem) => acc..add(elem)).$2;

  Pull<O, Unit> repeat() => flatMap((_) => repeat());

  Pull<O, Option<R>> take(int n) => n <= 0
      ? Result(none())
      : uncons.flatMap((step) => step.fold(
            (r) => Result(r.some),
            (tuple) =>
                tuple((hd, tl) => Output(hd).flatMap((_) => tl.take(n - 1))),
          ));

  Pull<Never, Either<R, Tuple2<O, Pull<O, R>>>> get uncons =>
      Pull.done.flatMap((_) => Result(step));

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
  Rill<O> get toStream => Rill._(this);

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
  Either<R, Tuple2<O, Pull<O, R>>> get step => Left(result);
}

class Output<O> extends Pull<O, Unit> {
  final O value;

  const Output(this.value);

  @override
  Either<Unit, Tuple2<O, Pull<O, Unit>>> get step =>
      Right(Tuple2(value, Pull.done));
}

class FlatMap<X, O, R> extends Pull<O, R> {
  final Pull<O, X> source;
  final Function1<X, Pull<O, R>> f;

  const FlatMap(this.source, this.f);

  @override
  Either<R, Tuple2<O, Pull<O, R>>> get step {
    if (source is FlatMap<X, O, R>) {
      final fm = source as FlatMap<X, O, R>;

      return fm.source.flatMap((x) => fm.f(x).flatMap((r) => f(r as X))).step;
    } else {
      return source.step.fold(
        (r) => f(r).step,
        (tuple) => tuple((hd, tl) => Right(Tuple2(hd, tl.flatMap(f)))),
      );
    }
  }
}
