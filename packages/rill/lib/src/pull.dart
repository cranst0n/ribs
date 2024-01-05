// ignore_for_file: strict_raw_type

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

sealed class Pull<O, R> {
  static _Terminal<O, Unit> _unit<O>() => _Succeeded<O, Unit>(Unit());

  static Pull<Never, R> acquire<R>(
    IO<R> resource,
    Function2<R, ExitCase, IO<Unit>> release,
  ) =>
      _Acquire(resource, release, false);

  static Pull<Never, R> acquireCancelable<R>(
    Function1<Poll, IO<R>> resource,
    Function2<R, ExitCase, IO<Unit>> release,
  ) =>
      _Acquire(IO.uncancelable(resource), release, true);

  static Pull<O, Either<RuntimeException, R>> attemptEval<O, R>(IO<R> fr) =>
      _Eval<O, R>(fr)
          .map((r) => r.asRight<RuntimeException>())
          .handleErrorWith((err) => _Succeeded(err.asLeft<R>()));

  static Pull<O, B> bracketCase<O, A, B>(
    Pull<O, A> acquire,
    Function1<A, Pull<O, B>> use,
    Function2<A, ExitCase, Pull<O, Unit>> release,
  ) {
    return acquire.flatMap((a) {
      final used = Either.catching(
              () => use(a), (e, s) => _Fail<O>(RuntimeException(e, s)))
          .fold(identity, identity);

      return _transformWith(used, (result) {
        final exitCase = result.fold(
          (_) => ExitCase.succeeded(),
          (f) => ExitCase.errored(f.error),
          (_) => ExitCase.canceled(),
        );

        return _transformWith(release(a, exitCase), (t) {
          switch (t) {
            case final _Fail f:
              switch (result) {
                case final _Fail f2:
                  return _Fail(CompositeError.from(f2.error, f.error));
                default:
                  return result;
              }
            default:
              return result;
          }
        });
      });
    });
  }

  static Pull<Never, Unit> done() => _unit();

  static Pull<Never, R> eval<R>(IO<R> fr) => _Eval(fr);

  static Pull<Never, Never> fail(RuntimeException err) => _Fail(err);

  static Pull<O, Unit> output<O>(IList<O> os) => _Output(os);

  static Pull<O, Unit> output1<O>(O o) => _Output(ilist([o]));

  static Pull<O, Unit> outputOption1<O>(Option<O> opt) =>
      opt.fold(() => done(), output1);

  static Pull<O, R> pure<O, R>(R r) => _Succeeded<O, R>(r);

  static Pull<Never, Never> raiseError(RuntimeException err) => _Fail(err);

  static Pull<O, Unit> scope<O>(Pull<O, Unit> s) => _InScope(s, false);

  static Pull<Never, Unit> sleep(Duration duration) =>
      Pull.eval(IO.sleep(duration));

  // ///////////////////////////////////////////////////////////////////////////

  static Pull<O, Scope> _getScope<O>() => _GetScope();

  // ///////////////////////////////////////////////////////////////////////////

  Pull<O, Either<RuntimeException, R>> attempt() =>
      map((o) => o.asRight<RuntimeException>())
          .handleErrorWith((t) => _Succeeded(t.asLeft<R>()));

  Pull<O, R2> append<R2>(Function0<Pull<O, R2>> f) => flatMap((_) => f());

  Pull<O, R2> as<R2>(R2 r2) => map((_) => r2);

  Pull<O, R2> evalMap<R2>(Function1<R, IO<R2>> f) =>
      flatMap((r) => Pull.eval(f(r)));

  // Relevant issue(s) ?:
  //  * https://github.com/dart-lang/language/issues/1674
  //  * https://github.com/dart-lang/language/issues/213
  Pull<O2, R2> flatMap<O2, R2>(covariant Function1<R, Pull<O2, R2>> f) {
    return _BindF(this as Pull<O2, R>, (e) {
      return e.fold(
        (s) {
          try {
            return f(s.r as R);
          } catch (e, s) {
            return _Fail(RuntimeException(e, s));
          }
        },
        (e) => _Fail(e.error),
        (i) => _Interrupted(i.context, i.deferredError),
      );
    });
  }

  Pull<O, R> handleErrorWith(Function1<RuntimeException, Pull<O, R>> handler) {
    return _BindF(this, (e) {
      switch (e) {
        case final _Fail f:
          {
            try {
              return handler(f.error);
            } catch (e, s) {
              return _Fail(RuntimeException(e, s));
            }
          }
        default:
          return e;
      }
    });
  }

