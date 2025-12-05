import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

final class Rill<O> {
  final Pull<O, Unit> _underlying;

  Rill(this._underlying);

  static Rill<O> chunk<O>(IList<O> os) => Pull.output(os).rillNoScope();

  static Rill<O> emit<O>(O o) => Pull.output1(o).rillNoScope();

  static Rill<O> emits<O>(IList<O> os) => Pull.output(os).rillNoScope();

  static Rill<O> empty<O>() => Pull.done().rillNoScope();

  static Rill<O> eval<O>(IO<O> io) => Pull.eval(io).flatMap((a) => Pull.output1(a)).rillNoScope();

  static Rill<O> raiseError<O>(RuntimeException err) => Pull.raiseError(err).rillNoScope();

  static Rill<int> range(int start, int stopExclusive, {int step = 1}) {
    Rill<int> go(int o) {
      if ((step > 0 && o < stopExclusive && start < stopExclusive) ||
          (step < 0 && o > stopExclusive && start > stopExclusive)) {
        return Rill.emit(o).append(() => go(o + step));
      } else {
        return Rill.empty();
      }
    }

    return go(start);
  }

  Rill<O> append(Function0<Rill<O>> that) =>
      _underlying.append(() => that()._underlying).rillNoScope();

  RillCompiled<O> compile() => RillCompiled(_underlying);

  Rill<O> cons(IList<O> l) => l.isEmpty ? this : Rill.chunk(l).append(() => this);

  Rill<Never> drain() => _underlying.unconsFlatMap((_) => Pull.done()).rill();

  Rill<O> drop(int n) =>
      pull().drop(n).flatMap((tl) => tl.fold(() => Pull.done(), (tl) => tl.pull().echo())).rill();

  Rill<O> dropThrough(Function1<O, bool> p) => pull()
      .dropThrough(p)
      .flatMap((a) => a.fold(() => Pull.done(), (a) => a.pull().echo()))
      .rill();

  Rill<O> dropWhile(Function1<O, bool> p) =>
      pull().dropWhile(p).flatMap((a) => a.fold(() => Pull.done(), (a) => a.pull().echo())).rill();

  Rill<O2> evalMap<O2>(Function1<O, IO<O2>> f) =>
      _underlying.flatMapOutput((o) => Pull.eval(f(o)).flatMap(Pull.output1)).rillNoScope();

  Rill<O> evalTap<O2>(Function1<O, IO<O2>> f) => evalMap((o) => f(o).as(o));

  Rill<bool> exists(Function1<O, bool> p) =>
      pull().forall((a) => !p(a)).flatMap((r) => Pull.output1(!r)).rill();

  Rill<O> find(Function1<O, bool> f) =>
      pull().find(f).flatMap((a) => a.fold(() => Pull.done(), (a) => Pull.output1(a.$1))).rill();

  Rill<O> filter(Function1<O, bool> p) => mapChunks((c) => c.filter(p));

  Rill<O> filterWithPrevious(Function2<O, O, bool> f) {
    Pull<O, Unit> go(O last, Rill<O> s) {
      return s.pull().uncons().flatMap(
            (a) => a.fold(
              () => Pull.done(),
              (a) => a((hd, tl) {
                final (allPass, newLast) = hd.foldLeft<(bool, O)>((true, last), (accLast, o) {
                  final (acc, last) = accLast;
                  return (acc && f(last, o), o);
                });

                if (allPass) {
                  return Pull.output(hd).append(() => go(newLast, tl));
                } else {
                  final (acc, newLast) =
                      hd.foldLeft<(IList<O>, O)>((IList.empty<O>(), last), (accLast, o) {
                    final (acc, last) = accLast;

                    if (f(last, o)) {
                      return (acc.appended(o), o);
                    } else {
                      return (acc, last);
                    }
                  });

                  return Pull.output(acc).append(() => go(newLast, tl));
                }
              }),
            ),
          );
    }

    return pull()
        .uncons1()
        .flatMap((a) => a.fold(
            () => Pull.done(),
            (a) => a(
                  (hd, tl) => Pull.output1(hd).append(() => go(hd, tl)),
                )))
        .rill();
  }

