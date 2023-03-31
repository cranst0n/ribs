import 'dart:async';

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/rill/scope.dart';

final class Rill<O> implements Monad<O> {
  final Pull<O, Unit> _pull;

  Rill._(this._pull);

  static Rill<R> bracket<R>(IO<R> acquire, Function1<R, IO<Unit>> release) =>
      _Eval(acquire)
          .flatMap((r) => _OpenScope(_Output(r), release(r).some))
          .rill;

  static Rill<O> constant<O>(O o) => _Output(o).rill.repeat();

  static Rill<O> emit<O>(O o) => _Output(o).rill;

  static Rill<O> emits<O>(List<O> os) => Pull.fromIterable(os).rill;

  static Rill<Never> empty = Pull.done.rill;

  static Rill<O> eval<O>(IO<O> o) => _Eval(o).flatMap((o) => _Output(o)).rill;

  static Rill<Never> exec<O>(IO<O> o) => eval(o).flatMap((a) => Pull.done.rill);

  // fixedDelay does *NOT* take into account the duration of effect evaluation
  static Rill<Unit> fixedDelay(Duration d) => sleep(d).repeat();

  // fixedRate takes into account the duration of effect evaluation
  static Rill<Unit> fixedRate(Duration period, {bool dampen = true}) =>
      eval(IO.delay(() => DateTime.now()))
          .flatMap((t) => fixedRate_(period, t, dampen));

  static Rill<Unit> fixedRate_(
    Duration period,
    DateTime lastAwakeAt,
    bool dampen,
  ) {
    if (period.inMicroseconds == 0) {
      return emit(Unit()).repeat();
    } else {
      return Rill.eval(IO.delay(() => DateTime.now())).flatMap((now) {
        final next = lastAwakeAt.add(period);

        if (next.isAfter(now)) {
          return sleep(next.difference(now)).voided() +
              fixedRate_(period, next, dampen);
        } else {
          final ticks = (now.microsecondsSinceEpoch -
                  lastAwakeAt.microsecondsSinceEpoch -
                  1) ~/
              period.inMicroseconds;

          final Rill<Unit> step;

          if (ticks < 0) {
            step = empty;
          } else if (ticks == 0 || dampen) {
            step = emit(Unit());
          } else {
            step = emit(Unit()).repeatN(ticks);
          }

          return step +
              fixedRate_(period, lastAwakeAt.add(period * ticks), dampen);
        }
      });
    }
  }

  static Rill<O> force<O>(IO<Rill<O>> f) => eval(f).flatMap(id);

  static Rill<O> fromFuture<O>(Function0<Future<O>> f) =>
      eval(IO.fromFuture(IO.delay(f)));

  static Rill<O> fromStream<O>(Stream<O> s) => Rill.bracket(
        IO.delay(() => StreamQueue(s)),
        (q) => IO
            .fromFuture(IO.delay(() => q.cancel() ?? Future<dynamic>.value()))
            .voided(),
      ).flatMap((q) => repeatEval(IO.fromFuture(IO.delay(() => q.next))));

  static Rill<O> iterate<O>(O initial, Function1<O, O> f) =>
      Pull.iterate(initial, f).voided().rill;

  static Rill<Never> get never => eval(IO.never());

  static Rill<O> raiseError<O>(IOError err) => _Error(err).rill;

  static Rill<O> range<O extends num>(O start, O stop, O step) {
    Rill<O> go(O o) {
      if ((step > 0 && o < stop && start < stop) ||
          (step < 0 && o > stop && start > stop)) {
        return emit(o) + go(o + step as O);
      } else {
        return empty;
      }
    }

    return go(start);
  }

  static Rill<O> repeatEval<O>(IO<O> fo) => eval(fo).repeat();

  static Rill<Unit> sleep(Duration d) => eval(IO.sleep(d));

  Rill<O> operator +(Rill<O> that) => concat(that);