  Pull<O, R> lease() => Pull.bracketCase(
        Pull._getScope<O>().evalMap((a) => a.lease()),
        (_) => this,
        (l, _) {
          return Pull.eval(l.cancel()).rethrowError();
        },
      );

  Pull<O, R2> map<R2>(Function1<R, R2> f) => _BindF(this, (r) => r.map(f));

  Pull<O, R2> onComplete<R2>(Function0<Pull<O, R2>> post) =>
      handleErrorWith((e) => post().append(() => _Fail(e)))
          .append(() => post());

  Pull<O, Unit> voided() => as(Unit());

  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////
  // ///////////////////////////////////////////////////////////////////////////

  static IO<B> compile<O, B>(
    Pull<O, Unit> stream,
    Scope initScope,
    bool extendLastTopLevelScope,
    B init,
    Function2<B, IList<O>, B> foldChunk,
  ) {
    late _ContP<dynamic, dynamic, Unit> contP;

    _ContP<AA, BB, Unit> getCont<AA, BB>() => contP as _ContP<AA, BB, Unit>;

    _ViewL<X> viewL<X>(Pull<X, Unit> free) {
      switch (free) {
        case final _Action<X, Unit> e:
          contP = e.idContP();
          return e;
        case final _Bind<X, dynamic, Unit> b:
          switch (b.step) {
            case final _Bind<X, dynamic, dynamic> c:
              return viewL(c.bindBind(b));
            case final _Action<X, dynamic> e:
              contP = b.delegate;
              return e;
            case final _Terminal<X, dynamic> r:
              return viewL(b(r));
            default:
              throw StateError('Pull.compile.viewL.bind: ${b.step}');
          }
        case final _Terminal<X, Unit> r:
          return r;
        default:
          throw StateError('Pull.compile.viewL: $free');
      }
    }

    Pull<X, Unit> interruptBoundary<X>(
      Pull<X, Unit> stream,
      _Interrupted<X> interruption,
    ) {
      final v = viewL(stream);

      switch (v) {
        case final _CloseScope<X> _:
          final cl = _CanceledScope(v.scopeId, interruption);
          return _transformWith(cl, getCont<Unit, X>().call);
        case final _Action<X, dynamic> _:
          return getCont<Unit, X>()(interruption);
        case final _Interrupted<X> interrupted:
          return interrupted;
        case final _Succeeded _:
          return interruption;
        case final _Fail f:
          final errs = interruption.deferredError.toIList().appended(f.error);
          return _Fail(CompositeError.fromIList(errs).getOrElse(() => f.error));
        default:
          throw StateError('Pull.compile.interruptBoundary: $v');
      }
    }

    IO<End> go<X, End>(
      Scope scope,
      Option<Scope> extendedTopLevelScope,
      _Run<X, IO<End>> runner,
      Pull<X, Unit> stream,
    ) {
      IO<End> interruptGuard(
        Scope scope,
        _ContP<dynamic, X, Unit> view,
        Function0<IO<End>> next,
      ) =>
          scope.isInterrupted.flatMap(
            (oc) => oc.fold(
              () => next(),
              (outcome) {
                final result = outcome.fold(
                  () => _Interrupted<X>(scope.id, none()),
                  (err) => _Fail<X>(err),
                  (scopeId) => _Interrupted<X>(scopeId, none()),
                );

                return go(scope, extendedTopLevelScope, runner, view(result));
              },
            ),
          );

      IO<End> goErr(RuntimeException err, _ContP<dynamic, X, Unit> view) =>
          go(scope, extendedTopLevelScope, runner, view(_Fail(err)));

      IO<End> goEval<V>(_Eval<O, V> eval, _ContP<V, X, Unit> view) =>
          scope.interruptibleEval(eval.value).flatMap((eitherOutcome) {
            final _Terminal<X, V> result = eitherOutcome.fold(
              (oc) => oc.fold(
                () => _Interrupted<X>(scope.id, none()),
                (err) => _Fail<X>(err),
                (token) => _Interrupted<X>(token, none()),
              ),
              (r) => _Succeeded<X, V>(r),
            );

            return go(scope, extendedTopLevelScope, runner, view(result));
          });

      IO<End> goAcquire<RR>(_Acquire<O, RR> acquire, _ContP<RR, X, Unit> view) {
        final onScope = scope.acquireResource(
            (poll) =>
                acquire.cancelable ? poll(acquire.resource) : acquire.resource,
            (resource, exit) => acquire.release(resource, exit));

        final cont = onScope.flatMap((outcome) {
          final _Terminal<X, RR> result = outcome.fold(
            () => _Interrupted(scope.id, none()),
            (err) => _Fail(err),
            (a) => a.fold(
              (scopeId) => _Interrupted(scopeId, none()),
              (r) => _Succeeded(r),
            ),
          );

          return go(scope, extendedTopLevelScope, runner, view(result));
        });

        return interruptGuard(scope, view, () => cont);
      }

      IO<End> goInterruptWhen(
        IO<Either<RuntimeException, Unit>> haltOnSignal,
        _ContP<Unit, X, Unit> view,
      ) {
        final onScope = scope.acquireResource(
            (_) => scope.interruptWhen(haltOnSignal), (f, _) => f.cancel());

        final cont = onScope.flatMap((outcome) {
          final _Terminal<X, Unit> result = outcome.fold(
            () => _Interrupted(scope.id, none()),
            (err) => _Fail(err),
            (a) => a.fold(
                (scopeId) => _Interrupted(scopeId, none()), (_) => _unit()),
          );

          return go(scope, extendedTopLevelScope, runner, view(result));
        });

        return interruptGuard(scope, view, () => cont);
      }

      _Run<X, IO<End>> viewRunner(
        _ContP<Unit, X, Unit> view,
        _Run<X, IO<End>> prevRunner,
      ) {
        return _ViewRunner(
          view: view,
          prevRunner: runner,
          doneF: (doneScope) =>
              go(doneScope, extendedTopLevelScope, prevRunner, view(_unit())),
          failF: (err) => goErr(err, view),
          interruptedF: (inter) =>
              go(scope, extendedTopLevelScope, prevRunner, view(inter)),
          outF: (a, b, c) => IO.never(), // not used...
        );
      }

      IO<End> goInScope(
        Pull<X, Unit> stream,
        bool useInterruption,
        _ContP<Unit, X, Unit> view,
      ) {
        Pull<X, Unit> endScope(
          UniqueToken scopeId,
          _Terminal<X, Unit> result,
        ) =>
            result.fold(
              (s) => _SucceedScope(scopeId),
              (f) => _FailedScope(scopeId, f.error),
              (i) => _CanceledScope(scopeId, i),
            );

        final maybeCloseExtendedScope =
            scope.isRoot && extendedTopLevelScope.isDefined
                ? extendedTopLevelScope
                    .traverseIO_(
                        (a) => a.close(ExitCase.succeeded()).rethrowError())
                    .as(none<Scope>())
                : IO.pure(extendedTopLevelScope);

        final tail = maybeCloseExtendedScope.flatMap((newExtendedScope) {
          return scope
              .open(useInterruption)
              .rethrowError()
              .flatMap((childScope) {
            final bb = _BindF(stream, (r) => endScope(childScope.id, r));

            return go(
              childScope,
              newExtendedScope,
              viewRunner(view, runner),
              bb,
            );
          });
        });

        return interruptGuard(scope, view, () => tail);
      }

      IO<End> goCloseScope(
        _CloseScope<X> close,
        _ContP<Unit, X, Unit> view,
      ) {
        _Terminal<X, Unit> addError(
                RuntimeException err, _Terminal<X, Unit> res) =>
            res.fold(
              (s) => _Fail(err),
              (f) => _Fail(CompositeError.from(err, f.error)),
              (i) => throw StateError('Impossible, cannot interrupt here!'),
            );

        Pull<X, Unit> viewCont(_Terminal<X, Unit> res) => close.exitCase.fold(
              () => view(res),
              (err) => view(addError(err, res)),
              () => view(res),
            );

        _Terminal<X, Unit> closeTerminal(
            Either<RuntimeException, Unit> r, Scope ancestor) {
          return close.interruption.fold(
            () => r.fold((err) => _Fail(err), (a) => _Succeeded(a)),
            (i) {
              final err1 = CompositeError.fromIList(
                  r.swap().toIList().concat(i.deferredError.toIList()));

              if (ancestor.descendsFrom(i.context)) {
                return _Interrupted(i.context, err1);
              } else {
                return err1.fold(() => _unit(), (err) => _Fail(err));
              }
            },
          );
        }

        return scope.findInLineage(close.scopeId).flatMap((s) {
          return s.fold(
            () {
              final result =
                  close.interruption.fold(() => _unit<X>(), identity);
              return go(scope, extendedTopLevelScope, runner, viewCont(result));
            },
            (toClose) {
              if (toClose.isRoot) {
                return go(
                    scope, extendedTopLevelScope, runner, viewCont(_unit()));
              } else if (extendLastTopLevelScope && toClose.level == 1) {
                return extendedTopLevelScope
                    .traverseIO_(
                        (a) => a.close(ExitCase.succeeded()).rethrowError())
                    .productR(() => toClose.openAncestor().flatMap((ancestor) =>
                        go(ancestor, Some(toClose), runner,
                            viewCont(_unit()))));
              } else {
                return toClose.close(close.exitCase).flatMap(
                      (r) => toClose.openAncestor().flatMap(
                        (ancestor) {
                          final res = closeTerminal(r, ancestor);
                          return go(ancestor, extendedTopLevelScope, runner,
                              viewCont(res));
                        },
                      ),
                    );
              }
            },
          );
        });
      }

      // ///////////////////////////////////////////////////////////////////////

      _Run<Y, IO<End>> flatMapR<Y>(
        _ContP<Unit, X, Unit> view,
        Fn1<Y, Pull<X, Unit>> fun,
      ) {
        Pull<X, Unit> unconsed(IList<Y> chunk, Pull<Y, Unit> tail) {
          if (chunk.size == 1 && tail is _Succeeded) {
            try {
              return fun(chunk[0]);
            } catch (e, s) {
              return _Fail(RuntimeException(e, s));
            }
          } else {
            Pull<X, Unit> go(int idx) {
              if (idx == chunk.size) {
                return tail.flatMapOutput(fun.call);
              } else {
                try {
                  int j = idx;

                  // TODO: Not stack safe
                  Pull<X, Unit> loop() {
                    final p = fun(chunk[idx]);

                    if (p is _Succeeded && j < chunk.size - 1) {
                      j += 1;
                      return loop();
                    } else {
                      return p;
                    }
                  }

                  final next = loop();

                  return _transformWith(next, (t) {
                    switch (t) {
                      case final _Succeeded _:
                        return go(j + 1);
                      case final _Fail f:
                        return _Fail(f.error);
                      case final _Interrupted<Y> i:
                        return interruptBoundary(tail, i)
                            .flatMapOutput(fun.call);
                      default:
                        throw StateError(
                            'Pull.compile.go.flatMapR.unconsed: $t');
                    }
                  });
                } catch (e, s) {
                  return _Fail(RuntimeException(e, s));
                }
              }
            }

            return go(0);
          }
        }

        return _RunF<Y, End>(
          doneF: (scope) => interruptGuard(
            scope,
            view,
            () => go(scope, extendedTopLevelScope, runner, view(_unit())),
          ),
          failF: (err) => goErr(err, view),
          interruptedF: (inter) {
            final foo = inter as _Terminal<X, Never>;
            return go(scope, extendedTopLevelScope, runner, view(foo));
          },
          outF: (head, outScope, tail) {
            final next = _bindView(unconsed(head, tail), view);
            return go(outScope, extendedTopLevelScope, runner, next);
          },
        );
      }

      _Run<Y, IO<End>> unconsRunR<Y>(
        _ContP<Option<(IList<Y>, Pull<Y, Unit>)>, X, Unit> view,
      ) {
        return _RunF(
          doneF: (scope) => interruptGuard(
            scope,
            view,
            () => go(scope, extendedTopLevelScope, runner,
                view(_Succeeded(const None()))),
          ),
          failF: (err) => goErr(err, view),
          interruptedF: (inter) {
            return go(scope, extendedTopLevelScope, runner,
                view(inter as _Terminal<X, Never>));
          },
          outF: (head, outScope, tail) => interruptGuard(
            scope,
            view,
            () => go(scope, extendedTopLevelScope, runner,
                view(_Succeeded(Some((head, tail))))),
          ),
        );
      }

      _Run<Y, IO<End>> stepLegRunR<Y>(
        _ContP<Option<StepLeg<Y>>, X, Unit> view,
      ) =>
          _RunF(
            doneF: (scope) => interruptGuard(
              scope,
              view,
              () => go(scope, extendedTopLevelScope, runner,
                  view(_Succeeded(const None()))),
            ),
            failF: (err) => goErr(err, view),
            interruptedF: (inter) {
              return go(scope, extendedTopLevelScope, runner,
                  view(inter as _Terminal<X, Never>));
            },
            outF: (head, outScope, tail) => interruptGuard(
              scope,
              view,
              () => go(scope, extendedTopLevelScope, runner,
                  view(_Succeeded(Some(StepLeg(head, outScope.id, tail))))),
            ),
          );

      // ///////////////////////////////////////////////////////////////////////

      final vl = viewL(stream);

      switch (vl) {
        case final _Output<X> output:
          final view = contP as _ContP<Unit, X, Unit>;

          return interruptGuard(
            scope,
            view,
            () => runner.out(output.values, scope, view(output._unit())),
          );
        case final _FlatMapOutput fmout:
          final view = getCont<Unit, X>();
          final fmRunr =
              flatMapR(view, fmout.fun as Fn1<dynamic, Pull<X, Unit>>);

          return IO.unit.productR(
              () => go(scope, extendedTopLevelScope, fmRunr, fmout.stream));
        case final _Uncons<X> u:
          final view = getCont<Option<(IList<X>, Pull<X, Unit>)>, X>();
          final runr = u.buildR<End>();

          return IO.unit
              .productR(() =>
                  go(scope, extendedTopLevelScope, runr, u.stream).attempt())
              .flatMap(
                (a) => a.fold(
                  (err) => goErr(err, view),
                  (a) => a(unconsRunR(view)),
                ),
              );
        case final _StepLeg s:
          final view = contP as _ContP<Option<StepLeg<dynamic>>, X, Unit>;
          final runr = s.buildR<End>();

          return scope
              .shiftScope(s.scope, s.toString())
              .flatMap(
                  (a) => go(a, extendedTopLevelScope, runr, s.stream).attempt())
              .flatMap((a) => a.fold(
                    (err) => goErr(err, view),
                    (a) => a(stepLegRunR(view)),
                  ));
        case final _GetScope _:
          return go(
            scope,
            extendedTopLevelScope,
            runner,
            getCont<Scope, Unit>()(_Succeeded(scope)),
          );
        case final _Eval<O, X> eval:
          final view = contP as _ContP<X, X, Unit>;
          return goEval(eval, view);
        case final _Acquire<O, dynamic> acquire:
          return goAcquire(acquire, getCont<Unit, X>());
        case final _InScope<X> inScope:
          final view = contP as _ContP<Unit, X, Unit>;
          return goInScope(inScope.stream, inScope.useInterruption, view);
        case final _InterruptWhen inter:
          final view = contP as _ContP<Unit, X, Unit>;
          return goInterruptWhen(inter.haltOnSignal, view);
        case final _CloseScope<X> close:
          final view = contP as _ContP<Unit, X, Unit>;
          return goCloseScope(close, view);
        case final _Succeeded _:
          return runner.done(scope);
        case final _Fail failed:
          return runner.fail(failed.error);
        case final _Interrupted<X> inter:
          return runner.interrupted(inter);
        default:
          throw StateError('Pull.compile.go: $vl');
      }
    }

    final runner = _OuterRun<O, B>(foldChunk, init, getCont, viewL, go);
    return go(initScope, none(), runner, stream);
  }