  Rill<O2> flatMap<O2>(covariant Function1<O, Rill<O2>> f) =>
      _underlying.flatMapOutput((o) => f(o)._underlying).rillNoScope();

  Rill<O2> fold<O2>(O2 initial, Function2<O2, O, O2> f) =>
      pull().fold(initial, f).flatMap((x) => Pull.output1(x)).rill();

  Rill<O> handleErrorWith(Function1<RuntimeException, Rill<O>> handler) =>
      Pull.scope(_underlying).handleErrorWith((e) => handler(e)._underlying).rillNoScope();

  Rill<O2> map<O2>(Function1<O, O2> f) => Pull.mapOutput(this, f).rillNoScope();

  // Rill<O2> _mapNoScope<O2>(Function1<O, O2> f) =>
  //     Pull.mapOutputNoScope(this, f).rillNoScope();

  Rill<O2> mapChunks<O2>(Function1<IList<O>, IList<O2>> f) =>
      _underlying.unconsFlatMap((hd) => Pull.output(f(hd))).rill();

  Rill<O> onComplete(Function0<Rill<O>> s2) =>
      handleErrorWith((e) => s2().append(() => Rill(Pull.fail(e)))).append(s2);

  ToPull<O> pull() => ToPull(this);
}

extension RillNestedOps<O> on Rill<Rill<O>> {
  Rill<O> flatten() => flatMap(identity);
}

final class StepLeg<O> {
  final IList<O> head;

  final UniqueToken scopeId;
  final Pull<O, Unit> next;

  StepLeg(this.head, this.scopeId, this.next);
}

class RillCompiled<O> {
  final Pull<O, Unit> _pull;

  const RillCompiled(this._pull);

  IO<int> count() => foldChunks(0, (acc, chunk) => acc + chunk.size);

  IO<Unit> drain() => foldChunks(Unit(), (a, _) => a);

  IO<A> fold<A>(A init, Function2<A, O, A> f) =>
      foldChunks(init, (acc, chunk) => chunk.foldLeft(acc, f));

  IO<A> foldChunks<A>(
    A init,
    Function2<A, IList<O>, A> fold,
  ) =>
      Resource.makeCase(
        Scope.newRoot(),
        (scope, ec) => scope.close(ec).rethrowError(),
      ).use((scope) => Pull.compile(_pull, scope, false, init, fold));

  IO<Option<O>> last() => foldChunks(none(), (acc, elem) => elem.lastOption.orElse(() => acc));

  IO<IList<O>> toIList() => foldChunks(IList.empty(), (acc, chunk) => acc.concat(chunk));
}

class ToPull<O> {
  final Rill<O> self;

  const ToPull(this.self);

  Pull<O, Option<Rill<O>>> drop(int n) {
    if (n <= 0) {
      return Pull.pure(Some(self));
    } else {
      return uncons().flatMap((a) => a.fold(
            () => Pull.pure(none()),
            (a) {
              final (hd, tl) = a;

              if (hd.size < n) {
                return tl.pull().drop(n - hd.size);
              } else if (hd.size == n) {
                return Pull.pure(Some(tl));
              } else {
                return Pull.pure(Some(tl.cons(hd.drop(n))));
              }
            },
          ));
    }
  }

  Pull<O, Option<Rill<O>>> dropThrough(Function1<O, bool> p) => _dropWhile_(p, true);

  Pull<O, Option<Rill<O>>> dropWhile(Function1<O, bool> p) => _dropWhile_(p, false);

  Pull<O, Option<Rill<O>>> _dropWhile_(
    Function1<O, bool> p,
    bool dropFailure,
  ) =>
      uncons().flatMap(
        (a) => a.fold(
          () => Pull.pure(none()),
          (a) => a(
            (hd, tl) {
              return hd.indexWhere((o) => !p(o)).fold(
                () => tl.pull()._dropWhile_(p, dropFailure),
                (idx) {
                  final toDrop = dropFailure ? idx + 1 : idx;
                  return Pull.pure(Some(tl.cons(hd.drop(toDrop))));
                },
              );
            },
          ),
        ),
      );