  @override
  Rill<O2> ap<O2>(covariant Rill<Function1<O, O2>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  Rill<O2> as<O2>(O2 o2) => map((_) => o2);

  Rill<Either<IOError, O>> attempt() => map((o) => o.asRight<IOError>())
      .handleErrorWith((err) => Rill.emit(err.asLeft<O>()));

  Rill<O> changes() => filterWithPrevious((o1, o2) => o1 != o2);

  Rill<O> changesBy(Function2<O, O, bool> isEqual) =>
      filterWithPrevious((o1, o2) => !isEqual(o1, o2));

  RillCompiled<O> compile() => RillCompiled(_pull);

  Rill<O> concat(Rill<O> that) => _pull.flatMap((_) => that._pull).rill;

  Rill<O> cons(O o) => emit(o) + this;

  Rill<O> debug({
    Function1<O, String>? formatter,
    Function1<String, IO<Unit>>? logger,
  }) =>
      evalTap(
          (o) => (logger ?? IO.println)((formatter ?? (o) => o.toString())(o)));

  Rill<Never> drain() => _pull.unconsFlatMap((_) => Pull.done).rill;

  Rill<O> drop(int n) => _pull.drop(n).rill;

  Rill<O> dropRight(int n) => _pull.dropRight(n).rill;

  Rill<O> dropWhile(Function1<O, bool> p) => _pull.dropWhile(p).flatten().rill;

  Rill<O> evalFilter(Function1<O, IO<bool>> f) => _pull
      .flatMapOutput((o) => _Eval(f(o)).flatMap((a) {
            return a ? _Output(o) : Pull.done as Pull<O, Unit>;
          }))
      .rill;

  Rill<O> evalTap<O2>(Function1<O, IO<O2>> fo) => mapEval((o) => fo(o).as(o));

  Rill<bool> exists(Function1<O, bool> p) =>
      _pull.forall((o) => !p(o)).flatMap((r) => _Output(!r)).rill;

  Rill<O> filter(Function1<O, bool> p) => _pull.filter(p).rill;

  @override
  Rill<O2> flatMap<O2>(covariant Function1<O, Rill<O2>> f) =>
      _pull.flatMapOutput((o) => f(o)._pull).rill;

  IO<A> fold<A>(A init, Function2<A, O, A> f) =>
      _pull.fold(init, f).map((t) => t.$2);

  Rill<Option<O>> find(Function1<O, bool> p) =>
      _pull.find(p).flatMap((r) => _Output(r)).rill;

  Rill<O> filterWithPrevious(Function2<O, O, bool> f) {
    Pull<O, Unit> go(O last, Rill<O> s) {
      return s._pull.uncons().flatMap((step) {
        return step.fold(
          (r) => Pull.done,
          (tuple) => tuple((hd, tl) {
            if (f(last, hd)) {
              return _Output(hd).flatMap((_) => go(hd, tl.rill));
            } else {
              return go(last, tl.rill);
            }
          }),
        );
      });
    }

    return _pull.uncons().flatMap((step) {
      return step.fold(
        (r) => _Result<O, Unit>(r),
        (tuple) =>
            tuple((hd, tl) => _Output(hd).flatMap((_) => go(hd, tl.rill))),
      );
    }).rill;
  }

  Rill<bool> forall(Function1<O, bool> p) =>
      _pull.forall(p).flatMap((r) => _Output(r)).rill;

  Rill<O> handleErrorWith(Function1<IOError, Rill<O>> f) =>
      _Handle(_pull, (e) => f(e)._pull).rill;

  Rill<O> get head => take(1);

  Rill<O> interleave(Rill<O> that) =>
      zip(that).flatMap((a) => Rill.emits([a.$1, a.$2]));

  Rill<O> intersperse(O separator) =>
      interleave(Rill.emit(separator).repeat()).dropRight(1);

  @override
  Rill<O2> map<O2>(Function1<O, O2> f) => _pull.mapOutput(f).rill;

  Rill<O2> mapEval<O2>(Function1<O, IO<O2>> f) =>
      flatMap((o) => Rill.eval(f(o)));

  Rill<O> metered(Duration rate) => fixedRate(rate).zipRight(this);

  Rill<O> onComplete(Function0<Rill<O>> that) =>
      handleErrorWith((e) => that().concat(raiseError(e))).concat(that());

  Rill<O> repeat() => _pull.repeat().rill;

  Rill<O> repeatN(int n) => n > 0 ? this + repeatN(n - 1) : this;

  Rill<O2> scan<O2>(O2 initial, Function2<O2, O, O2> f) =>
      _Output(initial).flatMap((_) => _pull.scan(initial, f)).rill;

  Rill<O> scope() => _pull.scope().rill;

  Rill<IList<O>> sliding(int size, {int step = 1}) {
    Pull<IList<O>, Unit> go(IList<O> buffer, Pull<O, Unit> p) {
      return p.uncons().flatMap((st) {
        return st.fold(
          (r) => buffer.size == size ? _Output(buffer) : cast(Pull.done),
          (tuple) => tuple((hd, tl) {
            if (buffer.size == size) {
              return _Output(buffer).flatMap((_) =>
                  go(IList.empty(), tl.prepend(buffer.append(hd)).drop(step)));
            } else {
              return go(buffer.append(hd), tl);
            }
          }),
        );
      });
    }

    return go(IList.empty(), _pull).rill;
  }

  Rill<IList<O>> split(Function1<O, bool> f) {
    Pull<IList<O>, Unit> go(IList<O> buffer, Pull<O, Unit> p) {
      return p.uncons().flatMap((step) {
        return step.fold(
          (r) {
            return buffer.nonEmpty ? _Output(buffer) : cast(Pull.done);
          },
          (tuple) => tuple((hd, tl) {
            if (f(hd)) {
              return _Output(buffer).flatMap((_) => go(IList.empty(), tl));
            } else {
              return go(buffer.append(hd), tl);
            }
          }),
        );
      });
    }

    return go(IList.empty(), _pull).rill;
  }

  Rill<O> tail() => drop(1);

  Rill<O> take(int n) => _pull.take(n).voided().rill;

  Rill<O> takeWhile(Function1<O, bool> p) => _pull.takeWhile(p).voided().rill;

  Rill<O2> through<O2>(Pipe<O, O2> pipe) => pipe(this);

  Pull<O, Unit> toPull() => _pull;

  // TODO: Revisit
  Stream<O> toStream() {
    final ctrl = StreamController<O>();

    IO
        .pure(ctrl)
        .bracket(
          (ctrl) => attempt()
              .evalTap((o) => IO.delay(() => o.fold(
                    (err) => ctrl.addError(err.$1, err.$2),
                    (o) => ctrl.add(o),
                  )))
              .compile()
              .drain(),
          (ctrl) => IO.fromFuture(IO.delay(() => ctrl.close())).voided(),
        )
        .unsafeRunAndForget();

    return ctrl.stream;
  }

  Rill<Unit> voided() => as(Unit());

  Rill<(O, int)> zipWithIndex() => zip(Rill.iterate(0, (x) => x + 1));

  Rill<(O, O2)> zip<O2>(Rill<O2> that) => _pull.zipWith(that._pull).rill;

  Rill<O2> zipRight<O2>(Rill<O2> that) =>
      _pull.zipWith(that._pull).rill.map((a) => a.$2);
}

extension RillNestedOps<O> on Rill<Rill<O>> {
  Rill<O> flatten() => flatMap(id);
}

extension RillOptionOps<O> on Rill<Option<O>> {
  Rill<O> unNone() => _pull.unNone().rill;
}

typedef Pipe<I, O> = Function1<Rill<I>, Rill<O>>;

class RillCompiled<O> {
  final Pull<O, Unit> _pull;