  static Pull<P, Unit> mapOutput<O, P>(Rill<O> s, Function1<O, P> f) =>
      interruptScope(mapOutputNoScope(s, f));

  static Pull<P, Unit> mapOutputNoScope<O, P>(Rill<O> s, Function1<O, P> f) =>
      s.pull().echo().unconsFlatMap((hd) => Pull.output(hd.map(f)));
}

extension PullOps<O> on Pull<O, Unit> {
  Pull<O2, Unit> flatMapOutput<O2>(Function1<O, Pull<O2, Unit>> f) {
    switch (this) {
      case final _AlgEffect<O, Unit> a:
        return a as _AlgEffect<O2, Unit>;
      case final _Terminal<O2, Unit> r:
        return r;
      default:
        return _FlatMapOutput(this, Fn1.of(f));
    }
  }

  Pull<O2, Unit> unconsFlatMap<O2>(
    Function1<IList<O>, Pull<O2, Unit>> f,
  ) =>
      uncons().flatMap((a) => a.fold(
            () => Pull.done(),
            (next) => next((hd, tl) => f(hd).append(() => tl.unconsFlatMap(f))),
          ));

  Pull<O, Option<(IList<O>, Pull<O, Unit>)>> uncons() {
    switch (this) {
      case final _Succeeded _:
        return _Succeeded(none());
      case final _Output<O> o:
        return _Succeeded(Some((o.values, Pull.done())));
      case final _Fail<O> f:
        return f;
      case final _Interrupted<O> i:
        return i;
      default:
        return _Uncons(this);
    }
  }