  Pull<O, Unit> echo() => self._underlying;

  Pull<O, Option<(O, Rill<O>)>> find(Function1<O, bool> f) => uncons().flatMap((a) => a.fold(
        () => Pull.pure(none()),
        (a) => a((hd, tl) {
          return hd.indexWhere(f).fold(
            () => tl.pull().find(f),
            (idx) {
              if (idx + 1 < hd.size) {
                final rem = hd.drop(idx + 1);
                return Pull.pure(Some((hd[idx], tl.cons(rem))));
              } else {
                return Pull.pure(Some((hd[idx], tl)));
              }
            },
          );
        }),
      ));

  Pull<O, O2> fold<O2>(O2 init, Function2<O2, O, O2> f) => uncons().flatMap((a) => a.fold(
      () => Pull.pure(init),
      (a) => a(
            (hd, tl) {
              final acc = hd.foldLeft(init, f);
              return tl.pull().fold(acc, f);
            },
          )));

  Pull<O, bool> forall(Function1<O, bool> p) => uncons().flatMap((a) => a.foldN(
        () => Pull.pure<O, bool>(true),
        (hd, tl) => hd.forall(p) ? tl.pull().forall(p) : Pull.pure<O, bool>(false),
      ));

  Pull<O, Option<(IList<O>, Rill<O>)>> uncons() =>
      self._underlying.uncons().map((a) => a.map((a) => a((hd, tl) => (hd, tl.rillNoScope()))));

  Pull<O, Option<(O, Rill<O>)>> uncons1() =>
      uncons().flatMap((a) => a.fold(() => Pull.pure(none()), (x) {
            final (hd, tl) = x;
            final ntl = hd.size == 1 ? tl : tl.cons(hd.drop(1));
            return Pull.pure(Some((hd[0], ntl)));
          }));

  Pull<O, Option<(IList<O>, Rill<O>)>> unconsLimit(int n) {
    if (n <= 0) {
      return Pull.pure(Some((IList.empty(), self)));
    } else {
      return uncons().flatMap((a) {
        return a.fold(
          () => Pull.pure(none()),
          (x) {
            final (hd, tl) = x;

            if (hd.size < n) {
              return Pull.pure(Some((hd, tl)));
            } else {
              final (out, rem) = hd.splitAt(n);
              return Pull.pure(Some((out, tl.cons(rem))));
            }
          },
        );
      });
    }
  }

  Pull<O, Option<(IList<O>, Rill<O>)>> unconsMin(
    int n, {
    bool allowFewerTotal = false,
  }) {
    Pull<O, Option<(IList<O>, Rill<O>)>> go(
      IList<O> acc,
      int n,
      Rill<O> s,
    ) =>
        s.pull().uncons().flatMap((a) => a.fold(
              () {
                if (allowFewerTotal && acc.nonEmpty) {
                  return Pull.pure(Some((acc, Rill.empty<O>())));
                } else {
                  return Pull.pure(none());
                }
              },
              (x) {
                final (hd, tl) = x;

                if (hd.size < n) {
                  return go(acc.concat(hd), n - hd.size, tl);
                } else {
                  return Pull.pure(Some((acc.concat(hd), tl)));
                }
              },
            ));

    if (n <= 0) {
      return Pull.pure(Some((IList.empty(), self)));
    } else {
      return go(IList.empty(), n, self);
    }
  }

  Pull<O, Option<(IList<O>, Rill<O>)>> unconsN(
    int n, {
    bool allowFewerTotal = false,
  }) {
    if (n <= 0) {
      return Pull.pure(Some((IList.empty(), self)));
    } else {
      return unconsMin(n, allowFewerTotal: allowFewerTotal).map((x) => x.map((a) => a((hd, tl) {
            final (pfx, sfx) = hd.splitAt(n);
            return (pfx, tl.cons(sfx));
          })));
    }
  }
}