  const RillCompiled(this._pull);

  IO<int> count() => _pull.fold(0, (x, __) => x + 1).map((t) => t.$2);

  IO<Unit> drain() => _pull.fold(null, (_, __) => null).as(Unit());

  IO<B> fold<B>(B initial, Function2<B, O, B> f) =>
      _pull.fold(initial, f).map((t) => t.$2);

  IO<Option<O>> get last =>
      _pull.last.fold(none<O>(), (a, b) => b.some).map((a) => a.$1);

  IO<O> lastOr(O fallback) => _pull.last
      .fold(none<O>(), (a, b) => b.some)
      .map((a) => a.$1.getOrElse(() => fallback));

  IO<IList<O>> toIList() =>
      _pull.fold(nil<O>(), (acc, elem) => acc.append(elem)).map((t) => t.$2);

  IO<List<O>> toList() => _pull
      .fold(List<O>.empty(growable: true), (acc, elem) => acc..add(elem))
      .map((t) => t.$2);
}

extension RillCompiledStringOps on RillCompiled<String> {
  IO<String> string() => _pull
      .fold(StringBuffer(), (acc, elem) => acc..write(elem))
      .map((t) => t.$2.toString());
}

sealed class Pull<O, R> {
  const Pull();

  static Pull<Never, R> eval<R>(IO<R> fr) => _Eval(fr);