  Rill<O> rill() => Rill(Pull.scope(this));

  Rill<O> rillNoScope() => Rill(this);
}

extension PullErrorOps<O, R> on Pull<O, Either<RuntimeException, R>> {
  Pull<O, R> rethrowError() =>
      flatMap((r) => r.fold(Pull.raiseError, (r) => Pull.pure(r)));
}

Pull<O, S> _transformWith<O, R, S>(
  Pull<O, R> p,
  Function1<_Terminal<O, R>, Pull<O, S>> f,
) {
  if (p is _Terminal<O, R>) {
    try {
      return f(p);
    } catch (e, s) {
      return _Fail(RuntimeException(e, s));
    }
  } else {
    return _BindF(p, (r) {
      try {
        return f(r);
      } catch (e, s) {
        return _Fail(RuntimeException(e, s));
      }
    });
  }
}

mixin class _ViewL<O> {}

sealed class _Terminal<O, R> extends Pull<O, R> with _ViewL<O> {
  B fold<B>(
    Function1<_Succeeded, B> succeeded,
    Function1<_Fail, B> failed,
    Function1<_Interrupted<O>, B> interrupted,
  ) {
    switch (this) {
      case final _Succeeded<O, R> s:
        return succeeded(s);
      case final _Fail<O> f:
        return failed(f);
      case final _Interrupted<O> i:
        return interrupted(i);
      default:
        throw StateError('_Terminal.fold');
    }
  }
}

final class _Succeeded<O, R> extends _Terminal<O, R> {
  final R r;

  _Succeeded(this.r);

  @override
  Pull<O, R2> map<R2>(Function1<R, R2> f) {
    try {
      return _Succeeded(f(r));
    } catch (e, s) {
      return _Fail(RuntimeException(e, s));
    }
  }
}

final class _Fail<O> extends _Terminal<O, Never> {
  final RuntimeException error;

  _Fail(this.error);

  @override
  Pull<O, R2> map<R2>(Function1<Never, R2> f) => this;
}

final class _Interrupted<O> extends _Terminal<O, Never> {
  final UniqueToken context;
  final Option<RuntimeException> deferredError;

  _Interrupted(this.context, this.deferredError);

  @override
  Pull<O, R2> map<R2>(Function1<Never, R2> f) => this;
}

abstract mixin class _ContP<Y, O, X> {
  Pull<O, X> call(_Terminal<O, Y> t);
}

final class _IdContP<A> extends _ContP<Unit, A, Unit> {
  final Function1<_Terminal<A, Unit>, Pull<A, Unit>> f;

  _IdContP(this.f);

  @override
  Pull<A, Unit> call(_Terminal<A, Unit> t) => f(t);
}

abstract class _Bind<O, X, R> extends Pull<O, R> with _ContP<X, O, R> {
  final Pull<O, X> step;