  IO<_StepResult<O, R>> step(Scope scope);

  Pull<O, R> cons(O o) => _Output(o).flatMap((_) => this);

  Pull<O, R> drop(int n) => n <= 0
      ? this
      : uncons().flatMap((step) => step.fold(
            (r) => _Result(r),
            (tuple) => tuple((_, tl) => tl.drop(n - 1)),
          ));

  Pull<O, R> dropRight(int n) {
    if (n <= 0) {
      return this;
    } else {
      Pull<O, R> go(IList<O> acc, Pull<O, R> p) {
        return p.uncons().flatMap((step) {
          return step.fold(
            (r) => _Result(r),
            (tuple) => tuple((hd, tl) {
              final all = acc.append(hd);
              return fromIList(all.dropRight(n))
                  .flatMap((_) => go(all.takeRight(n), tl));
            }),
          );
        });
      }

      return go(IList.empty(), this);
    }
  }

  Pull<O, Pull<O, R>> dropWhile(Function1<O, bool> p) =>
      uncons().flatMap((step) => step.fold(
            (r) => _Result(_Result(r)),
            (tuple) => tuple((hd, tl) => p(hd)
                ? tl.dropWhile(p)
                : _Result(_Output(hd).flatMap((_) => tl))),
          ));

  Pull<O, R> filter(Function1<O, bool> p) =>
      uncons().flatMap((step) => step.fold(
            (r) => _Result(r),
            (tuple) => tuple((hd, tl) =>
                // ignore: unnecessary_cast
                (p(hd) ? _Output(hd) : (Pull.done as Pull<O, Unit>))
                    .flatMap((_) => tl.filter(p))),
          ));

  // TODO: sus
  Pull<O2, R2> flatMap<O2, R2>(covariant Function1<R, Pull<O2, R2>> f) =>
      _FlatMap(this as Pull<O2, R>, f);

  IO<(R, A)> fold<A>(A init, Function2<A, O, A> f) {
    IO<(R, A)> go(Scope scope, Pull<O, R> p, A acc) {
      return p.step(scope).flatMap((result) {
        return result.fold(
          (done) => IO.pure((done.result, acc)),
          (out) => go(out.scope, out.tail, f(acc, out.head)),
        );
      });
    }

    return Scope.root().flatMap(
      (scope) => go(scope, this, init).attempt().flatMap(
            (res) => scope.close.flatMap(
              (_) => res.fold(IO.raiseError, (t) => IO.pure(t)),
            ),
          ),
    );
  }