  _Bind(this.step);

  _Bind<O, X, R> get delegate => this;

  _BindBind<O, X, R> bindBind(_Bind<O, R, Unit> other) =>
      _BindBind(step, delegate, other.delegate);
}

final class _BindF<O, X, R> extends _Bind<O, X, R> {
  final Function1<_Terminal<O, X>, Pull<O, R>> f;

  _BindF(super.step, this.f);

  @override
  Pull<O, R> call(_Terminal<O, X> r) => f(r);
}

final class _DelegateBind<O, Y> extends _Bind<O, Y, Unit> {
  final _Bind<O, Y, Unit> _delegate;

  _DelegateBind(super.step, this._delegate);

  @override
  _Bind<O, Y, Unit> get delegate => _delegate;

  @override
  Pull<O, Unit> call(_Terminal<O, Y> yr) => delegate(yr);
}

Pull<O, Unit> _bindView<O>(Pull<O, Unit> fmoc, _ContP<Unit, O, Unit> view) {
  switch (view) {
    case _IdContP _:
      return fmoc;
    case final _Bind<O, Unit, Unit> bv:
      switch (fmoc) {
        case final _Terminal<O, Unit> r:
          try {
            return bv(r);
          } catch (e, s) {
            return _Fail(RuntimeException(e, s));
          }
        default:
          return _DelegateBind(fmoc, view.delegate);
      }
    default:
      return _BindF(fmoc, (r) => view(r));
  }
}

class _BindBind<O, X, Y> extends _Bind<O, X, Unit> {
  final _Bind<O, X, Y> bb;
  final _Bind<O, Y, Unit> del;

  _BindBind(super.step, this.bb, this.del);

  @override
  Pull<O, Unit> call(_Terminal<O, X> tx) {
    try {
      return _bindBindAux(bb(tx), del);
    } catch (e, s) {
      return _Fail(RuntimeException(e, s));
    }
  }
}