  Pull<Never, bool> forall(Function1<O, bool> p) =>
      uncons().flatMap((step) => step.fold(
            (r) => const _Result(true),
            (tuple) => tuple((hd, tl) {
              if (p(hd)) {
                return tl.forall(p);
              } else {
                return const _Result(false);
              }
            }),
          ));

  Pull<Never, Option<O>> find(Function1<O, bool> p) =>
      uncons().flatMap((step) => step.fold(
            (r) => _Result(none<O>()),
            (tuple) => tuple((hd, tl) {
              if (p(hd)) {
                return _Result(hd.some);
              } else {
                return tl.find(p);
              }
            }),
          ));

  Pull<O, R> handleErrorWith(Function1<IOError, Pull<O, R>> f) =>
      _Handle(this, f);

  Pull<O, Option<O>> get last {
    Pull<Never, Option<O>> go(Option<O> prev, Pull<O, R> s) {
      return s.uncons().flatMap((step) {
        return step.fold(
          (_) => _Result(prev),
          (tuple) => tuple((hd, tl) => go(hd.some, tl)),
        );
      });
    }

    return go(none(), this);
  }

  Pull<O, R2> map<R2>(Function1<R, R2> f) => flatMap((r) => _Result(f(r)));

  Pull<O2, R> mapOutput<O2>(Function1<O, O2> f) =>
      uncons().flatMap((step) => step.fold(
            (r) => _Result(r),
            (tuple) => tuple(
                (hd, tl) => _Output(f(hd)).flatMap((_) => tl.mapOutput(f))),
          ));

  Pull<O, Unit> repeat() => flatMap((_) => repeat());

  Pull<O2, R> scan<O2>(O2 initial, Function2<O2, O, O2> f) =>
      uncons().flatMap((step) => step.fold(
            (r) => _Result<O2, R>(r),
            (tuple) => tuple((hd, tl) {
              final out = f(initial, hd);

              return _Output(out).flatMap((_) => tl.scan(out, f));
            }),
          ));

  Pull<O, Option<R>> take(int n) => n <= 0
      ? _Result(none())
      : uncons().flatMap((step) => step.fold(
            (r) => _Result(r.some),
            (tuple) =>
                tuple((hd, tl) => _Output(hd).flatMap((_) => tl.take(n - 1))),
          ));

  Pull<O, Pull<O, R>> takeWhile(Function1<O, bool> p) =>
      uncons().flatMap((step) {
        return step.fold(
          (r) => _Result(_Result(r)),
          (tuple) => tuple((hd, tl) {
            if (p(hd)) {
              return _Output(hd).flatMap((_) => tl.takeWhile(p));
            } else {
              return _Result(_Output(hd).flatMap((_) => tl));
            }
          }),
        );
      });

  Pull<Never, Either<R, (O, Pull<O, R>)>> uncons() => _Uncons(this);

  Pull<O, Unit> voided() => map((_) => Unit());

  Pull<O, R> prepend(IList<O> os) => fromIList(os).flatMap((_) => this);

  Pull<(O, O2), R> zipWith<O2>(Pull<O2, R> that) =>
      uncons().flatMap((step) => step.fold(
            (r) => _Result<(O, O2), R>(r),
            (tuple) => tuple((hd, tl) {
              return that.uncons().flatMap((step2) {
                return step2.fold(
                  (r2) => _Result<(O, O2), R>(r2),
                  (tuple2) => tuple2((hd2, tl2) =>
                      _Output((hd, hd2)).flatMap((_) => tl.zipWith(tl2))),
                );
              });
            }),
          ));

  static Pull<Never, Unit> done = _Result(Unit());

  static Pull<O, Unit> fromIterable<O>(Iterable<O> os) => os.isEmpty
      ? Pull.done
      : _Output(os.first).flatMap((_) => fromIterable(os.skip(1)));

  static Pull<O, Unit> fromIList<O>(IList<O> os) => os.uncons((h, t) =>
      h.fold(() => Pull.done, (h) => _Output(h).flatMap((_) => fromIList(t))));

  static Pull<O, Unit> iterate<O>(O initial, Function1<O, O> f) =>
      _Output(initial).flatMap((_) => iterate(f(initial), f));

  static Pull<O, R> unfold<O, R>(
    R init,
    Function1<R, Either<R, (O, R)>> f,
  ) =>
      f(init).fold(
        (r) => _Result(r),
        (tuple) => tuple((o, r2) => unfold(r2, f)),
      );
}

extension PullOps<O> on Pull<O, Unit> {
  Rill<O> get rill => Rill._(this);

  Pull<O2, Unit> flatMapOutput<O2>(Function1<O, Pull<O2, Unit>> f) =>
      _FlatMapOutput(this, f);

  Pull<O2, Unit> unconsFlatMap<O2>(Function1<O, Pull<O2, Unit>> f) =>
      uncons().flatMap((a) => a.fold(
            (_) => Pull.done,
            (tuple) =>
                tuple((hd, tl) => f(hd).flatMap((_) => tl.unconsFlatMap(f))),
          ));

  Pull<O, Unit> scope() => _OpenScope(this, none());
}

extension PullNestedOps<O, R> on Pull<O, Pull<O, R>> {
  Pull<O, R> flatten() => flatMap(id);
}

extension PullOptionOps<O, R> on Pull<Option<O>, R> {
  Pull<O, R> unNone() => uncons().flatMap(
        (step) => step.fold(
          (r) => _Result(r),
          (tuple) => tuple((hd, tl) {
            return hd
                // ignore: unnecessary_cast
                .fold(() => Pull.done as Pull<O, Unit>, (hd) => _Output(hd))
                .flatMap((_) => tl.unNone());
          }),
        ),
      );
}

final class _Result<O, R> extends Pull<O, R> {
  final R result;

  const _Result(this.result);

  @override
  IO<_StepResult<O, R>> step(Scope scope) => IO.pure(_Done(scope, result));
}

final class _Output<O> extends Pull<O, Unit> {
  final O value;

  const _Output(this.value);

  @override
  IO<_StepResult<O, Unit>> step(Scope scope) =>
      IO.pure(_Out(scope, value, Pull.done));
}

final class _Eval<R> extends Pull<Never, R> {
  final IO<R> action;

  const _Eval(this.action);

  @override
  IO<_StepResult<Never, R>> step(Scope scope) =>
      action.map((r) => _Done(scope, r));
}

final class _Handle<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final Function1<IOError, Pull<O, R>> handler;

  const _Handle(this.source, this.handler);

  @override
  IO<_StepResult<O, R>> step(Scope scope) {
    if (source is _Handle<O, R>) {
      final h = source as _Handle<O, R>;

      return h.source
          .handleErrorWith(
              (x) => h.handler(x).handleErrorWith((y) => handler(y)))
          .step(scope);
    } else {
      return source.step(scope).map((result) {
        return result.fold(
          (done) => _Done<O, R>(done.scope, done.result),
          (out) => _Out<O, R>(scope, out.head, _Handle(out.tail, handler)),
        );
      }).handleErrorWith((err) => handler(err).step(scope));
    }
  }
}

final class _Error extends Pull<Never, Unit> {
  final IOError error;

  const _Error(this.error);

  @override
  IO<_StepResult<Never, Unit>> step(Scope scope) => IO.raiseError(error);
}

final class _FlatMap<X, O, R> extends Pull<O, R> {
  final Pull<O, X> source;
  final Function1<X, Pull<O, R>> f;

  const _FlatMap(this.source, this.f);