// TODO: Not stack safe
Pull<O, Unit> _bindBindAux<O, X>(Pull<O, X> py, _Bind<O, X, Unit> del) {
  switch (py) {
    case final _Terminal<O, X> ty:
      switch (del) {
        case final _BindBind<O, dynamic, X> cici:
          return _bindBindAux(cici.bb(ty), cici.del);
        default:
          return del(ty);
      }
    case final Pull<O, X> x:
      return _DelegateBind(x, del);
  }
}

sealed class _Action<O, R> extends Pull<O, R> with _ViewL<O> {
  _ContP<Unit, O, Unit> idContP() => _IdContP<O>((a) => a);
}

final class _Output<O> extends _Action<O, Unit> {
  final IList<O> values;

  _Output(this.values);

  _Terminal<O, Unit> _unit() => Pull._unit();
}

final class _FlatMapOutput<O, O2> extends _Action<O2, Unit> {
  final Pull<O, Unit> stream;
  final Fn1<O, Pull<O2, Unit>> fun;

  _FlatMapOutput(this.stream, this.fun);

  _Run<O, IO<_CallRun<O, IO<End>>>> buildR<End>() => _RunF(
        doneF: (scope) => IO.pure((run) => run.done(scope)),
        failF: (err) => IO.raiseError(err),
        interruptedF: (inter) => IO.pure((run) => run.interrupted(inter)),
        outF: (head, scope, tail) =>
            IO.pure((run) => run.out(head, scope, tail)),
      );
}

final class _Uncons<O> extends _Action<O, Option<(IList<O>, Pull<O, Unit>)>> {
  final Pull<O, Unit> stream;

  _Uncons(this.stream);

  _Run<O, IO<_CallRun<O, IO<End>>>> buildR<End>() => _RunF(
        doneF: (scope) => IO.pure((run) => run.done(scope)),
        failF: (err) => IO.raiseError(err),
        interruptedF: (inter) => IO.pure((run) => run.interrupted(inter)),
        outF: (head, scope, tail) =>
            IO.pure((run) => run.out(head, scope, tail)),
      );
}

final class _StepLeg<O> extends _Action<O, Option<StepLeg<O>>> {
  final Pull<O, Unit> stream;
  final UniqueToken scope;

  _StepLeg(this.stream, this.scope);

  _Run<O, IO<_CallRun<O, IO<End>>>> buildR<End>() => _RunF(
        doneF: (scope) => IO.pure((run) => run.done(scope)),
        failF: (err) => IO.raiseError(err),
        interruptedF: (inter) => IO.pure((run) => run.interrupted(inter)),
        outF: (head, scope, tail) =>
            IO.pure((run) => run.out(head, scope, tail)),
      );
}

sealed class _AlgEffect<O, R> extends _Action<O, R> {}

final class _Eval<O, R> extends _AlgEffect<O, R> {
  final IO<R> value;

  _Eval(this.value);
}

final class _Acquire<O, R> extends _AlgEffect<O, R> {
  final IO<R> resource;
  final Function2<R, ExitCase, IO<Unit>> release;
  final bool cancelable;

  _Acquire(this.resource, this.release, this.cancelable);
}

final class _InScope<O> extends _Action<O, Unit> {
  final Pull<O, Unit> stream;
  final bool useInterruption;

  _InScope(this.stream, this.useInterruption);
}

final class _InterruptWhen<O> extends _AlgEffect<O, Unit> {
  final IO<Either<RuntimeException, Unit>> haltOnSignal;

  _InterruptWhen(this.haltOnSignal);
}

abstract class _CloseScope<O> extends _AlgEffect<O, Unit> {
  UniqueToken get scopeId;
  Option<_Interrupted<O>> get interruption;
  ExitCase get exitCase;
}

final class _SucceedScope<O> extends _CloseScope<O> {
  @override
  UniqueToken scopeId;

  _SucceedScope(this.scopeId);

  @override
  ExitCase get exitCase => ExitCase.succeeded();

  @override
  Option<_Interrupted<O>> get interruption => none();
}

final class _CanceledScope<O> extends _CloseScope<O> {
  @override
  final UniqueToken scopeId;

  final _Interrupted<O> inter;

  _CanceledScope(this.scopeId, this.inter);

  @override
  ExitCase get exitCase => ExitCase.canceled();

  @override
  Option<_Interrupted<O>> get interruption => Some(inter);
}

final class _FailedScope<O> extends _CloseScope<O> {
  @override
  final UniqueToken scopeId;

  final RuntimeException err;

  _FailedScope(this.scopeId, this.err);