  @override
  IO<_StepResult<O, R>> step(Scope scope) {
    if (source is _FlatMap<X, O, R>) {
      final fm = source as _FlatMap<X, O, R>;

      return fm.source
          .flatMap((x) => fm.f(x).flatMap((r) => f(r as X)))
          .step(scope);
    } else {
      return source.step(scope).flatMap((result) {
        return result.fold(
          (done) => f(done.result).step(scope),
          (out) => IO.pure(_Out(scope, out.head, out.tail.flatMap(f))),
        );
      });
    }
  }
}

final class _FlatMapOutput<O, O2> extends Pull<O2, Unit> {
  final Pull<O, Unit> source;
  final Function1<O, Pull<O2, Unit>> f;

  const _FlatMapOutput(this.source, this.f);

  @override
  IO<_StepResult<O2, Unit>> step(Scope scope) {
    return source.step(scope).flatMap((result) {
      return result.fold(
        (done) => IO.pure(_Done<O2, Unit>(scope, done.result)),
        (out) =>
            f(out.head).flatMap((_) => out.tail.flatMapOutput(f)).step(scope),
      );
    });
  }
}

final class _Uncons<O, R> extends Pull<Never, Either<R, (O, Pull<O, R>)>> {
  final Pull<O, R> source;

  const _Uncons(this.source);

  @override
  IO<_StepResult<Never, Either<R, (O, Pull<O, R>)>>> step(Scope scope) =>
      source.step(scope).map((result) => _Done(scope, result.toUnconsResult()));
}

final class _OpenScope<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final Option<IO<Unit>> finalizer;

  const _OpenScope(this.source, this.finalizer);

  @override
  IO<_StepResult<O, R>> step(Scope scope) =>
      scope.open(finalizer.getOrElse(() => IO.unit)).flatMap((subscope) =>
          _WithScope(source, subscope.id, scope.id).step(subscope));
}

final class _WithScope<O, R> extends Pull<O, R> {
  final Pull<O, R> source;
  final ScopeId id;
  final ScopeId returnScopeId;

  const _WithScope(this.source, this.id, this.returnScopeId);

  @override
  IO<_StepResult<O, R>> step(Scope scope) {
    return scope.findScope(id).map((s) {
      return s.map((s) => (s, true)).getOrElse(() => (scope, false));
    }).flatMap((tuple) {
      return tuple((newScope, closeAfterUse) {
        return source.step(newScope).attempt().flatMap((step) {
          return step.fold(
            (err) => scope.close.flatMap((_) => IO.raiseError(err)),
            (success) {
              return success.fold(
                (done) {
                  return scope
                      .findScope(returnScopeId)
                      .map((a) => a.getOrElse(() => done.scope))
                      .flatMap((nextScope) =>
                          scope.close.as(_Done(nextScope, done.result)));
                },
                (out) {
                  return IO.pure(_Out(scope, out.head,
                      _WithScope(out.tail, scope.id, returnScopeId)));
                },
              );
            },
          );
        });
      });
    });
  }
}

sealed class _StepResult<O, R> {
  const _StepResult();

  B fold<B>(Function1<_Done<O, R>, B> ifDone, Function1<_Out<O, R>, B> ifOut);

  Either<R, (O, Pull<O, R>)> toUnconsResult() => fold(
        (done) => Left(done.result),
        (out) => Right((out.head, out.tail)),
      );
}

final class _Done<O, R> extends _StepResult<O, R> {
  final Scope scope;
  final R result;

  const _Done(this.scope, this.result);

  @override
  B fold<B>(Function1<_Done<O, R>, B> ifDone, Function1<_Out<O, R>, B> ifOut) =>
      ifDone(this);
}

final class _Out<O, R> extends _StepResult<O, R> {
  final Scope scope;
  final O head;
  final Pull<O, R> tail;

  const _Out(this.scope, this.head, this.tail);

  @override
  B fold<B>(Function1<_Done<O, R>, B> ifDone, Function1<_Out<O, R>, B> ifOut) =>
      ifOut(this);
}