  @override
  ExitCase get exitCase => ExitCase.errored(err);

  @override
  Option<_Interrupted<O>> get interruption => none();
}

final class _GetScope<O> extends _AlgEffect<O, Scope> {}

// Pull<O, Option<StepLeg<O>>> _stepLeg<O>(StepLeg<O> leg) =>
//     _StepLeg(leg.next, leg.scopeId);

Pull<O, Unit> scope<O>(Pull<O, Unit> s) => _InScope(s, false);

Pull<O, Unit> interruptScope<O>(Pull<O, Unit> s) => _InScope(s, true);

Pull<O, Unit> interruptWhen<O>(
        IO<Either<RuntimeException, Unit>> haltOnSignal) =>
    _InterruptWhen(haltOnSignal);

sealed class _Run<X, End> {
  End done(Scope scope);

  End out(IList<X> head, Scope scope, Pull<X, Unit> tail);

  End interrupted(_Interrupted<X> inter);

  End fail(RuntimeException error);
}

typedef _CallRun<X, End> = Function1<_Run<X, End>, End>;

class _OuterRun<O, B> extends _Run<O, IO<B>> {
  final Function2<B, IList<O>, B> foldChunk;
  final B initB;

  final Function0<_ContP<O, Never, Unit>> getCont;
  final Function1<Pull<O, Unit>, _ViewL<O>> viewL;

  final Function4<Scope, Option<Scope>, _Run<O, IO<B>>, Pull<O, Unit>, IO<B>>
      go;

  B _accB;

  _OuterRun(
    this.foldChunk,
    this.initB,
    this.getCont,
    this.viewL,
    this.go,
  ) : _accB = initB;

  @override
  IO<B> done(Scope scope) => IO.pure(_accB);

  @override
  IO<B> fail(RuntimeException error) => IO.raiseError(error);

  @override
  IO<B> interrupted(_Interrupted<O> inter) => inter.deferredError
      .fold(() => IO.pure(_accB), (err) => IO.raiseError(err));

  @override
  IO<B> out(IList<O> head, Scope scope, Pull<O, Unit> tail) {
    try {
      _accB = foldChunk(_accB, head);
      return go(scope, none(), this, tail);
    } catch (e, s) {
      final viewTail = viewL(tail);
      final err = RuntimeException(e, s);

      if (viewTail is _Action<O, dynamic>) {
        return go(scope, none(), this, getCont()(_Fail(err)));
      } else if (viewTail is _Succeeded) {
        return IO.raiseError(err);
      } else if (viewTail is _Fail<O>) {
        return IO.raiseError(CompositeError.from(viewTail.error, err));
      } else if (viewTail is _Interrupted<O>) {
        return IO.raiseError(viewTail.deferredError.fold(
            () => RuntimeException(e, s),
            (err2) => CompositeError.from(err2, err)));
      } else {
        throw StateError('OuterRun.catch: $viewTail');
      }
    }
  }
}

class _RunF<Y, End> extends _Run<Y, IO<End>> {
  final Function1<Scope, IO<End>> doneF;
  final Function1<RuntimeException, IO<End>> failF;
  final Function1<_Interrupted<Y>, IO<End>> interruptedF;
  final Function3<IList<Y>, Scope, Pull<Y, Unit>, IO<End>> outF;

  _RunF({
    required this.doneF,
    required this.failF,
    required this.interruptedF,
    required this.outF,
  });

  @override
  IO<End> done(Scope scope) => doneF(scope);

  @override
  IO<End> fail(RuntimeException error) => failF(error);

  @override
  IO<End> interrupted(_Interrupted<Y> inter) => interruptedF(inter);

  @override
  IO<End> out(IList<Y> head, Scope scope, Pull<Y, Unit> tail) =>
      outF(head, scope, tail);
}

class _ViewRunner<X, End> extends _RunF<X, End> {
  _ContP<Unit, X, Unit> view;
  _Run<X, IO<End>> prevRunner;

  _ViewRunner({
    required this.view,
    required this.prevRunner,
    required super.doneF,
    required super.failF,
    required super.interruptedF,
    required super.outF,
  });

  @override
  IO<End> out(IList<X> head, Scope scope, Pull<X, Unit> tail) {
    IO<End> outLoop(Pull<X, Unit> acc, _Run<X, IO<End>> pred) {
      if (pred is _ViewRunner<X, End>) {
        return outLoop(_bindView(acc, pred.view), pred.prevRunner);
      } else {
        return pred.out(head, scope, acc);
      }
    }

    return outLoop(tail, this);
  }
}
